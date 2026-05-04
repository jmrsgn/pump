import '../../domain/entities/comment.dart';

class CommentResponse {
  final String id;
  final String comment;
  final String postId;
  final String? parentCommentId;
  final String author;
  final String? authorProfileImageUrl;
  final int likesCount;
  final int repliesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isLikedByCurrentUser;
  final bool isOwnedByCurrentUser;

  const CommentResponse({
    required this.id,
    required this.comment,
    required this.postId,
    this.parentCommentId,
    required this.author,
    this.authorProfileImageUrl,
    required this.likesCount,
    required this.repliesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.isLikedByCurrentUser,
    required this.isOwnedByCurrentUser,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      id: json['id'] ?? '',
      comment: json['comment'] ?? '',
      postId: json['postId'] ?? '',
      parentCommentId: json['parentCommentId'] as String?,
      author: json['author'] ?? '',
      authorProfileImageUrl: json['authorProfileImageUrl'] as String?,
      likesCount: json['likesCount'] ?? 0,
      repliesCount: json['repliesCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isLikedByCurrentUser: json['isLikedByCurrentUser'] ?? false,
      isOwnedByCurrentUser: json['isOwnedByCurrentUser'] ?? false,
    );
  }

  Comment toComment() {
    return Comment(
      id: id,
      postId: postId,
      parentCommentId: parentCommentId,
      author: author,
      authorProfileImageUrl: authorProfileImageUrl,
      comment: comment,
      likesCount: likesCount,
      repliesCount: repliesCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isLikedByCurrentUser: isLikedByCurrentUser,
      isOwnedByCurrentUser: isOwnedByCurrentUser,
    );
  }
}
