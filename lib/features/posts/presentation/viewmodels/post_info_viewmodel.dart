import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/error/validation_error_constants.dart';
import 'package:pump/core/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/features/posts/domain/usecases/create_comment_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_comments_usecase.dart';
import 'package:pump/features/posts/domain/usecases/like_post_usecase.dart';
import 'package:pump/features/posts/presentation/providers/post_info_state.dart';

import '../../../../core/constants/error/system_error_constants.dart';
import '../../../../core/utilities/logger_utility.dart';
import '../../domain/entities/comment.dart';
import '../providers/post_providers.dart';

class PostInfoViewModel extends BaseViewModel<PostInfoState> {
  final Ref ref;
  final GetAuthenticatedUserUseCase _getAuthenticatedUserUseCase;
  final CreateCommentUseCase _createCommentUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final LikePostUseCase _likePostUseCase;

  PostInfoViewModel(
    this.ref,
    this._getAuthenticatedUserUseCase,
    this._createCommentUseCase,
    this._getCommentsUseCase,
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

  void _handleFailure(String message) {
    state = state.copyWith(isLoading: false, errorMessage: message);
  }

  /// Wrap async operations with safe error handling
  Future<void> _safeExecute(
    Future<void> Function() action,
    String errorTag,
  ) async {
    try {
      await action();
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), errorTag, e, stack);
      _handleFailure(SystemErrorConstants.anUnexpectedErrorOccurred);
    }
  }

  void loadInitialComments(List<Comment> initialComments) {
    state = state.copyWith(comments: initialComments);
  }

  void _addLocalComment(Comment c) {
    state = state.copyWith(comments: [...state.comments, c]);
  }

  void _removeLocalComment(Comment c) {
    state = state.copyWith(
      comments: state.comments.where((x) => x != c).toList(),
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

  void _rollbackLocalLike(bool wasLikedBefore) {
    if (wasLikedBefore) {
      // rollback to liked state
      state = state.copyWith(
        post: state.post.copyWith(
          likesCount: state.post.likesCount + 1,
          isLikedByCurrentUser: true,
        ),
      );
    } else {
      // rollback to unliked state
      state = state.copyWith(
        post: state.post.copyWith(
          likesCount: state.post.likesCount - 1,
          isLikedByCurrentUser: false,
        ),
      );
    }
  }

  // createComment -------------------------------------------------------------
  Future<void> createComment(String comment, String postId) async {
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
        trimmedComment,
        postId,
      );

      if (!result.isSuccess || result.data == null) {
        // rollback
        _removeLocalComment(tempComment);
        return _handleFailure(result.error?.message ?? "Create comment failed");
      }

      final createdComment = result.data!;

      // Replace temp with actual comment
      final updatedComments = List.of(state.comments);
      final index = updatedComments.indexWhere((c) => c == tempComment);

      // Silent ignore
      if (index != -1) {
        updatedComments[index] = createdComment;
      }

      // Update comment count in feed
      ref
          .read(mainFeedViewModelProvider.notifier)
          .incrementCommentCount(postId);

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
  Future<void> getComments(String postId) async {
    _setLoading(true);

    await _safeExecute(() async {
      final response = await _getCommentsUseCase.execute(postId);

      if (response.isFailure) {
        return _handleFailure(response.error!.message);
      }

      state = state.copyWith(
        comments: response.data,
        isLoading: false,
        errorMessage: null,
      );
    }, "getComments");
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
}
