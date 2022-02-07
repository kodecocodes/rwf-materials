part of 'quote_list_bloc.dart';

abstract class QuoteListEvent extends Equatable {
  const QuoteListEvent();

  @override
  List<Object?> get props => [];
}

class QuoteListFirstPageRequested extends QuoteListEvent {
  const QuoteListFirstPageRequested();
}

class QuoteListFilterByFavoritesToggled extends QuoteListEvent {
  const QuoteListFilterByFavoritesToggled();
}

class QuoteListUserAuthenticationChanged extends QuoteListEvent {
  const QuoteListUserAuthenticationChanged();
}

class QuoteListTagChanged extends QuoteListEvent {
  const QuoteListTagChanged(
    this.tag,
  );

  final Tag? tag;

  @override
  List<Object?> get props => [
        tag,
      ];
}

class QuoteListSearchTermChanged extends QuoteListEvent {
  const QuoteListSearchTermChanged(
    this.searchTerm,
  );

  final String searchTerm;

  @override
  List<Object?> get props => [
        searchTerm,
      ];
}

class QuoteListRefreshed extends QuoteListEvent {
  const QuoteListRefreshed();
}

class QuoteListNewPageRequested extends QuoteListEvent {
  const QuoteListNewPageRequested({
    required this.pageNumber,
  });

  final int pageNumber;
}

abstract class QuoteListItemFavoriteToggled extends QuoteListEvent {
  const QuoteListItemFavoriteToggled(this.id);

  final int id;
}

class QuoteListItemUpdated extends QuoteListEvent {
  const QuoteListItemUpdated(
    this.updatedQuote,
  );

  final Quote updatedQuote;
}

class QuoteListItemFavorited extends QuoteListItemFavoriteToggled {
  const QuoteListItemFavorited(int id) : super(id);
}

class QuoteListItemUnfavorited extends QuoteListItemFavoriteToggled {
  const QuoteListItemUnfavorited(int id) : super(id);
}
