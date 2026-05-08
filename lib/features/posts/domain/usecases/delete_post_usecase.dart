import 'package:pump/features/posts/domain/repositories/post_repository.dart';

import '../../../../core/data/dto/response/result.dart';
import '../../../../core/errors/app_error.dart';

class DeletePostUseCase {
  final PostRepository _postRepository;

  DeletePostUseCase(this._postRepository);

  Future<Result<void, AppError>> execute(String postId) async {
    return await _postRepository.deletePost(postId);
  }
}
