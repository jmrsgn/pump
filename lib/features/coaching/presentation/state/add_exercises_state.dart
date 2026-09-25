class EditableExercise {
  final int key;
  final String name;
  final String minReps;
  final String maxReps;

  const EditableExercise({
    required this.key,
    this.name = '',
    this.minReps = '',
    this.maxReps = '',
  });

  EditableExercise copyWith({String? name, String? minReps, String? maxReps}) =>
      EditableExercise(
        key: key,
        name: name ?? this.name,
        minReps: minReps ?? this.minReps,
        maxReps: maxReps ?? this.maxReps,
      );
}

class EditableDay {
  final int number;
  final String name;
  final List<EditableExercise> exercises;

  const EditableDay({
    required this.number,
    required this.name,
    required this.exercises,
  });

  EditableDay copyWith({String? name, List<EditableExercise>? exercises}) =>
      EditableDay(
        number: number,
        name: name ?? this.name,
        exercises: exercises ?? this.exercises,
      );
}

class AddExercisesState {
  final List<EditableDay> days;
  const AddExercisesState({this.days = const []});
}
