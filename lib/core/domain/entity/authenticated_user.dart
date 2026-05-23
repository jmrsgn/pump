import 'package:pump/core/domain/entity/user.dart';

class AuthenticatedUser {
  final User user;
  final String token;

  AuthenticatedUser({required this.user, required this.token});
}
