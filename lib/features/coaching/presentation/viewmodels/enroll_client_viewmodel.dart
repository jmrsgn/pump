import 'package:pump/core/domain/usecases/search_users_usecase.dart';
import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/features/coaching/domain/usecases/create_client_user_usecase.dart';
import 'package:pump/features/coaching/presentation/state/enroll_client_state.dart';

import '../../../../core/utilities/logger_utility.dart';
import '../../enums/activity_level.dart';
import '../../enums/fitness_goal.dart';
import '../../enums/gender.dart';

class EnrollClientViewModel extends BaseViewModel<EnrollClientState> {
  static const debugTag = "EnrollClientViewModel";

  final CreateClientUserUseCase _createClientUserUseCase;
  final SearchUsersUseCase _searchUsersUseCase;

  EnrollClientViewModel(this._createClientUserUseCase, this._searchUsersUseCase)
    : super(EnrollClientState.initial());

  @override
  EnrollClientState copyWithState({bool? isLoading, String? errorMessage}) {
    return state.copyWith(isLoading: isLoading, errorMessage: errorMessage);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  void clearSearchUsers() {
    LoggerUtility.d(debugTag, "Execute method: [clearSearchUsers]");
    state = state.copyWith(users: [], errorMessage: null);
  }

  // createClientUser ----------------------------------------------------------
  Future<void> createClientUser({
    required String userId,
    required Gender gender,
    required int age,
    required double heightCm,
    required double currentWeight,
    required double goalWeight,
    required ActivityLevel activityLevel,
    required FitnessGoal fitnessGoal,
  }) async {
    LoggerUtility.d(debugTag, "Execute method: [createClientUser]");

    // Prevent double taps
    if (state.isLoading) return;

    setLoading(true);

    try {
      final result = await _createClientUserUseCase.execute(
        userId,
        gender,
        age,
        heightCm,
        currentWeight,
        goalWeight,
        activityLevel,
        fitnessGoal,
      );

      if (result.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: null,
          isEnrollSuccess: true,
        );
      } else {
        LoggerUtility.d(debugTag, "createClientUser", result.error!.message);
        emitError(result.error!.message);
      }
    } catch (e, stack) {
      LoggerUtility.e(debugTag, "createClientUser", e, stack);
      emitUnexpectedError();
    }
  }

  // searchUsers ---------------------------------------------------------------
  Future<void> searchUsers({required String query}) async {
    LoggerUtility.d(debugTag, "Execute method: [searchUsers] query: [$query]");

    try {
      final result = await _searchUsersUseCase.execute(query.trim());
      if (result.isSuccess) {
        state = state.copyWith(users: result.data!, errorMessage: null);
        LoggerUtility.logItemSize(debugTag, "users", result.data!);
      } else {
        LoggerUtility.d(debugTag, "searchUsers", result.error!.message);
        emitError(result.error!.message);
      }
    } catch (e, stack) {
      LoggerUtility.e(debugTag, "searchUsers", e, stack);
      emitUnexpectedError();
    }
  }
}
