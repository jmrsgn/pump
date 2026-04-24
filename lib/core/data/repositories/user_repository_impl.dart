import 'package:pump/core/constants/error/auth_error_constants.dart';
import 'package:pump/core/constants/error/domain/user_error_constants.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/domain/entities/authenticated_user.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/core/utils/secure_storage.dart';

import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final SecureStorage _secureStorage;

  UserRepositoryImpl({SecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? SecureStorage();

  // getAuthenticatedUser ------------------------------------------------------
  @override
  Future<Result<AuthenticatedUser, AppError>> getAuthenticatedUser() async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [getAuthenticatedUser]",
    );

    try {
      final token = await _secureStorage.getToken();
      if (token == null || token.isEmpty) {
        LoggerUtility.e(runtimeType.toString(), "Token is missing");
        return Result.failure(
          AppError(message: AuthErrorConstants.tokenIsMissing),
        );
      }

      // Check for stored user
      final user = await _secureStorage.getCurrentLoggedInUser();
      if (user == null) {
        LoggerUtility.e(runtimeType.toString(), "User not found");
        return Result.failure(
          AppError(message: UserErrorConstants.userNotFound),
        );
      }
      return Result.success(AuthenticatedUser(user: user, token: token));
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getAuthenticatedUser", e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }
}
