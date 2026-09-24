import 'package:pump/features/coaching/domain/entity/training_block.dart';

class TrainingBlockResponse {
  final String id;
  final String clientId;
  final String trainingBlockName;
  final int numberOfWeeks;
  final int trainingDays;
  final String trainingSplit;
  final int estimatedMacros;
  final int targetProteinInGrams;
  final int targetCarbsInGrams;
  final int targetFatInGrams;
  final int requiredDailySteps;
  final String? otherNotes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TrainingBlockResponse({
    required this.id,
    required this.clientId,
    required this.trainingBlockName,
    required this.numberOfWeeks,
    required this.trainingDays,
    required this.trainingSplit,
    required this.estimatedMacros,
    required this.targetProteinInGrams,
    required this.targetCarbsInGrams,
    required this.targetFatInGrams,
    required this.requiredDailySteps,
    required this.otherNotes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrainingBlockResponse.fromJson(Map<String, dynamic> json) =>
      TrainingBlockResponse(
        id: json['id'] as String,
        clientId: json['clientId'] as String,
        trainingBlockName: json['trainingBlockName'] as String,
        numberOfWeeks: json['numberOfWeeks'] as int,
        trainingDays: json['trainingDays'] as int,
        trainingSplit: json['trainingSplit'] as String,
        estimatedMacros: json['estimatedMacros'] as int,
        targetProteinInGrams: json['targetProteinInGrams'] as int,
        targetCarbsInGrams: json['targetCarbsInGrams'] as int,
        targetFatInGrams: json['targetFatInGrams'] as int,
        requiredDailySteps: json['requiredDailySteps'] as int,
        otherNotes: json['otherNotes'] as String?,
        status: json['status'] as String,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      );

  TrainingBlock toTrainingBlock() => TrainingBlock(
    id: id,
    clientId: clientId,
    trainingBlockName: trainingBlockName,
    numberOfWeeks: numberOfWeeks,
    trainingDays: trainingDays,
    trainingSplit: trainingSplit,
    estimatedMacros: estimatedMacros,
    targetProteinInGrams: targetProteinInGrams,
    targetCarbsInGrams: targetCarbsInGrams,
    targetFatInGrams: targetFatInGrams,
    requiredDailySteps: requiredDailySteps,
    otherNotes: otherNotes,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
