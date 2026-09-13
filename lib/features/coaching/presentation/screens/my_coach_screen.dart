import 'package:flutter/material.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/utils/ui_utils.dart';

class MyCoachScreen extends StatelessWidget {
  const MyCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'My Coach',
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
            _buildProfileHeader(),

            UiUtils.addVerticalSpaceL(),

            _buildActionButton(context),

            UiUtils.addVerticalSpaceL(),

            _buildSocialsSection(),

            UiUtils.addVerticalSpaceL(),

            _buildAboutSection(),

            UiUtils.addVerticalSpaceL(),

            _buildCredentialsSection(),

            UiUtils.addVerticalSpaceL(),

            _buildCoachingSection(),

            UiUtils.addVerticalSpaceL(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Profile Header
  // ---------------------------------------------------------------------------

  Widget _buildProfileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: AppDimens.radius48,
          backgroundImage: AssetImage('assets/images/coach.jpg'),
        ),

        UiUtils.addVerticalSpaceM(),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Coach Churva',
              style: AppTextStyles.heading2.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            UiUtils.addHorizontalSpaceXS(),

            Icon(
              Icons.verified,
              size: AppDimens.dimen18,
              color: AppColors.info,
            ),
          ],
        ),

        UiUtils.addVerticalSpaceXS(),

        Text(
          'Certified Strength & Conditioning Coach',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          textAlign: TextAlign.center,
        ),

        UiUtils.addVerticalSpaceS(),

        _buildActiveStatus(),

        UiUtils.addVerticalSpaceM(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding16),
          child: Text(
            'Helping clients build strength, improve performance, '
            'and stay consistent with their training.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.circle, size: AppDimens.dimen8, color: AppColors.success),

        UiUtils.addHorizontalSpaceXS(),

        Text(
          'Active',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        prefixIcon: Icons.chat_bubble_outline,
        onPressed: () {
          _openMessages(context);
        },
        label: 'Message',
      ),
    );
  }

  void _openMessages(BuildContext context) {
    // TODO: Navigate to MessagesScreen.
  }

  // ---------------------------------------------------------------------------
  // Socials
  // ---------------------------------------------------------------------------

  Widget _buildSocialsSection() {
    return _buildSection(
      title: 'Socials',
      icon: Icons.share_outlined,
      child: Column(
        children: [
          _buildSocialItem(
            icon: Icons.facebook,
            iconColor: const Color(0xFF1877F2),
            title: 'Facebook',
            value: 'Coach Churva',
            onTap: () {
              // TODO: Open Facebook profile.
            },
          ),

          _buildDivider(),

          _buildSocialItem(
            icon: Icons.camera_alt_outlined,
            iconColor: const Color(0xFFE1306C),
            title: 'Instagram',
            value: '@coachchurva',
            onTap: () {
              // TODO: Open Instagram profile.
            },
          ),

          _buildDivider(),

          _buildSocialItem(
            icon: Icons.music_note_outlined,
            iconColor: AppColors.textPrimary,
            title: 'TikTok',
            value: '@coachchurva',
            onTap: () {
              // TODO: Open TikTok profile.
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSocialItem({
    required IconData icon,
    required Color iconColor,
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
              Container(
                width: AppDimens.dimen40,
                height: AppDimens.dimen40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimens.dimen12),
                ),
                child: Icon(icon, size: AppDimens.dimen20, color: iconColor),
              ),

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
  // About
  // ---------------------------------------------------------------------------

  Widget _buildAboutSection() {
    return _buildSection(
      title: 'About',
      icon: Icons.info_outline,
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.work_outline,
            label: 'Experience',
            value: '8 years',
          ),

          _buildDivider(),

          _buildInfoRow(
            icon: Icons.fitness_center_outlined,
            label: 'Specialization',
            value: 'Strength & Hypertrophy',
          ),

          _buildDivider(),

          _buildInfoRow(
            icon: Icons.people_outline,
            label: 'Clients',
            value: '24 active clients',
          ),

          _buildDivider(),

          _buildInfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            value: '+63 917 123 4567',
          ),

          _buildDivider(),

          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: 'Makati City, Philippines',
          ),

          _buildDivider(),

          _buildInfoRow(
            icon: Icons.calendar_month_outlined,
            label: 'Coaching Since',
            value: '2018',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.padding4),
      child: Row(
        children: [
          Container(
            width: AppDimens.dimen40,
            height: AppDimens.dimen40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimens.dimen12),
            ),
            child: Icon(
              icon,
              size: AppDimens.dimen20,
              color: AppColors.primary,
            ),
          ),

          UiUtils.addHorizontalSpaceM(),

          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ),

          UiUtils.addHorizontalSpaceM(),

          SizedBox(
            width: AppDimens.dimen140,
            child: Text(
              value,
              textAlign: TextAlign.end,
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
  // Credentials
  // ---------------------------------------------------------------------------

  Widget _buildCredentialsSection() {
    return _buildSection(
      title: 'Credentials',
      icon: Icons.workspace_premium_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCredentialGroupTitle(
            icon: Icons.emoji_events_outlined,
            title: 'Awards',
          ),

          UiUtils.addVerticalSpaceXL(),

          _buildCredentialItem(
            title: 'WNBF Pro 2026',
            description: 'Natural Bodybuilding Competition',
          ),

          UiUtils.addVerticalSpaceM(),

          _buildCredentialItem(
            title: 'NPC Philippines Overall Champion',
            description: '2025',
          ),

          UiUtils.addVerticalSpaceM(),

          _buildCredentialItem(
            title: 'Regional Classic Physique Champion',
            description: '2024',
          ),

          UiUtils.addVerticalSpaceL(),

          _buildDivider(),

          UiUtils.addVerticalSpaceL(),

          _buildCredentialGroupTitle(
            icon: Icons.workspace_premium_outlined,
            title: 'Certifications',
          ),

          UiUtils.addVerticalSpaceXL(),

          _buildCredentialItem(
            title: 'Certified Strength & Conditioning Specialist',
            description: 'CSCS • 2022',
          ),

          UiUtils.addVerticalSpaceM(),

          _buildCredentialItem(
            title: 'Certified Personal Trainer',
            description: 'CPT • 2019',
          ),

          UiUtils.addVerticalSpaceM(),

          _buildCredentialItem(
            title: 'Sports Nutrition Coach',
            description: '2021',
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialGroupTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: AppDimens.dimen18, color: AppColors.primary),

        UiUtils.addHorizontalSpaceS(),

        Text(
          title,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildCredentialItem({
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimens.padding4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: AppDimens.padding8),
            width: AppDimens.dimen6,
            height: AppDimens.dimen6,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),

          UiUtils.addHorizontalSpaceM(),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
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
  // Coaching
  // ---------------------------------------------------------------------------

  Widget _buildCoachingSection() {
    return _buildSection(
      title: 'Coaching',
      icon: Icons.sports_gymnastics_outlined,
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.fitness_center_outlined,
            title: 'Training Plan',
            description: 'View your current training block.',
            onTap: () {
              // TODO: Navigate to Training Block.
            },
          ),

          _buildDivider(),

          _buildActionTile(
            icon: Icons.show_chart_outlined,
            title: 'Progress',
            description: 'View your progress and check-ins.',
            onTap: () {
              // TODO: Navigate to Progress & Analytics.
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String description,
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
              Container(
                width: AppDimens.dimen40,
                height: AppDimens.dimen40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimens.dimen12),
                ),
                child: Icon(
                  icon,
                  size: AppDimens.dimen20,
                  color: AppColors.primary,
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

              UiUtils.addHorizontalSpaceS(),

              Icon(
                Icons.chevron_right,
                size: AppDimens.dimen22,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared Components
  // ---------------------------------------------------------------------------

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        ),

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

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.padding8),
      child: Divider(
        height: 1,
        color: AppColors.textHint.withValues(alpha: 0.12),
      ),
    );
  }
}
