import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pump/core/constants/api/api_constants.dart';
import 'package:pump/core/data/dto/api_error_response.dart';
import 'package:pump/core/data/dto/result.dart';

import '../../../../core/constants/api/api_error_strings.dart';
import '../../../../core/utilities/logger_utility.dart';
import '../dto/create_post_request_dto.dart';
import '../dto/post_response_dto.dart';

class PostService {
  // getPosts ------------------------------------------------------------------
  Future<Result<List<PostResponse>, ApiErrorResponse>> getPosts(
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.postUrl),
        headers: {...ApiConstants.headerType, 'Authorization': 'Bearer $token'},
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok) {
        // Assume the backend returns a list of posts
        List<PostResponse> posts = (jsonBody['data'] as List)
            .map((e) => PostResponse.fromJson(e))
            .toList();

        return Result.success(posts);
      } else {
        final error = ApiErrorResponse.fromJson(jsonBody['error']);
        return Result.failure(error);
      }
    } catch (e) {
      return Result.failure(
        ApiErrorResponse(
          status: HttpStatus.internalServerError,
          error: ApiErrorStrings.internalServerError,
          message: e.toString(),
        ),
      );
    }
  }

  /// Create a new post, after sending it to server, return the created post
  ///
  /// @param request: CreatePostRequest
  /// returns: Result<PostResponse, ApiErrorResponse>
  Future<Result<PostResponse, ApiErrorResponse>> createPost(
    String token,
    CreatePostRequest request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.postUrl),
        headers: {...ApiConstants.headerType, 'Authorization': 'Bearer $token'},
        body: jsonEncode(request.toJson()),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return Result.success(PostResponse.fromJson(json['data']));
      } else {
        final error = ApiErrorResponse.fromJson(json['error']);
        return Result.failure(error);
      }
    } catch (e, stackTrace) {
      LoggerUtility.e(
        runtimeType.toString(),
        ApiErrorStrings.anUnexpectedErrorOccurred,
        e.toString(),
        stackTrace,
      );
      final apiErrorResponse = ApiErrorResponse(
        status: HttpStatus.internalServerError,
        error: ApiErrorStrings.anUnexpectedErrorOccurred,
        message: '${ApiErrorStrings.anUnexpectedErrorOccurred}: $e',
      );
      return Result.failure(apiErrorResponse);
    }
  }

  Future<Result<PostResponse, ApiErrorResponse>> likePost(
    String token,
    String postId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.getLikePostUrl(postId)),
        headers: {...ApiConstants.headerType, 'Authorization': 'Bearer $token'},
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return Result.success(PostResponse.fromJson(json['data']));
      } else {
        final error = ApiErrorResponse.fromJson(json['error']);
        return Result.failure(error);
      }
    } catch (e, stackTrace) {
      LoggerUtility.e(
        runtimeType.toString(),
        ApiErrorStrings.anUnexpectedErrorOccurred,
        e.toString(),
        stackTrace,
      );
      final apiErrorResponse = ApiErrorResponse(
        status: HttpStatus.internalServerError,
        error: ApiErrorStrings.anUnexpectedErrorOccurred,
        message: '${ApiErrorStrings.anUnexpectedErrorOccurred}: $e',
      );
      return Result.failure(apiErrorResponse);
    }
  }
}
