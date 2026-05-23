import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/domain/entity/post.dart';

import '../../../../core/data/dto/response/result.dart';
import '../repository/post_repository.dart';

class UpdatePostUseCase {
  final PostRepository _postRepository;

  UpdatePostUseCase(this._postRepository);

  Future<Result<Post, AppError>> execute(
    String postId,
    String title,
    String description,
  ) async {
    return await _postRepository.updatePost(postId, title, description);
  }
}
