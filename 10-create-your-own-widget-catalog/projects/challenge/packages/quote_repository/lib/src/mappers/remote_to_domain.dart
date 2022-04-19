import 'package:domain_models/domain_models.dart';
import 'package:fav_qs_api/fav_qs_api.dart';

extension QuoteListPageRMtoDomain on QuoteListPageRM {
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

extension QuoteRMtoDomain on QuoteRM {
  Quote toDomainModel() {
    return Quote(
      id: id,
      body: body ?? '',
      author: author,
      favoritesCount: favoritesCount,
      upvotesCount: upvotesCount,
      downvotesCount: downvotesCount,
      isFavorite: userInfo?.isFavorite,
      isUpvoted: userInfo?.isUpvoted,
      isDownvoted: userInfo?.isDownvoted,
    );
  }
}
