import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/app_routes.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/coaching/domain/entity/training_block.dart';
import 'package:pump/features/coaching/domain/entity/training_program.dart';
import 'package:pump/features/coaching/presentation/provider/training_block_providers.dart';
import 'package:pump/features/coaching/presentation/state/add_exercises_state.dart';

class TrainingBlockScreen extends ConsumerStatefulWidget {
  final TrainingBlock trainingBlock;
  const TrainingBlockScreen({super.key, required this.trainingBlock});

  @override
  ConsumerState<TrainingBlockScreen> createState() =>
      _TrainingBlockScreenState();
}

class _TrainingBlockScreenState extends ConsumerState<TrainingBlockScreen> {
  int _selectedWeek = 0;
  int _expandedDay = 0;

  @override
  Widget build(BuildContext context) {
    final block = widget.trainingBlock;
    final state = ref.watch(trainingBlockScreenViewModelProvider(block.id));
    final program = state.program;
    return CustomScaffold(
      showAppBar: false,
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(block),
          UiUtils.addVerticalSpaceM(),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              label: 'Add Exercises',
              onPressed: () => _openAddExercises(block),
            ),
          ),
          if (state.draft != null) ...[
            UiUtils.addVerticalSpaceM(),
            Expanded(child: _buildDraftPreview(state.draft!)),
          ] else if (program != null && program.hasExercises) ...[
            _buildWeekSelector(block.numberOfWeeks),
            UiUtils.addVerticalSpaceM(),
            Expanded(child: _buildWeekContent(program)),
          ],
        ],
      ),
    );
  }

  Future<void> _openAddExercises(TrainingBlock block) async {
    final draft = await NavigationUtils.navigateTo<AddExercisesState>(
      context,
      AppRoutes.addExercises,
      arguments: block,
    );
    if (!mounted || draft == null) {
      return;
    }
    ref
        .read(trainingBlockScreenViewModelProvider(block.id).notifier)
        .setDraft(draft);
  }

  Widget _buildDraftPreview(AddExercisesState draft) => ListView(
    padding: const EdgeInsets.only(bottom: AppDimens.padding16),
    children: [
      Text('Local preview', style: AppTextStyles.heading3),
      UiUtils.addVerticalSpaceS(),
      Text(
        'This program is not saved to the backend.',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
      ),
      UiUtils.addVerticalSpaceM(),
      ...draft.days.map(
        (day) => Card(
          color: AppColors.surface,
          margin: const EdgeInsets.only(bottom: AppDimens.padding12),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.padding16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Day ${day.number}: ${day.name.trim().isEmpty ? 'Unnamed day' : day.name.trim()}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                UiUtils.addVerticalSpaceS(),
                if (day.exercises.isEmpty)
                  Text('No exercises added', style: AppTextStyles.bodySmall),
                ...day.exercises.asMap().entries.map(
                  (entry) => Text(
                    '${entry.key + 1}. ${entry.value.name.trim().isEmpty ? 'Unnamed exercise' : entry.value.name.trim()}'
                    ' • ${entry.value.minReps.isEmpty ? '?' : entry.value.minReps}'
                    '-${entry.value.maxReps.isEmpty ? '?' : entry.value.maxReps} reps',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildHeader(TrainingBlock block) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppDimens.padding16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimens.radius8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          block.trainingBlockName,
          style: AppTextStyles.heading3.copyWith(
            fontSize: AppDimens.textSize18,
          ),
        ),
        UiUtils.addVerticalSpaceS(),
        Row(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              size: AppDimens.dimen18,
              color: AppColors.textHint,
            ),
            UiUtils.addHorizontalSpaceS(),
            Text(
              '${block.numberOfWeeks} weeks',
              style: AppTextStyles.bodySmall,
            ),
            UiUtils.addHorizontalSpaceM(),
            const Icon(
              Icons.fitness_center_outlined,
              size: AppDimens.dimen18,
              color: AppColors.textHint,
            ),
            UiUtils.addHorizontalSpaceS(),
            Text(
              '${block.trainingDays} days / week',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        UiUtils.addVerticalSpaceS(),
        Text(
          block.trainingSplit.split(',').map((name) => name.trim()).join(' • '),
          style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
        ),
      ],
    ),
  );

  Widget _buildWeekSelector(int weeks) => SizedBox(
    height: AppDimens.dimen44,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: weeks,
      separatorBuilder: (_, __) => UiUtils.addHorizontalSpaceS(),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => setState(() {
          _selectedWeek = index;
          _expandedDay = 0;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: index == _selectedWeek
                ? AppColors.primary
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radius36),
          ),
          child: Text(
            'Week ${index + 1}',
            style: AppTextStyles.button.copyWith(
              fontSize: AppDimens.textSize14,
              color: index == _selectedWeek
                  ? AppColors.textOnPrimary
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildWeekContent(TrainingProgram program) => ListView(
    padding: const EdgeInsets.only(bottom: AppDimens.padding16),
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Week ${_selectedWeek + 1}',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: AppDimens.textSize18,
                ),
              ),
              UiUtils.addVerticalSpaceS(),
              Text(
                'Prescribed exercises',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.padding12,
              vertical: AppDimens.padding8,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppDimens.radius36),
            ),
            child: Text(
              '${program.days.length} sessions',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
      UiUtils.addVerticalSpaceM(),
      ...program.days.asMap().entries.map(
        (entry) => _buildDay(entry.key, entry.value),
      ),
    ],
  );

  Widget _buildDay(int index, ProgramDay day) {
    final expanded = _expandedDay == index;
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.padding12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radius8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expandedDay = expanded ? -1 : index),
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.padding16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: Text(
                      '${day.dayNumber}',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  UiUtils.addHorizontalSpaceM(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Day ${day.dayNumber}',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          day.dayName,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.all(AppDimens.padding12),
              child: Column(
                children: day.exercises.map(_buildExercise).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExercise(ProgramExercise exercise) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: AppDimens.padding12),
    padding: const EdgeInsets.all(AppDimens.padding12),
    decoration: BoxDecoration(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(AppDimens.radius8),
      border: Border.all(color: AppColors.textHint.withValues(alpha: 0.15)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${exercise.exerciseOrder}. ${exercise.exerciseName}',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        UiUtils.addVerticalSpaceS(),
        Text(
          '${exercise.targetSets} sets • ${exercise.minReps}-${exercise.maxReps} reps',
          style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
        ),
      ],
    ),
  );
}
