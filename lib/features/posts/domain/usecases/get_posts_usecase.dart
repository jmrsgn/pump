import 'package:pump/core/data/dto/response/paged_response.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/domain/entities/post.dart';

import '../../../../core/data/dto/response/result.dart';
import '../repositories/post_repository.dart';

class GetPostsUseCase {
  final PostRepository _postRepository;

  GetPostsUseCase(this._postRepository);

  Future<Result<PagedResponse<Post>, AppError>> execute(int page) async {
    return await _postRepository.getPosts(page);
  }
}
