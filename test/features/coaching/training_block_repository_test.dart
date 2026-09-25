import 'package:flutter_test/flutter_test.dart';
import 'package:pump/core/data/dto/response/api_error_response.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/data/repository/user_repository_impl.dart';
import 'package:pump/core/domain/entity/authenticated_user.dart';
import 'package:pump/core/domain/entity/user.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/coaching/data/dto/response/training_block_response_dto.dart';
import 'package:pump/features/coaching/data/repository/training_block_repository_impl.dart';
import 'package:pump/features/coaching/data/service/training_block_service.dart';

class TestUserRepository extends UserRepositoryImpl {
  @override
  Future<Result<AuthenticatedUser, AppError>> getAuthenticatedUser() async =>
      Result.success(
        AuthenticatedUser(
          token: 'test-token',
          user: const User(
            id: 'coach-id',
            firstName: 'Coach',
            lastName: 'Test',
            email: 'coach@example.test',
            profileImageUrl: '',
            followersNo: 0,
            followingNo: 0,
          ),
        ),
      );
}

class TestTrainingBlockService extends TrainingBlockService {
  TestTrainingBlockService(this.response);

  final Result<TrainingBlockResponse, ApiErrorResponse> response;

  @override
  Future<Result<TrainingBlockResponse, ApiErrorResponse>>
  getActiveTrainingBlock(String token, String clientId) async {
    expect(token, 'test-token');
    expect(clientId, 'client-id');
    return response;
  }
}

void main() {
  final dto = TrainingBlockResponse(
    id: 'block-id',
    clientId: 'client-id',
    trainingBlockName: 'Strength',
    numberOfWeeks: 12,
    trainingDays: 4,
    trainingSplit: 'Upper/Lower',
    estimatedMacros: 2400,
    targetProteinInGrams: 180,
    targetCarbsInGrams: 250,
    targetFatInGrams: 70,
    requiredDailySteps: 8000,
    otherNotes: null,
    status: 'Active',
    createdAt: DateTime.utc(2026, 9, 24),
    updatedAt: DateTime.utc(2026, 9, 24),
  );

  test('repository returns mapped domain TrainingBlock', () async {
    final repository = TrainingBlockRepositoryImpl(
      TestTrainingBlockService(Result.success(dto)),
      TestUserRepository(),
    );

    final result = await repository.getActiveTrainingBlock('client-id');

    expect(result.isSuccess, isTrue);
    expect(result.data?.id, 'block-id');
    expect(result.data?.trainingBlockName, 'Strength');
    expect(result.data?.status, 'Active');
    expect(result.data?.otherNotes, isNull);
  });

  test('repository preserves not-found status and message', () async {
    final repository = TrainingBlockRepositoryImpl(
      TestTrainingBlockService(
        Result.failure(
          ApiErrorResponse(
            status: 404,
            error: 'Not Found',
            message: 'Client not found',
          ),
        ),
      ),
      TestUserRepository(),
    );

    final result = await repository.getActiveTrainingBlock('client-id');

    expect(result.isFailure, isTrue);
    expect(result.error?.status, 404);
    expect(result.error?.message, 'Client not found');
  });
}
