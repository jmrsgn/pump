import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/ui_constants.dart';
import 'package:pump/core/enums/app_menu_item.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';

import '../../constants/app/app_dimens.dart';
import '../../constants/app/app_strings.dart';
import '../../domain/entities/user.dart';
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
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top:
                  MediaQuery.of(context).size.height *
                  UIConstants.percentage0_1,
            ),
            padding: EdgeInsets.symmetric(horizontal: AppDimens.padding16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: currentUser.profileImageUrl == null
                      ? CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: AppDimens.radius48,
                          child: Text(
                            currentUser.firstName[0],
                            style: AppTextStyles.heading1.copyWith(
                              fontSize: AppDimens.textSize48,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: AssetImage(
                            currentUser.profileImageUrl!,
                          ),
                          radius: AppDimens.radius48,
                        ),
                ),
                UiUtils.addHorizontalSpaceL(),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${currentUser.firstName} ${currentUser.lastName}",
                        style: AppTextStyles.heading3,
                      ),
                      UiUtils.addVerticalSpaceXS(),
                      Text(currentUser.email, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),

          UiUtils.addVerticalSpaceXL(),
          UiUtils.addDivider(),

          // Expand to have the Sign out tab at the bottom
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...AppMenuItem.values.asMap().entries.map((entry) {
                  int index = entry.key;
                  AppMenuItem item = entry.value;

                  // Build the drawer item
                  List<Widget> widgets = [
                    _buildDrawerItem(context: context, item: item),
                  ];

                  if (index == 0 || index == 3) {
                    widgets.add(UiUtils.addDivider());
                    widgets.add(
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: AppDimens.dimen8,
                            bottom: AppDimens.dimen8,
                          ),
                          child: Text(
                            index == 0
                                ? AppStrings.user.toUpperCase()
                                : AppStrings.developer.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textDisabled,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(children: widgets);
                }),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(
              FontAwesomeIcons.rightFromBracket,
              color: AppColors.error,
            ),
            title: const Text(
              AppStrings.signOut,
              style: TextStyle(color: AppColors.error),
            ),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required AppMenuItem item,
  }) {
    final bool isSelected = selectedRoute == item.route;

    return ListTile(
      leading: Icon(
        item.icon,
        color: AppColors.textPrimary,
        size: AppDimens.dimen20,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.drawerSelected,
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
    );
  }
}
