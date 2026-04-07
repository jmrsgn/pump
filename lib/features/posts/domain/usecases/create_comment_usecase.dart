import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/domain/repositories/comment_repository.dart';

import '../../../../core/data/dto/response/result.dart';
import '../entities/comment.dart';

class CreateCommentUseCase {
  final CommentRepository _commentRepository;

  CreateCommentUseCase(this._commentRepository);

  Future<Result<Comment, AppError>> execute(
    String comment,
    String postId,
  ) async {
    return await _commentRepository.createComment(comment, postId);
  }
}
