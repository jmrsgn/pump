import 'package:flutter/material.dart';

import '../constants/app/app_dimens.dart';
import '../constants/app/app_strings.dart';
import '../presentation/theme/app_colors.dart';
import '../presentation/theme/app_text_styles.dart';

class UiUtils {
  UiUtils._();

  static Widget addDivider() {
    return Divider(color: AppColors.divider, thickness: AppDimens.dimen1);
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
}
