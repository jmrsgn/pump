import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';
import 'package:pump/features/coaching/domain/entity/training_program.dart';
import 'package:pump/features/coaching/presentation/state/add_exercises_state.dart';

class AddExercisesViewModel extends StateNotifier<AddExercisesState> {
  int _nextKey = 0;
  AddExercisesViewModel() : super(const AddExercisesState());

  void initialize(
    TrainingBlock block, {
    AddExercisesState? existingDraft,
    TrainingProgram? existingProgram,
  }) {
    if (state.days.isNotEmpty) {
      return;
    }
    if (existingDraft != null) {
      state = existingDraft;
      for (final day in existingDraft.days) {
        for (final exercise in day.exercises) {
          if (exercise.key >= _nextKey) {
            _nextKey = exercise.key + 1;
          }
        }
      }
      return;
    }
    if (existingProgram != null &&
        existingProgram.days.length == block.trainingDays) {
      state = AddExercisesState(
        days: existingProgram.days
            .map(
              (day) => EditableDay(
                number: day.dayNumber,
                name: day.dayName,
                exercises: day.exercises
                    .map(
                      (exercise) => EditableExercise(
                        key: _nextKey++,
                        name: exercise.exerciseName,
                        minReps: '${exercise.minReps}',
                        maxReps: '${exercise.maxReps}',
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      );
      return;
    }
    // The current block creation screen stores split labels separated by commas.
    // Coaches can edit the names when the split count differs from the day count.
    final names = block.trainingSplit
        .split(',')
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    state = AddExercisesState(
      days: List.generate(
        block.trainingDays,
        (index) => EditableDay(
          number: index + 1,
          name: names.length == block.trainingDays
              ? names[index]
              : 'Day ${index + 1}',
          exercises: [],
        ),
      ),
    );
  }

  void renameDay(int dayIndex, String value) =>
      _updateDay(dayIndex, state.days[dayIndex].copyWith(name: value));

  void addExercise(int dayIndex) {
    final day = state.days[dayIndex];
    _updateDay(
      dayIndex,
      day.copyWith(
        exercises: [
          ...day.exercises,
          EditableExercise(key: _nextKey++),
        ],
      ),
    );
  }

  void removeExercise(int dayIndex, int exerciseIndex) {
    final day = state.days[dayIndex];
    _updateDay(
      dayIndex,
      day.copyWith(exercises: [...day.exercises]..removeAt(exerciseIndex)),
    );
  }

  void editExercise(
    int dayIndex,
    int exerciseIndex, {
    String? name,
    String? minReps,
    String? maxReps,
  }) {
    final day = state.days[dayIndex];
    final exercises = [...day.exercises];
    exercises[exerciseIndex] = exercises[exerciseIndex].copyWith(
      name: name,
      minReps: minReps,
      maxReps: maxReps,
    );
    _updateDay(dayIndex, day.copyWith(exercises: exercises));
  }

  void _updateDay(int index, EditableDay day) {
    final days = [...state.days];
    days[index] = day;
    state = AddExercisesState(days: days);
  }
}
