import 'package:pump/core/domain/entity/user_summary.dart';

import '../../data/dto/response/result.dart';
import '../../errors/app_error.dart';
import '../repository/user_repository.dart';

class SearchUsersUseCase {
  final UserRepository _userRepository;

  SearchUsersUseCase(this._userRepository);

  Future<Result<List<UserSummary>, AppError>> execute(String query) async {
    return await _userRepository.searchUsers(query);
  }
}
