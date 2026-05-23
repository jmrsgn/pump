import 'package:pump/features/coaching/enums/activity_level.dart';
import 'package:pump/features/coaching/enums/fitness_goal.dart';
import 'package:pump/features/coaching/enums/gender.dart';

class CreateClientUserRequest {
  final String firstName;
  final String lastName;
  final String? profileImageUrl;
  final Gender? gender;
  final DateTime? birthDate;
  final double? heightCm;
  final double? currentWeight;
  final double? goalWeight;
  final ActivityLevel? activityLevel;
  final FitnessGoal? fitnessGoal;

  const CreateClientUserRequest({
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
    this.gender,
    this.birthDate,
    this.heightCm,
    this.currentWeight,
    this.goalWeight,
    this.activityLevel,
    this.fitnessGoal,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'gender': gender?.name,
      'birthDate': birthDate?.toIso8601String(),
      'heightCm': heightCm,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'activityLevel': activityLevel?.name,
      'fitnessGoal': fitnessGoal?.name,
    };
  }
}
