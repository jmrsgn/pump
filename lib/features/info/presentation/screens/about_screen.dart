import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/app_constants.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: AppStrings.about,
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.padding16,
          AppDimens.padding16,
          AppDimens.padding16,
          AppDimens.padding24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),

            UiUtils.addVerticalSpaceXL(),

            _buildSection(
              title: 'What is Pump?',
              icon: Icons.info_outline,
              child: Text(
                'Pump brings training and coaching into one place. '
                'Track your workouts, monitor your progress, and stay '
                'connected with your coach throughout your fitness journey.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            UiUtils.addVerticalSpaceXL(),

            _buildFeaturesSection(),

            UiUtils.addVerticalSpaceXL(),

            _buildWorkflowSection(),

            UiUtils.addVerticalSpaceXL(),

            _buildVisionSection(),

            UiUtils.addVerticalSpaceXL(),

            _buildDeveloperSection(),

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

  // ---------------------------------------------------------------------------
  // Hero
  // ---------------------------------------------------------------------------

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: AppDimens.dimen64,
          height: AppDimens.dimen64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimens.dimen20),
          ),
          child: Text(
            AppConstants.appName[0],
            style: AppTextStyles.heading1.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        UiUtils.addVerticalSpaceM(),

        Text(
          AppConstants.appName,
          style: AppTextStyles.heading1.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),

        UiUtils.addVerticalSpaceXS(),

        Text(
          'Train. Track. Connect.',
          style: AppTextStyles.body.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        UiUtils.addVerticalSpaceM(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding16),
          child: Text(
            'A social fitness and coaching app built to help '
            'you stay consistent, track your progress, and '
            'work with your coach.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        UiUtils.addVerticalSpaceM(),

        Wrap(
          spacing: AppDimens.dimen8,
          runSpacing: AppDimens.dimen8,
          alignment: WrapAlignment.center,
          children: [
            _buildHighlightChip('Training'),
            _buildHighlightChip('Progress'),
            _buildHighlightChip('Coaching'),
            _buildHighlightChip('Social'),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Features
  // ---------------------------------------------------------------------------

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: 'Core Features', icon: Icons.apps_outlined),

        UiUtils.addVerticalSpaceM(),

        _buildFeatureItem(
          icon: Icons.fitness_center_outlined,
          title: 'Training',
          description:
              'Follow your training block and track your exercise performance.',
        ),

        _buildDivider(),

        _buildFeatureItem(
          icon: Icons.show_chart_outlined,
          title: 'Progress',
          description:
              'Monitor your bodyweight, check-ins, and progress over time.',
        ),

        _buildDivider(),

        _buildFeatureItem(
          icon: Icons.people_outline,
          title: 'Coaching',
          description:
              'Connect with your coach and manage your coaching journey.',
        ),

        _buildDivider(),

        _buildFeatureItem(
          icon: Icons.forum_outlined,
          title: 'Social',
          description:
              'Share your fitness journey and interact with the community.',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.padding8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconContainer(icon),

          UiUtils.addHorizontalSpaceM(),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                UiUtils.addVerticalSpaceXS(),

                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Workflow
  // ---------------------------------------------------------------------------

  Widget _buildWorkflowSection() {
    return _buildSection(
      title: 'How Pump Works',
      icon: Icons.route_outlined,
      child: Column(
        children: [
          _buildWorkflowItem(
            number: '01',
            icon: Icons.people_outline,
            title: 'Connect',
            description:
                'Work with your coach and manage your coaching relationship.',
          ),

          _buildWorkflowDivider(),

          _buildWorkflowItem(
            number: '02',
            icon: Icons.fitness_center_outlined,
            title: 'Train',
            description:
                'Follow your training block and record your workout performance.',
          ),

          _buildWorkflowDivider(),

          _buildWorkflowItem(
            number: '03',
            icon: Icons.monitor_weight_outlined,
            title: 'Track',
            description: 'Log your progress and complete regular check-ins.',
          ),

          _buildWorkflowDivider(),

          _buildWorkflowItem(
            number: '04',
            icon: Icons.trending_up_outlined,
            title: 'Improve',
            description:
                'Use your progress to understand how your training is moving forward.',
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowItem({
    required String number,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppDimens.dimen40,
          child: Text(
            number,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        _buildIconContainer(icon),

        UiUtils.addHorizontalSpaceM(),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),

              UiUtils.addVerticalSpaceXS(),

              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkflowDivider() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.dimen20,
        top: AppDimens.padding8,
        bottom: AppDimens.padding8,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 1,
          height: AppDimens.dimen20,
          color: AppColors.textHint.withValues(alpha: 0.15),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Vision
  // ---------------------------------------------------------------------------

  Widget _buildVisionSection() {
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
          _buildIconContainer(Icons.trending_up_outlined),

          UiUtils.addVerticalSpaceM(),

          Text('Built for Consistent Progress', style: AppTextStyles.heading2),

          UiUtils.addVerticalSpaceS(),

          Text(
            'Training is more than individual workouts. '
            'Pump brings training, progress tracking, coaching, '
            'and social interaction together so you can keep '
            'your fitness journey in one place.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Developer
  // ---------------------------------------------------------------------------

  Widget _buildDeveloperSection() {
    return _buildSection(
      title: 'About the Developer',
      icon: Icons.code_outlined,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: AppDimens.dimen36,
            backgroundImage: AssetImage('assets/images/jm.jpg'),
          ),

          UiUtils.addHorizontalSpaceM(),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.devName,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                UiUtils.addVerticalSpaceXS(),

                Text(
                  AppStrings.devTitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),

                UiUtils.addVerticalSpaceS(),

                Text(
                  'Pump is a personal project built to explore '
                  'full-stack application development, mobile '
                  'development, microservices, and cloud-native engineering.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Connect
  // ---------------------------------------------------------------------------

  Widget _buildConnectSection() {
    return _buildSection(
      title: 'Connect',
      icon: Icons.link_outlined,
      child: Column(
        children: [
          _buildConnectItem(
            icon: const Icon(Icons.email_outlined, size: AppDimens.dimen20),
            title: 'Email',
            value: AppStrings.devEmail,
            onTap: _launchEmail,
          ),

          _buildDivider(),

          _buildConnectItem(
            icon: const FaIcon(
              FontAwesomeIcons.github,
              size: AppDimens.dimen20,
            ),
            title: 'GitHub',
            value: AppStrings.devGithubUsername,
            onTap: _launchGithub,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectItem({
    required Widget icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.dimen12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.padding8),
          child: Row(
            children: [
              _buildIconContainerWidget(icon),

              UiUtils.addHorizontalSpaceM(),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    UiUtils.addVerticalSpaceXS(),

                    Text(
                      value,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.open_in_new,
                size: AppDimens.dimen18,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared
  // ---------------------------------------------------------------------------

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: title, icon: icon),

        UiUtils.addVerticalSpaceM(),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.padding16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.dimen16),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildSectionHeader({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: AppDimens.dimen20, color: AppColors.primary),

        UiUtils.addHorizontalSpaceS(),

        Text(
          title,
          style: AppTextStyles.heading3.copyWith(
            fontSize: AppDimens.textSize16,
          ),
        ),
      ],
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      width: AppDimens.dimen40,
      height: AppDimens.dimen40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.dimen12),
      ),
      child: Icon(icon, size: AppDimens.dimen20, color: AppColors.primary),
    );
  }

  Widget _buildIconContainerWidget(Widget icon) {
    return Container(
      width: AppDimens.dimen40,
      height: AppDimens.dimen40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.dimen12),
      ),
      child: icon,
    );
  }

  Widget _buildHighlightChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.padding12,
        vertical: AppDimens.padding4,
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

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppColors.textHint.withValues(alpha: 0.12),
    );
  }

  // ---------------------------------------------------------------------------
  // Links
  // ---------------------------------------------------------------------------

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri.parse('mailto:${AppStrings.devEmail}');

    await launchUrl(emailUri);
  }

  Future<void> _launchGithub() async {
    final Uri githubUri = Uri.parse(
      'https://github.com/${AppStrings.devGithubUsername}',
    );

    await launchUrl(githubUri, mode: LaunchMode.externalApplication);
  }
}
