import 'package:pump/core/constants/error/auth_error_constants.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/data/repository/user_repository_impl.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/features/coaching/data/dto/request/create_training_block_request_dto.dart';
import 'package:pump/features/coaching/data/service/training_block_service.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';
import 'package:pump/features/coaching/domain/entity/training_program_input.dart';
import 'package:pump/features/coaching/domain/repository/training_block_repository.dart';

class TrainingBlockRepositoryImpl implements TrainingBlockRepository {
  static const debugTag = 'TrainingBlockRepositoryImpl';

  final TrainingBlockService _service;
  final UserRepositoryImpl _userRepository;

  TrainingBlockRepositoryImpl(this._service, this._userRepository);

  @override
  Future<Result<void, AppError>> addTrainingExercises(
    TrainingProgramInput input,
  ) async {
    // The Coaching Service programming contract is not available yet.
    // Keep this boundary explicit and never report a local draft as persisted.
    return Result.failure(
      AppError(
        message:
            'Training exercise submission is unavailable until the Coaching Service API is implemented.',
      ),
    );
  }

  @override
  Future<Result<TrainingBlock, AppError>> getActiveTrainingBlock(
    String clientId,
  ) async {
    try {
      final userResult = await _userRepository.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }
      final result = await _service.getActiveTrainingBlock(
        userResult.data!.token,
        clientId,
      );
      if (!result.isSuccess || result.data == null) {
        return Result.failure(
          AppError(
            message:
                result.error?.message ??
                SystemErrorConstants.anUnexpectedErrorOccurred,
          ),
        );
      }
      return Result.success(result.data!.toTrainingBlock());
    } catch (e, stack) {
      LoggerUtility.e(debugTag, 'getActiveTrainingBlock', e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }

  @override
  Future<Result<TrainingBlock, AppError>> createTrainingBlock(
    String clientId,
    CreateTrainingBlockRequest request,
  ) async {
    try {
      final userResult = await _userRepository.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final result = await _service.createTrainingBlock(
        userResult.data!.token,
        clientId,
        request,
      );
      if (!result.isSuccess || result.data == null) {
        return Result.failure(
          AppError(
            message: result.error?.message ?? 'Create training block failed',
          ),
        );
      }
      return Result.success(result.data!.toTrainingBlock());
    } catch (e, stack) {
      LoggerUtility.e(debugTag, 'createTrainingBlock', e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }
}
