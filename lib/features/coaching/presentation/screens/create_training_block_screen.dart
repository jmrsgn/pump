import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/app_routes.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/presentation/widgets/custom_text_field.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/coaching/data/enums/training_split.dart';
import 'package:pump/features/coaching/data/dto/request/create_training_block_request_dto.dart';
import 'package:pump/features/coaching/domain/entity/client_user.dart';
import 'package:pump/features/coaching/presentation/provider/training_block_providers.dart';
import 'package:pump/features/coaching/presentation/state/create_training_block_state.dart';

class CreateTrainingBlockScreen extends ConsumerStatefulWidget {
  final ClientUser client;

  const CreateTrainingBlockScreen({super.key, required this.client});

  @override
  ConsumerState<CreateTrainingBlockScreen> createState() =>
      _CreateTrainingBlockScreenState();
}

class _CreateTrainingBlockScreenState
    extends ConsumerState<CreateTrainingBlockScreen> {
  // ---------------------------------------------------------------------------
  // Controllers
  // ---------------------------------------------------------------------------

  final _planNameController = TextEditingController();
  final _numberOfWeeksController = TextEditingController();
  final _trainingDaysController = TextEditingController();

  final _maintenanceInputController = TextEditingController();

  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();

  final _stepsController = TextEditingController();
  final _notesController = TextEditingController();

  // ---------------------------------------------------------------------------
  // Temporary UI state
  // ---------------------------------------------------------------------------

  final Set<TrainingSplit> _selectedSplits = {
    TrainingSplit.pull,
    TrainingSplit.legs,
    TrainingSplit.push,
    TrainingSplit.fullBody,
  };

  String? _maintenanceResult;

  @override
  void dispose() {
    _planNameController.dispose();
    _numberOfWeeksController.dispose();
    _trainingDaysController.dispose();
    _maintenanceInputController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    _stepsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final createTrainingBlockState = ref.watch(
      createTrainingBlockViewModelProvider,
    );

    ref.listen<CreateTrainingBlockState>(createTrainingBlockViewModelProvider, (
      previous,
      next,
    ) {
      if (previous?.isLoading != true || next.isLoading || !mounted) return;

      if (next.isCreateSuccess) {
        NavigationUtils.navigateAndRemoveAll(context, AppRoutes.clients);
      } else if (next.errorMessage != null) {
        UiUtils.showSnackBarError(context, message: next.errorMessage!);
      }
    });

    return CustomScaffold(
      appBarTitle: 'Create Training Block',
      backgroundColor: AppColors.background,
      isLoading: createTrainingBlockState.isLoading,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: AppDimens.padding16,
            right: AppDimens.padding16,
            top: AppDimens.padding16,
            bottom: AppDimens.padding16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClientSection(),

              UiUtils.addVerticalSpaceL(),

              _buildBlockDetailsSection(),

              UiUtils.addVerticalSpaceL(),

              _buildMaintenanceSection(),

              UiUtils.addVerticalSpaceL(),

              _buildNutritionSection(),

              UiUtils.addVerticalSpaceL(),

              _buildActivitySection(),

              UiUtils.addVerticalSpaceL(),

              _buildNotesSection(),

              UiUtils.addVerticalSpaceL(),

              _buildCreateButton(),
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
    final clientName = widget.client.fullName.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Client'),

        UiUtils.addVerticalSpaceS(),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimens.padding16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.dimen16),
          ),
          child: Row(
            children: [
              _buildClientAvatar(clientName),

              UiUtils.addHorizontalSpaceM(),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientName,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    UiUtils.addVerticalSpaceXS(),

                    Text(
                      '${widget.client.age} years old • '
                      '${widget.client.gender.value}',
                      style: AppTextStyles.bodySmall,
                    ),

                    UiUtils.addVerticalSpaceXS(),

                    Text(
                      '${widget.client.heightCm.toStringAsFixed(0)} cm • '
                      '${widget.client.currentWeight.toStringAsFixed(1)} kg',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClientAvatar(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      width: AppDimens.dimen44,
      height: AppDimens.dimen44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.dimen12),
      ),
      child: Text(
        initial,
        style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Block Details
  // ---------------------------------------------------------------------------

  Widget _buildBlockDetailsSection() {
    return _buildSection(
      title: 'Training Block',
      icon: Icons.fitness_center_outlined,
      children: [
        CustomTextField(
          hint: 'Plan Name',
          controller: _planNameController,
          prefixIcon: const Icon(Icons.edit_outlined),
        ),

        UiUtils.addVerticalSpaceM(),

        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hint: 'Number of Weeks',
                controller: _numberOfWeeksController,
                keyboardType: TextInputType.number,
              ),
            ),

            UiUtils.addHorizontalSpaceS(),

            Expanded(
              child: CustomTextField(
                hint: 'Training Days / Week',
                controller: _trainingDaysController,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),

        UiUtils.addVerticalSpaceL(),

        Text(
          'Training Split',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),

        UiUtils.addVerticalSpaceS(),

        _buildSplitSelection(),
      ],
    );
  }

  Widget _buildSplitSelection() {
    return Wrap(
      spacing: AppDimens.dimen8,
      runSpacing: AppDimens.dimen8,
      children: TrainingSplit.values.map((split) {
        final isSelected = _selectedSplits.contains(split);

        return InkWell(
          borderRadius: BorderRadius.circular(AppDimens.dimen50),
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedSplits.remove(split);
              } else {
                _selectedSplits.add(split);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.padding12,
              vertical: AppDimens.padding8,
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
              split.label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Maintenance Calculator
  // ---------------------------------------------------------------------------

  Widget _buildMaintenanceSection() {
    return _buildSection(
      title: 'Maintenance Calculator',
      icon: Icons.calculate_outlined,
      children: [
        Text(
          'Use a maintenance calculator to estimate the client\'s '
          'current daily energy needs.',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
        ),

        UiUtils.addVerticalSpaceM(),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomTextField(
                hint: 'Enter estimate',
                controller: _maintenanceInputController,
                keyboardType: TextInputType.number,
              ),
            ),

            UiUtils.addHorizontalSpaceS(),

            CustomButton(
              onPressed: _onCalculateMaintenance,
              label: 'Calculate',
            ),
          ],
        ),

        if (_maintenanceResult != null) ...[
          UiUtils.addVerticalSpaceM(),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.padding16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppDimens.dimen12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Maintenance',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),

                UiUtils.addVerticalSpaceXS(),

                Text(
                  _maintenanceResult!,
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],

        UiUtils.addVerticalSpaceL(),

        Text(
          'You can also use this online tool to calculate '
          'an estimate.',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
        ),

        UiUtils.addVerticalSpaceS(),

        _buildResourceLink(title: 'Online Nutrition Calculator (Online Tool))'),
      ],
    );
  }

  Widget _buildResourceLink({required String title}) {
    return InkWell(
      onTap: () {
        // TODO: Replace with actual external URLs.
        UiUtils.showSnackBarSuccess(
          context,
          message: 'Online tool link will be added later.',
        );
      },
      borderRadius: BorderRadius.circular(AppDimens.dimen8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.padding8),
        child: Row(
          children: [
            Icon(
              Icons.open_in_new,
              size: AppDimens.dimen18,
              color: AppColors.primary,
            ),

            UiUtils.addHorizontalSpaceS(),

            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCalculateMaintenance() {
    final input = _maintenanceInputController.text.trim();

    if (input.isEmpty) {
      UiUtils.showSnackBarError(context, message: 'Please enter an estimate.');
      return;
    }

    // UI-only mock calculation for now.
    setState(() {
      _maintenanceResult = '$input (mock)';
    });
  }

  // ---------------------------------------------------------------------------
  // Nutrition
  // ---------------------------------------------------------------------------

  Widget _buildNutritionSection() {
    return _buildSection(
      title: 'Nutrition',
      icon: Icons.restaurant_outlined,
      children: [
        Text(
          'Daily Macros',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),

        UiUtils.addVerticalSpaceS(),

        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hint: 'Protein (g)',
                controller: _proteinController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),

            UiUtils.addHorizontalSpaceS(),

            Expanded(
              child: CustomTextField(
                hint: 'Carbs (g)',
                controller: _carbsController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
          ],
        ),

        UiUtils.addVerticalSpaceM(),

        CustomTextField(
          hint: 'Fats (g)',
          controller: _fatsController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Activity
  // ---------------------------------------------------------------------------

  Widget _buildActivitySection() {
    return _buildSection(
      title: 'Activity',
      icon: Icons.directions_walk_outlined,
      children: [
        CustomTextField(
          hint: 'Required Daily Steps',
          controller: _stepsController,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.directions_walk_outlined),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Notes
  // ---------------------------------------------------------------------------

  Widget _buildNotesSection() {
    return _buildSection(
      title: 'Coach Notes',
      icon: Icons.notes_outlined,
      children: [
        CustomTextField(
          hint: 'Additional instructions or notes',
          controller: _notesController,
          isMultiline: true,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Shared Section
  // ---------------------------------------------------------------------------

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: AppTextStyles.heading3.copyWith(fontSize: AppDimens.textSize16),
    );
  }

  // ---------------------------------------------------------------------------
  // Create
  // ---------------------------------------------------------------------------

  Widget _buildCreateButton() {
    final isLoading = ref.watch(createTrainingBlockViewModelProvider).isLoading;
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        onPressed: isLoading ? null : _onCreatePressed,
        label: 'Create Training Block',
      ),
    );
  }

  void _onCreatePressed() {
    if (ref.read(createTrainingBlockViewModelProvider).isLoading) return;

    if (_planNameController.text.trim().isEmpty) {
      UiUtils.showSnackBarError(context, message: 'Please enter a plan name.');
      return;
    }

    if (_selectedSplits.isEmpty) {
      UiUtils.showSnackBarError(
        context,
        message: 'Please select at least one training split.',
      );
      return;
    }

    int? readInteger(TextEditingController controller, String field) {
      final value = int.tryParse(controller.text.trim());
      if (value == null) {
        UiUtils.showSnackBarError(
          context,
          message: 'Please enter a valid $field.',
        );
      }
      return value;
    }

    // Number of weeks
    final numberOfWeeks = readInteger(
      _numberOfWeeksController,
      'number of weeks',
    );
    if (numberOfWeeks == null) return;

    // Training days
    final trainingDays = readInteger(_trainingDaysController, 'training days');
    if (trainingDays == null) return;

    // Estimated Macros
    final estimatedMacros = readInteger(
      _maintenanceInputController,
      'estimate',
    );
    if (estimatedMacros == null) return;

    // Target Protein
    final targetProteinInGrams = readInteger(
      _proteinController,
      'protein target',
    );
    if (targetProteinInGrams == null) return;

    // Target Carbs
    final targetCarbsInGrams = readInteger(_carbsController, 'carbs target');
    if (targetCarbsInGrams == null) return;

    // Target Fat
    final targetFatInGrams = readInteger(_fatsController, 'fat target');
    if (targetFatInGrams == null) return;

    // Required Daily Steps
    final requiredDailySteps = readInteger(_stepsController, 'daily steps');
    if (requiredDailySteps == null) return;

    final notes = _notesController.text.trim();
    final request = CreateTrainingBlockRequest(
      trainingBlockName: _planNameController.text.trim(),
      numberOfWeeks: numberOfWeeks,
      trainingDays: trainingDays,
      trainingSplit: _selectedSplits.map((split) => split.label).join(', '),
      estimatedMacros: estimatedMacros,
      targetProteinInGrams: targetProteinInGrams,
      targetCarbsInGrams: targetCarbsInGrams,
      targetFatInGrams: targetFatInGrams,
      requiredDailySteps: requiredDailySteps,
      otherNotes: notes.isEmpty ? null : notes,
    );

    ref
        .read(createTrainingBlockViewModelProvider.notifier)
        .createTrainingBlock(widget.client.id, request);
  }
}
