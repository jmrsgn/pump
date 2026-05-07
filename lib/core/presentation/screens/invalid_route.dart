import 'package:flutter/material.dart';
import 'package:pump/core/constants/error/system_error_constants.dart';

import '../../constants/app/app_dimens.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/custom_scaffold.dart';

class InvalidRouteScreen extends StatelessWidget {
  const InvalidRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppDimens.dimen24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: AppDimens.dimen12),
                Text(
                  SystemErrorConstants.routeNotFound,
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
