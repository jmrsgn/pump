import 'package:pump/core/constants/error/auth_error_constants.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/data/repositories/user_repository_impl.dart';
import 'package:pump/core/errors/app_error.dart';

import '../../../../core/data/dto/response/paged_response.dart';
import '../../../../core/utilities/logger_utility.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/comment_repository.dart';
import '../services/comment_service.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentService _commentService;
  final UserRepositoryImpl _userRepositoryImpl;

  CommentRepositoryImpl(this._commentService, this._userRepositoryImpl);

  // createComment -------------------------------------------------------------
  @override
  Future<Result<Comment, AppError>> createComment(
    String postId,
    String comment,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [createComment]");

    try {
      // Get authenticated user
      final userResult = await _userRepositoryImpl.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final createCommentResult = await _commentService.createComment(
        userResult.data!.token,
        postId,
        comment,
      );

      if (!createCommentResult.isSuccess) {
        return Result.failure(
          AppError(
            message:
                createCommentResult.error?.message ?? "Create comment failed",
          ),
        );
      }

      final response = createCommentResult.data!;
      return Result.success(response.toComment());
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createComment", e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }

  // createReply ---------------------------------------------------------------
  @override
  Future<Result<Comment, AppError>> createReply(
    String postId,
    String parentCommentId,
    String comment,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [createReply]");

    try {
      // Get authenticated user
      final userResult = await _userRepositoryImpl.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final createReplyResult = await _commentService.createReply(
        userResult.data!.token,
        postId,
        parentCommentId,
        comment,
      );

      if (!createReplyResult.isSuccess || createReplyResult.data == null) {
        return Result.failure(
          AppError(
            message: createReplyResult.error?.message ?? "Create reply failed",
          ),
        );
      }

      final response = createReplyResult.data!;
      return Result.success(response.toComment());
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createReply", e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }

  // getComments ---------------------------------------------------------------
  @override
  Future<Result<PagedResponse<Comment>, AppError>> getComments(
    String postId,
    int page,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [getComments]");

    try {
      // Get authenticated user
      final userResult = await _userRepositoryImpl.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final commentResult = await _commentService.getComments(
        userResult.data!.token,
        postId,
        page,
      );

      if (!commentResult.isSuccess || commentResult.data == null) {
        return Result.failure(
          AppError(
            message: commentResult.error?.message ?? "Failed to fetch comments",
          ),
        );
      }

      final pagedDto = commentResult.data!;

      final paged = PagedResponse<Comment>(
        content: pagedDto.content.map((e) => e.toComment()).toList(),
        page: pagedDto.page,
        size: pagedDto.size,
        totalElements: pagedDto.totalElements,
      );

      return Result.success(paged);
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getComments", e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }

  // getReplies ----------------------------------------------------------------
  @override
  Future<Result<PagedResponse<Comment>, AppError>> getReplies(
    String postId,
    String commentId,
    int page,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [getReplies]");

    try {
      // Get authenticated user
      final userResult = await _userRepositoryImpl.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final repliesResult = await _commentService.getReplies(
        userResult.data!.token,
        postId,
        commentId,
        page,
      );

      if (!repliesResult.isSuccess || repliesResult.data == null) {
        return Result.failure(
          AppError(
            message: repliesResult.error?.message ?? "Failed to fetch replies",
          ),
        );
      }

      final pagedDto = repliesResult.data!;

      final paged = PagedResponse<Comment>(
        content: pagedDto.content.map((e) => e.toComment()).toList(),
        page: pagedDto.page,
        size: pagedDto.size,
        totalElements: pagedDto.totalElements,
      );

      return Result.success(paged);
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getReplies", e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }

  // likeComment ---------------------------------------------------------------
  @override
  Future<Result<Comment, AppError>> likeComment(
    String postId,
    String commentId,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [likeComment]");

    try {
      // Get authenticated user
      final userResult = await _userRepositoryImpl.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final likeCommentResult = await _commentService.likeComment(
        userResult.data!.token,
        postId,
        commentId,
      );

      if (!likeCommentResult.isSuccess || likeCommentResult.data == null) {
        return Result.failure(
          AppError(
            message: likeCommentResult.error?.message ?? "Like comment failed",
          ),
        );
      }

      final response = likeCommentResult.data!;
      return Result.success(response.toComment());
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "likeComment", e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }
}
