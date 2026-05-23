import 'exercise.dart';

class LogExercise {
  Exercise exercise;
  List<int> reps;
  List<double> weights;

  LogExercise({
    required this.exercise,
    required this.reps,
    required this.weights,
  });

  Map<String, dynamic> toJson() {
    return {'exercise': exercise.toJson(), 'reps': reps, 'weights': weights};
  }

  factory LogExercise.fromJson(Map<String, dynamic> json) {
    return LogExercise(
      exercise: Exercise.fromJson(json['exercise']),
      reps: List<int>.from(json['reps']),
      weights: List<double>.from(json['weights']),
    );
  }
}
