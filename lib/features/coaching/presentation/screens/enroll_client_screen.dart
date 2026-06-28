import 'dart:async';

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
import 'package:pump/features/coaching/presentation/state/enroll_client_state.dart';
import 'package:pump/features/coaching/presentation/viewmodels/enroll_client_viewmodel.dart';

class EnrollClientScreen extends ConsumerStatefulWidget {
  const EnrollClientScreen({super.key});

  @override
  ConsumerState<EnrollClientScreen> createState() => _EnrollClientScreenState();
}

class _EnrollClientScreenState extends ConsumerState<EnrollClientScreen> {
  final _searchController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _goalWeightController = TextEditingController();

  final LayerLink _searchLayerLink = LayerLink();

  String selectedGoal = AppStrings.fatLoss;
  String selectedActivityLevel = AppStrings.moderatelyActive;
  Gender selectedGender = Gender.male;

  DateTime? selectedBirthDate;
  String? selectedUserId;
  String? selectedUserName;
  String? selectedUserProfileImageUrl;

  OverlayEntry? _searchOverlay;

  Timer? _searchDebounce;

  EnrollClientViewModel get _enrollClientViewModel =>
      ref.read(enrollClientViewModelProvider.notifier);

  @override
  void dispose() {
    _removeSearchOverlay();

    _searchController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _goalWeightController.dispose();

    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onEnrollPressed() {
    if (selectedUserId == null) {
      UiUtils.showSnackBarError(context, message: "Please select a user");
      return;
    }

    final height = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    final goalWeight = double.tryParse(_goalWeightController.text.trim());

    if ([height, weight, goalWeight, selectedBirthDate].any((e) => e == null)) {
      UiUtils.showSnackBarError(
        context,
        message: ValidationErrorConstants.allFieldsAreRequired,
      );
      return;
    }

    _enrollClientViewModel.createClientUser(
      userId: selectedUserId!,
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
    ref.listen<EnrollClientState>(enrollClientViewModelProvider, (
      previous,
      next,
    ) {
      if (!mounted) return;

      if (_searchController.text.trim().isEmpty || selectedUserId != null) {
        _removeSearchOverlay();
        return;
      }

      if (_searchOverlay != null) {
        _searchOverlay!.markNeedsBuild();
      }

      final wasLoading = previous?.isLoading ?? false;
      final isFinished = wasLoading && !next.isLoading;

      if (!isFinished) return;

      if (next.errorMessage != null) {
        UiUtils.showSnackBarError(context, message: next.errorMessage!);
      }
    });

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

                    CompositedTransformTarget(
                      link: _searchLayerLink,
                      child: _buildUserSearch(),
                    ),

                    UiUtils.addVerticalSpaceM(),

                    if (selectedUserId != null) _buildSelectedUserCard(),

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

  Widget _buildSearchResults() {
    if (_searchController.text.trim().isEmpty || selectedUserId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _removeSearchOverlay();
      });

      return const SizedBox.shrink();
    }

    final users = ref.watch(enrollClientViewModelProvider).users;

    if (users.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppDimens.dimen16),
        child: const Text('No users found'),
      );
    }

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(AppDimens.dimen16),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.dimen16),
        ),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: users.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final user = users[index];
            final userName = "${user.firstName} ${user.lastName}";

            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(userName),
              onTap: () {
                _removeSearchOverlay();

                FocusScope.of(context).unfocus();

                setState(() {
                  selectedUserId = user.id;
                  selectedUserName = userName;
                  selectedUserProfileImageUrl = user.profileImageUrl;

                  _searchController.clear();
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserSearch() {
    return CustomTextField(
      hint: 'Search User',
      controller: _searchController,
      prefixIcon: Icons.search,
      onChanged: (value) {
        _searchDebounce?.cancel();

        final query = value.trim();

        if (query.isEmpty) {
          _searchDebounce?.cancel();
          _removeSearchOverlay();
          _enrollClientViewModel.clearSearchUsers();
          return;
        }

        _searchDebounce = Timer(
          Duration(milliseconds: UIConstants.milliseconds500),
          () {
            final latestQuery = _searchController.text.trim();

            if (latestQuery.isEmpty) {
              _removeSearchOverlay();
              return;
            }

            _enrollClientViewModel.searchUsers(latestQuery);

            if (_searchController.text.trim().isEmpty) {
              return;
            }

            _showSearchOverlay();
          },
        );
      },
    );
  }

  void _showSearchOverlay() {
    _removeSearchOverlay();

    _searchOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: MediaQuery.of(context).size.width - (AppDimens.dimen24 * 2),
          child: CompositedTransformFollower(
            link: _searchLayerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 64),
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(AppDimens.dimen16),
              child: _buildSearchResults(),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_searchOverlay!);
  }

  void _removeSearchOverlay() {
    _searchOverlay?.remove();
    _searchOverlay = null;
  }

  Widget _buildSelectedUserCard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimens.dimen16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.dimen16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: AppDimens.dimen24,
                backgroundImage: selectedUserProfileImageUrl != null
                    ? NetworkImage(selectedUserProfileImageUrl!)
                    : null,
                child: selectedUserProfileImageUrl == null
                    ? const Icon(Icons.person)
                    : null,
              ),

              UiUtils.addHorizontalSpaceM(),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedUserName ?? '',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text('Selected User', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),

              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: _clearSelectedUser,
              ),
            ],
          ),
        ),
        UiUtils.addVerticalSpaceM(),
      ],
    );
  }

  void _clearSelectedUser() {
    _removeSearchOverlay();
    _enrollClientViewModel.clearSearchUsers();

    setState(() {
      selectedUserId = null;
      selectedUserName = null;
      selectedUserProfileImageUrl = null;

      _searchController.clear();
    });
  }

  Widget _buildSectionLabel(String title) {
    return Text(title, style: AppTextStyles.heading3);
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
