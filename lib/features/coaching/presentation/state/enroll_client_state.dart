import 'package:pump/core/domain/entity/user_summary.dart';

import '../../../../core/presentation/state/ui_state.dart';

class EnrollClientState extends UiState {
  final List<UserSummary> users;

  const EnrollClientState({
    required super.isLoading,
    super.errorMessage,
    required this.users,
  });

  @override
  EnrollClientState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<UserSummary>? users,
  }) {
    return EnrollClientState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      users: users ?? this.users,
    );
  }

  factory EnrollClientState.initial() {
    return const EnrollClientState(
      isLoading: false,
      errorMessage: null,
      users: [],
    );
  }
}
