import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/features/coaching/data/dto/request/create_training_block_request_dto.dart';
import 'package:pump/features/coaching/domain/usecases/create_training_block_usecase.dart';
import 'package:pump/features/coaching/presentation/state/create_training_block_state.dart';

class CreateTrainingBlockViewModel
    extends BaseViewModel<CreateTrainingBlockState> {
  static const debugTag = 'CreateTrainingBlockViewModel';
  final CreateTrainingBlockUseCase _useCase;

  CreateTrainingBlockViewModel(this._useCase)
    : super(CreateTrainingBlockState.initial());

  @override
  CreateTrainingBlockState copyWithState({
    bool? isLoading,
    String? errorMessage,
  }) => state.copyWith(isLoading: isLoading, errorMessage: errorMessage);

  Future<void> createTrainingBlock(
    String clientId,
    CreateTrainingBlockRequest request,
  ) async {
    if (state.isLoading || state.isCreateSuccess) return;
    setLoading(true);
    try {
      final result = await _useCase.execute(clientId, request);
      if (result.isSuccess && result.data != null) {
        state = state.copyWith(isLoading: false, isCreateSuccess: true);
      } else {
        emitError(result.error?.message ?? 'Create training block failed');
      }
    } catch (e, stack) {
      LoggerUtility.e(debugTag, 'createTrainingBlock', e, stack);
      emitUnexpectedError();
    }
  }
}
