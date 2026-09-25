import 'package:flutter_test/flutter_test.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/coaching/data/dto/request/create_training_block_request_dto.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';
import 'package:pump/features/coaching/domain/repository/training_block_repository.dart';
import 'package:pump/features/coaching/domain/usecases/get_active_training_block_usecase.dart';
import 'package:pump/features/coaching/presentation/viewmodels/client_info_screen_viewmodel.dart';

class FakeTrainingBlockRepository implements TrainingBlockRepository {
  FakeTrainingBlockRepository(this.response);

  final Result<TrainingBlock, AppError> response;
  int calls = 0;

  @override
  Future<Result<TrainingBlock, AppError>> getActiveTrainingBlock(
    String clientId,
  ) async {
    calls++;
    expect(clientId, 'client-id');
    return response;
  }

  @override
  Future<Result<TrainingBlock, AppError>> createTrainingBlock(
    String clientId,
    CreateTrainingBlockRequest request,
  ) => throw UnimplementedError();
}

void main() {
  final block = TrainingBlock(
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

  test('loads an active block once', () async {
    final repository = FakeTrainingBlockRepository(Result.success(block));
    final viewModel = ClientInfoScreenViewModel(
      GetActiveTrainingBlockUseCase(repository),
    );
    final states = <bool>[];
    viewModel.addListener((state) => states.add(state.isLoading));

    await viewModel.getActiveTrainingBlock('client-id');
    await viewModel.getActiveTrainingBlock('client-id');

    expect(states, [false, true, false]);
    expect(repository.calls, 1);
    expect(viewModel.state.trainingBlock, block);
    expect(viewModel.state.isLoaded, isTrue);
    viewModel.dispose();
  });

  test('specific no-active 404 becomes an empty loaded state', () async {
    final repository = FakeTrainingBlockRepository(
      Result.failure(
        AppError(
          message: ClientInfoScreenViewModel.noActiveBlockMessage,
        ),
      ),
    );
    final viewModel = ClientInfoScreenViewModel(
      GetActiveTrainingBlockUseCase(repository),
    );

    await viewModel.getActiveTrainingBlock('client-id');

    expect(viewModel.state.isLoaded, isTrue);
    expect(viewModel.state.trainingBlock, isNull);
    expect(viewModel.state.errorMessage, isNull);
    viewModel.dispose();
  });

  test('other 404 and server failures remain errors', () async {
    for (final error in [
      AppError(message: 'Client not found'),
      AppError(message: 'Service unavailable'),
    ]) {
      final repository = FakeTrainingBlockRepository(Result.failure(error));
      final viewModel = ClientInfoScreenViewModel(
        GetActiveTrainingBlockUseCase(repository),
      );

      await viewModel.getActiveTrainingBlock('client-id');

      expect(viewModel.state.isLoaded, isFalse);
      expect(viewModel.state.errorMessage, error.message);
      viewModel.dispose();
    }
  });
}
