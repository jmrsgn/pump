import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/app/app_error_strings.dart';
import 'package:pump/core/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:pump/features/posts/domain/entities/post.dart';
import 'package:pump/features/posts/domain/usecases/create_comment_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_comments_usecase.dart';
import 'package:pump/features/posts/domain/usecases/like_post_usecase.dart';
import 'package:pump/features/posts/presentation/providers/post_info_state.dart';

import '../../../../core/domain/entities/user.dart';
import '../../../../core/utilities/logger_utility.dart';
import '../../domain/entities/comment.dart';
import '../providers/post_providers.dart';

class PostInfoViewModel extends StateNotifier<PostInfoState> {
  final Ref ref;
  final CreateCommentUseCase _createCommentUseCase;
  final GetAuthenticatedUser _getUserProfileUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final LikePostUseCase _likePostUseCase;

  PostInfoViewModel(
    this.ref,
    this._createCommentUseCase,
    this._getUserProfileUseCase,
    this._getCommentsUseCase,
    this._likePostUseCase,
  ) : super(PostInfoState.initial());

  // Helpers -------------------------------------------------------------------
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
      _handleFailure(AppErrorStrings.anUnexpectedErrorOccurred);
    }
  }

  // Comment Helpers -----------------------------------------------------------
  void loadInitialComments(List<Comment> initialComments) {
    state = state.copyWith(comments: initialComments);
  }

  void clearComments() {
    state = state.copyWith(comments: []);
  }

  void _addLocalComment(Comment c) {
    state = state.copyWith(comments: [...state.comments, c]);
  }

  void _removeLocalComment(Comment c) {
    state = state.copyWith(
      comments: state.comments.where((x) => x != c).toList(),
    );
  }

  // Like Helpers --------------------------------------------------------------
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
    _setLoading(true);

    // final userResponse = await _getUserProfileUseCase.execute();
    // if (!userResponse.isSuccess || userResponse.data?.user == null) {
    //   return _handleFailure(AppErrorStrings.anUnexpectedErrorOccurred);
    // }
    //
    // final User currentUser = userResponse.data!.user;
    //
    // final tempComment = Comment(
    //   userName: "${currentUser.firstName} ${currentUser.lastName}",
    //   userProfileImageUrl: currentUser.profileImageUrl,
    //   comment: comment,
    //   likesCount: 0,
    //   repliesCount: 0,
    //   createdAt: DateTime.now(),
    //   updatedAt: DateTime.now(),
    // );
    //
    // _addLocalComment(tempComment);
    //
    // await _safeExecute(() async {
    //   final response = await _createCommentUseCase.execute(
    //     comment.trim(),
    //     postId,
    //   );
    //
    //   if (!response.isSuccess) {
    //     _removeLocalComment(tempComment);
    //     return _handleFailure(response.error!.message);
    //   }
    //
    //   // Update comment count in feed
    //   ref
    //       .read(mainFeedViewModelProvider.notifier)
    //       .incrementCommentCount(postId);
    //
    //   state = state.copyWith(
    //     createdComment: response.data,
    //     errorMessage: null,
    //     isLoading: false,
    //   );
    // }, "createComment");
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

  // Like Post -----------------------------------------------------------------
  Future<void> likePost(String postId) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [likePost]");

    final wasLiked = state.post.isLikedByCurrentUser;

    if (wasLiked) {
      _applyLocalUnlike();
    } else {
      _applyLocalLike();
    }

    await _safeExecute(() async {
      final response = await _likePostUseCase.execute(postId);

      if (response.isFailure) {
        _rollbackLocalLike(wasLiked);
        return _handleFailure(response.error!.message);
      }

      final updatedPost = response.data;

      state = state.copyWith(
        post: updatedPost,
        isLoading: false,
        errorMessage: null,
      );
    }, "likePost");
  }
}
