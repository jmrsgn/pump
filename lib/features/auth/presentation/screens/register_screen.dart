import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/utils/ui_utils.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/providers/ui_state.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/custom_scaffold.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/routes.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../providers/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isCoach = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final role = isCoach ? 2 : 1;

    ref
        .read(registerViewModelProvider.notifier)
        .register(firstName, lastName, email, phone, role, password);
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(registerViewModelProvider);

    ref.listen<UiState>(registerViewModelProvider, (previous, next) {
      if (previous?.isLoading == true && next.isLoading == false) {
        if (!mounted) return;

        if (next.errorMessage == null) {
          UiUtils.showSnackBarSuccess(
            context,
            message: "User registered successfully",
          );
          NavigationUtils.replaceWith(context, AppRoutes.login);
        } else {
          UiUtils.showSnackBarError(context, message: next.errorMessage!);
        }
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        isLoading: uiState.isLoading,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.paddingScreen),
                child: Column(
                  children: [
                    UiUtils.addVerticalSpaceS(),

                    Text(
                      AppStrings.userRegistration,
                      style: AppTextStyles.heading2,
                    ),

                    UiUtils.addVerticalSpaceXXL(),

                    _buildNameFields(),
                    UiUtils.addVerticalSpaceM(),

                    _buildEmailField(),
                    UiUtils.addVerticalSpaceM(),

                    _buildPhoneField(),
                    UiUtils.addVerticalSpaceM(),

                    _buildPasswordField(),
                    UiUtils.addVerticalSpaceM(),

                    _buildRoleSwitch(),
                    UiUtils.addVerticalSpaceL(),

                    _buildRegisterButton(uiState),

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

  // UI Components
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

  Widget _buildPasswordField() {
    return CustomTextField(
      hint: AppStrings.password,
      controller: _passwordController,
      obscureText: true,
    );
  }

  Widget _buildRoleSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: "${AppStrings.iAmSigningUpAsA} ",
            style: AppTextStyles.body,
            children: [
              TextSpan(
                text: isCoach ? AppStrings.coach : AppStrings.client,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        UiUtils.addHorizontalSpaceXS(),
        Switch(
          activeThumbColor: AppColors.primary,
          value: isCoach,
          onChanged: (value) => setState(() => isCoach = value),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(UiState uiState) {
    return SizedBox(
      width: AppDimens.dimen180,
      child: CustomButton(
        onPressed: uiState.isLoading ? null : _onRegisterPressed,
        label: AppStrings.register,
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.padding8),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: UiUtils.addCopyright(),
      ),
    );
  }
}
