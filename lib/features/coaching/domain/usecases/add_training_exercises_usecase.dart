import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/coaching/domain/entity/training_program_input.dart';
import 'package:pump/features/coaching/domain/repository/training_block_repository.dart';

class AddTrainingExercisesUseCase {
  final TrainingBlockRepository trainingBlockRepository;

  AddTrainingExercisesUseCase(this.trainingBlockRepository);

  Future<Result<void, AppError>> execute(TrainingProgramInput input) =>
      trainingBlockRepository.addTrainingExercises(input);
}
