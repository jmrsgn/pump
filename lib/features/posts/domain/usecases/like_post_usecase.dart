import 'package:pump/features/posts/domain/repositories/post_repository.dart';

import '../../../../core/data/dto/response/result.dart';
import '../../../../core/errors/app_error.dart';
import '../entities/post.dart';

class LikePostUseCase {
  final PostRepository _postRepository;

  LikePostUseCase(this._postRepository);

  Future<Result<Post, AppError>> execute(String postId) async {
    return await _postRepository.likePost(postId);
  }
}
