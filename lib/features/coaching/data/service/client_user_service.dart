import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pump/core/data/dto/response/api_error_response.dart';
import 'package:pump/core/data/dto/response/result.dart';

import '../../../../core/constants/api/api_constants.dart';
import '../../../../core/constants/error/system_error_constants.dart';
import '../../../../core/utilities/logger_utility.dart';
import '../dto/request/create_client_user_request_dto.dart';
import '../dto/response/client_user_response_dto.dart';

class ClientUserService {
  // createClientUser ----------------------------------------------------------
  Future<Result<ClientUserResponse, ApiErrorResponse>> createClientUser(
    String token,
    CreateClientUserRequest request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.createClientUserUrl),
        headers: {
          ...ApiConstants.headerTypeJson,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      final json = response.body.isEmpty ? {} : jsonDecode(response.body);

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return Result.success(ClientUserResponse.fromJson(json['data']));
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
      LoggerUtility.e(runtimeType.toString(), "createClientUser", e, stack);
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
