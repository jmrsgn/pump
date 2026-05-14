import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/app_constants.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/custom_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: AppStrings.about,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.dimen16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),

            UiUtils.addVerticalSpaceXL(),

            _buildStatsSection(),

            UiUtils.addVerticalSpaceXL(),

            _buildSection(
              title: AppStrings.whatIsPump,
              icon: Icons.favorite_outline,
              description: AppStrings.pumpDescription,
            ),

            UiUtils.addVerticalSpaceXL(),

            _buildFeaturesSection(),

            UiUtils.addVerticalSpaceXL(),

            _buildWorkflowSection(),

            UiUtils.addVerticalSpaceXL(),

            _buildVisionSection(),

            UiUtils.addVerticalSpaceXL(),

            _buildDeveloperCard(),

            UiUtils.addVerticalSpaceXL(),

            _buildConnectSection(),

            UiUtils.addVerticalSpaceXL(),

            Center(child: UiUtils.addCopyright()),

            UiUtils.addVerticalSpaceL(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.dimen24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.dimen16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              AppConstants.appName[0],
              style: AppTextStyles.heading1.copyWith(color: AppColors.primary),
            ),
          ),

          UiUtils.addVerticalSpaceM(),

          Text(AppConstants.appName, style: AppTextStyles.heading1),

          UiUtils.addVerticalSpaceS(),

          Text(
            AppStrings.pumpSubDescription,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          UiUtils.addVerticalSpaceM(),

          Wrap(
            spacing: AppDimens.dimen8,
            runSpacing: AppDimens.dimen8,
            alignment: WrapAlignment.center,
            children: [
              _buildHighlightChip(AppStrings.nutrition),
              _buildHighlightChip(AppStrings.coaching),
              _buildHighlightChip(AppStrings.checkIns),
              _buildHighlightChip(AppStrings.programs),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: AppStrings.programs,
            subtitle: AppStrings.managed,
          ),
        ),

        UiUtils.addHorizontalSpaceS(),

        Expanded(
          child: _buildStatCard(
            title: AppStrings.coach,
            subtitle: AppStrings.focused,
          ),
        ),

        UiUtils.addHorizontalSpaceS(),

        Expanded(
          child: _buildStatCard(
            title: AppStrings.client,
            subtitle: AppStrings.centered,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.dimen16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          UiUtils.addVerticalSpaceXS(),
          Text(
            subtitle,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.coreFeatures, style: AppTextStyles.heading2),

        UiUtils.addVerticalSpaceM(),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppDimens.dimen12,
          mainAxisSpacing: AppDimens.dimen12,
          childAspectRatio: 1.1,
          children: [
            _buildFeatureCard(
              icon: Icons.restaurant_menu,
              title: AppStrings.nutrition,
              subtitle: AppStrings.nutritionFeature,
            ),
            _buildFeatureCard(
              icon: Icons.fitness_center,
              title: AppStrings.programs,
              subtitle: AppStrings.programsFeature,
            ),
            _buildFeatureCard(
              icon: Icons.analytics_outlined,
              title: AppStrings.checkIns,
              subtitle: AppStrings.checkInsFeature,
            ),
            _buildFeatureCard(
              icon: Icons.groups_outlined,
              title: AppStrings.coaching,
              subtitle: AppStrings.coachingFeature,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.dimen16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),

          UiUtils.addVerticalSpaceM(),

          Text(
            title,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
          ),

          UiUtils.addVerticalSpaceXS(),

          Text(subtitle, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildWorkflowSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.dimen20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.howPumpWorks, style: AppTextStyles.heading2),

          UiUtils.addVerticalSpaceS(),

          Text(
            AppStrings.pumpWorksInfo,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          UiUtils.addVerticalSpaceXXL(),

          _buildWorkflowItem(
            icon: Icons.groups_outlined,
            title: "1. ${AppStrings.connect}",
            subtitle: AppStrings.connectWorksInfo,
          ),

          _buildWorkflowDivider(),

          _buildWorkflowItem(
            icon: Icons.assignment_outlined,
            title: "2. ${AppStrings.buildPrograms}",
            subtitle: AppStrings.buildProgramsWorksInfo,
          ),

          _buildWorkflowDivider(),

          _buildWorkflowItem(
            icon: Icons.monitor_weight_outlined,
            title: "3. ${AppStrings.trackProgress}",
            subtitle: AppStrings.trackProgressWorksInfo,
          ),

          _buildWorkflowDivider(),

          _buildWorkflowItem(
            icon: Icons.sync_alt_outlined,
            title: "4. ${AppStrings.adjustAndImprove}",
            subtitle: AppStrings.adjustAndImproveWorksInfo,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimens.dimen10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimens.dimen12),
          ),
          child: Icon(icon, color: AppColors.primary, size: AppDimens.dimen20),
        ),

        UiUtils.addHorizontalSpaceM(),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
              ),
              UiUtils.addVerticalSpaceXS(),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkflowDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.dimen12,
        horizontal: AppDimens.dimen18,
      ),
      child: Container(
        width: 2,
        height: 20,
        color: AppColors.primary.withValues(alpha: 0.15),
      ),
    );
  }

  Widget _buildVisionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.dimen24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimens.dimen20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.auto_awesome,
            color: AppColors.primary,
            size: AppDimens.dimen32,
          ),

          UiUtils.addVerticalSpaceM(),

          Text(
            AppStrings.theFutureOfFitnessCoaching,
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),

          UiUtils.addVerticalSpaceM(),

          Text(
            AppStrings.pumpVision,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.dimen12,
        vertical: AppDimens.dimen6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.dimen16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),

              UiUtils.addHorizontalSpaceM(),

              Icon(icon, size: AppDimens.dimen20),

              UiUtils.addHorizontalSpaceM(),

              Expanded(child: Text(title, style: AppTextStyles.heading3)),
            ],
          ),

          UiUtils.addVerticalSpaceM(),

          Text(description, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.dimen20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen20),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: AppDimens.dimen48,
            backgroundImage: AssetImage("assets/images/jm.jpg"),
          ),

          UiUtils.addVerticalSpaceM(),

          Text(AppStrings.devName, style: AppTextStyles.heading3),

          UiUtils.addVerticalSpaceXS(),

          Text(
            AppStrings.devTitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDisabled,
            ),
          ),

          UiUtils.addVerticalSpaceM(),

          Text(
            AppStrings.devTitleInfo,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.dimen20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              AppStrings.connectWithMe,
              style: AppTextStyles.heading2,
            ),
          ),

          UiUtils.addVerticalSpaceS(),

          Text(
            AppStrings.connectDescription,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          UiUtils.addVerticalSpaceL(),

          _buildSocialCard(
            icon: Icons.email_outlined,
            title: AppStrings.email,
            subtitle: AppStrings.devEmail,
            onTap: _launchEmail,
          ),

          UiUtils.addVerticalSpaceM(),

          _buildSocialCard(
            icon: Icons.call_outlined,
            title: AppStrings.phone,
            subtitle: AppStrings.devMobileNo,
            onTap: _launchPhone,
          ),

          UiUtils.addVerticalSpaceM(),

          _buildSocialCard(
            icon: FontAwesomeIcons.github,
            title: AppStrings.github,
            subtitle: AppStrings.devGithubUsername,
            onTap: _launchGithub,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.dimen16),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.dimen16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppDimens.dimen16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.dimen12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimens.dimen12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: AppDimens.dimen20,
              ),
            ),

            UiUtils.addHorizontalSpaceM(),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  UiUtils.addVerticalSpaceXS(),

                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),

            Icon(
              Icons.open_in_new,
              size: AppDimens.dimen18,
              color: AppColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri.parse('mailto:${AppStrings.devEmail}');
    await launchUrl(emailUri);
  }

  Future<void> _launchPhone() async {
    final sanitizedPhoneNumber = AppStrings.devMobileNo.replaceAll(' ', '');
    final Uri phoneUri = Uri.parse('tel:$sanitizedPhoneNumber');
    await launchUrl(phoneUri);
  }

  Future<void> _launchGithub() async {
    final Uri githubUri = Uri.parse(
      'https://github.com/${AppStrings.devGithubUsername}',
    );
    await launchUrl(githubUri, mode: LaunchMode.externalApplication);
  }
}
