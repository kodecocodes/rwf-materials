part of 'quote_list_bloc.dart';

/// Holds all data needed to infer the state of the paginated grid of quotes.
///
/// You don't have to memorize what combination of properties lead to which
/// visual outputs, the [infinite_scroll_pagination](https://github.com/EdsonBueno/infinite_scroll_pagination)
/// package takes care of that. Simply provide the values as you have them and
/// everything will work.
///
/// For example:
/// 1. If both [itemList] and [error] aren't null, that is, if you have
/// both some quotes and an error at the same time, that means the error occurred
/// trying to fetch a *subsequent* page, therefore, the error indicator should
/// be appended to the bottom of the grid instead of taking the whole screen.
/// 2. If [error] isn't null but [itemList] is, that
/// means the error occurred trying to fetch the *first* page, in which case you
/// want to display the full-screen error indicator since you don't have any
/// quotes to show.
/// 3. If there's no [error], [itemList] has some items and [nextPage] isn't null,
/// that means you haven't fetched all pages yet and therefore a loading indicator
/// should be appended to the bottom of the grid.
class QuoteListState extends Equatable {
  const QuoteListState({
    this.itemList,
    this.nextPage,
    this.error,
    this.filter,
    this.refreshError,
    this.favoriteToggleError,
  });

  /// Holds all of the items from the pages you have loaded so far.
  final List<Quote>? itemList;

  /// The next page to be fetched, or `null` if you have already loaded the entire list.
  ///
  /// Besides determining which page should be asked next, it also determines
  /// whether you need a loading indicator at the bottom to indicate you haven't
  /// fetched all pages yet.
  final int? nextPage;

  /// Indicates an error occurred trying to fetch any page of quotes.
  ///
  /// If both this property and [itemList] holds values, that means the error
  /// occurred trying to fetch a subsequent page. If, on the other hand, this
  /// property has a value but [itemList] doesn't, that means the error occurred
  /// when fetching the first page.
  final dynamic error;

  /// The currently applied filter (if any).
  ///
  /// Can be either a tag filter (`QuoteListFilterByTag`), a search filter (`QuoteListFilterBySearchTerm`),
  /// or a favorites-only one (`QuoteListFilterByFavorites`).
  final QuoteListFilter? filter;

  /// Indicates an error occurred trying to refresh the list.
  ///
  /// Used to display a snackbar to indicate the failure.
  final dynamic refreshError;

  /// Indicates an error occurred trying to favorite a quote.
  ///
  /// Used to display a snackbar to the user indicating the failure and also
  /// redirect them to the Sign In screen in case the cause of the error is the
  /// user being signed out.
  final dynamic favoriteToggleError;

  /// Auxiliary constructor that facilitates building the state for when the app
  /// is loading a tag change.
  QuoteListState.loadingNewTag({
    required Tag? tag,
  }) : this(
          filter: tag != null ? QuoteListFilterByTag(tag) : null,
        );

  /// Auxiliary constructor that facilitates building the state for when the app
  /// is loading a search change.
  QuoteListState.loadingNewSearchTerm({
    required String searchTerm,
  }) : this(
          filter: searchTerm.isEmpty
              ? null
              : QuoteListFilterBySearchTerm(
                  searchTerm,
                ),
        );

  /// Auxiliary constructor that facilitates building the state for when the app
  /// is loading a change in the favorites-only toggle.
  const QuoteListState.loadingToggledFavoritesFilter({
    required bool isFilteringByFavorites,
  }) : this(
          filter: isFilteringByFavorites
              ? const QuoteListFilterByFavorites()
              : null,
        );

  /// Auxiliary constructor that facilitates building the state for when the app
  /// couldn't find any items for the selected filter.
  const QuoteListState.noItemsFound({
    required QuoteListFilter? filter,
  }) : this(
          itemList: const [],
          error: null,
          nextPage: 1,
          filter: filter,
        );

  /// Auxiliary constructor that facilitates building the state for when the app
  /// has successfully loaded a new page.
  const QuoteListState.success({
    required int? nextPage,
    required List<Quote> itemList,
    required QuoteListFilter? filter,
    required bool isRefresh,
  }) : this(
          nextPage: nextPage,
          itemList: itemList,
          filter: filter,
        );

  /// Auxiliary function that creates a copy of the current state with a new
  /// value for the [error] property.
  QuoteListState copyWithNewError(
    dynamic error,
  ) =>
      QuoteListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        refreshError: null,
      );

  /// Auxiliary function that creates a copy of the current state with a new
  /// value for the [refreshError] property.
  QuoteListState copyWithNewRefreshError(
    dynamic refreshError,
  ) =>
      QuoteListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        refreshError: refreshError,
        favoriteToggleError: null,
      );

  /// Auxiliary function that creates a copy of the current state by replacing
  /// just the [updatedQuote].
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
      favoriteToggleError: null,
    );
  }

  /// Auxiliary function that creates a copy of the current state with a new
  /// value for the [favoriteToggleError] property.
  QuoteListState copyWithFavoriteToggleError(
    dynamic favoriteToggleError,
  ) =>
      QuoteListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        refreshError: refreshError,
        favoriteToggleError: favoriteToggleError,
      );

  @override
  List<Object?> get props => [
        itemList,
        nextPage,
        error,
        filter,
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
