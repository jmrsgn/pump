import 'package:flutter/material.dart';
import 'package:pump/core/utils/ui_utils.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/domain/entity/user.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/custom_scaffold.dart';

class UserProfileScreen extends StatelessWidget {
  final User currentUser;

  const UserProfileScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: AppStrings.profile,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingScreen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),

            UiUtils.addVerticalSpaceXL(),

            _buildSectionTitle(AppStrings.account),

            UiUtils.addVerticalSpaceM(),

            _buildProfileTile(
              title: AppStrings.editProfile,
              subtitle: AppStrings.updateProfileInformation,
              leading: Icons.edit_outlined,
            ),

            UiUtils.addVerticalSpaceS(),

            _buildProfileTile(
              title: AppStrings.paymentMethod,
              subtitle: AppStrings.manageBillingAndPaymentMethods,
              leading: Icons.payment_outlined,
            ),

            UiUtils.addVerticalSpaceXL(),

            _buildSectionTitle(AppStrings.fitness),

            UiUtils.addVerticalSpaceM(),

            _buildProfileTile(
              title: AppStrings.clients,
              subtitle: AppStrings.manageClientsAndCoachingSessions,
              leading: Icons.groups_outlined,
            ),

            UiUtils.addVerticalSpaceS(),

            _buildProfileTile(
              title: AppStrings.coach,
              subtitle: AppStrings.viewCoachingProfileAndSettings,
              leading: Icons.fitness_center_outlined,
            ),

            UiUtils.addVerticalSpaceXL(),

            _buildSectionTitle(AppStrings.support),

            UiUtils.addVerticalSpaceM(),

            _buildProfileTile(
              title: AppStrings.help,
              subtitle: AppStrings.getHelpAndSupportResources,
              leading: Icons.help_outline,
            ),

            UiUtils.addVerticalSpaceXXL(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.dimen24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen24),
      ),
      child: Column(
        children: [
          currentUser.profileImageUrl.isEmpty
              ? CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  radius: AppDimens.dimen56,
                  child: Text(
                    currentUser.firstName[0],
                    style: AppTextStyles.heading1.copyWith(
                      fontSize: AppDimens.textSize48,
                      color: AppColors.primary,
                    ),
                  ),
                )
              : CircleAvatar(
                  backgroundImage: AssetImage(currentUser.profileImageUrl),
                  radius: AppDimens.dimen56,
                ),

          UiUtils.addVerticalSpaceL(),

          Text(
            "${currentUser.firstName} ${currentUser.lastName}",
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),

          UiUtils.addVerticalSpaceXS(),

          Text(
            currentUser.email,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),

          UiUtils.addVerticalSpaceM(),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.dimen14,
              vertical: AppDimens.dimen8,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              AppStrings.active,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.dimen18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
          ),

          UiUtils.addVerticalSpaceXS(),

          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.heading3);
  }

  Widget _buildProfileTile({
    required String title,
    required String subtitle,
    required IconData leading,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.dimen16,
          vertical: AppDimens.dimen4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(AppDimens.dimen10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppDimens.dimen12),
          ),
          child: Icon(leading, color: AppColors.primary),
        ),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: AppColors.textDisabled,
        ),
        title: Text(
          title,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppDimens.dimen4),
          child: Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
