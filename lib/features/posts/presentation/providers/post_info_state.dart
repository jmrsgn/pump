import 'package:pump/core/presentation/providers/ui_state.dart';

import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';

class PostInfoState extends UiState {
  final Post post;
  final List<Comment> comments;
  final int currentPage;
  final bool hasNext;

  // for reply creation / UI feedback
  final Comment? createdComment;
  final Comment? commentReplyingTo;

  const PostInfoState({
    required super.isLoading,
    super.errorMessage,
    required this.post,
    required this.comments,
    required this.currentPage,
    required this.hasNext,
    this.createdComment,
    this.commentReplyingTo,
  });

  @override
  PostInfoState copyWith({
    Post? post,
    bool? isLoading,
    String? errorMessage,
    List<Comment>? comments,
    int? currentPage,
    bool? hasNext,
    Comment? createdComment,
    Comment? commentReplyingTo,
  }) {
    return PostInfoState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      post: post ?? this.post,
      comments: comments ?? this.comments,
      currentPage: currentPage ?? this.currentPage,
      hasNext: hasNext ?? this.hasNext,
      createdComment: createdComment ?? this.createdComment,
      commentReplyingTo: commentReplyingTo ?? this.commentReplyingTo,
    );
  }

  factory PostInfoState.initial() {
    return PostInfoState(
      isLoading: false,
      errorMessage: null,
      post: Post.empty(),
      comments: const [],
      currentPage: 0,
      hasNext: true,
      createdComment: null,
      commentReplyingTo: null,
    );
  }
}
