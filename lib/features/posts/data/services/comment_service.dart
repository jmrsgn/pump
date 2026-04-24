import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pump/core/constants/api/api_constants.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/data/dto/response/api_error_response.dart';
import 'package:pump/core/data/dto/response/result.dart';

import '../../../../core/utilities/logger_utility.dart';
import '../dto/comment_response_dto.dart';

class CommentService {
  Future<Result<List<CommentResponse>, ApiErrorResponse>> getComments(
    String token,
    String postId,
  ) async {
    return Result.success(null);
    // try {
    //   final response = await http.get(
    //     Uri.parse(ApiConstants.getCommentUrl(postId)),
    //     headers: {...ApiConstants.headerType, 'Authorization': 'Bearer $token'},
    //   );
    //
    //   final jsonBody = jsonDecode(response.body);
    //
    //   if (response.statusCode == HttpStatus.ok) {
    //     List<CommentResponse> comments = (jsonBody['data'] as List)
    //         .map((e) => CommentResponse.fromJson(e))
    //         .toList();
    //
    //     return Result.success(comments);
    //   } else {
    //     final error = ApiErrorResponse.fromJson(jsonBody['error']);
    //     return Result.failure(error);
    //   }
    // } catch (e, stackTrace) {
    //   LoggerUtility.e(
    //     runtimeType.toString(),
    //     ApiErrorStrings.anUnexpectedErrorOccurred,
    //     e.toString(),
    //     stackTrace,
    //   );
    //   return Result.failure(
    //     ApiErrorResponse(
    //       status: HttpStatus.internalServerError,
    //       error: ApiErrorStrings.internalServerError,
    //       message: ApiErrorStrings.anUnexpectedErrorOccurred,
    //     ),
    //   );
    // }
  }

  // createComment -------------------------------------------------------------
  Future<Result<CommentResponse, ApiErrorResponse>> createComment(
    String token,
    String postId,
    String comment,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.getCommentUrl(postId)),
        headers: {
          ...ApiConstants.headerTypeTextPlain,
          'Authorization': 'Bearer $token',
        },
        body: comment,
      );

      final json = response.body.isEmpty ? {} : jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return Result.success(CommentResponse.fromJson(json['data']));
      }

      final errorJson = json['error'] ?? {};
      final error = ApiErrorResponse.fromJson(errorJson);

      return Result.failure(
        ApiErrorResponse(
          status: error.status,
          message: error.message,
          error: error.error,
        ),
      );
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createComment", e, stack);

      return Result.failure(
        ApiErrorResponse(
          status: HttpStatus.internalServerError,
          message: SystemErrorConstants.internalServerError,
          error: SystemErrorConstants.anUnexpectedErrorOccurred,
        ),
      );
    }
  }
}
