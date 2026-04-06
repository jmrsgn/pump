import 'package:pump/core/errors/app_error.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/core/utils/secure_storage.dart';

import '../../../../core/data/dto/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../dto/auth_response_dto.dart';
import '../dto/login_request_dto.dart';
import '../dto/register_request_dto.dart';
import '../services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl(this._authService, {SecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? SecureStorage();

  // login ---------------------------------------------------------------------
  @override
  Future<Result<AuthResponse, AppError>> login(LoginRequest request) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [login]");

    try {
      final result = await _authService.login(request);
      if (!result.isSuccess) {
        return Result.failure(
          AppError(message: result.error?.message ?? "User login failed"),
        );
      }

      final auth = result.data!;
      if (auth.accessToken != null && auth.userResponse != null) {
        await _secureStorage.saveToken(auth.accessToken!);
        await _secureStorage.saveCurrentLoggedInUser(
          auth.userResponse!.toUser(),
        );
      }

      return Result.success(auth);
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "login", e, stack);
      return Result.failure(AppError(message: "An unexpected error occurred"));
    }
  }

  // register ------------------------------------------------------------------
  @override
  Future<Result<AuthResponse, AppError>> register(
    RegisterRequest request,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [register]");

    try {
      final result = await _authService.register(request);
      if (!result.isSuccess) {
        return Result.failure(
          AppError(
            message: result.error?.message ?? "User registration failed",
          ),
        );
      }

      final auth = result.data!;
      if (auth.accessToken != null && auth.userResponse != null) {
        await _secureStorage.saveToken(auth.accessToken!);
        await _secureStorage.saveCurrentLoggedInUser(
          auth.userResponse!.toUser(),
        );
      }

      return Result.success(auth);
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "register", e, stack);
      return Result.failure(AppError(message: "An unexpected error occurred"));
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.deleteCurrentLoggedInUser();
    await _secureStorage.deleteToken();
  }
}
