import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pump/core/constants/api/api_constants.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/data/dto/response/api_error_response.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/features/coaching/data/dto/request/create_training_block_request_dto.dart';
import 'package:pump/features/coaching/data/dto/response/training_block_response_dto.dart';

class TrainingBlockService {
  static const debugTag = 'TrainingBlockService';

  // createTrainingBlock ---------------------------------------------------------------
  Future<Result<TrainingBlockResponse, ApiErrorResponse>> createTrainingBlock(
    String token,
    String clientId,
    CreateTrainingBlockRequest request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.createTrainingBlockUrl(clientId)),
        headers: {
          ...ApiConstants.headerTypeJson,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      final json = response.body.isEmpty ? {} : jsonDecode(response.body);

      if (response.statusCode == HttpStatus.created ||
          response.statusCode == HttpStatus.ok) {
        return Result.success(TrainingBlockResponse.fromJson(json['data']));
      }

      final error = ApiErrorResponse.fromJson(json['error'] ?? {});
      return Result.failure(error);
    } catch (e, stack) {
      LoggerUtility.e(debugTag, 'createTrainingBlock', e, stack);
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
