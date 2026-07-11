import 'package:pump/core/data/dto/response/result.dart';
import 'package:pump/core/errors/app_error.dart';
import 'package:pump/features/coaching/data/service/client_user_service.dart';
import 'package:pump/features/coaching/domain/entity/client_user.dart';
import 'package:pump/features/coaching/domain/repository/client_user_repository.dart';

import '../../../../core/constants/error/auth_error_constants.dart';
import '../../../../core/constants/error/system_error_constants.dart';
import '../../../../core/data/dto/response/paged_response.dart';
import '../../../../core/data/repository/user_repository_impl.dart';
import '../../../../core/domain/entity/user_summary.dart';
import '../../../../core/utilities/logger_utility.dart';
import '../dto/request/create_client_user_request_dto.dart';

class ClientUserRepositoryImpl extends ClientUserRepository {
  final ClientUserService _clientUserService;
  final UserRepositoryImpl _userRepositoryImpl;

  ClientUserRepositoryImpl(this._clientUserService, this._userRepositoryImpl);

  // createClientUser ----------------------------------------------------------
  @override
  Future<Result<void, AppError>> createClientUser(
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

      if (!createClientUserResult.isSuccess) {
        return Result.failure(
          AppError(
            message:
                createClientUserResult.error?.message ??
                "Create client user failed",
          ),
        );
      }

      return Result.success(null);
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "createClientUser", e, stack);
      return Result.failure(
        AppError(message: SystemErrorConstants.anUnexpectedErrorOccurred),
      );
    }
  }

  // getClientUsers ------------------------------------------------------------
  @override
  Future<Result<PagedResponse<ClientUser>, AppError>> getClientUsers(
    int page,
  ) async {
    LoggerUtility.d(runtimeType.toString(), "Execute method: [getPosts]");

    try {
      // Get authenticated user
      final userResult = await _userRepositoryImpl.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final postResult = await _clientUserService.getClientUsers(
        userResult.data!.token,
        page,
      );

      if (!postResult.isSuccess || postResult.data == null) {
        return Result.failure(
          AppError(
            message:
                postResult.error?.message ?? "Failed to fetch client users",
          ),
        );
      }

      final pagedDto = postResult.data!;
      final paged = PagedResponse<ClientUser>(
        content: pagedDto.content.map((e) => e.toClientUser()).toList(),
        page: pagedDto.page,
        size: pagedDto.size,
        totalElements: pagedDto.totalElements,
      );

      return Result.success(paged);
    } catch (e, stack) {
      LoggerUtility.e(runtimeType.toString(), "getClientUsers", e, stack);
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
      final userResult = await _userRepositoryImpl.getAuthenticatedUser();
      if (!userResult.isSuccess || userResult.data == null) {
        LoggerUtility.e(runtimeType.toString(), "User is not authenticated");
        return Result.failure(
          AppError(message: AuthErrorConstants.userIsNotAuthenticated),
        );
      }

      final searchUsersResult = await _clientUserService.searchUsers(
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
