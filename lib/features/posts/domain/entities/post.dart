import 'comment.dart';

class Post {
  final String id;
  final String title;
  final String description;
  final String userName;
  final String? userProfileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final List<Comment> comments;
  final bool isLikedByCurrentUser;

  const Post({
    required this.id,
    required this.title,
    required this.description,
    required this.userName,
    required this.userProfileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.comments,
    required this.isLikedByCurrentUser,
  });

  Post copyWith({
    String? id,
    String? title,
    String? description,
    String? userName,
    String? userProfileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    List<Comment>? comments,
    bool? isLikedByCurrentUser,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userName: userName ?? this.userName,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      comments: comments ?? this.comments,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }

  factory Post.empty() => Post(
    id: '',
    title: '',
    description: '',
    userName: '',
    userProfileImageUrl: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    likesCount: 0,
    commentsCount: 0,
    sharesCount: 0,
    comments: const [],
    isLikedByCurrentUser: false,
  );
}
