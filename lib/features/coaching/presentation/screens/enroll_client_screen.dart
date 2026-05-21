import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/constants/app/ui_constants.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/presentation/widgets/custom_text_field.dart';
import 'package:pump/core/utils/ui_utils.dart';

class EnrollClientScreen extends ConsumerStatefulWidget {
  const EnrollClientScreen({super.key});

  @override
  ConsumerState<EnrollClientScreen> createState() => _EnrollClientScreenState();
}

class _EnrollClientScreenState extends ConsumerState<EnrollClientScreen> {
  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _heightController = TextEditingController();

  final _weightController = TextEditingController();

  final _goalWeightController = TextEditingController();

  String selectedGoal = 'Fat Loss';

  String selectedActivityLevel = 'Moderately Active';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _goalWeightController.dispose();

    super.dispose();
  }

  void _onEnrollPressed() {
    UiUtils.showSnackBarSuccess(
      context,
      message: 'Client enrolled successfully',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.dimen24,
                  vertical: AppDimens.dimen20,
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
                          Icons.person_add_alt_1,
                          color: AppColors.primary,
                          size: AppDimens.dimen30,
                        ),
                      ),
                    ),

                    UiUtils.addVerticalSpaceXL(),

                    Text('Enroll Client', style: AppTextStyles.heading1),

                    UiUtils.addVerticalSpaceS(),

                    Text(
                      'Create a new coaching client profile and start managing their fitness journey.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    UiUtils.addVerticalSpaceXXL(),

                    _buildSectionLabel('Personal Information'),

                    UiUtils.addVerticalSpaceL(),

                    _buildNameFields(),

                    UiUtils.addVerticalSpaceM(),

                    _buildEmailField(),

                    UiUtils.addVerticalSpaceM(),

                    _buildPhoneField(),

                    UiUtils.addVerticalSpaceXXL(),

                    _buildSectionLabel('Body Metrics'),

                    UiUtils.addVerticalSpaceL(),

                    _buildBodyMetrics(),

                    UiUtils.addVerticalSpaceXXL(),

                    _buildSectionLabel('Fitness Goal'),

                    UiUtils.addVerticalSpaceL(),

                    _buildFitnessGoals(),

                    UiUtils.addVerticalSpaceXXL(),

                    _buildSectionLabel('Activity Level'),

                    UiUtils.addVerticalSpaceL(),

                    _buildActivityLevels(),

                    UiUtils.addVerticalSpaceXXL(),

                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: _onEnrollPressed,
                        label: 'Enroll Client',
                      ),
                    ),

                    UiUtils.addVerticalSpaceXXL(),
                  ],
                ),
              ),
            ),

            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Text(title, style: AppTextStyles.heading3);
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            hint: AppStrings.firstName,
            controller: _firstNameController,
          ),
        ),

        UiUtils.addHorizontalSpaceS(),

        Expanded(
          child: CustomTextField(
            hint: AppStrings.lastName,
            controller: _lastNameController,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      hint: AppStrings.email,
      controller: _emailController,
    );
  }

  Widget _buildPhoneField() {
    return CustomTextField(
      hint: AppStrings.phone,
      controller: _phoneController,
    );
  }

  Widget _buildBodyMetrics() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hint: 'Height (cm)',
                controller: _heightController,
                keyboardType: TextInputType.number,
              ),
            ),

            UiUtils.addHorizontalSpaceS(),

            Expanded(
              child: CustomTextField(
                hint: 'Weight (kg)',
                controller: _weightController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),

        UiUtils.addVerticalSpaceM(),

        CustomTextField(
          hint: 'Goal Weight (kg)',
          controller: _goalWeightController,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildFitnessGoals() {
    return Wrap(
      spacing: AppDimens.dimen12,
      runSpacing: AppDimens.dimen12,
      children: [
        _buildSelectionChip('Fat Loss'),
        _buildSelectionChip('Muscle Gain'),
        _buildSelectionChip('Maintenance'),
        _buildSelectionChip('Recomposition'),
      ],
    );
  }

  Widget _buildActivityLevels() {
    return Column(
      children: [
        _buildActivityTile(title: 'Sedentary'),

        UiUtils.addVerticalSpaceS(),

        _buildActivityTile(title: 'Lightly Active'),

        UiUtils.addVerticalSpaceS(),

        _buildActivityTile(title: 'Moderately Active'),

        UiUtils.addVerticalSpaceS(),

        _buildActivityTile(title: 'Very Active'),
      ],
    );
  }

  Widget _buildSelectionChip(String goal) {
    final bool isSelected = selectedGoal == goal;

    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.dimen50),
      onTap: () {
        setState(() {
          selectedGoal = goal;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: UIConstants.milliseconds180),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.dimen16,
          vertical: AppDimens.dimen10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.dimen50),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Text(
          goal,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityTile({required String title}) {
    final bool isSelected = selectedActivityLevel == title;

    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.dimen16),
      onTap: () {
        setState(() {
          selectedActivityLevel = title;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: UIConstants.milliseconds180),
        padding: EdgeInsets.all(AppDimens.dimen16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.dimen16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),

            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: AppDimens.dimen20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.dimen8),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: UiUtils.addCopyright(),
      ),
    );
  }
}
