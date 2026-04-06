import 'package:pump/core/domain/entities/user.dart';

class UserResponse {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImageUrl;
  final String? bio;
  final int? followersNo;
  final int? followingNo;

  UserResponse({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImageUrl,
    this.bio,
    this.followersNo,
    this.followingNo,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      followersNo: json['followersNo'],
      followingNo: json['followingNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'followersNo': followersNo,
      'followingNo': followingNo,
    };
  }

  User toUser() {
    return User(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      profileImageUrl: profileImageUrl ?? '',
      followersNo: followersNo ?? 0,
      followingNo: followingNo ?? 0,
    );
  }
}
