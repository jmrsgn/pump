import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/enums/app_menu_item.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';

import '../../constants/app/app_dimens.dart';
import '../../domain/entity/user.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppDrawer extends StatelessWidget {
  final String selectedRoute;
  final VoidCallback onSignOut;
  final User currentUser;

  const AppDrawer({
    super.key,
    required this.selectedRoute,
    required this.onSignOut,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.drawerBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.dimen16,
            vertical: AppDimens.dimen12,
          ),
          child: Column(
            children: [
              _buildDrawerHeader(),

              UiUtils.addVerticalSpaceXL(),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildSectionLabel(AppStrings.labelFitness),

                    UiUtils.addVerticalSpaceS(),

                    _buildDrawerItem(
                      context: context,
                      item: AppMenuItem.values[0],
                    ),

                    UiUtils.addVerticalSpaceL(),

                    _buildSectionLabel(AppStrings.labelUser),

                    UiUtils.addVerticalSpaceS(),

                    ...AppMenuItem.values
                        .sublist(1, 4)
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimens.dimen2,
                            ),
                            child: _buildDrawerItem(
                              context: context,
                              item: item,
                            ),
                          ),
                        ),

                    UiUtils.addVerticalSpaceL(),

                    _buildSectionLabel(AppStrings.labelDeveloper),

                    UiUtils.addVerticalSpaceS(),

                    ...AppMenuItem.values
                        .sublist(4)
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppDimens.dimen2,
                            ),
                            child: _buildDrawerItem(
                              context: context,
                              item: item,
                            ),
                          ),
                        ),
                  ],
                ),
              ),

              UiUtils.addVerticalSpaceM(),

              _buildSignOutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.dimen8,
        vertical: AppDimens.dimen12,
      ),
      child: Row(
        children: [
          UiUtils.buildDAvatarHeader(
            userName: "${currentUser.firstName} ${currentUser.lastName}",
            profileImageUrl: currentUser.profileImageUrl,
          ),

          UiUtils.addHorizontalSpaceL(),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${currentUser.firstName} ${currentUser.lastName}",
                  style: AppTextStyles.heading3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                UiUtils.addVerticalSpaceXS(),

                Text(
                  currentUser.email,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                UiUtils.addVerticalSpaceM(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.dimen10,
                    vertical: AppDimens.dimen6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    "Active",
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimens.dimen8),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textDisabled,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required AppMenuItem item,
  }) {
    final bool isSelected = selectedRoute == item.route;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimens.dimen18),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dimen18),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.dimen14,
          vertical: AppDimens.dimen2,
        ),
        leading: Icon(
          item.icon,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          size: AppDimens.dimen18,
        ),
        title: Text(
          item.title,
          style: AppTextStyles.body.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            : Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.textDisabled,
                size: AppDimens.dimen18,
              ),
        onTap: () {
          NavigationUtils.pop(context);

          if (selectedRoute != item.route) {
            NavigationUtils.navigateTo(
              context,
              item.route,
              arguments: currentUser,
            );
          }
        },
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.dimen18),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dimen18),
        ),
        leading: const Icon(
          FontAwesomeIcons.rightFromBracket,
          color: AppColors.error,
          size: AppDimens.dimen18,
        ),
        title: Text(
          AppStrings.signOut,
          style: AppTextStyles.body.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onSignOut,
      ),
    );
  }
}
