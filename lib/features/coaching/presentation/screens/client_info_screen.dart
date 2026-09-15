import 'package:flutter/material.dart';
import 'package:pump/core/app_routes.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/coaching/data/enums/coaching_status.dart';
import 'package:pump/features/coaching/domain/entity/client_user.dart';
import 'package:pump/features/coaching/enums/client_overview_tab.dart';

class ClientInfoScreen extends StatelessWidget {
  final ClientUser client;
  final ValueChanged<ClientOverviewTab>? onNavigateToTab;

  /// Temporary UI state.
  ///
  /// This will eventually come from the client's coaching data.
  final bool hasTrainingBlock;

  const ClientInfoScreen({
    super.key,
    required this.client,
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
          _buildProfileCard(client),

          UiUtils.addVerticalSpaceL(),

          _buildPhysicalStats(client),

          UiUtils.addVerticalSpaceL(),

          _buildFitnessInfo(client),

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

          if (!hasTrainingBlock)
            _buildCreateTrainingBlockButton(context, client),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------

  Widget _buildProfileCard(ClientUser client) {
    final name = '${client.firstName} ${client.lastName}'.trim();

    final isActive = client.coachingStatus == CoachingStatus.active;

    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.padding16),
        child: Row(
          children: [
            _buildProfileAvatar(
              name: name,
              profileImageUrl: client.profileImageUrl,
            ),

            UiUtils.addHorizontalSpaceL(),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.heading3.copyWith(
                      fontSize: AppDimens.textSize18,
                    ),
                  ),

                  UiUtils.addVerticalSpaceXS(),

                  Text(
                    '${client.age} years old • ${client.gender.value}',
                    style: AppTextStyles.bodySmall,
                  ),

                  UiUtils.addVerticalSpaceXS(),

                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: AppDimens.dimen8,
                        color: isActive ? AppColors.success : AppColors.error,
                      ),

                      UiUtils.addHorizontalSpaceXS(),

                      Text(
                        client.coachingStatus.value,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isActive ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar({
    required String name,
    required String profileImageUrl,
  }) {
    if (profileImageUrl.isEmpty) {
      return CircleAvatar(
        radius: AppDimens.radius36,
        backgroundColor: AppColors.primary.withValues(
          alpha: AppDimens.alpha0_12,
        ),
        child: Text(
          name.isEmpty ? '?' : name[0],
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: AppDimens.radius36,
      backgroundImage: NetworkImage(profileImageUrl),
    );
  }

  // ---------------------------------------------------------------------------
  // Physical Stats
  // ---------------------------------------------------------------------------

  Widget _buildPhysicalStats(ClientUser client) {
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
              value: '${client.heightCm.toStringAsFixed(0)} cm',
              icon: Icons.height,
            ),
            _buildStatCard(
              label: AppStrings.weight,
              value: '${client.currentWeight.toStringAsFixed(2)} kg',
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

  Widget _buildFitnessInfo(ClientUser client) {
    return _buildSectionCard(
      title: 'Fitness Info',
      icon: Icons.track_changes_outlined,
      children: [
        _buildInfoRow(
          label: 'Weight Goal',
          value: '${client.goalWeight.toStringAsFixed(0)} kg',
        ),

        _buildDivider(),

        _buildInfoRow(label: 'Fitness Goal', value: client.fitnessGoal.value),

        _buildDivider(),

        _buildInfoRow(
          label: 'Activity Level',
          value: client.activityLevel.value,
        ),

        if (hasTrainingBlock) ...[
          _buildDivider(),

          // TODO: Replace with training block data.
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
        // TODO: Replace with training block data.
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
        // TODO: Replace with training block nutrition data.
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
        // TODO: Replace with check-in data.
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
        // TODO: Replace with coaching data.
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
        // TODO: Replace with coaching data.
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

  // ---------------------------------------------------------------------------
  // Create Training Block
  // ---------------------------------------------------------------------------

  Widget _buildCreateTrainingBlockButton(
    BuildContext context,
    ClientUser client,
  ) {
    final name = '${client.firstName} ${client.lastName}'.trim();

    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        onPressed: () {
          NavigationUtils.navigateTo(
            context,
            AppRoutes.createTrainingBlock,
            arguments: {
              'clientName': name,
              'clientAge': client.age,
              'clientGender': client.gender.value,
              'clientHeight': client.heightCm,
              'clientCurrentWeight': client.currentWeight,
              'clientGoalWeight': client.goalWeight,
              'clientFitnessGoal': client.fitnessGoal.value,
            },
          );
        },
        label: 'Create Training Block',
      ),
    );
  }
}
