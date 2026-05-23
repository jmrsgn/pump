import 'package:pump/core/errors/app_error.dart';

import '../../data/dto/response/result.dart';
import '../entity/authenticated_user.dart';
import '../repository/user_repository.dart';

class GetAuthenticatedUserUseCase {
  final UserRepository _userRepository;

  GetAuthenticatedUserUseCase(this._userRepository);

  Future<Result<AuthenticatedUser, AppError>> execute() async {
    return await _userRepository.getAuthenticatedUser();
  }
}
