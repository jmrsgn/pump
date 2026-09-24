class TrainingBlock {
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

  const TrainingBlock({
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
}
