import 'dart:io';

import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/domain/entity/post.dart';

import '../../../../core/data/dto/response/result.dart';
import '../repository/post_repository.dart';

class CreatePostUseCase {
  final PostRepository _postRepository;

  CreatePostUseCase(this._postRepository);

  Future<Result<Post, AppError>> execute(
    String title,
    String description,
    File? image,
  ) async {
    return await _postRepository.createPost(title, description, image);
  }
}
