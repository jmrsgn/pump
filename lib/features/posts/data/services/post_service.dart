import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pump/core/constants/api/api_constants.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/data/dto/response/api_error_response.dart';
import 'package:pump/core/data/dto/response/paged_response.dart';
import 'package:pump/core/data/dto/response/result.dart';

import '../../../../core/utilities/logger_utility.dart';
import '../dto/create_post_request_dto.dart';
import '../dto/post_response_dto.dart';
import '../dto/update_post_request_dto.dart';

class PostService {
  // getPosts ------------------------------------------------------------------
  Future<Result<PagedResponse<PostResponse>, ApiErrorResponse>> getPosts(
    String token,
    int page,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.postUrl}?page=$page"),
        headers: {
          ...ApiConstants.headerTypeJson,
          'Authorization': 'Bearer $token',
        },
      );

      final json = response.body.isEmpty ? {} : jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok) {
        final paged = PagedResponse<PostResponse>.fromJson(
          json['data'],
          (e) => PostResponse.fromJson(e),
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
      LoggerUtility.e(runtimeType.toString(), "getPosts", e, stack);
      return Result.failure(
        ApiErrorResponse(
          status: HttpStatus.internalServerError,
          message: "An unexpected error occurred",
          error: "Internal server error",
        ),
      );
    }
  }

  // createPost ----------------------------------------------------------------
  Future<Result<PostResponse, ApiErrorResponse>> createPost(
    String token,
    CreatePostRequest request,
    File? image,
  ) async {
    try {
      final multipartRequest = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.postUrl),
      );

      // Headers
      multipartRequest.headers.addAll({'Authorization': 'Bearer $token'});

      // Fields
      multipartRequest.fields['title'] = request.title;
      multipartRequest.fields['description'] = request.description;

      // Image
      if (image != null) {
        multipartRequest.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }

      // Send request
      final streamedResponse = await multipartRequest.send();

      // Convert streamed response
      final response = await http.Response.fromStream(streamedResponse);

      final json = response.body.isEmpty ? {} : jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return Result.success(PostResponse.fromJson(json['data']));
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
      LoggerUtility.e(runtimeType.toString(), "createPost", e, stack);

      return Result.failure(
        ApiErrorResponse(
          status: HttpStatus.internalServerError,
          error: SystemErrorConstants.anUnexpectedErrorOccurred,
          message: SystemErrorConstants.internalServerError,
        ),
      );
    }
  }

  // likePost ------------------------------------------------------------------
  Future<Result<PostResponse, ApiErrorResponse>> likePost(
    String token,
    String postId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.getLikePostUrl(postId)),
        headers: {
          ...ApiConstants.headerTypeJson,
          'Authorization': 'Bearer $token',
        },
      );

      final json = response.body.isEmpty ? {} : jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return Result.success(PostResponse.fromJson(json['data']));
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
      LoggerUtility.e(runtimeType.toString(), "likePost", e, stack);
      return Result.failure(
        ApiErrorResponse(
          status: HttpStatus.internalServerError,
          message: SystemErrorConstants.internalServerError,
          error: SystemErrorConstants.anUnexpectedErrorOccurred,
        ),
      );
    }
  }

  // updatePost ----------------------------------------------------------------
  Future<Result<PostResponse, ApiErrorResponse>> updatePost(
    String token,
    String postId,
    UpdatePostRequest request,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [updatePost]");
    try {
      final response = await http.put(
        Uri.parse(ApiConstants.getPostInfoUrl(postId)),
        headers: {
          ...ApiConstants.headerTypeJson,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      final json = response.body.isEmpty ? {} : jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return Result.success(PostResponse.fromJson(json['data']));
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
      LoggerUtility.e(runtimeType.toString(), "updatePost", e, stack);
      return Result.failure(
        ApiErrorResponse(
          status: HttpStatus.internalServerError,
          message: SystemErrorConstants.internalServerError,
          error: SystemErrorConstants.anUnexpectedErrorOccurred,
        ),
      );
    }
  }

  // deletePost ----------------------------------------------------------------
  Future<Result<void, ApiErrorResponse>> deletePost(
    String token,
    String postId,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [deletePost]");
    try {
      final response = await http.delete(
        Uri.parse(ApiConstants.getPostInfoUrl(postId)),
        headers: {
          ...ApiConstants.headerTypeJson,
          'Authorization': 'Bearer $token',
        },
      );

      final json = response.body.isEmpty ? {} : jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok) {
        return Result.success(null);
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
      LoggerUtility.e(runtimeType.toString(), "deletePost", e, stack);
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
