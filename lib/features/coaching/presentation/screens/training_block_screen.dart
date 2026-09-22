import 'package:flutter/material.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/coaching/data/enums/training_split.dart';
import 'package:pump/features/coaching/domain/entity/exercise.dart';
import 'package:pump/features/coaching/domain/entity/log_exercise.dart';
import 'package:pump/features/coaching/domain/entity/training_day.dart';
import 'package:pump/features/coaching/domain/entity/training_plan.dart';
import 'package:pump/features/coaching/domain/entity/training_week.dart';

class TrainingBlockScreen extends StatefulWidget {
  const TrainingBlockScreen({super.key});

  @override
  State<TrainingBlockScreen> createState() => _TrainingBlockScreenState();
}

class _TrainingBlockScreenState extends State<TrainingBlockScreen> {
  late final TrainingPlan trainingPlan;

  int _selectedWeek = 1;
  int _expandedDay = 0;

  @override
  void initState() {
    super.initState();
    trainingPlan = _createTrainingPlan();
  }

  @override
  Widget build(BuildContext context) {
    final week = trainingPlan.weeks[_selectedWeek];

    return Column(
      children: [
        _buildTrainingPlanHeader(),
        UiUtils.addVerticalSpaceM(),
        _buildWeekSelector(),
        UiUtils.addVerticalSpaceM(),
        Expanded(child: _buildWeekContent(week)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildTrainingPlanHeader() {
    return Container(
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
            trainingPlan.planName,
            style: AppTextStyles.heading3.copyWith(
              fontSize: AppDimens.textSize18,
            ),
          ),
          UiUtils.addVerticalSpaceS(),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: AppDimens.dimen18,
                color: AppColors.textHint,
              ),
              UiUtils.addHorizontalSpaceS(),
              Text(
                '${trainingPlan.noOfWeeks} weeks',
                style: AppTextStyles.bodySmall,
              ),
              UiUtils.addHorizontalSpaceM(),
              Icon(
                Icons.fitness_center_outlined,
                size: AppDimens.dimen18,
                color: AppColors.textHint,
              ),
              UiUtils.addHorizontalSpaceS(),
              Text(
                '${trainingPlan.noOfDaysPerWeek} days / week',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          UiUtils.addVerticalSpaceS(),
          Text(
            trainingPlan.splits.map((split) => split.label).join(' • '),
            style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WEEK SELECTOR
  // ---------------------------------------------------------------------------

  Widget _buildWeekSelector() {
    return SizedBox(
      height: AppDimens.dimen44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trainingPlan.noOfWeeks,
        separatorBuilder: (_, __) => UiUtils.addHorizontalSpaceS(),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedWeek;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedWeek = index;
                _expandedDay = 0;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.padding16,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radius36),
              ),
              child: Text(
                AppStrings.weekNoTemplate(index + 1),
                style: AppTextStyles.button.copyWith(
                  fontSize: AppDimens.textSize14,
                  color: isSelected
                      ? AppColors.textOnPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WEEK CONTENT
  // ---------------------------------------------------------------------------

  Widget _buildWeekContent(TrainingWeek week) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppDimens.padding16),
      children: [
        _buildWeekHeader(week),
        UiUtils.addVerticalSpaceM(),
        ...week.days.asMap().entries.map(
          (entry) => _buildTrainingDay(entry.key, entry.value),
        ),
      ],
    );
  }

  Widget _buildWeekHeader(TrainingWeek week) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Week ${week.weekNo}',
              style: AppTextStyles.heading3.copyWith(
                fontSize: AppDimens.textSize18,
              ),
            ),
            UiUtils.addVerticalSpaceS(),
            Text(
              'Training performance',
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.fitness_center_outlined,
                size: AppDimens.dimen18,
                color: AppColors.textHint,
              ),
              UiUtils.addHorizontalSpaceS(),
              Text(
                '${week.days.length} sessions',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TRAINING DAY
  // ---------------------------------------------------------------------------

  Widget _buildTrainingDay(int index, TrainingDay day) {
    final isExpanded = _expandedDay == index;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.padding12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radius8),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppDimens.radius8),
            onTap: () {
              setState(() {
                _expandedDay = isExpanded ? -1 : index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.padding16),
              child: Row(
                children: [
                  Container(
                    width: AppDimens.dimen44,
                    height: AppDimens.dimen44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppDimens.radius8),
                    ),
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
                        UiUtils.addVerticalSpaceS(),
                        Text(
                          day.splitName.label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Padding(
              padding: const EdgeInsets.all(AppDimens.padding12),
              child: Column(
                children: day.exercises.map((exercise) {
                  return _buildExerciseCard(exercise, day);
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EXERCISE CARD
  // ---------------------------------------------------------------------------

  Widget _buildExerciseCard(Exercise exercise, TrainingDay day) {
    return Container(
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
          _buildExerciseHeader(exercise),
          UiUtils.addVerticalSpaceM(),
          _buildSetHeader(),
          UiUtils.addVerticalSpaceS(),
          ...List.generate(
            exercise.sets,
            (setIndex) => _buildSetRow(setIndex: setIndex, exercise: exercise),
          ),
          UiUtils.addVerticalSpaceS(),
          _buildPreviousPerformance(exercise),
        ],
      ),
    );
  }

  Widget _buildExerciseHeader(Exercise exercise) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              UiUtils.addVerticalSpaceS(),
              Text(
                '${exercise.sets} sets • ${exercise.repRange} reps',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.padding8,
            vertical: AppDimens.padding4,
          ),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimens.radius36),
          ),
          child: Text(
            'TRACK',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SET TABLE
  // ---------------------------------------------------------------------------

  Widget _buildSetHeader() {
    return Row(
      children: [
        SizedBox(
          width: AppDimens.dimen44,
          child: Text(
            'SET',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        UiUtils.addHorizontalSpaceS(),

        Expanded(
          child: Text(
            'REPS',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        UiUtils.addHorizontalSpaceS(),

        Expanded(
          child: Text(
            'WEIGHT',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSetRow({required int setIndex, required Exercise exercise}) {
    final reps = _mockReps(setIndex, exercise);
    final weight = _mockWeight(setIndex, exercise);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.padding8),
      child: Row(
        children: [
          SizedBox(
            width: AppDimens.dimen44,
            child: Container(
              width: AppDimens.dimen32,
              height: AppDimens.dimen32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radius8),
              ),
              child: Text(
                '${setIndex + 1}',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Gap between SET and REPS
          UiUtils.addHorizontalSpaceS(),

          Expanded(
            child: _buildInputField(value: '$reps', suffix: 'reps'),
          ),

          // Gap between REPS and WEIGHT
          UiUtils.addHorizontalSpaceS(),

          Expanded(
            child: _buildInputField(value: '$weight', suffix: 'kg'),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({required String value, required String suffix}) {
    return SizedBox(
      height: AppDimens.dimen44,
      child: TextFormField(
        initialValue: value,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface,
          suffixText: suffix,
          suffixStyle: AppTextStyles.caption.copyWith(
            color: AppColors.textHint,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.padding8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PREVIOUS PERFORMANCE
  // ---------------------------------------------------------------------------

  Widget _buildPreviousPerformance(Exercise exercise) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.padding8),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimens.radius8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.history,
            size: AppDimens.dimen18,
            color: AppColors.success,
          ),
          UiUtils.addHorizontalSpaceS(),
          Expanded(
            child: Text(
              'Previous session: ${_previousWeight(exercise)} kg × ${_previousReps(exercise)} reps',
              style: AppTextStyles.caption.copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MOCK DATA FOR UI
  // ---------------------------------------------------------------------------

  int _mockReps(int setIndex, Exercise exercise) {
    final ranges = exercise.repRange.split('-');

    if (ranges.length == 2) {
      final min = int.tryParse(ranges[0]) ?? 8;
      return min + (setIndex % 3);
    }

    return int.tryParse(ranges.first) ?? 10;
  }

  double _mockWeight(int setIndex, Exercise exercise) {
    final base = exercise.name.hashCode.abs() % 40 + 40;

    return base + (setIndex * 2.5);
  }

  double _previousWeight(Exercise exercise) {
    return (exercise.name.hashCode.abs() % 40 + 40).toDouble();
  }

  int _previousReps(Exercise exercise) {
    final ranges = exercise.repRange.split('-');

    return int.tryParse(ranges.first) ?? 8;
  }

  // ---------------------------------------------------------------------------
  // EXISTING MOCK TRAINING DATA
  // ---------------------------------------------------------------------------

  TrainingPlan _createTrainingPlan() {
    final trainingPlan = TrainingPlan(
      planName: 'PPL-Full Body 4-Day Split',
      splits: [
        TrainingSplit.pull,
        TrainingSplit.legs,
        TrainingSplit.push,
        TrainingSplit.rest,
        TrainingSplit.fullBody,
      ],
      noOfDaysPerWeek: 4,
      noOfWeeks: 12,
      weeks: [],
      trainingDays: [
        TrainingDay(
          dayNumber: 1,
          splitName: TrainingSplit.pull,
          exercises: [
            Exercise(
              name: 'Chest Supported Upperback Rows',
              sets: 3,
              repRange: '8-10',
            ),
            Exercise(name: 'Upperback Pulldown', sets: 3, repRange: '8-10'),
            Exercise(name: 'Single Arm Cable Rows', sets: 3, repRange: '10-12'),
          ],
          logExercises: [],
        ),
        TrainingDay(
          dayNumber: 2,
          splitName: TrainingSplit.legs,
          exercises: [
            Exercise(name: 'Leg Curls', sets: 3, repRange: '10-12'),
            Exercise(name: 'Leg Press', sets: 3, repRange: '8-10'),
            Exercise(name: 'Leg Extensions', sets: 3, repRange: '10-12'),
          ],
          logExercises: [],
        ),
        TrainingDay(
          dayNumber: 3,
          splitName: TrainingSplit.push,
          exercises: [
            Exercise(
              name: 'Smith Machine Incline Press',
              sets: 3,
              repRange: '8-10',
            ),
            Exercise(name: 'Machine Chest Press', sets: 3, repRange: '8-10'),
            Exercise(name: 'Machine Chest Flies', sets: 3, repRange: '10-12'),
          ],
          logExercises: [],
        ),
        TrainingDay(
          dayNumber: 4,
          splitName: TrainingSplit.fullBody,
          exercises: [
            Exercise(name: 'Leg Press', sets: 3, repRange: '8-10'),
            Exercise(name: 'Machine Chest Press', sets: 3, repRange: '8-10'),
            Exercise(name: 'Upperback Rows', sets: 3, repRange: '10-12'),
          ],
          logExercises: [],
        ),
      ],
    );

    for (int i = 0; i < trainingPlan.noOfWeeks; i++) {
      trainingPlan.weeks.add(
        TrainingWeek(
          date: DateTime.timestamp(),
          weekNo: i + 1,
          days: trainingPlan.trainingDays.map((day) {
            return TrainingDay(
              dayNumber: day.dayNumber,
              splitName: day.splitName,
              exercises: day.exercises
                  .map(
                    (ex) => Exercise(
                      name: ex.name,
                      sets: ex.sets,
                      repRange: ex.repRange,
                    ),
                  )
                  .toList(),
              logExercises: [],
            );
          }).toList(),
        ),
      );
    }

    for (int i = 0; i < trainingPlan.weeks.length; i++) {
      for (int j = 0; j < trainingPlan.weeks[i].days.length; j++) {
        for (
          int k = 0;
          k < trainingPlan.weeks[i].days[j].exercises.length;
          k++
        ) {
          trainingPlan.weeks[i].days[j].logExercises.add(
            LogExercise(
              exercise: trainingPlan.weeks[i].days[j].exercises[k],
              reps: [],
              weights: [],
            ),
          );
        }
      }
    }

    return trainingPlan;
  }
}
