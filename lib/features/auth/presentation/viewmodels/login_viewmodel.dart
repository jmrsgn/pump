import 'package:pump/core/constants/app/ui_constants.dart';
import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/core/utilities/logger_utility.dart';

import '../../../../core/presentation/providers/ui_state.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginViewModel extends BaseViewmodel<UiState> {
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase) : super(UiState.initial());

  @override
  UiState copyWithState({bool? isLoading, String? errorMessage}) {
    return state.copyWith(isLoading: isLoading, errorMessage: errorMessage);
  }

  Future<void> login(String email, String password) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [login]");

    // Prevent double taps
    if (state.isLoading) return;

    setLoading(true);

    if (email.trim().isEmpty || password.trim().isEmpty) {
      return emitError("Email and password are required");
    }

    if (!UIConstants.emailRegex.hasMatch(email.trim())) {
      return emitError("Enter a valid email");
    }

    if (password.length < UIConstants.minimumPasswordLength) {
      return emitError("Password must be at least 6 characters");
    }

    try {
      final response = await _loginUseCase.execute(
        email.trim(),
        password.trim(),
      );

      if (response.isSuccess) {
        state = state.copyWith(isLoading: false, errorMessage: null);
      } else {
        LoggerUtility.e(
          runtimeType.toString(),
          "login",
          response.error!.message,
        );
        emitError(response.error!.message);
      }
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "login", e, stack);
      emitUnexpectedError();
    }
  }
}
