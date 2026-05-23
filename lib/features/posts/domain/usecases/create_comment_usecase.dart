import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/domain/repository/comment_repository.dart';

import '../../../../core/data/dto/response/result.dart';
import '../entity/comment.dart';

class CreateCommentUseCase {
  final CommentRepository _commentRepository;

  CreateCommentUseCase(this._commentRepository);

  Future<Result<Comment, AppError>> execute(
    String postId,
    String comment,
  ) async {
    return await _commentRepository.createComment(postId, comment);
  }
}
