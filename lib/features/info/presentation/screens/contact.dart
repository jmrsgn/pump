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

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        appBarTitle: AppStrings.contact,
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
                    FontAwesomeIcons.paperPlane,
                    color: AppColors.primary,
                    size: AppDimens.dimen26,
                  ),
                ),
              ),

              UiUtils.addVerticalSpaceXL(),

              Text(AppStrings.letsTalk, style: AppTextStyles.heading1),

              UiUtils.addVerticalSpaceS(),

              Text(
                AppStrings.contactGuide,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              UiUtils.addVerticalSpaceXXL(),

              Text(AppStrings.yourInformation, style: AppTextStyles.heading3),

              UiUtils.addVerticalSpaceL(),

              CustomTextField(
                hint: AppStrings.name,
                controller: _nameController,
              ),

              UiUtils.addVerticalSpaceM(),

              CustomTextField(
                hint: AppStrings.email,
                controller: _emailController,
              ),

              UiUtils.addVerticalSpaceM(),

              CustomTextField(
                hint: AppStrings.phone,
                controller: _phoneController,
              ),

              UiUtils.addVerticalSpaceXL(),

              Text(AppStrings.message, style: AppTextStyles.heading3),

              UiUtils.addVerticalSpaceL(),

              CustomTextField(
                hint: AppStrings.contactHint,
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
                AppStrings.contactAdditionalInfo,
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
