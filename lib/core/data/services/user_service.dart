import 'dart:convert';
import 'dart:io';

import 'package:pump/core/data/dto/response/user_response_dto.dart';
import 'package:http/http.dart' as http;

import '../../constants/api/api_constants.dart';
import '../../constants/app/app_strings.dart';
import '../../utilities/logger_utility.dart';
import '../dto/response/api_error_response.dart';
import '../dto/response/result.dart';

class UserService {
  // Future<Result<UserResponse, ApiErrorResponse>> getCurrentUser(
  //   String token,
  // ) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse(ApiConstants.profileUrl),
  //       headers: {...ApiConstants.headerType, 'Authorization': 'Bearer $token'},
  //     );
  //
  //     final json = jsonDecode(response.body);
  //
  //     if (response.statusCode == HttpStatus.ok ||
  //         response.statusCode == HttpStatus.created) {
  //       return Result.success(UserResponse.fromJson(json['data']));
  //     } else {
  //       return Result.failure(ApiErrorResponse.fromJson(json['error']));
  //     }
  //   } catch (e, stackTrace) {
  //     LoggerUtility.e(
  //       runtimeType.toString(),
  //       AppStrings.anUnexpectedErrorOccurred,
  //       e.toString(),
  //       stackTrace,
  //     );
  //     final apiErrorResponse = ApiErrorResponse(
  //       status: HttpStatus.internalServerError,
  //       error: AppStrings.anUnexpectedErrorOccurred,
  //       message: '${AppStrings.anUnexpectedErrorOccurred}: $e',
  //     );
  //     return Result.failure(apiErrorResponse);
  //   }
  // }
}
