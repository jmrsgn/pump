import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/error/validation_error_constants.dart';
import 'package:pump/core/data/dto/response/paged_response.dart';
import 'package:pump/core/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/features/posts/domain/entities/post.dart';
import 'package:pump/features/posts/domain/helpers/post_comment_helper.dart';
import 'package:pump/features/posts/domain/usecases/create_comment_usecase.dart';
import 'package:pump/features/posts/domain/usecases/create_reply_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_comments_usecase.dart';
import 'package:pump/features/posts/domain/usecases/get_replies_usecase.dart';
import 'package:pump/features/posts/domain/usecases/like_post_usecase.dart';
import 'package:pump/features/posts/presentation/providers/post_info_state.dart';

import '../../../../core/constants/error/auth_error_constants.dart';
import '../../../../core/data/dto/response/result.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/utilities/logger_utility.dart';
import '../../domain/entities/comment.dart';
import '../providers/post_providers.dart';

class PostInfoViewModel extends BaseViewModel<PostInfoState> {
  final Ref ref;
  final GetAuthenticatedUserUseCase _getAuthenticatedUserUseCase;
  final CreateCommentUseCase _createCommentUseCase;
  final CreateReplyUseCase _createReplyUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final GetRepliesUseCase _getRepliesUseCase;
  final LikePostUseCase _likePostUseCase;

  PostInfoViewModel(
    this.ref,
    this._getAuthenticatedUserUseCase,
    this._createCommentUseCase,
    this._createReplyUseCase,
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
  void setPost(Post post) {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [setPost]");
    state = state.copyWith(post: post);
  }

  void setCommentReplyingTo(Comment comment) {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [setCommentReplyingTo]",
    );
    state = state.copyWith(commentReplyingTo: comment);
  }

  void clearCommentReplyingTo() {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [clearCommentReplyingTo]",
    );
    state = state.copyWith(commentReplyingTo: null);
  }

  void resetComments() {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [resetComments]");
    state = state.copyWith(
      comments: [],
      currentPage: 0,
      hasNext: true,
      errorMessage: null,
    );
  }

  bool isReplyingTo(String commentId) {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [isReplyingTo]");
    return state.commentReplyingTo?.id == commentId;
  }

  Future<Result<Comment, AppError>> getCreateCommentResult(
    Comment tempComment,
    String postId,
    String comment,
  ) async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [getCreateCommentResult]",
    );
    state = state.copyWith(
      comments: PostCommentHelper.addComment(state.comments, tempComment),
      post: state.post.copyWith(commentsCount: state.post.commentsCount + 1),
    );
    return await _createCommentUseCase.execute(postId, comment);
  }

  Future<Result<Comment, AppError>> getCreateReplyResult(
    Comment tempComment,
    String postId,
    String parentCommentId,
    String comment,
  ) async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [getCreateReplyResult]",
    );

    final parentIndex = state.comments.indexWhere(
      (comment) => comment.id == parentCommentId,
    );

    if (parentIndex != -1) {
      LoggerUtility.d(runtimeType.toString(), "parent comment is valid");
      final parent = state.comments[parentIndex];

      // If parent comment's replies are not loaded, and replies are not empty, get replies of that comment
      if (!parent.isRepliesLoaded && parent.repliesCount > 0) {
        await getReplies(postId, parent.id);
      }
    }

    state = state.copyWith(
      comments: PostCommentHelper.addReply(
        state.comments,
        parentCommentId,
        tempComment,
      ),
    );

    return await _createReplyUseCase.execute(postId, parentCommentId, comment);
  }

  Future<Result<PagedResponse<Comment>, AppError>> _executePagedFetch({
    required Future<Result<PagedResponse<Comment>, AppError>> Function()
    request,
  }) async {
    final result = await request();

    if (!result.isSuccess || result.data == null) {
      emitError(result.error!.message);
    }

    return result;
  }

  // ---------------------------------------------------------------------------
  // Core methods
  // ---------------------------------------------------------------------------

  // createComment -------------------------------------------------------------
  Future<void> createComment(String postId, String comment) async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [createComment] comment: [$comment]",
    );

    // Prevent double taps
    if (state.isLoading) return;

    final trimmedComment = comment.trim();
    LoggerUtility.d(runtimeType.toString(), "trimmedComment: $trimmedComment");
    if (trimmedComment.isEmpty) {
      return emitError(ValidationErrorConstants.aCommentIsRequired);
    }

    setLoading(true);
    Comment? tempComment;

    try {
      final userResult = await _getAuthenticatedUserUseCase.execute();
      if (!userResult.isSuccess || userResult.data?.user == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        emitError(AuthErrorConstants.userIsNotAuthenticated);
        return;
      }

      final currentUser = userResult.data!.user;
      final commentReplyingTo = state.commentReplyingTo;

      tempComment = Comment(
        id: '',
        author: "${currentUser.firstName} ${currentUser.lastName}",
        authorProfileImageUrl: currentUser.profileImageUrl,
        comment: trimmedComment,
        likesCount: 0,
        repliesCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        postId: postId,
        // can be null
        parentCommentId: commentReplyingTo?.id,
        isLikedByCurrentUser: false,
      );

      LoggerUtility.d(runtimeType.toString(), "tempComment created");

      final result = commentReplyingTo == null
          ? await getCreateCommentResult(tempComment, postId, trimmedComment)
          : await getCreateReplyResult(
              tempComment,
              postId,
              commentReplyingTo.id,
              trimmedComment,
            );

      if (!result.isSuccess || result.data == null) {
        if (commentReplyingTo == null) {
          state = state.copyWith(
            comments: PostCommentHelper.removeComment(
              state.comments,
              tempComment,
            ),
            post: state.post.copyWith(
              commentsCount: state.post.commentsCount - 1,
            ),
          );
        } else {
          state = state.copyWith(
            comments: PostCommentHelper.removeReply(
              state.comments,
              commentReplyingTo.id,
              tempComment,
            ),
          );
        }
        return emitError(result.error!.message);
      }

      final createdComment = result.data!;
      LoggerUtility.d(runtimeType.toString(), "createdComment: ${result.data}");

      // Update comments count of the post in main feed screen
      if (commentReplyingTo == null) {
        ref
            .read(mainFeedViewModelProvider.notifier)
            .incrementPostCommentsCount(postId);

        final updatedComments = List<Comment>.from(state.comments);
        final createdCommentIndex = updatedComments.indexWhere(
          (comment) => comment.createdAt == tempComment?.createdAt,
        );
        LoggerUtility.d(
          runtimeType.toString(),
          "created comment index: [$createdCommentIndex]",
        );
        if (createdCommentIndex != -1) {
          // Update local comment from updated comments with server truth
          updatedComments[createdCommentIndex] = createdComment;
        }
        state = state.copyWith(comments: updatedComments);
      } else {
        state = state.copyWith(
          comments: PostCommentHelper.replaceReply(
            state.comments,
            commentReplyingTo.id,
            tempComment,
            createdComment,
          ),
        );
      }

      // Update state
      state = state.copyWith(
        createdComment: createdComment,
        commentReplyingTo: null,
        errorMessage: null,
        isLoading: false,
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createComment", e, stack);

      final commentReplyingTo = state.commentReplyingTo;

      if (tempComment != null) {
        if (commentReplyingTo == null) {
          state = state.copyWith(
            comments: PostCommentHelper.removeComment(
              state.comments,
              tempComment,
            ),
            post: state.post.copyWith(
              commentsCount: state.post.commentsCount - 1,
            ),
          );
        } else {
          state = state.copyWith(
            comments: PostCommentHelper.removeReply(
              state.comments,
              commentReplyingTo.id,
              tempComment,
            ),
          );
        }
      }
      emitUnexpectedError();
    }
  }

  // likePost ------------------------------------------------------------------
  Future<void> likePost(String postId) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [likePost]");

    final originalPost = state.post;
    final wasLiked = originalPost.isLikedByCurrentUser;

    // Optimistic UI update
    final updatedPost = wasLiked
        ? PostCommentHelper.applyLocalUnlikeToPost(originalPost)
        : PostCommentHelper.applyLocalLikeToPost(originalPost);

    state = state.copyWith(post: updatedPost);

    try {
      final result = await _likePostUseCase.execute(postId);

      if (!result.isSuccess || result.data == null) {
        // rollback
        state = state.copyWith(post: originalPost);
        return emitError(result.error!.message);
      }

      // Replace with server truth
      state = state.copyWith(post: result.data!, errorMessage: null);
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "likePost", e, stack);

      // rollback
      state = state.copyWith(post: originalPost);
      emitUnexpectedError();
    }
  }

  // getComments ---------------------------------------------------------------
  Future<void> getComments(String postId, {bool isLoadMore = false}) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [getComments]");

    // Prevent double taps
    if (state.isLoading) return;

    setLoading(true);

    try {
      final nextPage = isLoadMore ? state.currentPage + 1 : 0;

      final result = await _executePagedFetch(
        request: () => _getCommentsUseCase.execute(postId, nextPage),
      );

      final pagedResult = result.data!;
      bool hasNext =
          (pagedResult.page + 1) * pagedResult.size < pagedResult.totalElements;

      state = state.copyWith(
        isLoading: false,
        currentPage: pagedResult.page,
        hasNext: hasNext,
        comments: isLoadMore
            ? [...state.comments, ...pagedResult.content]
            : pagedResult.content,
        errorMessage: null,
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getComments", e, stack);
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

    // Prevent double taps
    if (state.isLoading) return;

    setLoading(true);

    try {
      final commentIndex = state.comments.indexWhere((c) => c.id == commentId);

      if (commentIndex == -1) {
        LoggerUtility.d(
          runtimeType.toString(),
          "comment index is invalid, will not proceed with API call",
        );
        return;
      }

      final targetComment = state.comments[commentIndex];
      final nextPage = isLoadMore ? targetComment.currentRepliesPage + 1 : 0;

      final result = await _executePagedFetch(
        request: () => _getRepliesUseCase.execute(postId, commentId, nextPage),
      );

      final pagedResult = result.data!;
      final existingReplies = targetComment.replies;

      // If loading more replies, append only new replies that don't already exist (prevents duplicates)
      // Otherwise (first load), replace the entire replies list with the fetched content
      final updatedComment = targetComment.copyWith(
        replies: PostCommentHelper.mergeReplies(
          existingReplies: existingReplies,
          newReplies: pagedResult.content,
          isLoadMore: isLoadMore,
        ),
        currentRepliesPage: pagedResult.page,
        hasMoreReplies:
            (pagedResult.page + 1) * pagedResult.size <
            pagedResult.totalElements,
        isRepliesLoaded: true,
      );

      final updatedComments = List<Comment>.from(state.comments);
      updatedComments[commentIndex] = updatedComment;

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
