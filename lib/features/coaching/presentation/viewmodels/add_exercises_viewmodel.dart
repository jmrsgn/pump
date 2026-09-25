import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';
import 'package:pump/features/coaching/domain/entity/training_program.dart';
import 'package:pump/features/coaching/domain/entity/training_program_input.dart';
import 'package:pump/features/coaching/domain/usecases/add_training_exercises_usecase.dart';
import 'package:pump/features/coaching/presentation/state/add_exercises_state.dart';

class AddExercisesViewModel extends StateNotifier<AddExercisesState> {
  static const debugTag = 'AddExercisesViewModel';

  final AddTrainingExercisesUseCase addTrainingExercisesUseCase;
  int _nextKey = 0;

  AddExercisesViewModel(this.addTrainingExercisesUseCase)
    : super(const AddExercisesState());

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

  TrainingProgramInput? buildSubmissionInput(String trainingBlockId) {
    if (state.days.isEmpty) {
      _setValidationError('Add a training day before submitting.');
      return null;
    }

    final days = <TrainingDayInput>[];
    for (final day in state.days) {
      final dayName = day.name.trim();
      if (dayName.isEmpty) {
        _setValidationError('Enter a name for Day ${day.number}.');
        return null;
      }

      final exercises = <TrainingExerciseInput>[];
      for (final entry in day.exercises.asMap().entries) {
        final exercise = entry.value;
        final exerciseName = exercise.name.trim();
        if (exerciseName.isEmpty) {
          _setValidationError(
            'Enter a name for exercise ${entry.key + 1} on Day ${day.number}.',
          );
          return null;
        }

        final minReps = int.tryParse(exercise.minReps.trim());
        final maxReps = int.tryParse(exercise.maxReps.trim());
        if (minReps == null ||
            maxReps == null ||
            minReps <= 0 ||
            maxReps <= 0) {
          _setValidationError(
            'Enter positive whole-number reps for exercise ${entry.key + 1} on Day ${day.number}.',
          );
          return null;
        }
        if (maxReps < minReps) {
          _setValidationError(
            'Maximum reps must be at least minimum reps for exercise ${entry.key + 1} on Day ${day.number}.',
          );
          return null;
        }

        exercises.add(
          TrainingExerciseInput(
            exerciseName: exerciseName,
            exerciseOrder: entry.key + 1,
            minReps: minReps,
            maxReps: maxReps,
          ),
        );
      }
      days.add(
        TrainingDayInput(
          dayNumber: day.number,
          dayName: dayName,
          exercises: exercises,
        ),
      );
    }

    state = AddExercisesState(days: state.days);
    return TrainingProgramInput(trainingBlockId: trainingBlockId, days: days);
  }

  Future<void> submit(String trainingBlockId) async {
    if (state.isLoading || state.isSubmitSuccess) {
      return;
    }
    final input = buildSubmissionInput(trainingBlockId);
    if (input == null) {
      return;
    }

    state = AddExercisesState(days: state.days, isLoading: true);
    try {
      final result = await addTrainingExercisesUseCase.execute(input);
      if (!mounted) {
        return;
      }
      if (result.isSuccess) {
        state = AddExercisesState(days: state.days, isSubmitSuccess: true);
      } else {
        state = AddExercisesState(
          days: state.days,
          errorMessage:
              result.error?.message ??
              SystemErrorConstants.anUnexpectedErrorOccurred,
        );
      }
    } catch (error, stack) {
      LoggerUtility.e(debugTag, 'submit', error, stack);
      if (!mounted) {
        return;
      }
      state = AddExercisesState(
        days: state.days,
        errorMessage: SystemErrorConstants.anUnexpectedErrorOccurred,
      );
    }
  }

  void _setValidationError(String message) {
    state = AddExercisesState(days: state.days, errorMessage: message);
  }
}
