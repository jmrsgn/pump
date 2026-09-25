import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/features/coaching/domain/usecases/get_active_training_block_usecase.dart';
import 'package:pump/features/coaching/presentation/state/client_info_screen_state.dart';

class ClientInfoScreenViewModel extends BaseViewModel<ClientInfoScreenState> {
  static const debugTag = 'ClientInfoScreenViewModel';

  final GetActiveTrainingBlockUseCase _getActiveTrainingBlockUseCase;

  ClientInfoScreenViewModel(this._getActiveTrainingBlockUseCase)
    : super(ClientInfoScreenState.initial());

  @override
  ClientInfoScreenState copyWithState({
    bool? isLoading,
    String? errorMessage,
  }) => state.copyWith(isLoading: isLoading, errorMessage: errorMessage);

  // getActiveTrainingBlock ------------------------------------------------------------
  Future<void> getActiveTrainingBlock(String clientId) async {
    LoggerUtility.d(debugTag, 'Execute method: [getActiveTrainingBlock]');
    if (state.isLoading || state.isLoaded) return;

    setLoading(true);

    try {
      final result = await _getActiveTrainingBlockUseCase.execute(clientId);
      if (!result.isSuccess && result.data == null) {
        emitError(result.error?.message ?? 'Failed to load training block');
      }

      state = ClientInfoScreenState(
        isLoading: false,
        isLoaded: true,
        trainingBlock: result.data,
      );
    } catch (e, stack) {
      LoggerUtility.e(debugTag, 'getActiveTrainingBlock', e, stack);
      emitUnexpectedError();
    }
  }
}
