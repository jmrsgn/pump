import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/app/app_constants.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/routes.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/providers/ui_state.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/custom_scaffold.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = _emailController.text;
    final password = _passwordController.text;
    ref.read(loginViewModelProvider.notifier).login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(loginViewModelProvider);

    ref.listen<UiState>(loginViewModelProvider, (previous, next) {
      if (previous?.isLoading == true && next.isLoading == false) {
        if (!mounted) return;

        if (next.errorMessage == null) {
          UiUtils.showSnackBarSuccess(
            context,
            message: "Successfully logged in",
          );
          NavigationUtils.replaceWith(context, AppRoutes.mainFeed);
        } else {
          UiUtils.showSnackBarError(context, message: next.errorMessage!);
        }
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
            Image.asset('assets/images/home.png', fit: BoxFit.cover),
            Container(color: AppColors.overlay),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.padding16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstants.appName.toUpperCase(),
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: AppDimens.textSize32,
                      ),
                    ),

                    UiUtils.addVerticalSpaceXL(),

                    _buildForm(),

                    UiUtils.addVerticalSpaceM(),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        width: AppDimens.dimen120,
                        child: CustomButton(
                          onPressed: uiState.isLoading ? null : _onLoginPressed,
                          label: AppStrings.login,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Center(
      child: Column(
        children: [
          CustomTextField(hint: AppStrings.email, controller: _emailController),
          UiUtils.addVerticalSpaceM(),
          CustomTextField(
            hint: AppStrings.password,
            controller: _passwordController,
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: AppDimens.padding32),
        child: RichText(
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
                    NavigationUtils.navigateTo(context, AppRoutes.register);
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
