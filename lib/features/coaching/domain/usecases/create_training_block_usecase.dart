import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/coaching/data/dto/request/create_training_block_request_dto.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';
import 'package:pump/features/coaching/domain/repository/training_block_repository.dart';

class CreateTrainingBlockUseCase {
  final TrainingBlockRepository _repository;

  CreateTrainingBlockUseCase(this._repository);

  Future<Result<TrainingBlock, AppError>> execute(
    String clientId,
    CreateTrainingBlockRequest request,
  ) => _repository.createTrainingBlock(clientId, request);
}
