class Comment {
  final String id;
  final String postId;
  final String author;
  final String? authorProfileImageUrl;
  final String comment;
  final int likesCount;
  final int repliesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isLikedByCurrentUser;

  const Comment({
    required this.id,
    required this.postId,
    required this.author,
    required this.authorProfileImageUrl,
    required this.comment,
    required this.likesCount,
    required this.repliesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.isLikedByCurrentUser,
  });
}
