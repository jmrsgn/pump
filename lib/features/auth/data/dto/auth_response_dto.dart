import 'package:pump/core/data/dto/user_response_dto.dart';

class AuthResponse {
  String? accessToken;
  UserResponse? userResponse;
  int? expiresIn;

  AuthResponse({this.accessToken, this.userResponse, this.expiresIn});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final userData = json['userResponse'];

    return AuthResponse(
      accessToken: json['accessToken'],
      userResponse: userData == null ? null : UserResponse.fromJson(userData),
      expiresIn: json['expiresIn'],
    );
  }
}
