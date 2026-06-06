import 'package:pump/core/constants/error/auth_error_constants.dart';
import 'package:pump/core/constants/error/domain/user_error_constants.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/data/service/user_service.dart';
import 'package:pump/core/domain/entity/user_summary.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/core/utils/secure_storage.dart';

import '../../domain/entity/authenticated_user.dart';
import '../../domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserService _userService;
  final SecureStorage _secureStorage;

  UserRepositoryImpl(this._userService, {SecureStorage? secureStorage})
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

  // searchUsers ---------------------------------------------------------------
  @override
  Future<Result<List<UserSummary>, AppError>> searchUsers(String query) async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [searchUsers] query: [$query]",
    );

    try {
      final userResult = await getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final searchUsersResult = await _userService.searchUsers(
        userResult.data!.token,
        query,
      );

      if (!searchUsersResult.isSuccess) {
        return Result.failure(
          AppError(
            message: searchUsersResult.error?.message ?? "Search users failed",
          ),
        );
      }

      final users = searchUsersResult.data!
          .map((e) => e.toUserSummary())
          .toList();

      return Result.success(users);
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getAuthenticatedUser", e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }
}
