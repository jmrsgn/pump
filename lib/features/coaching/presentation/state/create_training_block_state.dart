import 'package:pump/core/presentation/state/ui_state.dart';

class CreateTrainingBlockState extends UiState {
  final bool isCreateSuccess;

  const CreateTrainingBlockState({
    required super.isLoading,
    super.errorMessage,
    required this.isCreateSuccess,
  });

  factory CreateTrainingBlockState.initial() =>
      const CreateTrainingBlockState(isLoading: false, isCreateSuccess: false);

  @override
  CreateTrainingBlockState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isCreateSuccess,
  }) => CreateTrainingBlockState(
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage,
    isCreateSuccess: isCreateSuccess ?? this.isCreateSuccess,
  );
}
