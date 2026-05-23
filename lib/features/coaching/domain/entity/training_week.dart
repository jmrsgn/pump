import 'training_day.dart';

class TrainingWeek {
  int weekNo;
  DateTime date;
  List<TrainingDay> days;

  TrainingWeek({required this.weekNo, required this.date, required this.days});

  Map<String, dynamic> toJson() => {
    'weekNo': weekNo,
    'date': date,
    'days': days.map((d) => d.toJson()).toList(),
  };

  factory TrainingWeek.fromJson(Map<String, dynamic> json) => TrainingWeek(
    weekNo: json['weekNo'],
    date: json['date'],
    days: (json['days'] as List).map((d) => TrainingDay.fromJson(d)).toList(),
  );
}
