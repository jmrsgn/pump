import 'package:pump/core/errors/app_error.dart';

import '../../data/dto/response/result.dart';
import '../entities/authenticated_user.dart';

abstract class UserRepository {
  Future<Result<AuthenticatedUser, AppError>> getAuthenticatedUser();
}
