import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';

import '../../../../core/routes.dart';

class ClientWidget extends StatelessWidget {
  final String name;
  final String status;
  final String imagePath;

  const ClientWidget({
    super.key,
    this.name = 'John Martin I. Marasigan',
    this.status = 'Active',
    this.imagePath = '', // leave empty if no image
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      margin: EdgeInsets.only(bottom: AppDimens.margin4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius8),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.padding16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile picture with border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: CircleAvatar(
                radius: AppDimens.radius24,
                backgroundImage: imagePath.isNotEmpty
                    ? AssetImage(imagePath)
                    : null,
                backgroundColor: imagePath.isEmpty
                    ? AppColors.primary
                    : Colors.transparent,
              ),
            ),

            UiUtils.addHorizontalSpaceL(),

            // Name and status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  UiUtils.addVerticalSpaceXS(),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: status.toLowerCase() == 'active'
                            ? AppColors.success
                            : AppColors.error,
                        size: AppDimens.dimen8,
                      ),
                      UiUtils.addHorizontalSpaceXS(),
                      Text(
                        status,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow button to navigate
            IconButton(
              onPressed: () {
                NavigationUtils.navigateTo(context, AppRoutes.clientOverview);
              },
              icon: FaIcon(
                FontAwesomeIcons.arrowRight,
                size: AppDimens.dimen16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
