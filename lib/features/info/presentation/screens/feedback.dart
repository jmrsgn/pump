import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/custom_scaffold.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/utils/ui_utils.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        appBarTitle: AppStrings.feedback,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.dimen20,
            vertical: AppDimens.dimen24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppDimens.dimen18),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FontAwesomeIcons.message,
                    color: AppColors.primary,
                    size: AppDimens.dimen26,
                  ),
                ),
              ),

              UiUtils.addVerticalSpaceXL(),

              Text(AppStrings.helpImprovePump, style: AppTextStyles.heading1),

              UiUtils.addVerticalSpaceS(),

              Text(
                AppStrings.feedbackGuide,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              UiUtils.addVerticalSpaceXXL(),

              Text(AppStrings.yourFeedback, style: AppTextStyles.heading3),

              UiUtils.addVerticalSpaceL(),

              CustomTextField(
                hint: AppStrings.feedbackHint,
                controller: _messageController,
                isMultiline: true,
              ),

              UiUtils.addVerticalSpaceXL(),

              SizedBox(
                width: double.infinity,
                child: CustomButton(onPressed: () {}, label: AppStrings.submit),
              ),

              UiUtils.addVerticalSpaceXL(),

              UiUtils.addDivider(),

              UiUtils.addVerticalSpaceL(),

              Text(
                AppStrings.feedbackAdditionalInfo,
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),

              UiUtils.addVerticalSpaceXL(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
