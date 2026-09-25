import 'package:pump/core/presentation/state/ui_state.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';

class ClientInfoScreenState extends UiState {
  final TrainingBlock? trainingBlock;
  final bool isLoaded;

  const ClientInfoScreenState({
    required super.isLoading,
    super.errorMessage,
    this.trainingBlock,
    required this.isLoaded,
  });

  factory ClientInfoScreenState.initial() =>
      const ClientInfoScreenState(isLoading: false, isLoaded: false);

  @override
  ClientInfoScreenState copyWith({
    bool? isLoading,
    String? errorMessage,
    TrainingBlock? trainingBlock,
    bool? isLoaded,
  }) => ClientInfoScreenState(
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage,
    trainingBlock: trainingBlock ?? this.trainingBlock,
    isLoaded: isLoaded ?? this.isLoaded,
  );
}
