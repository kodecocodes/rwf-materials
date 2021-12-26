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
    _registerEventHandler();

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

  void _registerEventHandler() {
    on<QuoteListEvent>(
      (event, emit) async {
        if (event is QuoteListFirstPageRequested) {
          emit(
            state.copyWithNewError(null),
          );

          await emit.onEach<QuoteListState>(
            _fetchQuotePage(
              1,
              fetchPolicy: QuoteListPageFetchPolicy.cacheAndNetwork,
            ),
            onData: emit,
          );
        } else if (event is QuoteListItemUpdated) {
          emit(
            state.copyWithUpdatedQuote(event.updatedQuote),
          );
        } else if (event is QuoteListUserAuthenticationChanged) {
          emit(
            QuoteListState(
              filter: state.filter,
            ),
          );
          await emit.onEach<QuoteListState>(
            _fetchQuotePage(
              1,
              fetchPolicy: QuoteListPageFetchPolicy.cacheAndNetwork,
            ),
            onData: emit,
          );
        } else if (event is QuoteListTagChanged) {
          emit(
            QuoteListState.loadingNewTag(tag: event.tag),
          );

          await emit.onEach<QuoteListState>(
            _fetchQuotePage(
              1,
              fetchPolicy: QuoteListPageFetchPolicy.cachePreferably,
            ),
            onData: emit,
          );
        } else if (event is QuoteListSearchTermChanged) {
          emit(
            QuoteListState.loadingNewSearchTerm(
              searchTerm: event.searchTerm,
            ),
          );

          await emit.onEach<QuoteListState>(
            _fetchQuotePage(
              1,
              fetchPolicy: QuoteListPageFetchPolicy.cachePreferably,
            ),
            onData: emit,
          );
        } else if (event is QuoteListRefreshed) {
          await emit.onEach<QuoteListState>(
            _fetchQuotePage(
              1,
              fetchPolicy: QuoteListPageFetchPolicy.networkOnly,
              isRefresh: true,
            ),
            onData: emit,
          );
        } else if (event is QuoteListNewPageRequested) {
          emit(
            state.copyWithNewError(null),
          );

          await emit.onEach<QuoteListState>(
            _fetchQuotePage(
              event.pageNumber,
              fetchPolicy: QuoteListPageFetchPolicy.networkPreferably,
            ),
            onData: emit,
          );
        } else if (event is QuoteListItemFavoriteToggled) {
          try {
            final updatedQuote = await (event is QuoteListItemFavorited
                ? _quoteRepository.favoriteQuote(event.id)
                : _quoteRepository.unfavoriteQuote(event.id));
            final isFilteringByFavorites =
                state.filter is QuoteListFilterByFavorites;
            if (!isFilteringByFavorites) {
              emit(
                state.copyWithUpdatedQuote(updatedQuote),
              );
            } else {
              emit(
                QuoteListState(
                  filter: state.filter,
                ),
              );

              await emit.onEach<QuoteListState>(
                _fetchQuotePage(
                  1,
                  fetchPolicy: QuoteListPageFetchPolicy.networkOnly,
                ),
                onData: emit,
              );
            }
          } catch (error) {
            emit(
              state.copyWithFavoriteToggleError(error),
            );
          }
        } else if (event is QuoteListFilterByFavoritesToggled) {
          final isFilteringByFavorites =
              state.filter is! QuoteListFilterByFavorites;

          emit(
            QuoteListState.loadingToggledFavoritesFilter(
              isFilteringByFavorites: isFilteringByFavorites,
            ),
          );

          await emit.onEach<QuoteListState>(
            _fetchQuotePage(
              1,
              fetchPolicy: isFilteringByFavorites
                  ? QuoteListPageFetchPolicy.cacheAndNetwork
                  : QuoteListPageFetchPolicy.cachePreferably,
            ),
            onData: emit,
          );
        }
      },
      transformer: _transformEvents,
    );
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

  Stream<QuoteListEvent> _transformEvents(
    Stream<QuoteListEvent> events,
    EventMapper<QuoteListEvent> mapper,
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
    return mergedEventStream.switchMap(mapper);
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
