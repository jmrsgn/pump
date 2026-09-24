class CreateTrainingBlockRequest {
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

  const CreateTrainingBlockRequest({
    required this.trainingBlockName,
    required this.numberOfWeeks,
    required this.trainingDays,
    required this.trainingSplit,
    required this.estimatedMacros,
    required this.targetProteinInGrams,
    required this.targetCarbsInGrams,
    required this.targetFatInGrams,
    required this.requiredDailySteps,
    this.otherNotes,
  });

  Map<String, dynamic> toJson() => {
    'trainingBlockName': trainingBlockName,
    'numberOfWeeks': numberOfWeeks,
    'trainingDays': trainingDays,
    'trainingSplit': trainingSplit,
    'estimatedMacros': estimatedMacros,
    'targetProteinInGrams': targetProteinInGrams,
    'targetCarbsInGrams': targetCarbsInGrams,
    'targetFatInGrams': targetFatInGrams,
    'requiredDailySteps': requiredDailySteps,
    'otherNotes': otherNotes,
  };
}
