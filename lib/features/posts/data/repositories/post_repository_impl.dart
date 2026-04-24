import 'package:pump/core/constants/error/auth_error_constants.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/data/dto/response/paged_response.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/data/repositories/user_repository_impl.dart';
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
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final request = CreatePostRequest(title: title, description: description);

      final createPostResult = await _postService.createPost(
        userResult.data!.token,
        request,
      );

      if (!createPostResult.isSuccess) {
        return Result.failure(
          AppError(
            message: createPostResult.error?.message ?? "Create post failed",
          ),
        );
      }

      final response = createPostResult.data;
      return Result.success(response?.toPost());
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createPost", e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
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
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
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
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }

  // likePost ------------------------------------------------------------------
  @override
  Future<Result<Post, AppError>> likePost(String postId) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [likePost]");

    try {
      // Get authenticated user
      final userResult = await _userRepositoryImpl.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final likePostResult = await _postService.likePost(
        userResult.data!.token,
        postId,
      );

      if (!likePostResult.isSuccess || likePostResult.data == null) {
        return Result.failure(
          AppError(
            message: likePostResult.error?.message ?? "Like post failed",
          ),
        );
      }

      final response = likePostResult.data!;
      return Result.success(response.toPost());
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "likePost", e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }
}
