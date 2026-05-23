import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/domain/repository/comment_repository.dart';

import '../../../../core/data/dto/response/paged_response.dart';
import '../../../../core/data/dto/response/result.dart';
import '../entity/comment.dart';

class GetCommentsUseCase {
  final CommentRepository _commentRepository;

  GetCommentsUseCase(this._commentRepository);

  Future<Result<PagedResponse<Comment>, AppError>> execute(
    String postId,
    int page,
  ) async {
    return await _commentRepository.getComments(postId, page);
  }
}
