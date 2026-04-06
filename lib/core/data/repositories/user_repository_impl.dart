import 'package:pump/core/data/dto/result.dart';
import 'package:pump/core/domain/entities/authenticated_user.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/core/utils/secure_storage.dart';

import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final SecureStorage _secureStorage;

  UserRepositoryImpl({SecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? SecureStorage();

  // getAuthenticatedCurrentUser -----------------------------------------------
  @override
  Future<Result<AuthenticatedUser, AppError>>
  getAuthenticatedCurrentUser() async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [getAuthenticatedCurrentUser]",
    );

    try {
      final token = await _secureStorage.getToken();
      if (token == null || token.isEmpty) {
        LoggerUtility.e(
          runtimeType.toString(),
          "Token is missing, will not proceed with API call",
        );
      }

      // Check for stored user
      final user = await _secureStorage.getCurrentLoggedInUser();
      if (user == null) {
        LoggerUtility.e(runtimeType.toString(), "User not found");
        return Result.failure(AppError(message: "User not found"));
      }
      return Result.success(AuthenticatedUser(user: user, token: token!));
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getAuthenticatedUser", e, stack);
      return Result.failure(AppError(message: "An unexpected error occurred"));
    }
  }
}
