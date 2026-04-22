import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pump/core/constants/api/api_constants.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/data/dto/response/api_error_response.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/features/posts/data/dto/create_comment_request_dto.dart';

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

  Future<Result<CommentResponse, ApiErrorResponse>> createComment(
    String token,
    CreateCommentRequest request,
    String postId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.getCommentUrl(postId)),
        headers: {...ApiConstants.headerType, 'Authorization': 'Bearer $token'},
        body: jsonEncode(request.toJson()),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return Result.success(CommentResponse.fromJson(json['data']));
      } else {
        final error = ApiErrorResponse.fromJson(json['error']);
        return Result.failure(error);
      }
    } catch (e, stackTrace) {
      LoggerUtility.e(
        runtimeType.toString(),
        SystemErrorConstants.anUnexpectedErrorOccurred,
        e.toString(),
        stackTrace,
      );
      final apiErrorResponse = ApiErrorResponse(
        status: HttpStatus.internalServerError,
        error: SystemErrorConstants.internalServerError,
        message: SystemErrorConstants.anUnexpectedErrorOccurred,
      );
      return Result.failure(apiErrorResponse);
    }
  }
}
