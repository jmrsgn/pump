import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';
import 'package:pump/features/coaching/domain/repository/training_block_repository.dart';

class GetActiveTrainingBlockUseCase {
  final TrainingBlockRepository _repository;

  GetActiveTrainingBlockUseCase(this._repository);

  Future<Result<TrainingBlock, AppError>> execute(String clientId) =>
      _repository.getActiveTrainingBlock(clientId);
}
