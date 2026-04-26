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
    this.hasMoreReplies = true,
    this.isRepliesLoaded = false,
    required this.createdAt,
    required this.updatedAt,
    required this.isLikedByCurrentUser,
  });

  Comment copyWith({
    List<Comment>? replies,
    int? currentRepliesPage,
    bool? hasMoreReplies,
    bool? isRepliesLoaded,
  }) {
    return Comment(
      id: id,
      postId: postId,
      parentCommentId: parentCommentId,
      author: author,
      authorProfileImageUrl: authorProfileImageUrl,
      comment: comment,
      likesCount: likesCount,
      repliesCount: repliesCount,
      replies: replies ?? this.replies,
      currentRepliesPage: currentRepliesPage ?? this.currentRepliesPage,
      hasMoreReplies: hasMoreReplies ?? this.hasMoreReplies,
      isRepliesLoaded: isRepliesLoaded ?? this.isRepliesLoaded,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isLikedByCurrentUser: isLikedByCurrentUser,
    );
  }
}
