import 'package:pump/core/errors/app_error.dart';

import '../../../../core/data/dto/response/paged_response.dart';
import '../../../../core/data/dto/response/result.dart';
import '../entities/comment.dart';

abstract class CommentRepository {
  Future<Result<Comment, AppError>> createComment(
    String comment,
    String postId,
  );

  Future<Result<PagedResponse<Comment>, AppError>> getComments(
    String postId,
    int page,
  );

  Future<Result<PagedResponse<Comment>, AppError>> getReplies(
    String postId,
    String commentId,
    int page,
  );
}
