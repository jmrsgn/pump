import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/domain/repositories/comment_repository.dart';

import '../../../../core/data/dto/response/result.dart';
import '../entities/comment.dart';

class CreateReplyUseCase {
  final CommentRepository _commentRepository;

  CreateReplyUseCase(this._commentRepository);

  Future<Result<Comment, AppError>> execute(
    String postId,
    String commentId,
    String comment,
  ) async {
    return await _commentRepository.createReply(postId, commentId, comment);
  }
}
