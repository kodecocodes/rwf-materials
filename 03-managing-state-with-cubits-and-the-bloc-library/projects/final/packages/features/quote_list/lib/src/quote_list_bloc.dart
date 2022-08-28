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
    _registerEventsHandler();

    add(const QuoteListOpened());

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

  void _registerEventsHandler() {
    on<QuoteListEvent>(
      (event, emitter) async {
        if (event is QuoteListOpened) {
          await _handleQuoteListOpened(emitter);
        } else if (event is QuoteListFailedFetchRetried) {
          await _handleQuoteListFailedFetchRetried(emitter);
        } else if (event is QuoteListItemUpdated) {
          _handleQuoteListItemUpdated(emitter, event);
        } else if (event is QuoteListUserAuthenticationChanged) {
          await _handleQuoteListUserAuthenticationChanged(emitter);
        } else if (event is QuoteListTagChanged) {
          await _handleQuoteListTagChanged(emitter, event);
        } else if (event is QuoteListSearchTermChanged) {
          await _handleQuoteListSearchTermChanged(emitter, event);
        } else if (event is QuoteListRefreshed) {
          await _handleQuoteListRefreshed(emitter, event);
        } else if (event is QuoteListNextPageRequested) {
          await _handleQuoteListNextPageRequested(emitter, event);
        } else if (event is QuoteListItemFavoriteToggled) {
          await _handleQuoteListItemFavoriteToggled(emitter, event);
        } else if (event is QuoteListFilterByFavoritesToggled) {
          await _handleQuoteListFilterByFavoritesToggled(emitter);
        }
      },
      transformer: _transformEvents,
    );
  }

  Future<void> _handleQuoteListOpened(Emitter emitter) {
    final firstPageFetchStream = _fetchQuotePage(
      1,
      fetchPolicy: QuoteListPageFetchPolicy.cacheAndNetwork,
    );

    return emitter.onEach(
      firstPageFetchStream,
      onData: emitter,
    );
  }

  Future<void> _handleQuoteListFailedFetchRetried(Emitter emitter) {
    emitter(
      state.copyWithNewError(null),
    );

    final firstPageFetchStream = _fetchQuotePage(
      1,
      fetchPolicy: QuoteListPageFetchPolicy.cacheAndNetwork,
    );

    return emitter.onEach<QuoteListState>(
      firstPageFetchStream,
      onData: emitter,
    );
  }

  void _handleQuoteListItemUpdated(
    Emitter emitter,
    QuoteListItemUpdated event,
  ) {
    emitter(
      state.copyWithUpdatedQuote(
        event.updatedQuote,
      ),
    );
  }

  Future<void> _handleQuoteListUserAuthenticationChanged(Emitter emitter) {
    emitter(
      QuoteListState(
        filter: state.filter,
      ),
    );

    final firstPageFetchStream = _fetchQuotePage(
      1,
      fetchPolicy: QuoteListPageFetchPolicy.cacheAndNetwork,
    );

    return emitter.onEach<QuoteListState>(
      firstPageFetchStream,
      onData: emitter,
    );
  }

  Future<void> _handleQuoteListTagChanged(
    Emitter emitter,
    QuoteListTagChanged event,
  ) {
    emitter(
      QuoteListState.loadingNewTag(tag: event.tag),
    );

    final firstPageFetchStream = _fetchQuotePage(
      1,
      fetchPolicy: QuoteListPageFetchPolicy.cachePreferably,
    );

    return emitter.onEach<QuoteListState>(
      firstPageFetchStream,
      onData: emitter,
    );
  }

  Future<void> _handleQuoteListSearchTermChanged(
    Emitter emitter,
    QuoteListSearchTermChanged event,
  ) {
    emitter(
      QuoteListState.loadingNewSearchTerm(
        searchTerm: event.searchTerm,
      ),
    );

    final firstPageFetchStream = _fetchQuotePage(
      1,
      fetchPolicy: QuoteListPageFetchPolicy.cachePreferably,
    );

    return emitter.onEach<QuoteListState>(
      firstPageFetchStream,
      onData: emitter,
    );
  }

  Future<void> _handleQuoteListRefreshed(
    Emitter emitter,
    QuoteListRefreshed event,
  ) {
    final firstPageFetchStream = _fetchQuotePage(
      1,
      fetchPolicy: QuoteListPageFetchPolicy.networkOnly,
      isRefresh: true,
    );

    return emitter.onEach<QuoteListState>(
      firstPageFetchStream,
      onData: emitter,
    );
  }

  Future<void> _handleQuoteListNextPageRequested(
    Emitter emitter,
    QuoteListNextPageRequested event,
  ) {
    emitter(
      state.copyWithNewError(null),
    );

    final nextPageFetchStream = _fetchQuotePage(
      event.pageNumber,
      fetchPolicy: QuoteListPageFetchPolicy.networkPreferably,
    );

    return emitter.onEach<QuoteListState>(
      nextPageFetchStream,
      onData: emitter,
    );
  }

  Future<void> _handleQuoteListItemFavoriteToggled(
    Emitter emitter,
    QuoteListItemFavoriteToggled event,
  ) async {
    try {
      final updatedQuote = await (event is QuoteListItemFavorited
          ? _quoteRepository.favoriteQuote(
              event.id,
            )
          : _quoteRepository.unfavoriteQuote(
              event.id,
            ));
      final isFilteringByFavorites = state.filter is QuoteListFilterByFavorites;
      if (!isFilteringByFavorites) {
        emitter(
          state.copyWithUpdatedQuote(
            updatedQuote,
          ),
        );
      } else {
        emitter(
          QuoteListState(
            filter: state.filter,
          ),
        );

        final firstPageFetchStream = _fetchQuotePage(
          1,
          fetchPolicy: QuoteListPageFetchPolicy.networkOnly,
        );

        await emitter.onEach<QuoteListState>(
          firstPageFetchStream,
          onData: emitter,
        );
      }
    } catch (error) {
      emitter(
        state.copyWithFavoriteToggleError(
          error,
        ),
      );
    }
  }

  Future<void> _handleQuoteListFilterByFavoritesToggled(
    Emitter emitter,
  ) {
    final isFilteringByFavorites = state.filter is! QuoteListFilterByFavorites;

    emitter(
      QuoteListState.loadingToggledFavoritesFilter(
        isFilteringByFavorites: isFilteringByFavorites,
      ),
    );

    final firstPageFetchStream = _fetchQuotePage(
      1,
      fetchPolicy: isFilteringByFavorites
          ? QuoteListPageFetchPolicy.cacheAndNetwork
          : QuoteListPageFetchPolicy.cachePreferably,
    );

    return emitter.onEach<QuoteListState>(
      firstPageFetchStream,
      onData: emitter,
    );
  }

  Stream<QuoteListState> _fetchQuotePage(
    int page, {
    required QuoteListPageFetchPolicy fetchPolicy,
    bool isRefresh = false,
  }) async* {
    final currentlyAppliedFilter = state.filter;
    final isFilteringByFavorites =
        currentlyAppliedFilter is QuoteListFilterByFavorites;
    final isUserSignedIn = _authenticatedUsername != null;
    if (isFilteringByFavorites && !isUserSignedIn) {
      yield QuoteListState.noItemsFound(
        filter: currentlyAppliedFilter,
      );
    } else {
      final pagesStream = _quoteRepository.getQuoteListPage(
        page,
        tag: currentlyAppliedFilter is QuoteListFilterByTag
            ? currentlyAppliedFilter.tag
            : null,
        searchTerm: currentlyAppliedFilter is QuoteListFilterBySearchTerm
            ? currentlyAppliedFilter.searchTerm
            : '',
        favoritedByUsername:
            currentlyAppliedFilter is QuoteListFilterByFavorites
                ? _authenticatedUsername
                : null,
        fetchPolicy: fetchPolicy,
      );

      try {
        await for (final newPage in pagesStream) {
          final newItemList = newPage.quoteList;
          final oldItemList = state.itemList ?? [];
          final completeItemList =
              isRefresh ? newItemList : (oldItemList + newItemList);

          final nextPage = newPage.isLastPage ? null : page + 1;

          yield QuoteListState.success(
            nextPage: nextPage,
            itemList: completeItemList,
            filter: currentlyAppliedFilter,
            isRefresh: isRefresh,
          );
        }
      } catch (error) {
        if (error is EmptySearchResultException) {
          yield QuoteListState.noItemsFound(
            filter: currentlyAppliedFilter,
          );
        }

        if (isRefresh) {
          yield state.copyWithNewRefreshError(
            error,
          );
        } else {
          yield state.copyWithNewError(
            error,
          );
        }
      }
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
