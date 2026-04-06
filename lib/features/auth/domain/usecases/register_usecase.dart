import 'package:pump/core/errors/app_error.dart';

import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/data/dto/result.dart';
import '../../data/dto/auth_response_dto.dart';
import '../../data/dto/register_request_dto.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<Result<AuthResponse, AppError>> execute(
    String firstName,
    String lastName,
    String email,
    String phone,
    int role,
    String password,
  ) async {
    final request = RegisterRequest(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: '${AppStrings.phPhonePrefix}$phone',
      role: role,
      password: password,
    );
    return await _authRepository.register(request);
  }
}
