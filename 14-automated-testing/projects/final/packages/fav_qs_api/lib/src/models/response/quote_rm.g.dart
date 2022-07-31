// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteRM _$QuoteRMFromJson(Map<String, dynamic> json) => $checkedCreate(
      'QuoteRM',
      json,
      ($checkedConvert) {
        final val = QuoteRM(
          id: $checkedConvert('id', (v) => v as int),
          body: $checkedConvert('body', (v) => v as String?),
          favoritesCount:
              $checkedConvert('favorites_count', (v) => v as int? ?? 0),
          upvotesCount: $checkedConvert('upvotes_count', (v) => v as int? ?? 0),
          downvotesCount:
              $checkedConvert('downvotes_count', (v) => v as int? ?? 0),
          author: $checkedConvert('author', (v) => v as String?),
          userInfo: $checkedConvert(
              'user_details',
              (v) => v == null
                  ? null
                  : QuoteUserInfoRM.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'favoritesCount': 'favorites_count',
        'upvotesCount': 'upvotes_count',
        'downvotesCount': 'downvotes_count',
        'userInfo': 'user_details'
      },
    );
