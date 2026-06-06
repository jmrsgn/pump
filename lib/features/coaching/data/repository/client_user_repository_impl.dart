import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/coaching/data/service/client_user_service.dart';
import 'package:pump/features/coaching/domain/entity/client_user.dart';
import 'package:pump/features/coaching/domain/repository/client_user_repository.dart';

import '../../../../core/constants/error/auth_error_constants.dart';
import '../../../../core/constants/error/system_error_constants.dart';
import '../../../../core/data/repository/user_repository_impl.dart';
import '../../../../core/utilities/logger_utility.dart';
import '../dto/request/create_client_user_request_dto.dart';

class ClientUserRepositoryImpl extends ClientUserRepository {
  final ClientUserService _clientUserService;
  final UserRepositoryImpl _userRepositoryImpl;

  ClientUserRepositoryImpl(this._clientUserService, this._userRepositoryImpl);

  // createClientUser ----------------------------------------------------------
  @override
  Future<Result<ClientUser, AppError>> createClientUser(
    CreateClientUserRequest request,
  ) async {
    LoggerUtility.d(
      runtimeType.toString(),
      "Execute method: [createClientUser]",
    );

    try {
      // Get authenticated user
      final userResult = await _userRepositoryImpl.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final createClientUserResult = await _clientUserService.createClientUser(
        userResult.data!.token,
        request,
      );

      if (!createClientUserResult.isSuccess ||
          createClientUserResult.data == null) {
        return Result.failure(
          AppError(
            message:
                createClientUserResult.error?.message ??
                "Create client user failed",
          ),
        );
      }

      final response = createClientUserResult.data!;
      return Result.success(response.toClientUser());
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createClientUser", e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }
}
