import 'package:pump/features/coaching/domain/entity/training_day.dart';
import 'package:pump/features/coaching/domain/entity/training_week.dart';
import 'package:pump/features/coaching/enums/training_split.dart';

class TrainingPlan {
  String planName;
  List<TrainingSplit> splits;
  List<TrainingWeek> weeks;
  List<TrainingDay> trainingDays;
  int noOfDaysPerWeek;
  int noOfWeeks;

  TrainingPlan({
    required this.planName,
    required this.splits,
    required this.weeks,
    required this.trainingDays,
    required this.noOfDaysPerWeek,
    required this.noOfWeeks,
  });

  Map<String, dynamic> toJson() => {
    'planName': planName,
    'splits': splits,
    'weeks': weeks.map((d) => d.toJson()).toList(),
    'trainingDays': trainingDays.map((d) => d.toJson()).toList(),
    'noOfDaysPerWeek': noOfDaysPerWeek,
    'noOfWeeks': noOfWeeks,
  };

  factory TrainingPlan.fromJson(Map<String, dynamic> json) => TrainingPlan(
    planName: json['planName'],
    weeks: (json['weeks'] as List)
        .map((d) => TrainingWeek.fromJson(d))
        .toList(),
    splits: json['splits'],
    noOfDaysPerWeek: json['noOfDaysPerWeek'],
    noOfWeeks: json['noOfWeeks'],
    trainingDays: (json['trainingDays'] as List)
        .map((d) => TrainingDay.fromJson(d))
        .toList(),
  );
}
