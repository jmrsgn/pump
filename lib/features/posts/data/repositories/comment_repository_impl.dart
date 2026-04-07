import 'package:pump/core/constants/app/app_error_strings.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/data/repositories/user_repository_impl.dart';
import 'package:pump/core/domain/entities/authenticated_user.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/data/dto/create_comment_request_dto.dart';

import '../../../../core/utilities/logger_utility.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/comment_repository.dart';
import '../services/comment_service.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentService _commentService;
  final UserRepositoryImpl _userRepositoryImpl;

  CommentRepositoryImpl(this._commentService, this._userRepositoryImpl);

  @override
  Future<Result<Comment, AppError>> createComment(
    String comment,
    String postId,
  ) async {
    try {
      final Result<AuthenticatedUser, AppError> userResult =
          await _userRepositoryImpl.getAuthenticatedUser();
      if (userResult.isSuccess) {
        final request = CreateCommentRequest(
          comment: comment,
          userId: userResult.data!.user.id,
        );

        // Create Post Request
        final result = await _commentService.createComment(
          userResult.data!.token,
          request,
          postId,
        );

        if (result.isSuccess && result.data != null) {
          LoggerUtility.v(
            runtimeType.toString(),
            'Created comment: ${result.data?.toComment()}',
          );
          return Result.success(result.data?.toComment());
        }
        return Result.failure(userResult.error);
      } else {
        LoggerUtility.e(
          runtimeType.toString(),
          "User id is missing, will not proceed with API call",
        );
        return Result.failure(
          AppError(message: AppErrorStrings.userIsNotAuthenticated),
        );
      }
    } catch (e, stackTrace) {
      LoggerUtility.e(
        runtimeType.toString(),
        AppErrorStrings.anUnexpectedErrorOccurred,
        e.toString(),
        stackTrace,
      );
      return Result.failure(
        AppError(message: AppErrorStrings.anUnexpectedErrorOccurred),
      );
    }
  }

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
