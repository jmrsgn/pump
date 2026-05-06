import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/app_constants.dart';
import 'package:pump/core/utils/ui_utils.dart';

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
              title: "What is Pump?",
              icon: Icons.favorite_outline,
              description:
                  "Pump is designed to solve one of the biggest problems in the fitness industry — the fragmented experience between coaches and clients.\n\nInstead of relying on multiple platforms for messaging, nutrition tracking, progress check-ins, workout programming, and coaching management, Pump brings everything into one centralized ecosystem.\n\nThe goal is to simplify communication, improve accountability, and provide both coaches and clients with powerful tools to achieve better fitness results through technology.",
            ),

            UiUtils.addVerticalSpaceXL(),

            _buildFeaturesSection(),

            UiUtils.addVerticalSpaceXL(),

            _buildWorkflowSection(),

            UiUtils.addVerticalSpaceXL(),

            _buildSection(
              title: AppStrings.inspiration,
              description:
                  "Pump was inspired by the idea of creating a lightweight and modern social platform where users can freely share thoughts, interact through meaningful discussions, and build communities in real time.",
              icon: Icons.lightbulb_outline,
            ),

            UiUtils.addVerticalSpaceL(),

            _buildSection(
              title: AppStrings.howItWorks,
              description:
                  "Users can create posts, interact using comments and replies, react through likes, and engage with a responsive and scalable architecture powered by Flutter and Spring Boot.",
              icon: Icons.auto_awesome,
            ),

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
        borderRadius: BorderRadius.circular(AppDimens.radius24),
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
            "An all-in-one platform for modern fitness coaching.",
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),

          UiUtils.addVerticalSpaceM(),

          Wrap(
            spacing: AppDimens.dimen8,
            runSpacing: AppDimens.dimen8,
            alignment: WrapAlignment.center,
            children: [
              _buildHighlightChip("Nutrition"),
              _buildHighlightChip("Coaching"),
              _buildHighlightChip("Check-ins"),
              _buildHighlightChip("Programs"),
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
          child: _buildStatCard(title: "AI", subtitle: "Ready"),
        ),
        UiUtils.addHorizontalSpaceS(),
        Expanded(
          child: _buildStatCard(title: "Real-time", subtitle: "Updates"),
        ),
        UiUtils.addHorizontalSpaceS(),
        Expanded(
          child: _buildStatCard(title: "Cross", subtitle: "Platform"),
        ),
      ],
    );
  }

  Widget _buildStatCard({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.dimen16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radius16),
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
        Text("Core Features", style: AppTextStyles.heading2),

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
              title: "Nutrition",
              subtitle: "Track meals and nutrition progress.",
            ),
            _buildFeatureCard(
              icon: Icons.fitness_center,
              title: "Programs",
              subtitle: "Manage personalized workout programs.",
            ),
            _buildFeatureCard(
              icon: Icons.analytics_outlined,
              title: "Check-ins",
              subtitle: "Monitor client progress in real-time.",
            ),
            _buildFeatureCard(
              icon: Icons.groups_outlined,
              title: "Coaching",
              subtitle: "Centralized coach and client management.",
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
        borderRadius: BorderRadius.circular(AppDimens.radius16),
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
          Text("How Pump Works", style: AppTextStyles.heading2),

          UiUtils.addVerticalSpaceL(),

          _buildWorkflowItem(
            icon: Icons.assignment_outlined,
            title: "1. Create Program",
            subtitle: "Coaches build personalized plans.",
          ),

          _buildWorkflowDivider(),

          _buildWorkflowItem(
            icon: Icons.monitor_weight_outlined,
            title: "2. Track Progress",
            subtitle: "Clients submit updates and check-ins.",
          ),

          _buildWorkflowDivider(),

          _buildWorkflowItem(
            icon: Icons.insights_outlined,
            title: "3. Analyze Results",
            subtitle: "Monitor improvements and performance.",
          ),

          _buildWorkflowDivider(),

          _buildWorkflowItem(
            icon: Icons.auto_awesome_outlined,
            title: "4. AI Assistance",
            subtitle: "Future intelligent coaching integration.",
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
            "The Future of Coaching",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),

          UiUtils.addVerticalSpaceM(),

          Text(
            "Pump aims to become a complete ecosystem for fitness professionals and clients through intelligent tools, centralized workflows, automation, and AI-powered coaching experiences.",
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
        borderRadius: BorderRadius.circular(AppDimens.radius16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),

              UiUtils.addHorizontalSpaceS(),

              Icon(icon, size: AppDimens.dimen20),

              UiUtils.addHorizontalSpaceS(),

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
            radius: AppDimens.radius48,
            backgroundImage: AssetImage("assets/images/jm.jpg"),
          ),

          UiUtils.addVerticalSpaceM(),

          Text("John Martin Marasigan", style: AppTextStyles.heading3),

          UiUtils.addVerticalSpaceXS(),

          Text(
            "Full Stack Developer",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDisabled,
            ),
          ),

          UiUtils.addVerticalSpaceM(),

          Text(
            "Passionate about building scalable applications, modern user experiences, and intelligent systems that solve real-world problems.",
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required String title,
    required String subtitle,
    required Widget leading,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.dimen16,
        vertical: AppDimens.dimen4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius16),
      ),
      tileColor: AppColors.surface,
      leading: leading,
      trailing: const Icon(Icons.open_in_new),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
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
          Center(child: Text("Connect With Me", style: AppTextStyles.heading2)),

          UiUtils.addVerticalSpaceS(),

          Text(
            "Feel free to reach out for collaborations, opportunities, or discussions about development and fitness technology.",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          UiUtils.addVerticalSpaceL(),

          _buildSocialCard(
            icon: Icons.email_outlined,
            title: "Email",
            subtitle: AppStrings.devEmail,
          ),

          UiUtils.addVerticalSpaceM(),

          _buildSocialCard(
            icon: Icons.call_outlined,
            title: "Phone",
            subtitle: AppStrings.devMobileNo,
          ),

          UiUtils.addVerticalSpaceM(),

          _buildSocialCard(
            icon: FontAwesomeIcons.github,
            title: "GitHub",
            subtitle: AppStrings.devGithubUsername,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.dimen16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimens.radius16),
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
    );
  }
}
