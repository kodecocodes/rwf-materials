import 'package:equatable/equatable.dart';

class Quote extends Equatable {
  const Quote({
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

  final int id;
  final String body;
  final String? author;
  final bool? isFavorite;
  final bool? isUpvoted;
  final bool? isDownvoted;
  final int favoritesCount;
  final int upvotesCount;
  final int downvotesCount;

  @override
  List<Object?> get props => [
        id,
        body,
        author,
        isFavorite,
        isUpvoted,
        isDownvoted,
        favoritesCount,
        upvotesCount,
        downvotesCount,
      ];
}
