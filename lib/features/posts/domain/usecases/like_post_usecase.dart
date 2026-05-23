import 'package:pump/features/posts/domain/repository/post_repository.dart';

import '../../../../core/data/dto/response/result.dart';
import '../../../../core/errors/app_error.dart';
import '../entity/post.dart';

class LikePostUseCase {
  final PostRepository _postRepository;

  LikePostUseCase(this._postRepository);

  Future<Result<Post, AppError>> execute(String postId) async {
    return await _postRepository.likePost(postId);
  }
}
