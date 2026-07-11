import 'package:pump/core/domain/usecases/search_users_usecase.dart';
import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/features/coaching/domain/usecases/create_client_user_usecase.dart';
import 'package:pump/features/coaching/presentation/state/enroll_client_state.dart';

import '../../../../core/constants/error/validation_error_constants.dart';
import '../../../../core/utilities/logger_utility.dart';
import '../../enums/activity_level.dart';
import '../../enums/fitness_goal.dart';
import '../../enums/gender.dart';

class EnrollClientViewModel extends BaseViewModel<EnrollClientState> {
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
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [clearSearchUsers]",
    );
    state = state.copyWith(users: [], errorMessage: null);
  }

  // createClientUser ----------------------------------------------------------
  Future<void> createClientUser({
    required String userId,
    required Gender gender,
    required DateTime? birthDate,
    required double heightCm,
    required double currentWeight,
    required double goalWeight,
    required ActivityLevel activityLevel,
    required FitnessGoal fitnessGoal,
  }) async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [createClientUser]",
    );

    // Prevent double taps
    if (state.isLoading) return;

    setLoading(true);

    // Validate nullable required selections
    if ([gender, birthDate, activityLevel, fitnessGoal].any((e) => e == null)) {
      emitError(ValidationErrorConstants.allFieldsAreRequired);
      return;
    }

    // Validate numeric fields
    if ([heightCm, currentWeight, goalWeight].any((e) => e <= 0)) {
      emitError(ValidationErrorConstants.allFieldsAreRequired);
      return;
    }

    try {
      final result = await _createClientUserUseCase.execute(
        userId,
        gender,
        birthDate,
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
        LoggerUtility.d(
          runtimeType.toString(),
          "createClientUser",
          result.error!.message,
        );

        emitError(result.error!.message);
      }
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createClientUser", e, stack);
      emitUnexpectedError();
    }
  }

  // searchUsers ---------------------------------------------------------------
  Future<void> searchUsers(String query) async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [searchUsers] query: [$query]",
    );

    if (query.trim().isEmpty) {
      state = state.copyWith(users: [], errorMessage: null);
      return;
    }

    try {
      final result = await _searchUsersUseCase.execute(query.trim());
      if (result.isSuccess) {
        state = state.copyWith(users: result.data!, errorMessage: null);
      } else {
        LoggerUtility.d(
          runtimeType.toString(),
          "searchUsers",
          result.error!.message,
        );

        emitError(result.error!.message);
      }
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "searchUsers", e, stack);
      emitUnexpectedError();
    }
  }
}
