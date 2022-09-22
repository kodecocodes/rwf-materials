import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
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

    _authChangesSubscription = userRepository.getUser().listen(
      (user) {
        _authenticatedUsername = user?.username;

        add(
          const QuoteListUsernameObtained(),
        );
      },
    );
  }

  late final StreamSubscription _authChangesSubscription;

  String? _authenticatedUsername;
  final QuoteRepository _quoteRepository;

  void _registerEventsHandler() {
    on<QuoteListEvent>(
      (event, emitter) async {
        if (event is QuoteListUsernameObtained) {
          await _handleQuoteListUsernameObtained(emitter);
        } else if (event is QuoteListFailedFetchRetried) {
          await _handleQuoteListFailedFetchRetried(emitter);
        } else if (event is QuoteListItemUpdated) {
          _handleQuoteListItemUpdated(emitter, event);
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
      transformer: (eventStream, eventHandler) {
        final nonDebounceEventStream = eventStream.where(
          (event) => event is! QuoteListSearchTermChanged,
        );

        final debounceEventStream = eventStream
            .whereType<QuoteListSearchTermChanged>()
            .debounceTime(
              const Duration(seconds: 1),
            )
            .where((event) {
          final previousFilter = state.filter;
          final previousSearchTerm =
              previousFilter is QuoteListFilterBySearchTerm
                  ? previousFilter.searchTerm
                  : '';

          return event.searchTerm != previousSearchTerm;
        });

        final mergedEventStream = MergeStream([
          nonDebounceEventStream,
          debounceEventStream,
        ]);

        final restartableTransformer = restartable<QuoteListEvent>();
        return restartableTransformer(mergedEventStream, eventHandler);
      },
    );
  }

  Future<void> _handleQuoteListFailedFetchRetried(Emitter emitter) {
    // Clears out the error and puts the loading indicator back on the screen.
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
    // Replaces the updated quote in the current state and re-emits it.
    emitter(
      state.copyWithUpdatedQuote(
        event.updatedQuote,
      ),
    );
  }

  Future<void> _handleQuoteListUsernameObtained(Emitter emitter) {
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
      // If the user is *deselecting* a tag, the `cachePreferably` fetch policy
      // will return you the cached quotes. If the user is selecting a new tag
      // instead, the `cachePreferably` fetch policy won't find any cached
      // quotes and will instead use the network.
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
      // If the user is *clearing out* the search bar, the `cachePreferably`
      // fetch policy will return you the cached quotes. If the user is
      // entering a new search instead, the `cachePreferably` fetch policy
      // won't find any cached quotes and will instead use the network.
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
      // Since the user is asking for a refresh, you don't want to get cached
      // quotes, thus the `networkOnly` fetch policy makes the most sense.
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
      // The `networkPreferably` fetch policy prioritizes fetching the new page
      // from the server, and, if it fails, try grabbing it from the cache.
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
      // The `favoriteQuote()` and `unfavoriteQuote()` functions return you the
      // updated quote object.
      final updatedQuote = await (event is QuoteListItemFavorited
          ? _quoteRepository.favoriteQuote(
              event.id,
            )
          : _quoteRepository.unfavoriteQuote(
              event.id,
            ));
      final isFilteringByFavorites = state.filter is QuoteListFilterByFavorites;

      // If the user isn't filtering by favorites, you just replace the changed
      // quote on-screen.
      if (!isFilteringByFavorites) {
        emitter(
          state.copyWithUpdatedQuote(
            updatedQuote,
          ),
        );
      } else {
        // If the user *is* filtering by favorites, that means the user is
        // actually *removing* a quote from the list, so you refresh the entire
        // list to make sure you won't break the pagination.
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
      // If an error happens trying to (un)favorite a quote you attach an error
      // to the current state which will result on the screen showing a snackbar
      // to the user and possibly taking him to the Sign In screen in case the
      // cause is the user being signed out.
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
      // If the user is *adding* the favorites filter, you use the *cacheAndNetwork*
      // fetch policy to show the cached data first followed by the updated list
      // from the server.
      // If the user is *removing* the favorites filter, you simply show the
      // cached data they were seeing before applying the filter.
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
          final completeItemList = isRefresh || page == 1
              ? newItemList
              : (oldItemList + newItemList);

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

  @override
  Future<void> close() {
    _authChangesSubscription.cancel();
    return super.close();
  }
}
