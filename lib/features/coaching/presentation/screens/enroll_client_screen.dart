import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/constants/app/ui_constants.dart';
import 'package:pump/core/constants/error/validation_error_constants.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/presentation/widgets/custom_text_field.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/coaching/enums/activity_level.dart';
import 'package:pump/features/coaching/enums/fitness_goal.dart';
import 'package:pump/features/coaching/enums/gender.dart';
import 'package:pump/features/coaching/presentation/provider/client_user_providers.dart';
import 'package:pump/features/coaching/presentation/viewmodels/enroll_client_viewmodel.dart';

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

  String selectedGoal = AppStrings.fatLoss;
  String selectedActivityLevel = AppStrings.moderatelyActive;

  Gender selectedGender = Gender.male;
  DateTime? selectedBirthDate;

  EnrollClientViewModel get _enrollClientViewModel =>
      ref.read(enrollClientViewModelProvider.notifier);

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
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final height = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    final goalWeight = double.tryParse(_goalWeightController.text.trim());

    if ([firstName, lastName, email, phone].any((e) => e.isEmpty)) {
      UiUtils.showSnackBarError(
        context,
        message: ValidationErrorConstants.allFieldsAreRequired,
      );
      return;
    }

    if ([height, weight, goalWeight, selectedBirthDate].any((e) => e == null)) {
      UiUtils.showSnackBarError(
        context,
        message: ValidationErrorConstants.allFieldsAreRequired,
      );
      return;
    }

    _enrollClientViewModel.createClientUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      // TODO: add actual photo
      profileImageUrl: "",
      gender: selectedGender,
      birthDate: selectedBirthDate!,
      heightCm: height!,
      currentWeight: weight!,
      goalWeight: goalWeight!,
      activityLevel: ActivityLevel.fromValue(selectedActivityLevel),
      fitnessGoal: FitnessGoal.fromValue(selectedGoal),
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

                    Text(
                      AppStrings.enrollClient,
                      style: AppTextStyles.heading1,
                    ),

                    UiUtils.addVerticalSpaceS(),

                    Text(
                      AppStrings.enrollClientHelperText,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    UiUtils.addVerticalSpaceXXL(),

                    _buildSectionLabel(AppStrings.personalInformation),

                    UiUtils.addVerticalSpaceL(),

                    _buildNameFields(),

                    UiUtils.addVerticalSpaceM(),

                    _buildEmailField(),

                    UiUtils.addVerticalSpaceM(),

                    _buildPhoneField(),

                    UiUtils.addVerticalSpaceM(),

                    _buildBirthDateField(),

                    UiUtils.addVerticalSpaceM(),

                    _buildGenderSelection(),

                    UiUtils.addVerticalSpaceXXL(),

                    _buildSectionLabel(AppStrings.bodyMetrics),

                    UiUtils.addVerticalSpaceL(),

                    _buildBodyMetrics(),

                    UiUtils.addVerticalSpaceXXL(),

                    _buildSectionLabel(AppStrings.fitnessGoal),

                    UiUtils.addVerticalSpaceL(),

                    _buildFitnessGoals(),

                    UiUtils.addVerticalSpaceXXL(),

                    _buildSectionLabel(AppStrings.activityLevel),

                    UiUtils.addVerticalSpaceL(),

                    _buildActivityLevels(),

                    UiUtils.addVerticalSpaceXXL(),

                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: _onEnrollPressed,
                        label: AppStrings.enrollClient,
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

  Widget _buildBirthDateField() {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.dimen16),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(DateTime.now().year - 18),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          setState(() {
            selectedBirthDate = pickedDate;
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.dimen16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.dimen16),
        ),
        child: Text(
          selectedBirthDate == null
              ? 'Select Birth Date'
              : selectedBirthDate!.toString().split(' ').first,
          style: AppTextStyles.body,
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        Expanded(
          child: _buildGenderChip(label: AppStrings.male, gender: Gender.male),
        ),

        UiUtils.addHorizontalSpaceS(),

        Expanded(
          child: _buildGenderChip(
            label: AppStrings.female,
            gender: Gender.female,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderChip({required String label, required Gender gender}) {
    final isSelected = selectedGender == gender;

    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.dimen16),
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: UIConstants.milliseconds180),
        padding: const EdgeInsets.all(AppDimens.dimen16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.dimen16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
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
        _buildSelectionChip(AppStrings.fatLoss),
        _buildSelectionChip(AppStrings.muscleMass),
        _buildSelectionChip(AppStrings.maintenance),
        _buildSelectionChip(AppStrings.recomposition),
      ],
    );
  }

  Widget _buildActivityLevels() {
    return Column(
      children: [
        _buildActivityTile(title: AppStrings.sedentary),

        UiUtils.addVerticalSpaceS(),

        _buildActivityTile(title: AppStrings.lightlyActive),

        UiUtils.addVerticalSpaceS(),

        _buildActivityTile(title: AppStrings.moderatelyActive),

        UiUtils.addVerticalSpaceS(),

        _buildActivityTile(title: AppStrings.veryActive),
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
        padding: const EdgeInsets.symmetric(
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
        padding: const EdgeInsets.all(AppDimens.dimen16),
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
