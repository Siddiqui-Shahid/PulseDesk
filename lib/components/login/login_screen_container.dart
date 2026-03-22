import 'package:flutter/material.dart';
import 'widgets/error_banner_component.dart';
import 'widgets/login_form_component.dart';
import 'widgets/login_button_component.dart';
import 'widgets/signup_link_component.dart';
import 'login_component_di.dart';

/// Login screen container that composes all login components
class LoginScreenContainer extends StatelessWidget {
  final String? errorMessage;
  final bool isLoading;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;
  final VoidCallback onSignupPressed;
  late final LoginComponentDI _di;

  LoginScreenContainer({
    super.key,
    this.errorMessage,
    required this.isLoading,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
    required this.onSignupPressed,
  }) {
    _di = LoginComponentDI();
  }

  @override
  Widget build(BuildContext context) {
    // Get all style models for spacing reference
    final errorBannerStyle = _di.getErrorBannerStyleModel();
    final loginFormStyle = _di.getLoginFormStyleModel();
    final loginButtonStyle = _di.getLoginButtonStyleModel();
    final signupLinkStyle = _di.getSignupLinkStyleModel();

    // Create data models using dependency injection
    final errorBannerData = _di.createErrorBannerDataModel(
      errorMessage: errorMessage,
      isVisible: errorMessage != null,
    );

    final loginFormData = _di.createLoginFormDataModel(
      emailValue: emailController.text,
      passwordValue: passwordController.text,
      isEnabled: !isLoading,
    );

    final loginButtonData = _di.createLoginButtonDataModel(
      isLoading: isLoading,
      isEnabled: !isLoading,
      onPressed: onLoginPressed,
    );

    final signupLinkData = _di.createSignupLinkDataModel(
      isEnabled: !isLoading,
      onTap: onSignupPressed,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error Banner Component with bottom padding
            Padding(
              padding: errorBannerStyle.marginBottom,
              child: ErrorBannerComponent(dataModel: errorBannerData),
            ),

            // Login Form Component with bottom padding
            Padding(
              padding: loginFormStyle.marginBottom,
              child: LoginFormComponent(
                dataModel: loginFormData,
                emailController: emailController,
                passwordController: passwordController,
              ),
            ),

            // Login Button Component with bottom padding
            Padding(
              padding: loginButtonStyle.marginBottom,
              child: LoginButtonComponent(dataModel: loginButtonData),
            ),

            // Signup Link Component
            Padding(
              padding: signupLinkStyle.marginTop,
              child: SignupLinkComponent(dataModel: signupLinkData),
            ),
          ],
        ),
      ),
    );
  }
}
