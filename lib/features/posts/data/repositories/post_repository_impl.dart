import 'package:pump/core/constants/app/app_error_strings.dart';
import 'package:pump/core/data/dto/response/paged_response.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/data/repositories/user_repository_impl.dart';
import 'package:pump/core/domain/entities/authenticated_user.dart';
import 'package:pump/core/enums/app_error_code.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/data/dto/create_post_request_dto.dart';
import 'package:pump/features/posts/data/services/post_service.dart';
import 'package:pump/features/posts/domain/entities/post.dart';

import '../../../../core/utilities/logger_utility.dart';
import '../../domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostService _postService;
  final UserRepositoryImpl _userRepositoryImpl;

  PostRepositoryImpl(this._postService, this._userRepositoryImpl);

  // createPost ----------------------------------------------------------------
  @override
  Future<Result<Post, AppError>> createPost(
    String title,
    String description,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [createPost]");

    try {
      // Get authenticated user
      final userResult = await _userRepositoryImpl.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(
            message: "User is not authenticated",
            code: AppErrorCode.unauthorized,
          ),
        );
      }

      final request = CreatePostRequest(
        title: title,
        description: description,
        userId: userResult.data!.user.id,
      );

      // Create Post Request
      final result = await _postService.createPost(
        userResult.data!.token,
        request,
      );

      if (result.isSuccess && result.data != null) {
        LoggerUtility.v(
          runtimeType.toString(),
          'Created post: ${result.data?.toPost()}',
        );
        return Result.success(result.data?.toPost());
      }
      return Result.failure(userResult.error);
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

  // getPosts ------------------------------------------------------------------
  @override
  Future<Result<PagedResponse<Post>, AppError>> getPosts(int page) async {
    try {
      // Get authenticated user
      final userResult = await _userRepositoryImpl.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(
            message: "User is not authenticated",
            code: AppErrorCode.unauthorized,
          ),
        );
      }

      final postResult = await _postService.getPosts(
        userResult.data!.token,
        page,
      );
      if (!postResult.isSuccess || postResult.data == null) {
        return Result.failure(
          AppError(
            message: postResult.error?.message ?? "Failed to fetch posts",
          ),
        );
      }

      final pagedDto = postResult.data!;
      final paged = PagedResponse<Post>(
        content: pagedDto.content.map((e) => e.toPost()).toList(),
        page: pagedDto.page,
        size: pagedDto.size,
        totalElements: pagedDto.totalElements,
      );

      return Result.success(paged);
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getPosts", e, stack);
      return Result.failure(AppError(message: "An unexpected error occurred"));
    }
  }

  @override
  Future<Result<Post, AppError>> likePost(String postId) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [likePost]");
    try {
      final Result<AuthenticatedUser, AppError> userResult =
          await _userRepositoryImpl.getAuthenticatedUser();
      if (userResult.isSuccess) {
        final result = await _postService.likePost(
          userResult.data!.token,
          postId,
        );
        if (result.isSuccess && result.data != null) {
          return Result.success(result.data?.toPost());
        } else {
          return Result.failure(
            AppError(message: AppErrorStrings.anUnexpectedErrorOccurred),
          );
        }
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
}
