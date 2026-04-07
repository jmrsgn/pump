import 'package:pump/core/errors/app_error.dart';

import '../../../../core/data/dto/response/result.dart';
import '../../data/dto/auth_response_dto.dart';
import '../../data/dto/login_request_dto.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Result<AuthResponse, AppError>> execute(
    String email,
    String password,
  ) async {
    final request = LoginRequest(email: email, password: password);
    return await _authRepository.login(request);
  }
}
