import '../../enums/activity_level.dart';
import '../../enums/fitness_goal.dart';
import '../../enums/gender.dart';

class ClientUser {
  final String id;
  final String coachId;

  final String firstName;
  final String lastName;
  final String profileImageUrl;

  final Gender gender;
  final DateTime birthDate;

  final double heightCm;
  final double currentWeight;
  final double goalWeight;

  final ActivityLevel activityLevel;
  final FitnessGoal fitnessGoal;

  final DateTime createdAt;
  final DateTime updatedAt;

  const ClientUser({
    required this.id,
    required this.coachId,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
    required this.gender,
    required this.birthDate,
    required this.heightCm,
    required this.currentWeight,
    required this.goalWeight,
    required this.activityLevel,
    required this.fitnessGoal,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';
}
