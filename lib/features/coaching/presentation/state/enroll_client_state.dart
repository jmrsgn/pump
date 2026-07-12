import 'package:pump/core/domain/entity/user_summary.dart';

import '../../../../core/presentation/state/ui_state.dart';

class EnrollClientState extends UiState {
  final List<UserSummary> users;
  final bool isEnrollSuccess;

  const EnrollClientState({
    required super.isLoading,
    super.errorMessage,
    required this.users,
    required this.isEnrollSuccess,
  });

  @override
  EnrollClientState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<UserSummary>? users,
    bool? isEnrollSuccess,
  }) {
    return EnrollClientState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      users: users ?? this.users,
      isEnrollSuccess: isEnrollSuccess ?? this.isEnrollSuccess,
    );
  }

  factory EnrollClientState.initial() {
    return const EnrollClientState(
      isLoading: false,
      errorMessage: null,
      users: [],
      isEnrollSuccess: false
    );
  }
}
