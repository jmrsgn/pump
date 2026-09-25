import 'package:pump/features/coaching/domain/entity/training_program.dart';
import 'package:pump/features/coaching/presentation/state/add_exercises_state.dart';

class TrainingBlockScreenState {
  final TrainingProgram? program;
  final AddExercisesState? draft;

  const TrainingBlockScreenState({this.program, this.draft});
}
