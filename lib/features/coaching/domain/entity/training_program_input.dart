/// Application input for a repeating weekly training program.
/// This is not a confirmed Coaching Service request body.
class TrainingProgramInput {
  final String trainingBlockId;
  final List<TrainingDayInput> days;

  const TrainingProgramInput({
    required this.trainingBlockId,
    required this.days,
  });
}

class TrainingDayInput {
  final int dayNumber;
  final String dayName;
  final List<TrainingExerciseInput> exercises;

  const TrainingDayInput({
    required this.dayNumber,
    required this.dayName,
    required this.exercises,
  });
}

class TrainingExerciseInput {
  final String exerciseName;
  final int exerciseOrder;
  final int minReps;
  final int maxReps;

  const TrainingExerciseInput({
    required this.exerciseName,
    required this.exerciseOrder,
    required this.minReps,
    required this.maxReps,
  });
}
