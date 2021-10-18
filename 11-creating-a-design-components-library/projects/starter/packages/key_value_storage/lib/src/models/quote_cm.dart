import 'package:hive/hive.dart';

part 'quote_cm.g.dart';

@HiveType(typeId: 0)
class QuoteCM {
  const QuoteCM({
    required this.id,
    required this.body,
    required this.favoritesCount,
    required this.upvotesCount,
    required this.downvotesCount,
    this.author,
    this.isFavorite,
    this.isUpvoted,
    this.isDownvoted,
  });

  @HiveField(0)
  final int id;
  @HiveField(1)
  final String body;
  @HiveField(2)
  final String? author;
  @HiveField(3)
  final bool? isFavorite;
  @HiveField(4)
  final bool? isUpvoted;
  @HiveField(5)
  final bool? isDownvoted;
  @HiveField(6)
  final int favoritesCount;
  @HiveField(7)
  final int upvotesCount;
  @HiveField(8)
  final int downvotesCount;
}
