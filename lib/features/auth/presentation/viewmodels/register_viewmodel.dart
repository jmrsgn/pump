import 'package:pump/core/presentation/viewmodels/base_viewmodel.dart';
import 'package:pump/core/utilities/logger_utility.dart';

import '../../../../core/constants/app/ui_constants.dart';
import '../../../../core/presentation/providers/ui_state.dart';
import '../../domain/usecases/register_usecase.dart';

class RegisterViewModel extends BaseViewModel<UiState> {
  final RegisterUseCase _registerUseCase;

  RegisterViewModel(this._registerUseCase) : super(UiState.initial());

  @override
  UiState copyWithState({bool? isLoading, String? errorMessage}) {
    return state.copyWith(isLoading: isLoading, errorMessage: errorMessage);
  }

  // register ------------------------------------------------------------------
  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String phone,
    int role,
    String password,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [register]");

    // Prevent double taps
    if (state.isLoading) return;

    setLoading(true);

    if ([
      firstName,
      lastName,
      email,
      phone,
      password,
    ].any((e) => e.trim().isEmpty)) {
      emitError("All fields are required");
      return;
    }

    if (!UIConstants.emailRegex.hasMatch(email.trim())) {
      return emitError("Enter a valid email");
    }

    if (password.length < UIConstants.minimumPasswordLength) {
      return emitError("Password must be at least 6 characters");
    }

    try {
      final result = await _registerUseCase.execute(
        firstName,
        lastName,
        email,
        phone,
        role,
        password,
      );

      if (result.isSuccess) {
        state = state.copyWith(isLoading: false, errorMessage: null);
      } else {
        LoggerUtility.e(
          runtimeType.toString(),
          "register",
          result.error!.message,
        );
        emitError(result.error!.message);
      }
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "register", e, stack);
      emitUnexpectedError();
    }
  }
}
