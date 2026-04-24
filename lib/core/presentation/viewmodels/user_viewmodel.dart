import 'package:pump/core/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:pump/core/presentation/providers/user_state.dart';
import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/core/utilities/logger_utility.dart';

class UserViewModel extends BaseViewModel<UserState> {
  final GetAuthenticatedUserUseCase _getAuthenticatedUserUseCase;

  UserViewModel(this._getAuthenticatedUserUseCase) : super(UserState.initial());

  @override
  UserState copyWithState({bool? isLoading, String? errorMessage}) {
    return state.copyWith(isLoading: isLoading, errorMessage: errorMessage);
  }

  // getAuthenticatedUser -----------------------------------------------------
  Future<void> getAuthenticatedUser() async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [initializeCurrentUser]",
    );

    // Prevent double taps
    if (state.isLoading) return;

    setLoading(true);

    try {
      final result = await _getAuthenticatedUserUseCase.execute();

      if (result.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          user: result.data!.user,
          errorMessage: null,
        );
      } else {
        LoggerUtility.e(
          runtimeType.toString(),
          "getAuthenticatedUser",
          result.error!.message,
        );
        emitError(result.error!.message);
      }
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getAuthenticatedUser", e, stack);
      emitUnexpectedError();
    }
  }
}
