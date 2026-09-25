import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/features/coaching/domain/entity/training_program.dart';
import 'package:pump/features/coaching/presentation/state/add_exercises_state.dart';
import 'package:pump/features/coaching/presentation/state/training_block_screen_state.dart';

/// Holds a program locally until the programming API is available.
class TrainingBlockScreenViewModel
    extends StateNotifier<TrainingBlockScreenState> {
  TrainingBlockScreenViewModel() : super(const TrainingBlockScreenState());

  void setProgram(TrainingProgram program) =>
      state = TrainingBlockScreenState(program: program, draft: state.draft);

  void setDraft(AddExercisesState draft) =>
      state = TrainingBlockScreenState(program: state.program, draft: draft);
}
