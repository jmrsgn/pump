import 'package:pump/core/domain/entity/user_summary.dart';
import 'package:pump/core/errors/app_error.dart';

import '../../data/dto/response/result.dart';
import '../entity/authenticated_user.dart';

abstract class UserRepository {
  Future<Result<AuthenticatedUser, AppError>> getAuthenticatedUser();

  Future<Result<List<UserSummary>, AppError>> searchUsers(String query);
}
