part of 'quote_list_bloc.dart';

class QuoteListState extends Equatable {
  const QuoteListState({
    this.itemList,
    this.nextPage,
    this.error,
    this.filter,
    this.refreshError,
    this.favoriteToggleError,
    DateTime? fetchTimestamp,
  }) : _fetchTimestamp = fetchTimestamp;

  final List<Quote>? itemList;
  final int? nextPage;
  final dynamic error;
  final QuoteListFilter? filter;
  final DateTime? _fetchTimestamp;
  final dynamic refreshError;
  final dynamic favoriteToggleError;

  factory QuoteListState.loadingNewTag({
    required Tag? tag,
  }) {
    return QuoteListState(
      filter: tag != null ? QuoteListFilterByTag(tag) : null,
    );
  }

  factory QuoteListState.loadingNewSearchTerm({
    required String searchTerm,
  }) {
    return QuoteListState(
      filter: searchTerm.isEmpty
          ? null
          : QuoteListFilterBySearchTerm(
              searchTerm,
            ),
    );
  }

  factory QuoteListState.loadingToggledFavoritesFilter({
    required bool isFilteringByFavorites,
  }) {
    return QuoteListState(
      filter:
          isFilteringByFavorites ? const QuoteListFilterByFavorites() : null,
    );
  }

  factory QuoteListState.noItemsFound({
    required QuoteListFilter? filter,
  }) {
    return QuoteListState(
      itemList: const [],
      error: null,
      nextPage: 1,
      filter: filter,
    );
  }

  factory QuoteListState.success({
    required int? nextPage,
    required List<Quote> itemList,
    required QuoteListFilter? filter,
    required bool isRefresh,
  }) {
    return QuoteListState(
      nextPage: nextPage,
      itemList: itemList,
      filter: filter,
      fetchTimestamp: isRefresh ? DateTime.now() : null,
    );
  }

  QuoteListState copyWithNewError(dynamic error) => QuoteListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        refreshError: null,
        fetchTimestamp: _fetchTimestamp,
      );

  QuoteListState copyWithNewRefreshError(
    dynamic refreshError,
  ) =>
      QuoteListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        refreshError: refreshError,
        fetchTimestamp: _fetchTimestamp,
        favoriteToggleError: null,
      );

  QuoteListState copyWithUpdatedQuote(
    Quote updatedQuote,
  ) {
    return QuoteListState(
      itemList: itemList?.map((quote) {
        if (quote.id == updatedQuote.id) {
          return updatedQuote;
        } else {
          return quote;
        }
      }).toList(),
      nextPage: nextPage,
      error: error,
      filter: filter,
      refreshError: null,
      fetchTimestamp: _fetchTimestamp,
      favoriteToggleError: null,
    );
  }

  QuoteListState copyWithFavoriteToggleError(
    dynamic favoriteToggleError,
  ) =>
      QuoteListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        refreshError: refreshError,
        fetchTimestamp: _fetchTimestamp,
        favoriteToggleError: favoriteToggleError,
      );

  @override
  List<Object?> get props => [
        itemList,
        nextPage,
        error,
        filter,
        _fetchTimestamp,
        refreshError,
        favoriteToggleError,
      ];
}

abstract class QuoteListFilter extends Equatable {
  const QuoteListFilter();

  @override
  List<Object?> get props => [];
}

class QuoteListFilterByTag extends QuoteListFilter {
  const QuoteListFilterByTag(this.tag);

  final Tag tag;

  @override
  List<Object?> get props => [
        tag,
      ];
}

class QuoteListFilterBySearchTerm extends QuoteListFilter {
  const QuoteListFilterBySearchTerm(this.searchTerm);

  final String searchTerm;

  @override
  List<Object?> get props => [
        searchTerm,
      ];
}

class QuoteListFilterByFavorites extends QuoteListFilter {
  const QuoteListFilterByFavorites();
}
