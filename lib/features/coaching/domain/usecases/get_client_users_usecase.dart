import '../../../../core/data/dto/response/paged_response.dart';
import '../../../../core/data/dto/response/result.dart';
import '../../../../core/errors/app_error.dart';
import '../entity/client_user.dart';
import '../repository/client_user_repository.dart';

class GetClientUsersUseCase {
  final ClientUserRepository _clientUserRepository;

  GetClientUsersUseCase(this._clientUserRepository);

  Future<Result<PagedResponse<ClientUser>, AppError>> execute(int page) async {
    return await _clientUserRepository.getClientUsers(page);
  }
}
