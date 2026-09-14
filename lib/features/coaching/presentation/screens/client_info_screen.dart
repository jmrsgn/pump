import 'package:flutter/material.dart';
import 'package:pump/core/app_routes.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/coaching/enums/client_overview_tab.dart';
import 'package:pump/features/coaching/presentation/screens/create_training_block_screen.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/features/coaching/presentation/screens/create_training_block_screen.dart';

class ClientInfoScreen extends StatelessWidget {
  final ValueChanged<ClientOverviewTab>? onNavigateToTab;

  /// Temporary UI state.
  ///
  /// This will eventually come from the client's coaching data.
  final bool hasTrainingBlock;

  const ClientInfoScreen({
    super.key,
    this.onNavigateToTab,
    this.hasTrainingBlock = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.padding4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileCard(),
          UiUtils.addVerticalSpaceL(),

          _buildPhysicalStats(),
          UiUtils.addVerticalSpaceL(),

          _buildFitnessInfo(),
          UiUtils.addVerticalSpaceL(),

          if (hasTrainingBlock) ...[
            _buildTrainingCard(),
            UiUtils.addVerticalSpaceL(),

            _buildNutritionCard(),
            UiUtils.addVerticalSpaceL(),

            _buildProgressCard(),
            UiUtils.addVerticalSpaceL(),

            _buildCoachingNotesCard(),
            UiUtils.addVerticalSpaceL(),

            _buildExtrasCard(),
            UiUtils.addVerticalSpaceL(),
          ],

          // if (!hasTrainingBlock) ...[
          //   UiUtils.addVerticalSpaceL(),
          //   _buildCreateTrainingBlockButton(context),
          // ],
          UiUtils.addVerticalSpaceL(),
          _buildCreateTrainingBlockButton(context),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------

  Widget _buildProfileCard() {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.padding16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: AppDimens.radius36,
              backgroundImage: AssetImage('assets/images/jm.jpg'),
            ),
            UiUtils.addHorizontalSpaceL(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Martin Marasigan',
                    style: AppTextStyles.heading3.copyWith(
                      fontSize: AppDimens.textSize18,
                    ),
                  ),
                  UiUtils.addVerticalSpaceXS(),
                  Text('25 years old • Male', style: AppTextStyles.bodySmall),
                  UiUtils.addVerticalSpaceXS(),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: AppColors.success),
                      UiUtils.addHorizontalSpaceXS(),
                      Text(
                        'Active',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  UiUtils.addVerticalSpaceXS(),
                  Text(
                    'Since Oct 2025',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Physical Stats
  // ---------------------------------------------------------------------------

  Widget _buildPhysicalStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(AppStrings.physicalStats),
        UiUtils.addVerticalSpaceS(),

        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: AppDimens.padding8,
          mainAxisSpacing: AppDimens.padding8,
          childAspectRatio: 1.8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatCard(
              label: AppStrings.height,
              value: '163 cm',
              icon: Icons.height,
            ),
            _buildStatCard(
              label: AppStrings.weight,
              value: '64.35 kg',
              icon: Icons.monitor_weight_outlined,
            ),
            _buildStatCard(
              label: AppStrings.bodyFat,
              value: '-',
              icon: Icons.percent,
            ),
            _buildStatCard(
              label: AppStrings.muscleMass,
              value: '-',
              icon: Icons.fitness_center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.padding12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.padding8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radius8),
              ),
              child: Icon(
                icon,
                size: AppDimens.dimen20,
                color: AppColors.textOnPrimary,
              ),
            ),
            UiUtils.addHorizontalSpaceS(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                  UiUtils.addVerticalSpaceXS(),
                  Text(
                    value,
                    style: AppTextStyles.heading3.copyWith(
                      fontSize: AppDimens.textSize16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Fitness Information
  // ---------------------------------------------------------------------------

  Widget _buildFitnessInfo() {
    return _buildSectionCard(
      title: 'Fitness Info',
      icon: Icons.track_changes_outlined,
      children: [
        _buildInfoRow(label: 'Weight Goal', value: '60 kg'),
        _buildDivider(),
        _buildInfoRow(label: 'Fitness Goal', value: 'Recomposition'),
        _buildDivider(),
        _buildInfoRow(label: 'Activity Level', value: 'Moderately Active'),
        if (hasTrainingBlock) ...[
          _buildDivider(),
          _buildInfoRow(label: 'Current Phase', value: 'Cut'),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Training
  // ---------------------------------------------------------------------------

  Widget _buildTrainingCard() {
    return _buildSectionCard(
      title: AppStrings.trainingInfo,
      icon: Icons.fitness_center,
      children: [
        _buildInfoRow(label: 'Program', value: 'Program ni Kuya O'),
        _buildDivider(),
        _buildInfoRow(label: 'Frequency', value: '4x / week'),
        _buildDivider(),
        _buildInfoRow(label: AppStrings.lastWorkout, value: 'Nov 20, 2025'),
        UiUtils.addVerticalSpaceS(),
        _buildActionTile(
          title: AppStrings.tapToViewTrainingBlock,
          icon: Icons.arrow_forward,
          onTap: () {
            onNavigateToTab?.call(ClientOverviewTab.trainingBlock);
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Nutrition
  // ---------------------------------------------------------------------------

  Widget _buildNutritionCard() {
    return _buildSectionCard(
      title: AppStrings.nutritionInfo,
      icon: Icons.restaurant_outlined,
      children: [
        Text(
          '2,583 cal',
          style: AppTextStyles.heading3.copyWith(fontSize: AppDimens.dimen22),
        ),
        UiUtils.addVerticalSpaceXS(),
        Text(
          'Daily calorie target',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
        ),
        UiUtils.addVerticalSpaceL(),
        Row(
          children: [
            Expanded(child: _buildMacroItem('Protein', '194g')),
            Expanded(child: _buildMacroItem('Carbs', '291g')),
            Expanded(child: _buildMacroItem('Fat', '72g')),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
        ),
        UiUtils.addVerticalSpaceXS(),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Progress
  // ---------------------------------------------------------------------------

  Widget _buildProgressCard() {
    return _buildSectionCard(
      title: AppStrings.progressAndAnalytics,
      icon: Icons.show_chart,
      children: [
        _buildInfoRow(label: 'Next check-in', value: 'Nov 23, 2025'),
        UiUtils.addVerticalSpaceS(),
        _buildActionTile(
          title: AppStrings.tapToViewChartsAndPhotos,
          icon: Icons.arrow_forward,
          onTap: () {
            onNavigateToTab?.call(ClientOverviewTab.progress);
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Coaching Notes
  // ---------------------------------------------------------------------------

  Widget _buildCoachingNotesCard() {
    return _buildSectionCard(
      title: AppStrings.coachingNotes,
      icon: Icons.notes_outlined,
      children: [
        _buildInfoRow(
          label: 'Last note',
          value: 'Overall size, especially chest',
        ),
        _buildDivider(),
        _buildInfoRow(label: 'Reminders', value: 'NA'),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Extras
  // ---------------------------------------------------------------------------

  Widget _buildExtrasCard() {
    return _buildSectionCard(
      title: AppStrings.extras,
      icon: Icons.more_horiz,
      children: [
        _buildInfoRow(
          label: 'Supplements',
          value: 'Whey Protein, Creatine, Pre-workout',
        ),
        _buildDivider(),
        _buildInfoRow(label: 'Injuries', value: 'Neck'),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Shared Components
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
      color: AppColors.surface,
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

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radius8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.padding12,
          vertical: AppDimens.padding12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimens.radius8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(icon, size: AppDimens.dimen18, color: AppColors.info),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.padding8),
      child: Divider(
        height: 1,
        color: AppColors.textHint.withValues(alpha: 0.15),
      ),
    );
  }

  Widget _buildCreateTrainingBlockButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        onPressed: () {
          NavigationUtils.navigateTo(
            context,
            AppRoutes.createTrainingBlock,
            arguments: {
              'clientName': "John Martin Marasigan",
              'clientAge': 25,
              'clientGender': "Male",
              'clientHeight': 163.0,
              'clientCurrentWeight': 64.35,
              'clientGoalWeight': 60.0,
              'clientFitnessGoal': "Recomposition",
            },
          );
        },
        label: 'Create Training Block',
      ),
    );
  }
}
