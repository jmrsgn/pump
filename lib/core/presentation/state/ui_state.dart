class UiState {
  final bool isLoading;
  final String? errorMessage;

  const UiState({required this.isLoading, this.errorMessage});

  factory UiState.initial() =>
      const UiState(isLoading: false, errorMessage: null);

  UiState copyWith({bool? isLoading, String? errorMessage}) {
    return UiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
