import 'package:pump/features/coaching/domain/entity/client_user.dart';
import 'package:pump/features/coaching/data/enums/activity_level.dart';
import 'package:pump/features/coaching/data/enums/coaching_status.dart';
import 'package:pump/features/coaching/data/enums/fitness_goal.dart';
import 'package:pump/features/coaching/data/enums/gender.dart';

class ClientUserResponse {
  final String? id;
  final String? coachId;

  final String? firstName;
  final String? lastName;
  final String? profileImageUrl;

  final Gender? gender;
  final int? age;
  final DateTime? birthDate;

  final double? heightCm;
  final double? currentWeight;
  final double? goalWeight;

  final ActivityLevel? activityLevel;
  final FitnessGoal? fitnessGoal;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final CoachingStatus? coachingStatus;
  final bool hasActiveTrainingBlock;

  ClientUserResponse({
    this.id,
    this.coachId,
    this.firstName,
    this.lastName,
    this.profileImageUrl,
    this.gender,
    this.age,
    this.birthDate,
    this.heightCm,
    this.currentWeight,
    this.goalWeight,
    this.activityLevel,
    this.fitnessGoal,
    this.createdAt,
    this.updatedAt,
    this.coachingStatus,
    required this.hasActiveTrainingBlock,
  });

  factory ClientUserResponse.fromJson(Map<String, dynamic> json) {
    return ClientUserResponse(
      id: json['id'],
      coachId: json['coachId'],

      firstName: json['firstName'],
      lastName: json['lastName'],
      profileImageUrl: json['profileImageUrl'],

      gender: json['gender'] == null ? null : Gender.fromValue(json['gender']),

      age: json['age'] == null ? null : json['age'] as int,

      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate']),

      heightCm: json['heightCm']?.toDouble(),

      currentWeight: json['currentWeight']?.toDouble(),

      goalWeight: json['goalWeight']?.toDouble(),

      activityLevel: json['activityLevel'] == null
          ? null
          : ActivityLevel.fromValue(json['activityLevel']),

      fitnessGoal: json['fitnessGoal'] == null
          ? null
          : FitnessGoal.fromValue(json['fitnessGoal']),

      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt']),

      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt']),

      coachingStatus: json['coachingStatus'] == null
          ? null
          : CoachingStatus.fromValue(json['coachingStatus']),

      hasActiveTrainingBlock: json['hasActiveTrainingBlock'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coachId': coachId,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'gender': gender?.value,
      'birthDate': birthDate?.toIso8601String(),
      'heightCm': heightCm,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'activityLevel': activityLevel?.value,
      'fitnessGoal': fitnessGoal?.value,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      "coachingStatus": coachingStatus,
      "hasActiveTrainingBlock": hasActiveTrainingBlock,
    };
  }

  ClientUser toClientUser() {
    return ClientUser(
      id: id ?? '',
      coachId: coachId ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      profileImageUrl: profileImageUrl ?? '',
      gender: gender ?? Gender.male,
      age: age ?? 0,
      birthDate: birthDate ?? DateTime.now(),
      heightCm: heightCm ?? 0,
      currentWeight: currentWeight ?? 0,
      goalWeight: goalWeight ?? 0,
      activityLevel: activityLevel ?? ActivityLevel.sedentary,
      fitnessGoal: fitnessGoal ?? FitnessGoal.maintenance,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      coachingStatus: coachingStatus ?? CoachingStatus.inactive,
      hasActiveTrainingBlock: hasActiveTrainingBlock,
    );
  }
}
