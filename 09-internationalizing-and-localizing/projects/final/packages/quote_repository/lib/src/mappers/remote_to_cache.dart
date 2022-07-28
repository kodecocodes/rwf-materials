import 'package:fav_qs_api/fav_qs_api.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension QuoteListPageRMtoCM on QuoteListPageRM {
  QuoteListPageCM toCacheModel() {
    return QuoteListPageCM(
      isLastPage: isLastPage,
      quoteList: quoteList
          .map(
            (quote) => quote.toCacheModel(),
          )
          .toList(),
    );
  }
}

extension QuoteRMtoCM on QuoteRM {
  QuoteCM toCacheModel() {
    return QuoteCM(
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
