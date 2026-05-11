import 'dart:io';

import 'package:pump/core/data/dto/response/paged_response.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/domain/entities/post.dart';

import '../../../../core/data/dto/response/result.dart';

abstract class PostRepository {
  Future<Result<PagedResponse<Post>, AppError>> getPosts(int page);

  Future<Result<Post, AppError>> createPost(
    String title,
    String description,
    File? image,
  );

  Future<Result<Post, AppError>> likePost(String postId);

  Future<Result<Post, AppError>> updatePost(
    String postId,
    String title,
    String description,
  );

  Future<Result<void, AppError>> deletePost(String postId);
}
