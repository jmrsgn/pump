import 'package:flutter/material.dart';

import '../constants/app/app_dimens.dart';
import '../constants/app/app_strings.dart';
import '../domain/entity/user_summary.dart';
import '../presentation/theme/app_colors.dart';
import '../presentation/theme/app_text_styles.dart';

class UiUtils {
  UiUtils._();

  static Widget addDivider() {
    return Divider(
      color: AppColors.divider.withValues(alpha: 0.6),
      thickness: AppDimens.dimen1,
    );
  }

  static Widget addCopyright() {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.dimen8),
      child: Center(
        child: Text(AppStrings.copyright, style: AppTextStyles.footer),
      ),
    );
  }

  static Widget addSpace({double height = 0, double width = 0}) {
    return SizedBox(height: height, width: width);
  }

  // Vertical Spaces
  static Widget addVerticalSpaceXS() {
    return SizedBox(height: AppDimens.dimen4);
  }

  static Widget addVerticalSpaceS() {
    return SizedBox(height: AppDimens.dimen8);
  }

  static Widget addVerticalSpaceM() {
    return SizedBox(height: AppDimens.dimen12);
  }

  static Widget addVerticalSpaceL() {
    return SizedBox(height: AppDimens.dimen16);
  }

  static Widget addVerticalSpaceXL() {
    return SizedBox(height: AppDimens.dimen24);
  }

  static Widget addVerticalSpaceXXL() {
    return SizedBox(height: AppDimens.dimen32);
  }

  static Widget addVerticalSpaceXXXL() {
    return SizedBox(height: AppDimens.dimen48);
  }

  // Horizontal Spaces
  static Widget addHorizontalSpaceXS() {
    return SizedBox(width: AppDimens.dimen4);
  }

  static Widget addHorizontalSpaceS() {
    return SizedBox(width: AppDimens.dimen8);
  }

  static Widget addHorizontalSpaceM() {
    return SizedBox(width: AppDimens.dimen12);
  }

  static Widget addHorizontalSpaceL() {
    return SizedBox(width: AppDimens.dimen16);
  }

  static Widget addHorizontalSpaceXL() {
    return SizedBox(width: AppDimens.dimen24);
  }

  static Widget addHorizontalSpaceXXL() {
    return SizedBox(width: AppDimens.dimen32);
  }

  // Snackbar
  static void showSnackbar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyles.bodySmall),
        backgroundColor: backgroundColor ?? AppColors.surface,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.dimen4),
        ),
      ),
    );
  }

  static void showSnackBarSuccess(
    BuildContext context, {
    required String message,
  }) => showSnackbar(
    context,
    message: message,
    backgroundColor: AppColors.snackBarSuccess,
  );

  static void showSnackBarError(
    BuildContext context, {
    required String message,
  }) => showSnackbar(
    context,
    message: message,
    backgroundColor: AppColors.snackBarError,
  );

  static void showSnackBarInfo(
    BuildContext context, {
    required String message,
  }) => showSnackbar(
    context,
    message: message,
    backgroundColor: AppColors.snackBarInfo,
  );

  /// Create avatar using the App's default theme
  static CircleAvatar _buildAvatar({
    required UserSummary user,
    required radius,
    required fontSize,
  }) {
    return user.profileImageUrl.isEmpty
        ? CircleAvatar(
            backgroundColor: AppColors.primary.withValues(
              alpha: AppDimens.alpha0_12,
            ),
            radius: radius,
            child: Text(
              user.firstName[0],
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.primary,
                fontSize: fontSize,
              ),
            ),
          )
        : CircleAvatar(
            backgroundImage: AssetImage(user.profileImageUrl),
            radius: radius,
          );
  }

  static CircleAvatar buildDAvatarHeader({required UserSummary user}) {
    return _buildAvatar(
      user: user,
      radius: AppDimens.dimen48,
      fontSize: AppDimens.dimen48,
    );
  }

  static CircleAvatar buildAvatarSmall({required UserSummary user}) {
    return _buildAvatar(
      user: user,
      radius: AppDimens.dimen18,
      fontSize: AppDimens.dimen18,
    );
  }

  static CircleAvatar buildAvatarMedium({required UserSummary user}) {
    return _buildAvatar(
      user: user,
      radius: AppDimens.dimen24,
      fontSize: AppDimens.dimen24,
    );
  }
}
