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
import 'package:pump/features/coaching/data/enums/activity_level.dart';
import 'package:pump/features/coaching/data/enums/fitness_goal.dart';
import 'package:pump/features/coaching/data/enums/gender.dart';
import 'package:pump/features/coaching/presentation/provider/client_user_providers.dart';
import 'package:pump/features/coaching/presentation/state/enroll_client_state.dart';
import 'package:pump/features/coaching/presentation/viewmodels/enroll_client_viewmodel.dart';

class EnrollClientScreen extends ConsumerStatefulWidget {
  const EnrollClientScreen({super.key});

  @override
  ConsumerState<EnrollClientScreen> createState() => _EnrollClientScreenState();
}

class _EnrollClientScreenState extends ConsumerState<EnrollClientScreen> {
  static const String _debugTag = 'EnrollClientScreen';

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

      _searchOverlay?.markNeedsBuild();

      if (next.errorMessage != null) {
        UiUtils.showSnackBarError(context, message: next.errorMessage!);
      }

      if (next.isEnrollSuccess) {
        NavigationUtils.pop(context, true);
      }
    });

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _removeSearchOverlay();
      },
      child: CustomScaffold(
        appBarTitle: AppStrings.enrollClient,
        backgroundColor: AppColors.background,
        isLoading: enrollClientState.isLoading,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.padding16,
            AppDimens.padding16,
            AppDimens.padding16,
            AppDimens.padding24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.enrollClientHelperText,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              UiUtils.addVerticalSpaceM(),

              _buildRequiredFieldsNotice(),

              UiUtils.addVerticalSpaceXL(),

              _buildClientSection(),

              UiUtils.addVerticalSpaceXL(),

              _buildPersonalInformationSection(),

              UiUtils.addVerticalSpaceXL(),

              _buildBodyMetricsSection(),

              UiUtils.addVerticalSpaceXL(),

              _buildFitnessGoalSection(),

              UiUtils.addVerticalSpaceXL(),

              _buildActivityLevelSection(),

              UiUtils.addVerticalSpaceXL(),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: _onEnrollPressed,
                  label: AppStrings.enrollClient,
                ),
              ),

              UiUtils.addVerticalSpaceXL(),

              Center(child: UiUtils.addCopyright()),

              UiUtils.addVerticalSpaceM(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Client
  // ---------------------------------------------------------------------------

  Widget _buildClientSection() {
    return _buildSection(
      title: 'Client',
      icon: Icons.person_search_outlined,
      child: selectedUser == null
          ? CompositedTransformTarget(
              link: _searchLayerLink,
              child: _buildUserSearch(),
            )
          : _buildSelectedUserCard(),
    );
  }

  Widget _buildUserSearch() {
    return CustomTextField(
      hint: 'Search User',
      controller: _searchController,
      prefixIcon: const Icon(Icons.search),
      onChanged: (value) {
        _searchDebounce?.cancel();

        final query = value.trim();

        if (query.isEmpty) {
          LoggerUtility.d(_debugTag, 'Search query is empty');

          _removeSearchOverlay();
          _enrollClientViewModel.clearSearchUsers();

          return;
        }

        _searchDebounce = Timer(
          Duration(milliseconds: UIConstants.milliseconds300),
          () async {
            final latestQuery = _searchController.text.trim();

            LoggerUtility.d(_debugTag, 'latestQuery: [$latestQuery]');

            if (latestQuery.isEmpty) {
              _removeSearchOverlay();
              return;
            }

            await _enrollClientViewModel.searchUsers(query: latestQuery);

            if (!mounted ||
                _searchController.text.trim().isEmpty ||
                selectedUser != null) {
              return;
            }

            _showSearchOverlay();
          },
        );
      },
    );
  }

  Widget _buildSelectedUserCard() {
    final userName = '${selectedUser!.firstName} ${selectedUser!.lastName}';

    return Row(
      children: [
        UiUtils.buildAvatarMedium(
          userName: userName,
          profileImageUrl: selectedUser!.profileImageUrl,
        ),

        UiUtils.addHorizontalSpaceM(),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),

              UiUtils.addVerticalSpaceXS(),

              Text(
                'Selected client',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          tooltip: 'Change client',
          onPressed: _clearSelectedUser,
          icon: const Icon(Icons.close, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Personal Information
  // ---------------------------------------------------------------------------

  Widget _buildPersonalInformationSection() {
    return _buildSection(
      title: AppStrings.personalInformation,
      icon: Icons.badge_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),

          UiUtils.addVerticalSpaceS(),

          Row(
            children: [
              Expanded(
                child: _buildGenderChip(
                  label: AppStrings.male,
                  gender: Gender.male,
                  icon: FontAwesomeIcons.mars,
                ),
              ),

              UiUtils.addHorizontalSpaceS(),

              Expanded(
                child: _buildGenderChip(
                  label: AppStrings.female,
                  gender: Gender.female,
                  icon: FontAwesomeIcons.venus,
                ),
              ),
            ],
          ),

          UiUtils.addVerticalSpaceM(),

          CustomTextField(
            hint: 'Age',
            controller: _ageController,
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.cake_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderChip({
    required String label,
    required Gender gender,
    required FaIconData icon,
  }) {
    final isSelected = selectedGender == gender;

    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.dimen12),
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: UIConstants.milliseconds180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.padding12,
          vertical: AppDimens.padding12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: AppDimens.alpha0_08)
              : AppColors.background,
          borderRadius: BorderRadius.circular(AppDimens.dimen12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textHint.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: AppDimens.dimen16,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),

            UiUtils.addHorizontalSpaceS(),

            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Body Metrics
  // ---------------------------------------------------------------------------

  Widget _buildBodyMetricsSection() {
    return _buildSection(
      title: AppStrings.bodyMetrics,
      icon: Icons.monitor_weight_outlined,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hint: 'Height (cm)',
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),

              UiUtils.addHorizontalSpaceS(),

              Expanded(
                child: CustomTextField(
                  hint: 'Weight (kg)',
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
            ],
          ),

          UiUtils.addVerticalSpaceM(),

          CustomTextField(
            hint: 'Goal Weight (kg)',
            controller: _goalWeightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Fitness Goal
  // ---------------------------------------------------------------------------

  Widget _buildFitnessGoalSection() {
    return _buildSection(
      title: AppStrings.fitnessGoal,
      icon: Icons.flag_outlined,
      child: Wrap(
        spacing: AppDimens.dimen8,
        runSpacing: AppDimens.dimen8,
        children: [
          _buildSelectionChip(AppStrings.fatLoss),
          _buildSelectionChip(AppStrings.muscleGain),
          _buildSelectionChip(AppStrings.maintenance),
          _buildSelectionChip(AppStrings.recomposition),
        ],
      ),
    );
  }

  Widget _buildSelectionChip(String goal) {
    final isSelected = selectedGoal == goal;

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
          horizontal: AppDimens.padding12,
          vertical: AppDimens.padding8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: AppDimens.alpha0_12)
              : AppColors.background,
          borderRadius: BorderRadius.circular(AppDimens.dimen50),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textHint.withValues(alpha: 0.12),
          ),
        ),
        child: Text(
          goal,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Activity Level
  // ---------------------------------------------------------------------------

  Widget _buildActivityLevelSection() {
    return _buildSection(
      title: AppStrings.activityLevel,
      icon: Icons.directions_run_outlined,
      child: Column(
        children: [
          _buildActivityTile(title: AppStrings.sedentary),

          _buildSectionDivider(),

          _buildActivityTile(title: AppStrings.lightlyActive),

          _buildSectionDivider(),

          _buildActivityTile(title: AppStrings.moderatelyActive),

          _buildSectionDivider(),

          _buildActivityTile(title: AppStrings.veryActive),
        ],
      ),
    );
  }

  Widget _buildActivityTile({required String title}) {
    final isSelected = selectedActivityLevel == title;

    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.dimen12),
      onTap: () {
        setState(() {
          selectedActivityLevel = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.padding12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),

            AnimatedSwitcher(
              duration: Duration(milliseconds: UIConstants.milliseconds180),
              child: isSelected
                  ? const Icon(
                      Icons.check_circle,
                      key: ValueKey('selected'),
                      color: AppColors.primary,
                      size: AppDimens.dimen20,
                    )
                  : Icon(
                      Icons.circle_outlined,
                      key: const ValueKey('unselected'),
                      color: AppColors.textHint,
                      size: AppDimens.dimen20,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Required Fields
  // ---------------------------------------------------------------------------

  Widget _buildRequiredFieldsNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.padding12,
        vertical: AppDimens.padding10,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: AppDimens.alpha0_08),
        borderRadius: BorderRadius.circular(AppDimens.dimen12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: AppDimens.alpha0_25),
        ),
      ),
      child: Row(
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

  // ---------------------------------------------------------------------------
  // Section
  // ---------------------------------------------------------------------------

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: AppDimens.dimen20, color: AppColors.primary),

            UiUtils.addHorizontalSpaceS(),

            Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                fontSize: AppDimens.textSize16,
              ),
            ),
          ],
        ),

        UiUtils.addVerticalSpaceM(),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.padding16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.dimen16),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildSectionDivider() {
    return Divider(
      height: 1,
      color: AppColors.textHint.withValues(alpha: 0.12),
    );
  }

  // ---------------------------------------------------------------------------
  // Search Results
  // ---------------------------------------------------------------------------

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
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.padding16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.dimen16),
          ),
          child: Text(
            'No users found',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),
        ),
      );
    }

    return Material(
      elevation: AppDimens.elevation8,
      borderRadius: BorderRadius.circular(AppDimens.dimen16),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 240),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.dimen16),
        ),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: users.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            color: AppColors.textHint.withValues(alpha: 0.12),
          ),
          itemBuilder: (context, index) {
            final user = users[index];

            final userName = '${user.firstName} ${user.lastName}';

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.padding12,
                vertical: AppDimens.padding4,
              ),
              leading: UiUtils.buildAvatarSmall(
                userName: userName,
                profileImageUrl: user.profileImageUrl,
              ),
              title: Text(
                userName,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
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

  void _showSearchOverlay() {
    _removeSearchOverlay();

    _searchOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          width:
              MediaQuery.of(context).size.width -
              (AppDimens.padding16 * 2) -
              (AppDimens.padding16 * 2),
          child: CompositedTransformFollower(
            link: _searchLayerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 64),
            child: _buildSearchResults(),
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

  void _clearSelectedUser() {
    _removeSearchOverlay();
    _enrollClientViewModel.clearSearchUsers();

    setState(() {
      selectedUser = null;
      _searchController.clear();
    });
  }

  // ---------------------------------------------------------------------------
  // Enrollment
  // ---------------------------------------------------------------------------

  void _onEnrollPressed() {
    if (selectedUser == null) {
      UiUtils.showSnackBarError(context, message: 'Please select a user');

      return;
    }

    final age = int.tryParse(_ageController.text.trim());

    final height = double.tryParse(_heightController.text.trim());

    final weight = double.tryParse(_weightController.text.trim());

    final goalWeight = double.tryParse(_goalWeightController.text.trim());

    if ([height, weight, goalWeight, age].any((value) => value == null)) {
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
}
