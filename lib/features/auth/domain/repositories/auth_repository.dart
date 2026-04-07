import 'package:pump/core/errors/app_error.dart';

import '../../../../core/data/dto/response/result.dart';
import '../../data/dto/auth_response_dto.dart';
import '../../data/dto/login_request_dto.dart';
import '../../data/dto/register_request_dto.dart';

abstract class AuthRepository {
  Future<Result<AuthResponse, AppError>> login(LoginRequest request);

  Future<Result<AuthResponse, AppError>> register(RegisterRequest request);

  Future<void> logout();
}
