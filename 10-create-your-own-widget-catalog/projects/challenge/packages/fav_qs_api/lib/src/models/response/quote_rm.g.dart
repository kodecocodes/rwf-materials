// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteRM _$QuoteRMFromJson(Map<String, dynamic> json) {
  return $checkedNew('QuoteRM', json, () {
    final val = QuoteRM(
      id: $checkedConvert(json, 'id', (v) => v as int),
      body: $checkedConvert(json, 'body', (v) => v as String?),
      favoritesCount:
          $checkedConvert(json, 'favorites_count', (v) => v as int?) ?? 0,
      upvotesCount:
          $checkedConvert(json, 'upvotes_count', (v) => v as int?) ?? 0,
      downvotesCount:
          $checkedConvert(json, 'downvotes_count', (v) => v as int?) ?? 0,
      author: $checkedConvert(json, 'author', (v) => v as String?),
      userInfo: $checkedConvert(
          json,
          'user_details',
          (v) => v == null
              ? null
              : QuoteUserInfoRM.fromJson(v as Map<String, dynamic>)),
    );
    return val;
  }, fieldKeyMap: const {
    'favoritesCount': 'favorites_count',
    'upvotesCount': 'upvotes_count',
    'downvotesCount': 'downvotes_count',
    'userInfo': 'user_details'
  });
}
