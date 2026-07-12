import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/constants/app/ui_constants.dart';
import 'package:pump/core/constants/error/validation_error_constants.dart';
import 'package:pump/core/domain/entity/user_summary.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/presentation/widgets/custom_text_field.dart';
import 'package:pump/core/utilities/logger_utility.dart';
import 'package:pump/core/utils/navigation_utils.dart';
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
  static const debugTag = "EnrollClientScreen";

  final _searchController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _goalWeightController = TextEditingController();

  final LayerLink _searchLayerLink = LayerLink();

  String selectedGoal = AppStrings.fatLoss;
  String selectedActivityLevel = AppStrings.moderatelyActive;
  Gender selectedGender = Gender.male;

  UserSummary? selectedUser;

  OverlayEntry? _searchOverlay;

  Timer? _searchDebounce;

  EnrollClientViewModel get _enrollClientViewModel =>
      ref.read(enrollClientViewModelProvider.notifier);

  @override
  void dispose() {
    _removeSearchOverlay();

    _searchController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _goalWeightController.dispose();

    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onEnrollPressed() {
    if (selectedUser == null) {
      UiUtils.showSnackBarError(context, message: "Please select a user");
      return;
    }

    final age = int.tryParse(_ageController.text.trim());
    final height = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    final goalWeight = double.tryParse(_goalWeightController.text.trim());

    if ([height, weight, goalWeight, age].any((e) => e == null)) {
      UiUtils.showSnackBarError(
        context,
        message: ValidationErrorConstants.allFieldsAreRequired,
      );
      return;
    }

    _enrollClientViewModel.createClientUser(
      userId: selectedUser!.id,
      gender: selectedGender,
      age: age!,
      heightCm: height!,
      currentWeight: weight!,
      goalWeight: goalWeight!,
      activityLevel: ActivityLevel.fromValue(selectedActivityLevel),
      fitnessGoal: FitnessGoal.fromValue(selectedGoal),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enrollClientState = ref.watch(enrollClientViewModelProvider);

    ref.listen<EnrollClientState>(enrollClientViewModelProvider, (
      previous,
      next,
    ) {
      final wasLoading = previous?.isLoading ?? false;
      final isFinished = wasLoading && !next.isLoading;

      if (!isFinished || !mounted) return;

      if (_searchController.text.trim().isEmpty || selectedUser != null) {
        _removeSearchOverlay();
      }

      if (_searchOverlay != null) {
        _searchOverlay?.markNeedsBuild();
      }

      if (next.errorMessage != null) {
        UiUtils.showSnackBarError(context, message: next.errorMessage!);
      }

      if (next.isEnrollSuccess) {
        // Navigates back to Coaching Screen
        NavigationUtils.pop(context, true);
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        isLoading: enrollClientState.isLoading,
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
                          color: AppColors.primary.withValues(
                            alpha: AppDimens.alpha0_08,
                          ),
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

                    UiUtils.addVerticalSpaceL(),

                    _buildRequiredFieldsNotice(),

                    UiUtils.addVerticalSpaceL(),

                    _buildSectionLabel(AppStrings.personalInformation),

                    UiUtils.addVerticalSpaceL(),

                    CompositedTransformTarget(
                      link: _searchLayerLink,
                      child: _buildUserSearch(),
                    ),

                    UiUtils.addVerticalSpaceM(),

                    if (selectedUser != null) _buildSelectedUserCard(),

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

  Widget _buildRequiredFieldsNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.dimen14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: AppDimens.alpha0_08),
        borderRadius: BorderRadius.circular(AppDimens.dimen12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: AppDimens.alpha0_25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: AppDimens.dimen18,
          ),

          UiUtils.addHorizontalSpaceS(),

          Expanded(
            child: Text(
              'All fields are required unless stated otherwise.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.trim().isEmpty || selectedUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _removeSearchOverlay();
      });

      return const SizedBox.shrink();
    }

    final users = ref.watch(enrollClientViewModelProvider).users;

    if (users.isEmpty) {
      return Material(
        elevation: AppDimens.elevation8,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.dimen16),
          ),
          padding: const EdgeInsets.all(AppDimens.dimen16),
          child: const Center(child: Text("No users found")),
        ),
      );
    }

    return Material(
      elevation: AppDimens.elevation8,
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
              leading: UiUtils.buildAvatarSmall(
                userName: userName,
                profileImageUrl: user.profileImageUrl,
              ),
              title: Text(userName),
              onTap: () {
                _removeSearchOverlay();

                FocusScope.of(context).unfocus();

                setState(() {
                  selectedUser = user;
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
          LoggerUtility.d(
            debugTag,
            "Search query is empty, will not proceed to _showSearchOverlay",
          );
          _searchDebounce?.cancel();
          _removeSearchOverlay();
          _enrollClientViewModel.clearSearchUsers();
          return;
        }

        _searchDebounce = Timer(
          Duration(milliseconds: UIConstants.milliseconds300),
          () async {
            final latestQuery = _searchController.text.trim();
            LoggerUtility.d(debugTag, "latestQuery: [$latestQuery}]");

            if (latestQuery.isEmpty) {
              _removeSearchOverlay();
              return;
            }

            await _enrollClientViewModel.searchUsers(query: latestQuery);

            if (!mounted || _searchController.text.trim().isEmpty) {
              LoggerUtility.d(
                debugTag,
                "Search query is empty, will not proceed to _showSearchOverlay",
              );
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
              elevation: AppDimens.elevation12,
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
              UiUtils.buildAvatarMedium(
                userName:
                    "${selectedUser!.firstName} ${selectedUser!.lastName}",
                profileImageUrl: selectedUser!.profileImageUrl,
              ),

              UiUtils.addHorizontalSpaceM(),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${selectedUser?.firstName} ${selectedUser?.lastName}",
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
      selectedUser = null;
      _searchController.clear();
    });
  }

  Widget _buildSectionLabel(String title) {
    return Text(title, style: AppTextStyles.heading3);
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        Expanded(
          child: _buildGenderChip(
            label: AppStrings.male,
            gender: Gender.male,
            icon: FontAwesomeIcons.venus,
          ),
        ),

        UiUtils.addHorizontalSpaceS(),

        Expanded(
          child: _buildGenderChip(
            label: AppStrings.female,
            gender: Gender.female,
            icon: FontAwesomeIcons.mars,
          ),
        ),

        UiUtils.addHorizontalSpaceS(),

        Expanded(
          child: CustomTextField(
            hint: 'Age',
            controller: _ageController,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderChip({
    required String label,
    required Gender gender,
    required IconData icon,
  }) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                size: AppDimens.dimen16,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),

              UiUtils.addHorizontalSpaceS(),

              Text(
                label,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ],
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
                prefixIcon: Icons.height,
              ),
            ),

            UiUtils.addHorizontalSpaceS(),

            Expanded(
              child: CustomTextField(
                hint: 'Weight (kg)',
                controller: _weightController,
                keyboardType: TextInputType.number,
                prefixIcon: FontAwesomeIcons.weightScale,
              ),
            ),
          ],
        ),

        UiUtils.addVerticalSpaceM(),

        CustomTextField(
          hint: 'Goal Weight (kg)',
          controller: _goalWeightController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.track_changes,
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
        _buildSelectionChip(AppStrings.muscleGain),
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
              ? AppColors.primary.withValues(alpha: AppDimens.alpha0_12)
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
              ? AppColors.primary.withValues(alpha: AppDimens.alpha0_08)
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
