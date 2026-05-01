class Comment {
  final String id;
  final String postId;
  final String? parentCommentId;
  final String author;
  final String? authorProfileImageUrl;
  final String comment;
  final int likesCount;
  final int repliesCount;

  final List<Comment> replies;
  final int currentRepliesPage;
  final bool hasMoreReplies;
  final bool isRepliesLoaded;

  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isLikedByCurrentUser;

  const Comment({
    required this.id,
    required this.postId,
    this.parentCommentId,
    required this.author,
    this.authorProfileImageUrl,
    required this.comment,
    required this.likesCount,
    required this.repliesCount,
    this.replies = const [],
    this.currentRepliesPage = 0,
    this.hasMoreReplies = false,
    this.isRepliesLoaded = false,
    required this.createdAt,
    required this.updatedAt,
    required this.isLikedByCurrentUser,
  });

  Comment copyWith({
    String? id,
    String? postId,
    String? parentCommentId,
    String? author,
    String? authorProfileImageUrl,
    String? comment,
    int? likesCount,
    int? repliesCount,
    List<Comment>? replies,
    int? currentRepliesPage,
    bool? hasMoreReplies,
    bool? isRepliesLoaded,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLikedByCurrentUser,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      author: author ?? this.author,
      authorProfileImageUrl:
          authorProfileImageUrl ?? this.authorProfileImageUrl,
      comment: comment ?? this.comment,
      likesCount: likesCount ?? this.likesCount,
      repliesCount: repliesCount ?? this.repliesCount,
      replies: replies ?? this.replies,
      currentRepliesPage: currentRepliesPage ?? this.currentRepliesPage,
      hasMoreReplies: hasMoreReplies ?? this.hasMoreReplies,
      isRepliesLoaded: isRepliesLoaded ?? this.isRepliesLoaded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLikedByCurrentUser: isLikedByCurrentUser ?? this.isLikedByCurrentUser,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Comment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
