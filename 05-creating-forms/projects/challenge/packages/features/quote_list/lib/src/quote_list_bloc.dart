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

    add(
      const QuoteListOpened(),
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

  void _registerEventsHandler() {
    on<QuoteListEvent>(
      (event, emitter) async {
        if (event is QuoteListOpened || event is QuoteListFailedFetchRetried) {
          emitter(
            state.copyWithNewError(null),
          );

          final firstPageFetchStream = _fetchQuotePage(
            1,
            fetchPolicy: QuoteListPageFetchPolicy.cacheAndNetwork,
          );

          await emitter.onEach<QuoteListState>(
            firstPageFetchStream,
            onData: emitter,
          );
        } else if (event is QuoteListItemUpdated) {
          emitter(
            state.copyWithUpdatedQuote(
              event.updatedQuote,
            ),
          );
        } else if (event is QuoteListUserAuthenticationChanged) {
          emitter(
            QuoteListState(
              filter: state.filter,
            ),
          );

          await emitter.onEach<QuoteListState>(
            _fetchQuotePage(
              1,
              fetchPolicy: QuoteListPageFetchPolicy.cacheAndNetwork,
            ),
            onData: emitter,
          );
        } else if (event is QuoteListTagChanged) {
          emitter(
            QuoteListState.loadingNewTag(tag: event.tag),
          );

          await emitter.onEach<QuoteListState>(
            _fetchQuotePage(
              1,
              fetchPolicy: QuoteListPageFetchPolicy.cachePreferably,
            ),
            onData: emitter,
          );
        } else if (event is QuoteListSearchTermChanged) {
          emitter(
            QuoteListState.loadingNewSearchTerm(
              searchTerm: event.searchTerm,
            ),
          );

          await emitter.onEach<QuoteListState>(
            _fetchQuotePage(
              1,
              fetchPolicy: QuoteListPageFetchPolicy.cachePreferably,
            ),
            onData: emitter,
          );
        } else if (event is QuoteListRefreshed) {
          await emitter.onEach<QuoteListState>(
            _fetchQuotePage(
              1,
              fetchPolicy: QuoteListPageFetchPolicy.networkOnly,
              isRefresh: true,
            ),
            onData: emitter,
          );
        } else if (event is QuoteListNewPageRequested) {
          emitter(
            state.copyWithNewError(null),
          );

          await emitter.onEach<QuoteListState>(
            _fetchQuotePage(
              event.pageNumber,
              fetchPolicy: QuoteListPageFetchPolicy.networkPreferably,
            ),
            onData: emitter,
          );
        } else if (event is QuoteListItemFavoriteToggled) {
          try {
            final updatedQuote = await (event is QuoteListItemFavorited
                ? _quoteRepository.favoriteQuote(
                    event.id,
                  )
                : _quoteRepository.unfavoriteQuote(
                    event.id,
                  ));
            final isFilteringByFavorites =
                state.filter is QuoteListFilterByFavorites;
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

              await emitter.onEach<QuoteListState>(
                _fetchQuotePage(
                  1,
                  fetchPolicy: QuoteListPageFetchPolicy.networkOnly,
                ),
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
        } else if (event is QuoteListFilterByFavoritesToggled) {
          final isFilteringByFavorites =
              state.filter is! QuoteListFilterByFavorites;

          emitter(
            QuoteListState.loadingToggledFavoritesFilter(
              isFilteringByFavorites: isFilteringByFavorites,
            ),
          );

          await emitter.onEach<QuoteListState>(
            _fetchQuotePage(
              1,
              fetchPolicy: isFilteringByFavorites
                  ? QuoteListPageFetchPolicy.cacheAndNetwork
                  : QuoteListPageFetchPolicy.cachePreferably,
            ),
            onData: emitter,
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
