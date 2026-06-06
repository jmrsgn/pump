class UserSummary {
  final String id;
  final String firstName;
  final String lastName;
  final String profileImageUrl;

  const UserSummary({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'profileImageUrl': profileImageUrl,
  };

  @override
  String toString() => 'User(id: $id, name: $firstName $lastName)';
}
