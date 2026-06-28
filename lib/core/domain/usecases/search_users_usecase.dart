import 'package:pump/core/domain/entity/user_summary.dart';
import 'package:pump/features/coaching/domain/repository/client_user_repository.dart';

import '../../data/dto/response/result.dart';
import '../../errors/app_error.dart';

class SearchUsersUseCase {
  final ClientUserRepository _clientUserRepository;

  SearchUsersUseCase(this._clientUserRepository);

  Future<Result<List<UserSummary>, AppError>> execute(String query) async {
    return await _clientUserRepository.searchUsers(query);
  }
}
