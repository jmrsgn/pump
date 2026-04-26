import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pump/core/constants/api/api_constants.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/data/dto/response/api_error_response.dart';
import 'package:pump/core/data/dto/response/result.dart';

import '../../../../core/data/dto/response/paged_response.dart';
import '../../../../core/utilities/logger_utility.dart';
import '../dto/comment_response_dto.dart';

class CommentService {
  // getComments ---------------------------------------------------------------
  Future<Result<PagedResponse<CommentResponse>, ApiErrorResponse>> getComments(
    String token,
    String postId,
    int page,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.getCommentsUrl(postId)}?page=$page"),
        headers: {
          ...ApiConstants.headerTypeJson,
          'Authorization': 'Bearer $token',
        },
      );

      final json = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == HttpStatus.ok) {
        final paged = PagedResponse<CommentResponse>.fromJson(
          json['data'],
          (e) => CommentResponse.fromJson(e),
        );

        return Result.success(paged);
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
      LoggerUtility.e(runtimeType.toString(), "getComments", e, stack);

      return Result.failure(
        ApiErrorResponse(
          status: HttpStatus.internalServerError,
          message: SystemErrorConstants.internalServerError,
          error: SystemErrorConstants.anUnexpectedErrorOccurred,
        ),
      );
    }
  }

  // createComment -------------------------------------------------------------
  Future<Result<CommentResponse, ApiErrorResponse>> createComment(
    String token,
    String postId,
    String comment,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.getCommentsUrl(postId)),
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

  // getReplies
  Future<Result<PagedResponse<CommentResponse>, ApiErrorResponse>> getReplies(
    String token,
    String postId,
    String commentId,
    int page,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ApiConstants.getCommentRepliesUrl(postId, commentId)}?page=$page",
        ),
        headers: {
          ...ApiConstants.headerTypeJson,
          'Authorization': 'Bearer $token',
        },
      );

      final json = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == HttpStatus.ok) {
        final paged = PagedResponse<CommentResponse>.fromJson(
          json['data'],
          (e) => CommentResponse.fromJson(e),
        );

        return Result.success(paged);
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
      LoggerUtility.e(runtimeType.toString(), "getReplies", e, stack);

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
