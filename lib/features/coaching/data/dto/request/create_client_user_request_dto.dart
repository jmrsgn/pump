class CreateClientUserRequest {
  final String userId;
  final String gender;
  final int age;
  final double heightCm;
  final double currentWeight;
  final double goalWeight;
  final String activityLevel;
  final String fitnessGoal;

  const CreateClientUserRequest({
    required this.userId,
    required this.gender,
    required this.age,
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
      'age': age,
      'heightCm': heightCm,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'activityLevel': activityLevel,
      'fitnessGoal': fitnessGoal,
    };
  }
}
