import 'package:flutter/material.dart';

import '../../../../../core/constants/app/app_dimens.dart';
import '../../../../../core/constants/app/app_strings.dart';
import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/theme/app_text_styles.dart';
import '../../../domain/entity/log_exercise.dart';
import '../../../domain/entity/training_day.dart';
import '../../../domain/entity/training_week.dart';

class TrainingBlockContent extends StatefulWidget {
  final TrainingWeek week;

  const TrainingBlockContent({super.key, required this.week});

  @override
  State<TrainingBlockContent> createState() => _TrainingBlockContentState();
}

class _TrainingBlockContentState extends State<TrainingBlockContent> {
  late Map<String, List<List<TextEditingController>>> weightControllers;
  late Map<String, List<List<TextEditingController>>> repsControllers;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    weightControllers = {};
    repsControllers = {};

    for (var day in widget.week.days) {
      final key = '${widget.week.weekNo}_${day.dayNumber}';

      weightControllers[key] = [];
      repsControllers[key] = [];

      for (var exercise in day.exercises) {
        weightControllers[key]!.add(
          List.generate(exercise.sets, (i) => TextEditingController()),
        );
        repsControllers[key]!.add(
          List.generate(exercise.sets, (i) => TextEditingController()),
        );
      }
    }
  }

  @override
  void dispose() {
    void disposeControllers(
      Map<String, List<List<TextEditingController>>> controllers,
    ) {
      for (var dayControllers in controllers.values) {
        for (var row in dayControllers) {
          for (var c in row) {
            c.dispose();
          }
        }
      }
    }

    disposeControllers(weightControllers);
    disposeControllers(repsControllers);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.padding4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.week.days.map(_buildDaySection).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDaySection(TrainingDay day) {
    final logExercises = day.logExercises;
    final maxSets = day.exercises.fold(
      0,
      (max, ex) => ex.sets > max ? ex.sets : max,
    );

    Map<int, TableColumnWidth> columnWidths = {
      0: const FixedColumnWidth(200),
      1: const FixedColumnWidth(60),
      2: const FixedColumnWidth(60),
      for (int i = 0; i < maxSets; i++) 3 + i * 2: const FixedColumnWidth(70),
      for (int i = 0; i < maxSets; i++)
        3 + i * 2 + 1: const FixedColumnWidth(70),
    };

    TableRow buildHeader() {
      return TableRow(
        decoration: BoxDecoration(color: AppColors.surfaceLight),
        children: [
          tableCell("EXERCISES"),
          tableCell("SETS"),
          tableCell("REPS"),
          ...List.generate(maxSets, (i) => tableCell("SET ${i + 1} (WEIGHT)")),
          ...List.generate(maxSets, (i) => tableCell("SET ${i + 1} (REPS)")),
        ],
      );
    }

    List<Widget> buildCells(LogExercise logExercise, int exIndex) {
      List<Widget> cells = [
        tableCell(logExercise.exercise.name),
        tableCell(logExercise.exercise.sets.toString()),
        tableCell(logExercise.exercise.repRange),
      ];

      final key = '${widget.week.weekNo}_${day.dayNumber}';

      for (int i = 0; i < maxSets; i++) {
        cells.add(
          i < logExercise.exercise.sets
              ? editableCell(weightControllers[key]![exIndex][i], hint: "kg")
              : tableCell("-"),
        );
      }

      for (int i = 0; i < maxSets; i++) {
        cells.add(
          i < logExercise.exercise.sets
              ? editableCell(repsControllers[key]![exIndex][i], hint: "reps")
              : tableCell("-"),
        );
      }

      return cells;
    }

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        collapsedIconColor: AppColors.textHint,
        iconColor: AppColors.textOnPrimary,
        title: Text(
          AppStrings.dayNoSplitTemplate(day.dayNumber, day.splitName.label),
          style: AppTextStyles.heading3.copyWith(color: AppColors.textPrimary),
        ),
        initiallyExpanded: true,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(color: Colors.grey.shade700),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: columnWidths,
              children: [
                buildHeader(),
                ...List.generate(
                  logExercises.length,
                  (exIndex) => TableRow(
                    children: buildCells(logExercises[exIndex], exIndex),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.dimen4),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget editableCell(TextEditingController controller, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.dimen2),
      child: TextField(
        cursorColor: AppColors.primary,
        controller: controller,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
          contentPadding: const EdgeInsets.all(AppDimens.dimen4),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
