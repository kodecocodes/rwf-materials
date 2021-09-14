import 'dart:async';

import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_repository/quote_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/user_repository.dart';

part 'quote_list_event.dart';
part 'quote_list_state.dart';

class QuoteListBloc extends Bloc<QuoteListEvent, QuoteListState> {
  QuoteListBloc({
    required QuoteRepository quoteRepository,
    required UserRepository userRepository,
  })  : _quoteRepository = quoteRepository,
        super(
          const QuoteListState(),
        ) {
    add(
      const QuoteListFirstPageRequested(),
    );

    _authChangesSubscription = userRepository
        .getUser()
        .where(
          (user) => user?.username != _authenticatedUsername,
        )
        .listen((user) {
      _authenticatedUsername = user?.username;
      add(
        const QuoteListUserAuthenticationChanged(),
      );
    });
  }

  late final StreamSubscription _authChangesSubscription;

  String? _authenticatedUsername;
  final QuoteRepository _quoteRepository;

  @override
  Stream<Transition<QuoteListEvent, QuoteListState>> transformEvents(
    Stream<QuoteListEvent> events,
    TransitionFunction<QuoteListEvent, QuoteListState> transitionFn,
  ) {
    final nonDebounceEventStream = events.where(
      (event) => event is! QuoteListSearchTermChanged,
    );

    final debounceEventStream = events
        .whereType<QuoteListSearchTermChanged>()
        .debounceTime(
          const Duration(seconds: 1),
        )
        .where((event) {
      final previousFilter = state.filter;
      final previousSearchTerm = previousFilter is QuoteListFilterBySearchTerm
          ? previousFilter.searchTerm
          : '';

      return event.searchTerm != previousSearchTerm;
    });

    final mergedEventStream = MergeStream([
      nonDebounceEventStream,
      debounceEventStream,
    ]);

    // Explanation: https://stackoverflow.com/questions/61569917/how-do-i-nest-streams-in-dart-map-streams-to-stream-events
    return mergedEventStream.switchMap(transitionFn);
  }

  @override
  Stream<QuoteListState> mapEventToState(QuoteListEvent event) async* {
    if (event is QuoteListFirstPageRequested) {
      yield state.copyWithNewError(null);
      yield* _fetchQuotePage(
        1,
        fetchPolicy: QuoteListPageFetchPolicy.cacheAndNetwork,
      );
    } else if (event is QuoteListItemUpdated) {
      yield state.copyWithUpdatedQuote(event.updatedQuote);
    } else if (event is QuoteListUserAuthenticationChanged) {
      yield QuoteListState(
        filter: state.filter,
      );
      yield* _fetchQuotePage(
        1,
        fetchPolicy: QuoteListPageFetchPolicy.cacheAndNetwork,
      );
    } else if (event is QuoteListTagChanged) {
      yield QuoteListState.loadingNewTag(tag: event.tag);

      yield* _fetchQuotePage(
        1,
        fetchPolicy: QuoteListPageFetchPolicy.cacheFirst,
      );
    } else if (event is QuoteListSearchTermChanged) {
      yield QuoteListState.loadingNewSearchTerm(
        searchTerm: event.searchTerm,
      );

      yield* _fetchQuotePage(
        1,
        fetchPolicy: QuoteListPageFetchPolicy.cacheFirst,
      );
    } else if (event is QuoteListRefreshed) {
      yield* _fetchQuotePage(
        1,
        fetchPolicy: QuoteListPageFetchPolicy.networkOnly,
        isRefresh: true,
      );
    } else if (event is QuoteListNewPageRequested) {
      yield state.copyWithNewError(null);
      yield* _fetchQuotePage(
        event.pageNumber,
        fetchPolicy: QuoteListPageFetchPolicy.networkFirst,
      );
    } else if (event is QuoteListItemFavoriteToggled) {
      try {
        final updatedQuote = await (event is QuoteListItemFavorited
            ? _quoteRepository.favoriteQuote(event.id)
            : _quoteRepository.unfavoriteQuote(event.id));
        final isFilteringByFavorites =
            state.filter is QuoteListFilterByFavorites;
        if (!isFilteringByFavorites) {
          yield state.copyWithUpdatedQuote(updatedQuote);
        } else {
          yield QuoteListState(
            filter: state.filter,
          );

          yield* _fetchQuotePage(
            1,
            fetchPolicy: QuoteListPageFetchPolicy.networkOnly,
          );
        }
      } catch (error) {
        yield state.copyWithFavoriteToggleError(error);
      }
    } else if (event is QuoteListFilterByFavoritesToggled) {
      final isFilteringByFavorites =
          state.filter is! QuoteListFilterByFavorites;

      yield QuoteListState.loadingToggledFavoritesFilter(
        isFilteringByFavorites: isFilteringByFavorites,
      );

      yield* _fetchQuotePage(
        1,
        fetchPolicy: isFilteringByFavorites
            ? QuoteListPageFetchPolicy.cacheAndNetwork
            : QuoteListPageFetchPolicy.cacheFirst,
      );
    }
  }

  Stream<QuoteListState> _fetchQuotePage(
    int page, {
    required QuoteListPageFetchPolicy fetchPolicy,
    bool isRefresh = false,
  }) async* {
    final filter = state.filter;
    final isFilteringByFavorites = filter is QuoteListFilterByFavorites;
    if (isFilteringByFavorites && _authenticatedUsername == null) {
      yield QuoteListState.noItemsFound(
        filter: state.filter,
      );
    } else {
      yield* _quoteRepository
          .getQuoteListPage(
        page,
        tag: filter is QuoteListFilterByTag ? filter.tag : null,
        searchTerm:
            filter is QuoteListFilterBySearchTerm ? filter.searchTerm : '',
        favoritedByUsername: filter is QuoteListFilterByFavorites
            ? _authenticatedUsername
            : null,
        fetchPolicy: fetchPolicy,
      )
          .map(
        (newPage) {
          return newPage.toQuoteListState(
            page,
            state,
            // TODO: Pq aqui não ta usando a flag isRefresh ali de cima?
            // O certo é mudar o nome do parametro da função.
            isRefresh: page != state.nextPage,
          );
        },
      ).onErrorReturnWith(
        (error, _) {
          if (error is EmptySearchResultException) {
            return QuoteListState.noItemsFound(
              filter: state.filter,
            );
          }

          if (isRefresh) {
            return state.copyWithNewRefreshError(
              error,
            );
          } else {
            return state.copyWithNewError(
              error,
            );
          }
        },
      );
    }
  }

  @override
  Future<void> close() {
    _authChangesSubscription.cancel();
    return super.close();
  }
}

extension on QuoteListPage {
  QuoteListState toQuoteListState(
    int page,
    QuoteListState lastState, {
    bool isRefresh = false,
  }) {
    final newItemList = quoteList;
    final nextPage = isLastPage ? null : page + 1;

    final oldItemList = lastState.itemList ?? [];

    return QuoteListState.success(
      nextPage: nextPage,
      itemList: isRefresh ? newItemList : [...oldItemList, ...newItemList],
      filter: lastState.filter,
      isRefresh: isRefresh,
    );
  }
}
