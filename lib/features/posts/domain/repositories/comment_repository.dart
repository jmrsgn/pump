import 'package:pump/core/errors/app_error.dart';

import '../../../../core/data/dto/response/result.dart';
import '../entities/comment.dart';

abstract class CommentRepository {
  Future<Result<Comment, AppError>> createComment(
    String comment,
    String postId,
  );

  Future<Result<List<Comment>, AppError>> getComments(String postId);
}
