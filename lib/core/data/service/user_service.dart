import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pump/core/data/dto/response/user_summary_response.dart';

import '../../constants/api/api_constants.dart';
import '../../utilities/logger_utility.dart';
import '../dto/response/api_error_response.dart';
import '../dto/response/result.dart';

class UserService {
  // searchUsers ---------------------------------------------------------------
  Future<Result<List<UserSummaryResponse>, ApiErrorResponse>> searchUsers(
    String token,
    String query,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.searchUsersUrl}?query=$query"),
        headers: {
          ...ApiConstants.headerTypeJson,
          'Authorization': 'Bearer $token',
        },
      );

      final json = response.body.isEmpty ? {} : jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> data = json['data'] ?? [];

        final users = data
            .map((item) => UserSummaryResponse.fromJson(item))
            .toList();

        return Result.success(users);
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
      LoggerUtility.e(runtimeType.toString(), "searchUsers", e, stack);
      return Result.failure(
        ApiErrorResponse(
          status: HttpStatus.internalServerError,
          message: "An unexpected error occurred",
          error: "Internal server error",
        ),
      );
    }
  }
}
