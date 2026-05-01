import '../../domain/entities/post.dart';
import 'comment_response_dto.dart';

class PostResponse {
  final String id;
  final String title;
  final String? description;
  final String author;
  final String? authorProfileImageUrl;
  final String? mediaUrl;
  final String? mediaType;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final List<CommentResponse> comments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isLikedByCurrentUser;
  final bool isOwnedByCurrentUser;

  const PostResponse({
    required this.id,
    required this.title,
    this.description,
    required this.author,
    this.authorProfileImageUrl,
    this.mediaUrl,
    this.mediaType,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
    required this.isLikedByCurrentUser,
    required this.isOwnedByCurrentUser,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      author: json['author'] ?? '',
      authorProfileImageUrl: json['authorProfileImageUrl'],
      mediaUrl: json['mediaUrl'],
      mediaType: json['mediaType'],
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      sharesCount: json['sharesCount'] ?? 0,
      isLikedByCurrentUser: json['isLikedByCurrentUser'] ?? false,
      isOwnedByCurrentUser: json['isOwnedByCurrentUser'] ?? false,
      comments: (json['comments'] as List? ?? [])
          .map((e) => CommentResponse.fromJson(e))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Post toPost() {
    return Post(
      id: id,
      title: title,
      description: description ?? '',
      userName: author,
      userProfileImageUrl: authorProfileImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      likesCount: likesCount,
      commentsCount: commentsCount,
      sharesCount: sharesCount,
      comments: comments.map((e) => e.toComment()).toList(),
      isLikedByCurrentUser: isLikedByCurrentUser,
      isOwnedByCurrentUser: isOwnedByCurrentUser,
    );
  }
}
