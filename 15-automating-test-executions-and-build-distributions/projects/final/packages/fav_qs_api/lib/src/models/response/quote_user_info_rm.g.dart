// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_user_info_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteUserInfoRM _$QuoteUserInfoRMFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'QuoteUserInfoRM',
      json,
      ($checkedConvert) {
        final val = QuoteUserInfoRM(
          isFavorite: $checkedConvert('favorite', (v) => v as bool),
          isUpvoted: $checkedConvert('upvote', (v) => v as bool),
          isDownvoted: $checkedConvert('downvote', (v) => v as bool),
        );
        return val;
      },
      fieldKeyMap: const {
        'isFavorite': 'favorite',
        'isUpvoted': 'upvote',
        'isDownvoted': 'downvote'
      },
    );
