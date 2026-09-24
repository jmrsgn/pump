import '../../../../core/data/dto/response/paged_response.dart';
import '../../../../core/data/dto/response/result.dart';
import '../../../../core/errors/app_error.dart';
import '../entity/client_user.dart';
import '../repository/client_user_repository.dart';

class GetClientsUseCase {
  final ClientUserRepository _clientUserRepository;

  GetClientsUseCase(this._clientUserRepository);

  Future<Result<PagedResponse<ClientUser>, AppError>> execute(int page) async {
    return await _clientUserRepository.getClients(page);
  }
}
