import 'package:pump/core/domain/entity/user_summary.dart';
import 'package:pump/features/coaching/domain/entity/client_user.dart';

import '../../../../core/data/dto/response/paged_response.dart';
import '../../../../core/data/dto/response/result.dart';
import '../../../../core/errors/app_error.dart';
import '../../data/dto/request/create_client_user_request_dto.dart';

abstract class ClientUserRepository {
  Future<Result<void, AppError>> createClientUser(
    CreateClientUserRequest request,
  );

  Future<Result<PagedResponse<ClientUser>, AppError>> getClientUsers(int page);

  Future<Result<List<UserSummary>, AppError>> searchUsers(String query);
}
