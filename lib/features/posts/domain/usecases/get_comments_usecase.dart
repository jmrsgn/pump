import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/posts/domain/repositories/comment_repository.dart';

import '../../../../core/data/dto/response/result.dart';
import '../entities/comment.dart';

class GetCommentsUseCase {
  final CommentRepository _commentRepository;

  GetCommentsUseCase(this._commentRepository);

  Future<Result<List<Comment>, AppError>> execute(String postId) async {
    return await _commentRepository.getComments(postId);
  }
}
