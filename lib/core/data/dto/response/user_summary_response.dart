import 'package:pump/core/domain/entity/user_summary.dart';

class UserSummaryResponse {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? profileImageUrl;

  UserSummaryResponse({
    this.id,
    this.firstName,
    this.lastName,
    this.profileImageUrl,
  });

  factory UserSummaryResponse.fromJson(Map<String, dynamic> json) {
    return UserSummaryResponse(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
    };
  }

  UserSummary toUserSummary() {
    return UserSummary(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      profileImageUrl: profileImageUrl ?? '',
    );
  }
}
