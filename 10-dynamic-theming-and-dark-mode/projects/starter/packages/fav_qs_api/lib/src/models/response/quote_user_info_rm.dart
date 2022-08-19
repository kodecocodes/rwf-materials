import 'package:json_annotation/json_annotation.dart';

part 'quote_user_info_rm.g.dart';

@JsonSerializable(createToJson: false)
class QuoteUserInfoRM {
  const QuoteUserInfoRM({
    required this.isFavorite,
    required this.isUpvoted,
    required this.isDownvoted,
  });

  @JsonKey(name: 'favorite')
  final bool isFavorite;
  @JsonKey(name: 'upvote')
  final bool isUpvoted;
  @JsonKey(name: 'downvote')
  final bool isDownvoted;

  static const fromJson = _$QuoteUserInfoRMFromJson;
}
