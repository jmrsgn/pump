import 'package:pump/features/coaching/enums/training_split.dart';

import 'exercise.dart';
import 'log_exercise.dart';

class TrainingDay {
  int dayNumber;
  TrainingSplit splitName;
  List<Exercise> exercises;
  List<LogExercise> logExercises;

  TrainingDay({
    required this.dayNumber,
    required this.splitName,
    required this.exercises,
    required this.logExercises,
  });

  Map<String, dynamic> toJson() => {
    'dayNumber': dayNumber,
    'splitName': splitName,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'logExercises': logExercises.map((e) => e.toJson()).toList(),
  };

  factory TrainingDay.fromJson(Map<String, dynamic> json) => TrainingDay(
    dayNumber: json['dayNumber'],
    splitName: json['splitName'],
    exercises: (json['exercises'] as List)
        .map((e) => Exercise.fromJson(e))
        .toList(),
    logExercises: (json['logExercises'] as List)
        .map((e) => LogExercise.fromJson(e))
        .toList(),
  );
}
