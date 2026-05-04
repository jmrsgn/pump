import 'package:flutter/material.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/utils/date_time_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';

import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/utils/navigation_utils.dart';

class ProgressAndAnalyticsScreen extends StatelessWidget {
  const ProgressAndAnalyticsScreen({super.key});

  final int totalWeeks = 12;
  final int totalDaysAWeek = 7;

  @override
  Widget build(BuildContext context) {
    final weeks = DateTimeUtils.generateWeeks(
      DateTime(2025, 10, 13),
      totalWeeks,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            _buildHeaderRow(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildAllDataColumns(context, weeks),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header
  Widget _buildHeaderRow() {
    return Container(
      color: AppColors.primary,
      child: Row(
        children: [
          _tableCell(
            text: AppStrings.week,
            isHeader: true,
            height: AppDimens.dimen40,
          ),
          _tableCell(
            text: AppStrings.date,
            isHeader: true,
            width: AppDimens.dimen180,
            height: AppDimens.dimen40,
          ),
          _tableCell(
            text: AppStrings.weightInLbs,
            isHeader: true,
            height: AppDimens.dimen40,
          ),
          _tableCell(
            text: AppStrings.weeklyAvg,
            isHeader: true,
            height: AppDimens.dimen40,
          ),
          _tableCell(
            text: AppStrings.weeklyRate,
            isHeader: true,
            height: AppDimens.dimen40,
          ),
          _tableCell(
            text: AppStrings.noteOrAdjustment,
            isHeader: true,
            width: AppDimens.dimen180,
            height: AppDimens.dimen40,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAllDataColumns(
    BuildContext context,
    List<List<DateTime>> weeks,
  ) {
    return [
      _buildWeeksColumn(context),
      _buildDatesColumn(weeks, AppDimens.dimen180),
      _buildWeightsColumn(),
      _buildWeeklyAverageWeightColumn(),
      _buildWeeklyRateColumn(),
      _buildNoteOrAdjustmentColumn(AppDimens.dimen180),
    ];
  }

  Widget _buildWeeksColumn(BuildContext context) {
    return Column(
      children: List.generate(totalWeeks, (index) {
        return GestureDetector(
          onTap: () => _showWeekDialog(context, index + 1),
          child: _tableCell(
            height: AppDimens.dimen50 * totalDaysAWeek,
            widget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (index + 1).toString(),
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                UiUtils.addVerticalSpaceS(),
                Text(
                  AppStrings.tapToViewCheckins,
                  style: AppTextStyles.caption.copyWith(color: AppColors.info),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // TODO: add to AlertDialogUtils
  void _showWeekDialog(BuildContext context, int weekNumber) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dimen20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.dimen20),
          child: Container(
            color: AppColors.surfaceLight,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.dimen14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'Week $weekNumber',
                    style: AppTextStyles.heading3,
                    textAlign: TextAlign.center,
                  ),
                  UiUtils.addVerticalSpaceL(),

                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.dimen15),
                    child: Image.asset(
                      'assets/images/before1.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: AppDimens.dimen500,
                    ),
                  ),
                  UiUtils.addVerticalSpaceL(),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Compare Button
                      TextButton.icon(
                        onPressed: () {
                          // TODO: Add Compare action
                        },
                        icon: const Icon(
                          Icons.compare,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          AppStrings.compare,
                          style: AppTextStyles.button.copyWith(
                            fontSize: AppDimens.textSize14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      UiUtils.addHorizontalSpaceL(),
                      // Close Button
                      TextButton.icon(
                        onPressed: () => NavigationUtils.pop(context),
                        icon: const Icon(Icons.close, color: AppColors.primary),
                        label: Text(
                          AppStrings.close,
                          style: AppTextStyles.button.copyWith(
                            fontSize: AppDimens.textSize14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatesColumn(List<List<DateTime>> weeks, double width) {
    return Column(
      children: List.generate(
        weeks.length,
        (weekIndex) => Column(
          children: List.generate(
            weeks[weekIndex].length,
            (dayIndex) => _tableCell(
              text: DateTimeUtils.formatFullDate(weeks[weekIndex][dayIndex]),
              height: AppDimens.dimen50,
              width: width,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightsColumn() {
    return Column(
      children: List.generate(
        totalWeeks,
        (index) => Column(
          children: List.generate(
            totalDaysAWeek,
            (dayIndex) => _editableCell(
              inputType: TextInputType.number,
              height: AppDimens.dimen50,
              hint: AppStrings.kgOrLbs,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyAverageWeightColumn() {
    return Column(
      children: List.generate(
        totalWeeks,
        (index) => _tableCell(
          text: AppStrings.noNumberInputTemplate,
          height: AppDimens.dimen50 * totalDaysAWeek,
        ),
      ),
    );
  }

  Widget _buildWeeklyRateColumn() {
    return Column(
      children: List.generate(
        totalWeeks,
        (index) => _tableCell(
          text: AppStrings.noNumberInputTemplate,
          height: AppDimens.dimen50 * totalDaysAWeek,
        ),
      ),
    );
  }

  Widget _buildNoteOrAdjustmentColumn(double width) {
    return Column(
      children: List.generate(
        totalWeeks,
        (index) => Column(
          children: List.generate(
            totalDaysAWeek,
            (dayIndex) => _editableCell(
              inputType: TextInputType.text,
              height: AppDimens.dimen50,
              width: width,
            ),
          ),
        ),
      ),
    );
  }

  Widget _tableCell({
    String? text,
    bool isHeader = false,
    double? height,
    double? width,
    Widget? widget,
  }) {
    return Container(
      height: height ?? AppDimens.dimen50,
      width: width ?? AppDimens.dimen120,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppDimens.dimen6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade700,
          width: AppDimens.dimen0_7,
        ),
      ),
      child:
          widget ??
          Text(
            text!,
            style: isHeader
                ? AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)
                : AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
    );
  }

  Widget _editableCell({
    required TextInputType inputType,
    String? hint,
    double? height,
    double? width,
  }) {
    return Container(
      height: height ?? AppDimens.dimen50,
      width: width ?? AppDimens.dimen120,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppDimens.dimen2),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade700,
          width: AppDimens.dimen0_7,
        ),
      ),
      child: TextField(
        cursorColor: AppColors.primary,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
          contentPadding: const EdgeInsets.all(AppDimens.dimen4),
          border: InputBorder.none,
          // Remove TextField's internal border
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        keyboardType: inputType,
      ),
    );
  }
}
