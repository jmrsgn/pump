import 'package:pump/core/constants/error/auth_error_constants.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/data/repositories/user_repository_impl.dart';
import 'package:pump/core/errors/app_error.dart';

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

  // getComments ---------------------------------------------------------------
  @override
  Future<Result<List<Comment>, AppError>> getComments(String postId) async {
    return Result.success(null);
    // try {
    //   final Result<AuthenticatedUser, AppError> userResult =
    //       await _userRepositoryImpl.getAuthenticatedUser();
    //   if (userResult.isSuccess) {
    //     final result = await _commentService.getComments(
    //       userResult.data!.token,
    //       postId,
    //     );
    //
    //     if (result.isSuccess && result.data != null) {
    //       final comments = result.data!.map((e) => e.toComment()).toList();
    //       LoggerUtility.d(
    //         runtimeType.toString(),
    //         "Comments fetched: $comments",
    //       );
    //       return Result.success(comments);
    //     }
    //     return Result.failure(userResult.error);
    //   } else {
    //     LoggerUtility.e(
    //       runtimeType.toString(),
    //       "User id is missing, will not proceed with API call",
    //     );
    //     return Result.failure(
    //       AppError(message: AppErrorStrings.userIsNotAuthenticated),
    //     );
    //   }
    // } catch (e, stackTrace) {
    //   LoggerUtility.e(
    //     runtimeType.toString(),
    //     AppErrorStrings.anUnexpectedErrorOccurred,
    //     e.toString(),
    //     stackTrace,
    //   );
    //   return Result.failure(
    //     AppError(message: AppErrorStrings.anUnexpectedErrorOccurred),
    //   );
    // }
  }
}
