import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/app/app_constants.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/routes.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/auth/presentation/viewmodels/login_viewmodel.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/state/ui_state.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/custom_scaffold.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../provider/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginViewModel get _loginViewModel =>
      ref.read(loginViewModelProvider.notifier);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    _loginViewModel.login(email, password);
  }

  void _onForgotPasswordPressed() {
    // TODO: Implement forgot password
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(loginViewModelProvider);

    // Listeners
    ref.listen<UiState>(loginViewModelProvider, (previous, next) {
      final wasLoading = previous?.isLoading ?? false;
      final isFinished = wasLoading && !next.isLoading;

      if (!isFinished || !mounted) return;

      if (next.errorMessage == null) {
        UiUtils.showSnackBarSuccess(context, message: "Successfully logged in");
        NavigationUtils.replaceWith(context, AppRoutes.mainFeed);
      } else {
        UiUtils.showSnackBarError(context, message: next.errorMessage!);
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        showAppBar: false,
        isLoading: uiState.isLoading,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset('assets/images/home.png', fit: BoxFit.cover),

            // Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.70),
                    Colors.black.withValues(alpha: 0.82),
                    Colors.black.withValues(alpha: 0.92),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.dimen24,
                vertical: AppDimens.dimen20,
              ),
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    AppDimens.dimen40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UiUtils.addVerticalSpaceXXL(),

                        // Hero
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(AppDimens.dimen20),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              AppConstants.appName[0],
                              style: AppTextStyles.heading1.copyWith(
                                fontSize: AppDimens.textSize48,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),

                        UiUtils.addVerticalSpaceXXL(),

                        Text(
                          AppStrings.welcomeBack,
                          style: AppTextStyles.heading1,
                        ),

                        UiUtils.addVerticalSpaceS(),

                        Text(
                          AppStrings.welcomeMessage,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),

                        UiUtils.addVerticalSpaceXXL(),

                        // Login section
                        Text(AppStrings.login, style: AppTextStyles.heading3),

                        UiUtils.addVerticalSpaceL(),

                        _buildForm(),

                        UiUtils.addVerticalSpaceXL(),

                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            onPressed: uiState.isLoading
                                ? null
                                : _onLoginPressed,
                            label: AppStrings.login,
                          ),
                        ),

                        UiUtils.addVerticalSpaceL(),

                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => uiState.isLoading
                                ? null
                                : _onForgotPasswordPressed,
                            child: Text(
                              AppStrings.forgotPassword,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "${AppStrings.dontHaveAnAccount} ",
                              style: AppTextStyles.bodySmall,
                              children: [
                                TextSpan(
                                  text: AppStrings.registerHere,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      NavigationUtils.navigateTo(
                                        context,
                                        AppRoutes.register,
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        UiUtils.addVerticalSpaceL(),
                        Center(child: UiUtils.addCopyright()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FORMS
  Widget _buildForm() {
    return Column(
      children: [
        CustomTextField(hint: AppStrings.email, controller: _emailController),

        UiUtils.addVerticalSpaceM(),

        CustomTextField(
          hint: AppStrings.password,
          controller: _passwordController,
          obscureText: true,
        ),
      ],
    );
  }
}
