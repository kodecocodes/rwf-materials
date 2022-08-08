// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_user_info_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteUserInfoRM _$QuoteUserInfoRMFromJson(Map<String, dynamic> json) {
  return $checkedNew('QuoteUserInfoRM', json, () {
    final val = QuoteUserInfoRM(
      isFavorite: $checkedConvert(json, 'favorite', (v) => v as bool),
      isUpvoted: $checkedConvert(json, 'upvote', (v) => v as bool),
      isDownvoted: $checkedConvert(json, 'downvote', (v) => v as bool),
    );
    return val;
  }, fieldKeyMap: const {
    'isFavorite': 'favorite',
    'isUpvoted': 'upvote',
    'isDownvoted': 'downvote'
  });
}
