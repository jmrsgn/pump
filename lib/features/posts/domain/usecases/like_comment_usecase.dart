import 'package:pump/features/posts/domain/entities/comment.dart';
import 'package:pump/features/posts/domain/repositories/comment_repository.dart';

import '../../../../core/data/dto/response/result.dart';
import '../../../../core/errors/app_error.dart';

class LikeCommentUseCase {
  final CommentRepository _commentRepository;

  LikeCommentUseCase(this._commentRepository);

  Future<Result<Comment, AppError>> execute(
    String postId,
    String commentId,
  ) async {
    return await _commentRepository.likeComment(postId, commentId);
  }
}
