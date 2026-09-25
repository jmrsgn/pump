import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/coaching/data/dto/request/create_training_block_request_dto.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';

abstract class TrainingBlockRepository {
  Future<Result<TrainingBlock, AppError>> getActiveTrainingBlock(
    String clientId,
  );

  Future<Result<TrainingBlock, AppError>> createTrainingBlock(
    String clientId,
    CreateTrainingBlockRequest request,
  );
}
