import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pump/core/data/dto/api_error_response.dart';
import 'package:pump/core/utilities/logger_utility.dart';

import '../../../../core/constants/api/api_constants.dart';
import '../../../../core/data/dto/result.dart';
import '../dto/auth_response_dto.dart';
import '../dto/login_request_dto.dart';
import '../dto/register_request_dto.dart';

class AuthService {
  // login ---------------------------------------------------------------------
  Future<Result<AuthResponse, ApiErrorResponse>> login(
    LoginRequest request,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [login]");

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginUrl),
        headers: ApiConstants.headerType,
        body: jsonEncode(request.toJson()),
      );

      final json = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      // Success
      // If response code is ok, return data immediately
      if (response.statusCode == HttpStatus.ok) {
        return Result.success(AuthResponse.fromJson(json['data']));
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
      LoggerUtility.e(runtimeType.toString(), "login", e, stack);
      return Result.failure(
        ApiErrorResponse(
          status: HttpStatus.internalServerError,
          message: "An unexpected error occurred",
          error: "Internal server error",
        ),
      );
    }
  }

  // register ------------------------------------------------------------------
  Future<Result<AuthResponse, ApiErrorResponse>> register(
    RegisterRequest request,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [register]");

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.registerUrl),
        headers: ApiConstants.headerType,
        body: jsonEncode(request.toJson()),
      );

      final json = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      // Success
      // If response code is ok, return data immediately
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return Result.success(AuthResponse.fromJson(json['data']));
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
      LoggerUtility.e(runtimeType.toString(), "register", e, stack);
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
