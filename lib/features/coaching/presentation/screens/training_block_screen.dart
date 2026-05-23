import 'package:flutter/material.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/coaching/enums/training_split.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../domain/entity/exercise.dart';
import '../../domain/entity/log_exercise.dart';
import '../../domain/entity/training_day.dart';
import '../../domain/entity/training_plan.dart';
import '../../domain/entity/training_week.dart';
import '../widgets/training_block/training_block_content.dart';

class TrainingBlockScreen extends StatelessWidget {
  const TrainingBlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TrainingPlan trainingPlan = _createTrainingPlan();

    return DefaultTabController(
      length: trainingPlan.noOfWeeks,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textHint,
              tabs: List.generate(
                trainingPlan.noOfWeeks,
                (i) => Tab(text: AppStrings.weekNoTemplate(i + 1)),
              ),
            ),
          ),

          UiUtils.addVerticalSpaceL(),

          Expanded(
            child: Column(
              children: [
                Text(
                  trainingPlan.planName,
                  style: AppTextStyles.heading3.copyWith(
                    fontSize: AppDimens.textSize18,
                  ),
                ),
                UiUtils.addVerticalSpaceS(),
                Text(
                  trainingPlan.splits.map((s) => s.label).join(" • "),
                  style: AppTextStyles.bodySmall,
                ),
                UiUtils.addVerticalSpaceL(),
                Expanded(
                  child: TabBarView(
                    children: List.generate(
                      trainingPlan.noOfWeeks,
                      (i) => TrainingBlockContent(week: trainingPlan.weeks[i]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
              name: "Chest Supported Upperback Rows",
              sets: 3,
              repRange: "8-10",
            ),
            Exercise(name: "Upperback Pulldown", sets: 3, repRange: "8-10"),
            Exercise(name: "Single Arm Cable Rows", sets: 3, repRange: "10-12"),
          ],
          logExercises: [],
        ),
        TrainingDay(
          dayNumber: 2,
          splitName: TrainingSplit.legs,
          exercises: [
            Exercise(name: "Leg Curls", sets: 3, repRange: "10-12"),
            Exercise(name: "Leg Press", sets: 3, repRange: "8-10"),
            Exercise(name: "Leg Extensions", sets: 3, repRange: "10-12"),
          ],
          logExercises: [],
        ),
        TrainingDay(
          dayNumber: 3,
          splitName: TrainingSplit.push,
          exercises: [
            Exercise(
              name: "Smith Machine Incline Press",
              sets: 3,
              repRange: "8-10",
            ),
            Exercise(name: "Machine Chest Press", sets: 3, repRange: "8-10"),
            Exercise(name: "Machine Chest Flies", sets: 3, repRange: "10-12"),
          ],
          logExercises: [],
        ),
        TrainingDay(
          dayNumber: 4,
          splitName: TrainingSplit.fullBody,
          exercises: [
            Exercise(name: "Leg Press", sets: 3, repRange: "8-10"),
            Exercise(name: "Machine Chest Press", sets: 3, repRange: "8-10"),
            Exercise(name: "Upperback Rows", sets: 3, repRange: "10-12"),
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

    // Log exercises, where user can input
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
