class CreateClientUserRequest {
  final String userId;
  final String gender;
  final DateTime? birthDate;
  final double heightCm;
  final double currentWeight;
  final double goalWeight;
  final String activityLevel;
  final String fitnessGoal;

  const CreateClientUserRequest({
    required this.userId,
    required this.gender,
    this.birthDate,
    required this.heightCm,
    required this.currentWeight,
    required this.goalWeight,
    required this.activityLevel,
    required this.fitnessGoal,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'heightCm': heightCm,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'activityLevel': activityLevel,
      'fitnessGoal': fitnessGoal,
    };
  }
}
