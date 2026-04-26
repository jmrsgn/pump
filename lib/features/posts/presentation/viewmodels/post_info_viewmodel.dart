import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/error/validation_error_constants.dart';
import 'package:pump/core/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/features/posts/domain/entities/post.dart';
import 'package:pump/features/posts/domain/usecases/create_comment_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_comments_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_replies_usecase.dart';
import 'package:pump/features/posts/domain/usecases/like_post_usecase.dart';
import 'package:pump/features/posts/presentation/providers/post_info_state.dart';

import '../../../../core/utilities/logger_utility.dart';
import '../../domain/entities/comment.dart';
import '../providers/post_providers.dart';

class PostInfoViewModel extends BaseViewModel<PostInfoState> {
  final Ref ref;
  final GetAuthenticatedUserUseCase _getAuthenticatedUserUseCase;
  final CreateCommentUseCase _createCommentUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final GetRepliesUseCase _getRepliesUseCase;
  final LikePostUseCase _likePostUseCase;

  PostInfoViewModel(
    this.ref,
    this._getAuthenticatedUserUseCase,
    this._createCommentUseCase,
    this._getCommentsUseCase,
    this._getRepliesUseCase,
    this._likePostUseCase,
  ) : super(PostInfoState.initial());

  @override
  PostInfoState copyWithState({bool? isLoading, String? errorMessage}) {
    return state.copyWith(isLoading: isLoading, errorMessage: errorMessage);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  void _setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setPost(Post post) {
    state = state.copyWith(post: post);
  }

  void _addLocalComment(Comment c) {
    state = state.copyWith(
      comments: [...state.comments, c],
      post: state.post.copyWith(commentsCount: state.post.commentsCount + 1),
    );
  }

  void _removeLocalComment(Comment c) {
    state = state.copyWith(
      comments: state.comments.where((x) => x != c).toList(),
      post: state.post.copyWith(commentsCount: state.post.commentsCount - 1),
    );
  }

  void _applyLocalLike() {
    state = state.copyWith(
      post: state.post.copyWith(
        likesCount: state.post.likesCount + 1,
        isLikedByCurrentUser: true,
      ),
    );
  }

  void _applyLocalUnlike() {
    state = state.copyWith(
      post: state.post.copyWith(
        likesCount: state.post.likesCount - 1,
        isLikedByCurrentUser: false,
      ),
    );
  }

  // createComment -------------------------------------------------------------
  Future<void> createComment(String postId, String comment) async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [createComment] comment: [$comment]",
    );

    // Prevent double taps
    if (state.isLoading) return;

    _setLoading(true);

    final trimmedComment = comment.trim();
    if (trimmedComment.isEmpty) {
      return emitError(ValidationErrorConstants.aCommentIsRequired);
    }

    try {
      final userResult = await _getAuthenticatedUserUseCase.execute();
      if (!userResult.isSuccess || userResult.data?.user == null) {
        return emitUnexpectedError();
      }

      final currentUser = userResult.data!.user;

      // Create temporary comment (optimistic)
      final tempComment = Comment(
        id: '',
        author: "${currentUser.firstName} ${currentUser.lastName}",
        authorProfileImageUrl: currentUser.profileImageUrl,
        comment: trimmedComment,
        likesCount: 0,
        repliesCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        postId: postId,
        isLikedByCurrentUser: false,
      );

      _addLocalComment(tempComment);

      final result = await _createCommentUseCase.execute(
        postId,
        trimmedComment,
      );

      if (!result.isSuccess || result.data == null) {
        // rollback
        _removeLocalComment(tempComment);
        return emitError(result.error?.message ?? "Create comment failed");
      }

      final createdComment = result.data!;

      // Update comments count of post in main feed screen
      ref
          .read(mainFeedViewModelProvider.notifier)
          .incrementCommentCount(postId);

      // Replace temp with actual comment
      final updatedComments = List.of(state.comments);
      final index = updatedComments.indexWhere(
        (c) => c.createdAt == tempComment.createdAt,
      );

      // Silent ignore
      if (index == -1) {
        LoggerUtility.d(
          runtimeType.toString(),
          "Comment is not present in updated list of comments",
        );
      } else {
        updatedComments[index] = createdComment;
      }

      state = state.copyWith(
        comments: updatedComments,
        createdComment: createdComment,
        errorMessage: null,
        isLoading: false,
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createComment", e, stack);

      // rollback (safe)
      state = state.copyWith(
        comments: state.comments
            .where((c) => c.comment != trimmedComment)
            .toList(),
      );

      emitUnexpectedError();
    }
  }

  // getComments ---------------------------------------------------------------
  Future<void> getComments(String postId, {bool isLoadMore = false}) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [getComments]");

    if (state.isLoading) return;

    setLoading(true);

    try {
      final nextPage = isLoadMore ? state.currentPage + 1 : 0;

      final result = await _getCommentsUseCase.execute(postId, nextPage);

      if (!result.isSuccess || result.data == null) {
        setLoading(false);
        return emitError(result.error!.message);
      }

      final paged = result.data!;

      state = state.copyWith(
        isLoading: false,
        currentPage: paged.page,
        hasNext: (paged.page + 1) * paged.size < paged.totalElements,
        comments: isLoadMore
            ? [...state.comments, ...paged.content]
            : paged.content,
        errorMessage: null,
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getComments", e, stack);
      emitUnexpectedError();
    }
  }

  // likePost (optimistic update) ----------------------------------------------
  Future<void> likePost(String postId) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [likePost]");

    final originalPost = state.post; // backup
    final wasLiked = originalPost.isLikedByCurrentUser;

    // Optimistic update
    if (wasLiked) {
      _applyLocalUnlike();
    } else {
      _applyLocalLike();
    }

    try {
      final result = await _likePostUseCase.execute(postId);

      if (!result.isSuccess || result.data == null) {
        // rollback exact state
        state = state.copyWith(post: originalPost);
        return emitError(result.error?.message ?? "Like post failed");
      }

      final updatedPost = result.data!;

      // replace with updated post
      state = state.copyWith(
        post: updatedPost,
        errorMessage: null,
        isLoading: false,
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "likePost", e, stack);
      // rollback exact state
      state = state.copyWith(post: originalPost);
      emitUnexpectedError();
    }
  }

  // getReplies ----------------------------------------------------------------
  Future<void> getReplies(
    String postId,
    String commentId, {
    bool isLoadMore = false,
  }) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [getReplies]");

    if (state.isLoading) return;

    setLoading(true);

    try {
      final targetIndex = state.comments.indexWhere((c) => c.id == commentId);

      if (targetIndex == -1) {
        LoggerUtility.e(runtimeType.toString(), "Comment not found");
        setLoading(false);
        return;
      }

      final targetComment = state.comments[targetIndex];

      final nextPage = isLoadMore ? targetComment.currentRepliesPage + 1 : 0;

      final result = await _getRepliesUseCase.execute(
        postId,
        commentId,
        nextPage,
      );

      if (!result.isSuccess || result.data == null) {
        setLoading(false);
        return emitError(result.error!.message);
      }

      final paged = result.data!;

      final updatedReplies = isLoadMore
          ? [...targetComment.replies, ...paged.content]
          : paged.content;

      final updatedComment = targetComment.copyWith(
        replies: updatedReplies,
        currentRepliesPage: paged.page,
        hasMoreReplies: (paged.page + 1) * paged.size < paged.totalElements,
        isRepliesLoaded: true,
      );

      final updatedComments = List<Comment>.from(state.comments);
      updatedComments[targetIndex] = updatedComment;

      state = state.copyWith(
        isLoading: false,
        comments: updatedComments,
        errorMessage: null,
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getReplies", e, stack);
      emitUnexpectedError();
    }
  }
}
