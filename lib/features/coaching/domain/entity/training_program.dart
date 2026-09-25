class TrainingProgram {
  final String trainingBlockId;
  final int trainingDays;
  final List<ProgramDay> days;

  const TrainingProgram({
    required this.trainingBlockId,
    required this.trainingDays,
    required this.days,
  });

  bool get hasExercises => days.any((day) => day.exercises.isNotEmpty);
}

class ProgramDay {
  final String id;
  final int dayNumber;
  final String dayName;
  final List<ProgramExercise> exercises;

  const ProgramDay({
    required this.id,
    required this.dayNumber,
    required this.dayName,
    required this.exercises,
  });
}

class ProgramExercise {
  final String id;
  final String exerciseName;
  final int exerciseOrder;
  final int targetSets;
  final int minReps;
  final int maxReps;

  const ProgramExercise({
    required this.id,
    required this.exerciseName,
    required this.exerciseOrder,
    required this.targetSets,
    required this.minReps,
    required this.maxReps,
  });
}
