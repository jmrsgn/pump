import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/presentation/widgets/custom_text_field.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';
import 'package:pump/features/coaching/presentation/provider/training_block_providers.dart';
import 'package:pump/features/coaching/presentation/state/add_exercises_state.dart';
import 'package:pump/features/coaching/presentation/viewmodels/add_exercises_viewmodel.dart';

class AddExercisesScreen extends ConsumerStatefulWidget {
  final TrainingBlock trainingBlock;
  const AddExercisesScreen({super.key, required this.trainingBlock});

  @override
  ConsumerState<AddExercisesScreen> createState() => _AddExercisesScreenState();
}

class _AddExercisesScreenState extends ConsumerState<AddExercisesScreen> {
  final Map<int, TextEditingController> _dayNameControllers = {};

  AddExercisesViewModel get _addExercisesViewModel =>
      ref.read(addExercisesViewModelProvider(widget.trainingBlock.id).notifier);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final trainingBlockState = ref.read(
          trainingBlockScreenViewModelProvider(widget.trainingBlock.id),
        );
        _addExercisesViewModel.initialize(
          widget.trainingBlock,
          existingDraft: trainingBlockState.draft,
          existingProgram: trainingBlockState.program,
        );
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _dayNameControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = addExercisesViewModelProvider(widget.trainingBlock.id);
    final state = ref.watch(provider);
    return CustomScaffold(
      appBarTitle: AppStrings.addExercises,
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.padding16,
          AppDimens.padding16,
          AppDimens.padding16,
          AppDimens.padding24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.trainingBlock.trainingBlockName,
              style: AppTextStyles.heading3,
            ),
            UiUtils.addVerticalSpaceS(),
            Text(
              'Program each training day. Exercises appear in the order shown. Each exercise has 3 sets.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            UiUtils.addVerticalSpaceL(),
            ...state.days.asMap().entries.map(
              (entry) => _buildDay(entry.key, entry.value),
            ),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: 'Preview Program',
                onPressed: () => NavigationUtils.pop(context, state),
              ),
            ),
            UiUtils.addVerticalSpaceS(),
            Text(
              'Preview only. Changes are not saved to the backend.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDay(int index, EditableDay day) {
    final dayNameController = _dayNameControllers.putIfAbsent(
      day.number,
      () => TextEditingController(text: day.name),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.padding24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day ${day.number}',
            style: AppTextStyles.heading3.copyWith(
              fontSize: AppDimens.textSize16,
            ),
          ),
          UiUtils.addVerticalSpaceM(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.padding16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radius16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  key: ValueKey('day-name-${day.number}'),
                  hint: 'Training day name',
                  controller: dayNameController,
                  onChanged: (value) =>
                      _addExercisesViewModel.renameDay(index, value),
                ),
                UiUtils.addVerticalSpaceM(),
                ...day.exercises.asMap().entries.map(
                  (entry) => _ExerciseEditor(
                    key: ValueKey(entry.value.key),
                    number: entry.key + 1,
                    exercise: entry.value,
                    onChanged: ({name, minReps, maxReps}) =>
                        _addExercisesViewModel.editExercise(
                          index,
                          entry.key,
                          name: name,
                          minReps: minReps,
                          maxReps: maxReps,
                        ),
                    onRemove: () =>
                        _addExercisesViewModel.removeExercise(index, entry.key),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'Add Exercise',
                    prefixIcon: Icons.add,
                    isOutlineButton: true,
                    onPressed: () => _addExercisesViewModel.addExercise(index),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseEditor extends StatefulWidget {
  final int number;
  final EditableExercise exercise;
  final void Function({String? name, String? minReps, String? maxReps})
  onChanged;
  final VoidCallback onRemove;
  const _ExerciseEditor({
    super.key,
    required this.number,
    required this.exercise,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<_ExerciseEditor> createState() => _ExerciseEditorState();
}

class _ExerciseEditorState extends State<_ExerciseEditor> {
  late final TextEditingController _name = TextEditingController(
    text: widget.exercise.name,
  );
  late final TextEditingController _min = TextEditingController(
    text: widget.exercise.minReps,
  );
  late final TextEditingController _max = TextEditingController(
    text: widget.exercise.maxReps,
  );

  @override
  void dispose() {
    _name.dispose();
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppDimens.padding16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Exercise ${widget.number} • 3 sets',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              tooltip: 'Remove exercise',
              onPressed: widget.onRemove,
              icon: const Icon(Icons.close, color: AppColors.textSecondary),
            ),
          ],
        ),
        CustomTextField(
          hint: 'Exercise name',
          controller: _name,
          onChanged: (value) => widget.onChanged(name: value),
        ),
        UiUtils.addVerticalSpaceS(),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hint: 'Min reps',
                controller: _min,
                keyboardType: TextInputType.number,
                onChanged: (value) => widget.onChanged(minReps: value),
              ),
            ),
            UiUtils.addHorizontalSpaceS(),
            Expanded(
              child: CustomTextField(
                hint: 'Max reps',
                controller: _max,
                keyboardType: TextInputType.number,
                onChanged: (value) => widget.onChanged(maxReps: value),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
