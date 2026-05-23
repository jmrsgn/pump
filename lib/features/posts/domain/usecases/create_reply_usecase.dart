import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/domain/repository/comment_repository.dart';

import '../../../../core/data/dto/response/result.dart';
import '../entity/comment.dart';

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
