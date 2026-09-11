import 'package:flutter/material.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';

class ProgressAndAnalyticsScreen extends StatelessWidget {
  const ProgressAndAnalyticsScreen({super.key});

  static const double _currentWeight = 64.35;
  static const double _startingWeight = 66.50;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.padding4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressSummary(),
          UiUtils.addVerticalSpaceL(),
          _buildWeightTrend(),
          UiUtils.addVerticalSpaceL(),
          _buildWeeklyTracking(context),
          UiUtils.addVerticalSpaceL(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Progress Summary
  // ---------------------------------------------------------------------------

  Widget _buildProgressSummary() {
    final weightChange = _currentWeight - _startingWeight;
    final percentageChange = (weightChange.abs() / _startingWeight) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppStrings.progressAndAnalytics),
        UiUtils.addVerticalSpaceS(),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Current Weight',
                value: '$_currentWeight kg',
                subtitle: 'Week 12',
                icon: Icons.monitor_weight_outlined,
              ),
            ),
            UiUtils.addHorizontalSpaceS(),
            Expanded(
              child: _buildMetricCard(
                title: 'Weight Change',
                value: '${weightChange.toStringAsFixed(2)} kg',
                subtitle: '↓ ${percentageChange.toStringAsFixed(1)}% overall',
                icon: Icons.trending_down,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.padding12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: AppDimens.dimen20, color: AppColors.textOnPrimary),
            UiUtils.addVerticalSpaceS(),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
            UiUtils.addVerticalSpaceXS(),
            Text(
              value,
              style: AppTextStyles.heading3.copyWith(
                fontSize: AppDimens.textSize18,
              ),
            ),
            UiUtils.addVerticalSpaceXS(),
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(color: AppColors.success),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Weight Trend
  // ---------------------------------------------------------------------------

  Widget _buildWeightTrend() {
    return _buildSectionCard(
      title: 'Weight Trend',
      icon: Icons.show_chart,
      children: [
        SizedBox(
          height: AppDimens.dimen180,
          child: CustomPaint(
            painter: _WeightChartPainter(
              weights: const [
                66.50,
                66.10,
                65.90,
                65.60,
                65.30,
                65.10,
                64.90,
                64.70,
                64.60,
                64.50,
                64.45,
                64.35,
              ],
            ),
            child: const SizedBox.expand(),
          ),
        ),
        UiUtils.addVerticalSpaceS(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildChartLabel('Week 1'),
            _buildChartLabel('Week 4'),
            _buildChartLabel('Week 8'),
            _buildChartLabel('Week 12'),
          ],
        ),
      ],
    );
  }

  Widget _buildChartLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
    );
  }

  // ---------------------------------------------------------------------------
  // Weekly Tracking
  // ---------------------------------------------------------------------------

  Widget _buildWeeklyTracking(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Weekly Tracking'),
        UiUtils.addVerticalSpaceS(),
        ...List.generate(12, (index) {
          final weekNumber = 12 - index;

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == 11 ? 0 : AppDimens.padding8,
            ),
            child: _buildWeekDropdown(
              context,
              weekNumber: weekNumber,
              initiallyExpanded: weekNumber == 12,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildWeekDropdown(
    BuildContext context, {
    required int weekNumber,
    required bool initiallyExpanded,
  }) {
    final weeklyAverage = _getWeeklyAverage(weekNumber);
    final weeklyRate = _getWeeklyRate(weekNumber);

    return Card(
      color: AppColors.surfaceLight,
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.padding12,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppDimens.padding12,
            0,
            AppDimens.padding12,
            AppDimens.padding12,
          ),
          iconColor: AppColors.textOnPrimary,
          collapsedIconColor: AppColors.textHint,
          title: _buildWeekHeader(
            weekNumber: weekNumber,
            weeklyAverage: weeklyAverage,
            weeklyRate: weeklyRate,
          ),
          children: [_buildWeekDetails(context, weekNumber)],
        ),
      ),
    );
  }

  Widget _buildWeekHeader({
    required int weekNumber,
    required double weeklyAverage,
    required double weeklyRate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.padding8,
                vertical: AppDimens.padding4,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radius8),
              ),
              child: Text(
                'W$weekNumber',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            UiUtils.addHorizontalSpaceS(),
            Expanded(
              child: Text(
                _getWeekDateRange(weekNumber),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ),
          ],
        ),
        UiUtils.addVerticalSpaceS(),
        Row(
          children: [
            Expanded(
              child: _buildWeekSummaryItem(
                label: 'Weekly Avg',
                value: '${weeklyAverage.toStringAsFixed(2)} kg',
              ),
            ),
            Expanded(
              child: _buildWeekSummaryItem(
                label: 'Weekly Rate',
                value: weeklyRate == 0
                    ? '—'
                    : '${weeklyRate > 0 ? '+' : ''}${weeklyRate.toStringAsFixed(2)}%',
                valueColor: weeklyRate <= 0
                    ? AppColors.success
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekSummaryItem({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
        ),
        UiUtils.addVerticalSpaceXS(),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Daily Weight Entries
  // ---------------------------------------------------------------------------

  Widget _buildWeekDetails(BuildContext context, int weekNumber) {
    return Column(
      children: [
        Divider(height: 1, color: AppColors.textHint.withValues(alpha: 0.15)),
        UiUtils.addVerticalSpaceS(),
        ...List.generate(
          7,
          (dayIndex) =>
              _buildDailyWeightRow(weekNumber: weekNumber, dayIndex: dayIndex),
        ),
        UiUtils.addVerticalSpaceS(),
        _buildCheckInButton(context, weekNumber),
      ],
    );
  }

  Widget _buildDailyWeightRow({
    required int weekNumber,
    required int dayIndex,
  }) {
    final date = _getDailyDate(weekNumber, dayIndex);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.padding8),
      child: Row(
        children: [
          SizedBox(
            width: AppDimens.dimen90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDayName(dayIndex),
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                UiUtils.addVerticalSpaceXS(),
                Text(
                  date,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          UiUtils.addHorizontalSpaceS(),
          Expanded(
            child: _buildWeightInput(
              initialValue: _getDailyWeight(weekNumber, dayIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightInput({required double initialValue}) {
    return Container(
      height: AppDimens.dimen44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radius8),
      ),
      child: TextField(
        controller: TextEditingController(
          text: initialValue.toStringAsFixed(2),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.right,
        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          suffixText: 'kg',
          suffixStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.padding12,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Check-in
  // ---------------------------------------------------------------------------

  Widget _buildCheckInButton(BuildContext context, int weekNumber) {
    return InkWell(
      onTap: () => _showCheckInDialog(context, weekNumber),
      borderRadius: BorderRadius.circular(AppDimens.radius8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.padding12,
          vertical: AppDimens.padding12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radius8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: AppDimens.dimen18,
              color: AppColors.info,
            ),
            UiUtils.addHorizontalSpaceS(),
            Text(
              'View Check-in',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.info,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Check-in Dialog
  // ---------------------------------------------------------------------------

  void _showCheckInDialog(BuildContext context, int weekNumber) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.dimen20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.dimen20),
            child: Container(
              color: AppColors.surfaceLight,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.padding12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Week $weekNumber Check-in',
                            style: AppTextStyles.heading3,
                          ),
                        ),
                        IconButton(
                          onPressed: () => NavigationUtils.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    UiUtils.addVerticalSpaceS(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimens.dimen15),
                      child: Image.asset(
                        'assets/images/before1.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: AppDimens.dimen300,
                      ),
                    ),
                    UiUtils.addVerticalSpaceL(),
                    _buildDialogInfo(
                      'Weight',
                      '${_getWeight(weekNumber).toStringAsFixed(2)} kg',
                    ),
                    _buildDialogInfo('Check-in', _getWeekDateRange(weekNumber)),
                    _buildDialogInfo('Status', 'Submitted'),
                    UiUtils.addVerticalSpaceL(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Compare check-ins.
                            },
                            icon: const Icon(Icons.compare),
                            label: Text(AppStrings.compare),
                          ),
                        ),
                        UiUtils.addHorizontalSpaceS(),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => NavigationUtils.pop(context),
                            child: Text(AppStrings.close),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.padding4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared UI
  // ---------------------------------------------------------------------------

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTextStyles.heading3.copyWith(fontSize: AppDimens.textSize16),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      color: AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: AppDimens.dimen20,
                  color: AppColors.textOnPrimary,
                ),
                UiUtils.addHorizontalSpaceS(),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.heading3.copyWith(
                      fontSize: AppDimens.textSize16,
                    ),
                  ),
                ),
              ],
            ),
            UiUtils.addVerticalSpaceL(),
            ...children,
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Mock Data
  // ---------------------------------------------------------------------------

  double _getWeight(int week) {
    const weights = [
      66.50,
      66.10,
      65.90,
      65.60,
      65.30,
      65.10,
      64.90,
      64.70,
      64.60,
      64.50,
      64.45,
      64.35,
    ];

    return weights[week - 1];
  }

  double _getWeeklyAverage(int week) {
    const averages = [
      66.50,
      66.10,
      65.90,
      65.60,
      65.30,
      65.10,
      64.90,
      64.70,
      64.60,
      64.50,
      64.45,
      64.35,
    ];

    return averages[week - 1];
  }

  double _getWeeklyRate(int week) {
    if (week == 1) return 0;

    final current = _getWeeklyAverage(week);
    final previous = _getWeeklyAverage(week - 1);

    return ((current - previous) / previous) * 100;
  }

  double _getDailyWeight(int week, int day) {
    final weeklyWeight = _getWeight(week);

    const offsets = [0.35, 0.20, 0.10, 0.00, -0.10, -0.20, -0.05];

    return weeklyWeight + offsets[day];
  }

  String _getWeekDateRange(int week) {
    final start = DateTime(2025, 10, 13).add(Duration(days: (week - 1) * 7));

    final end = start.add(const Duration(days: 6));

    return '${_monthName(start.month)} ${start.day} – '
        '${_monthName(end.month)} ${end.day}';
  }

  String _getDailyDate(int week, int day) {
    final date = DateTime(
      2025,
      10,
      13,
    ).add(Duration(days: ((week - 1) * 7) + day));

    return '${_monthName(date.month)} ${date.day}';
  }

  String _getDayName(int day) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[day];
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month];
  }
}

// -----------------------------------------------------------------------------
// Weight Chart
// -----------------------------------------------------------------------------

class _WeightChartPainter extends CustomPainter {
  final List<double> weights;

  _WeightChartPainter({required this.weights});

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.isEmpty) return;

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final minWeight = weights.reduce((a, b) => a < b ? a : b);

    final maxWeight = weights.reduce((a, b) => a > b ? a : b);

    final range = (maxWeight - minWeight) == 0 ? 1 : maxWeight - minWeight;

    const horizontalPadding = 8.0;
    const verticalPadding = 12.0;

    final points = <Offset>[];

    for (var i = 0; i < weights.length; i++) {
      final x =
          horizontalPadding +
          (i / (weights.length - 1)) * (size.width - horizontalPadding * 2);

      final normalized = (weights[i] - minWeight) / range;

      final y =
          size.height -
          verticalPadding -
          normalized * (size.height - verticalPadding * 2);

      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, linePaint);

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WeightChartPainter oldDelegate) {
    return oldDelegate.weights != weights;
  }
}
