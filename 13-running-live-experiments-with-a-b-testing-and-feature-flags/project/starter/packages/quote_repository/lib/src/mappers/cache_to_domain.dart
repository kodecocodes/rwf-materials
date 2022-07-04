import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension QuoteListPageCMtoDomain on QuoteListPageCM {
  QuoteListPage toDomainModel() {
    return QuoteListPage(
      isLastPage: isLastPage,
      quoteList: quoteList
          .map(
            (quote) => quote.toDomainModel(),
          )
          .toList(),
    );
  }
}

extension QuoteCMtoDomain on QuoteCM {
  Quote toDomainModel() {
    return Quote(
      id: id,
      body: body,
      author: author,
      favoritesCount: favoritesCount,
      upvotesCount: upvotesCount,
      downvotesCount: downvotesCount,
      isUpvoted: isUpvoted,
      isDownvoted: isDownvoted,
      isFavorite: isFavorite,
    );
  }
}
