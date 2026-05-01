import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/error/validation_error_constants.dart';
import 'package:pump/core/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/features/posts/domain/entities/post.dart';
import 'package:pump/features/posts/domain/usecases/create_comment_usecase.dart';
import 'package:pump/features/posts/domain/usecases/create_reply_usecase.dart';
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

  void _setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setPost(Post post) {
    state = state.copyWith(post: post);
  }

  void setCommentReplyingTo(Comment comment) {
    state = state.copyWith(commentReplyingTo: comment);
  }

  void clearCommentReplyingTo() {
    state = state.copyWith(commentReplyingTo: null);
  }

  void resetComments() {
    state = state.copyWith(
      comments: [],
      currentPage: 0,
      hasNext: true,
      errorMessage: null,
    );
  }

  bool isReplyingTo(String commentId) {
    return state.commentReplyingTo?.id == commentId;
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

  void _addLocalReply(Comment reply, String parentId) {
    final updated = state.comments.map((c) {
      if (c.id == parentId) {
        return c.copyWith(replies: [...c.replies, reply]);
      }
      return c;
    }).toList();

    state = state.copyWith(comments: updated);
  }

  void _removeLocalReply(Comment reply, String parentId) {
    final updated = state.comments.map((c) {
      if (c.id == parentId) {
        return c.copyWith(replies: c.replies.where((r) => r != reply).toList());
      }
      return c;
    }).toList();

    state = state.copyWith(comments: updated);
  }

  void _replaceLocalReply(Comment temp, Comment actual, String parentId) {
    final updated = state.comments.map((c) {
      if (c.id == parentId) {
        final replies = List<Comment>.from(c.replies);
        final index = replies.indexWhere((r) => r.createdAt == temp.createdAt);
        if (index != -1) {
          replies[index] = actual;
        }
        return c.copyWith(replies: replies);
      }
      return c;
    }).toList();

    state = state.copyWith(comments: updated);
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

    if (state.isLoading) return;

    final trimmedComment = comment.trim();
    if (trimmedComment.isEmpty) {
      return emitError(ValidationErrorConstants.aCommentIsRequired);
    }

    _setLoading(true);

    Comment? tempComment;

    try {
      final userResult = await _getAuthenticatedUserUseCase.execute();
      if (!userResult.isSuccess || userResult.data?.user == null) {
        return emitUnexpectedError();
      }

      final currentUser = userResult.data!.user;
      final replyingTo = state.commentReplyingTo;

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
        parentCommentId: replyingTo?.id,
        isLikedByCurrentUser: false,
      );

      if (replyingTo != null) {
        final parentIndex = state.comments.indexWhere(
          (c) => c.id == replyingTo.id,
        );

        if (parentIndex != -1) {
          final parent = state.comments[parentIndex];

          if (!parent.isRepliesLoaded && parent.repliesCount > 0) {
            await getReplies(postId, parent.id);
          }
        }

        _addLocalReply(tempComment, replyingTo.id);
      } else {
        _addLocalComment(tempComment);
      }

      final result = replyingTo != null
          ? await _createReplyUseCase.execute(
              postId,
              replyingTo.id,
              trimmedComment,
            )
          : await _createCommentUseCase.execute(postId, trimmedComment);

      if (!result.isSuccess || result.data == null) {
        if (replyingTo != null) {
          _removeLocalReply(tempComment, replyingTo.id);
        } else {
          _removeLocalComment(tempComment);
        }
        return emitError(result.error?.message ?? "Create failed");
      }

      final created = result.data!;

      if (replyingTo == null) {
        ref
            .read(mainFeedViewModelProvider.notifier)
            .incrementCommentCount(postId);
      }

      if (replyingTo != null) {
        _replaceLocalReply(tempComment, created, replyingTo.id);
      } else {
        final updated = List<Comment>.from(state.comments);
        final index = updated.indexWhere(
          (c) => c.createdAt == tempComment?.createdAt,
        );
        if (index != -1) {
          updated[index] = created;
        }
        state = state.copyWith(comments: updated);
      }

      state = state.copyWith(
        createdComment: created,
        commentReplyingTo: null,
        errorMessage: null,
        isLoading: false,
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createComment", e, stack);

      final replyingTo = state.commentReplyingTo;

      if (tempComment != null) {
        if (replyingTo != null) {
          _removeLocalReply(tempComment, replyingTo.id);
        } else {
          _removeLocalComment(tempComment);
        }
      }

      emitUnexpectedError();
    }
  }

  // getComments ---------------------------------------------------------------
  Future<void> getComments(String postId, {bool isLoadMore = false}) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [getComments]");

    if (state.isLoading) return;

    _setLoading(true);

    try {
      final nextPage = isLoadMore ? state.currentPage + 1 : 0;

      final result = await _getCommentsUseCase.execute(postId, nextPage);

      if (!result.isSuccess || result.data == null) {
        _setLoading(false);
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

  // likePost ------------------------------------------------------------------
  Future<void> likePost(String postId) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [likePost]");

    final originalPost = state.post;
    final wasLiked = originalPost.isLikedByCurrentUser;

    if (wasLiked) {
      _applyLocalUnlike();
    } else {
      _applyLocalLike();
    }

    try {
      final result = await _likePostUseCase.execute(postId);

      if (!result.isSuccess || result.data == null) {
        state = state.copyWith(post: originalPost);
        return emitError(result.error?.message ?? "Like post failed");
      }

      state = state.copyWith(
        post: result.data!,
        errorMessage: null,
        isLoading: false,
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "likePost", e, stack);
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

    _setLoading(true);

    try {
      final index = state.comments.indexWhere((c) => c.id == commentId);

      if (index == -1) {
        _setLoading(false);
        return;
      }

      final target = state.comments[index];
      final nextPage = isLoadMore ? target.currentRepliesPage + 1 : 0;

      final result = await _getRepliesUseCase.execute(
        postId,
        commentId,
        nextPage,
      );

      if (!result.isSuccess || result.data == null) {
        _setLoading(false);
        return emitError(result.error!.message);
      }

      final paged = result.data!;
      final existing = target.replies;

      final mergedReplies = isLoadMore
          ? [
              ...existing,
              ...paged.content.where(
                (newReply) => !existing.any((r) => r.id == newReply.id),
              ),
            ]
          : paged.content;

      final updatedComment = target.copyWith(
        replies: mergedReplies,
        currentRepliesPage: paged.page,
        hasMoreReplies: (paged.page + 1) * paged.size < paged.totalElements,
        isRepliesLoaded: true,
      );

      final updatedComments = List<Comment>.from(state.comments);
      updatedComments[index] = updatedComment;

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
