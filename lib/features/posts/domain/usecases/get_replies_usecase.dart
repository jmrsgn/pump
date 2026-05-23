import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/domain/repository/comment_repository.dart';

import '../../../../core/data/dto/response/paged_response.dart';
import '../../../../core/data/dto/response/result.dart';
import '../entity/comment.dart';

class GetRepliesUseCase {
  final CommentRepository _commentRepository;

  GetRepliesUseCase(this._commentRepository);

  Future<Result<PagedResponse<Comment>, AppError>> execute(
    String postId,
    String commentId,
    int page,
  ) async {
    return await _commentRepository.getReplies(postId, commentId, page);
  }
}
