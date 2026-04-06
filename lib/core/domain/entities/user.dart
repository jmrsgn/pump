class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String profileImageUrl;
  final int followersNo;
  final int followingNo;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImageUrl,
    required this.followersNo,
    required this.followingNo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
      followersNo: (json['followersNo'] ?? 0) as int,
      followingNo: (json['followingNo'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'profileImageUrl': profileImageUrl,
    'followersNo': followersNo,
    'followingNo': followingNo,
  };

  @override
  String toString() =>
      'User(id: $id, name: $firstName $lastName, email: $email)';
}
