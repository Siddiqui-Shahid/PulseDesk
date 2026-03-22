import 'package:flutter/material.dart';
import '../models/error_banner_data_model.dart';
import '../models/error_banner_style_model.dart';
import '../models/login_form_data_model.dart';
import '../models/login_form_style_model.dart';
import '../models/login_button_data_model.dart';
import '../models/login_button_style_model.dart';
import '../models/signup_link_data_model.dart';
import '../models/signup_link_style_model.dart';

/// Default themes for each login component
class LoginDefaultThemes {
  // ================================
  // ERROR BANNER DEFAULTS
  // ================================

  static ErrorBannerDataModel get defaultErrorBannerData =>
      const ErrorBannerDataModel(errorMessage: null, isVisible: false);

  static ErrorBannerStyleModel get defaultErrorBannerStyle =>
      const ErrorBannerStyleModel(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        backgroundColor: Color(0xFFFFEBEE), // Light red background
        borderColor: Color(0xFFE57373), // Red border
        borderWidth: 1.5,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        iconColor: Color(0xFFD32F2F), // Dark red icon
        iconSize: 20,
        textColor: Color(0xFFC62828), // Dark red text
        fontSize: 13,
        textHeight: 1.5,
        spacingBetweenIconAndText: 8,
        marginBottom: EdgeInsets.only(bottom: 24),
      );

  // ================================
  // LOGIN FORM DEFAULTS
  // ================================

  static LoginFormDataModel get defaultLoginFormData =>
      const LoginFormDataModel(
        emailValue: '',
        passwordValue: '',
        isEnabled: true,
        emailLabel: 'Email',
        passwordLabel: 'Password',
      );

  static LoginFormStyleModel get defaultLoginFormStyle =>
      const LoginFormStyleModel(
        fieldSpacing: 12,
        emailDecoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        passwordDecoration: InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        emailKeyboardType: TextInputType.emailAddress,
        obscurePassword: true,
        marginBottom: EdgeInsets.only(bottom: 24),
      );

  // ================================
  // LOGIN BUTTON DEFAULTS
  // ================================

  static LoginButtonDataModel get defaultLoginButtonData =>
      const LoginButtonDataModel(
        isLoading: false,
        isEnabled: true,
        buttonText: 'Login',
        onPressed: null,
      );

  static LoginButtonStyleModel get defaultLoginButtonStyle =>
      const LoginButtonStyleModel(
        width: double.infinity,
        height: 48,
        loadingIndicatorSize: 20,
        loadingStrokeWidth: 2,
        loadingColor: Colors.white,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        marginBottom: EdgeInsets.only(bottom: 16),
      );

  // ================================
  // SIGNUP LINK DEFAULTS
  // ================================

  static SignupLinkDataModel get defaultSignupLinkData =>
      const SignupLinkDataModel(
        isEnabled: true,
        prefixText: "Don't have an account? ",
        linkText: 'Sign Up',
        onTap: null,
      );

  static SignupLinkStyleModel get defaultSignupLinkStyle =>
      const SignupLinkStyleModel(
        alignment: MainAxisAlignment.center,
        enabledLinkColor: Colors.blue,
        disabledLinkColor: Colors.grey,
        linkFontWeight: FontWeight.bold,
        prefixTextStyle: TextStyle(fontSize: 14, color: Colors.black87),
        spacing: 0,
        marginTop: EdgeInsets.only(top: 16),
      );

  // ================================
  // THEME VARIATIONS
  // ================================
}

/// Dark theme variants
class LoginDarkTheme {
  static ErrorBannerStyleModel get errorBannerStyle =>
      const ErrorBannerStyleModel(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        backgroundColor: Color(0xFF3E2723), // Dark brown
        borderColor: Color(0xFFD84315), // Dark orange
        borderWidth: 1.5,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        iconColor: Color(0xFFFF5722), // Orange
        iconSize: 20,
        textColor: Color(0xFFFFAB91), // Light orange
        fontSize: 13,
        textHeight: 1.5,
        spacingBetweenIconAndText: 8,
        marginBottom: EdgeInsets.only(bottom: 24),
      );

  static LoginFormStyleModel get loginFormStyle => const LoginFormStyleModel(
    fieldSpacing: 12,
    emailDecoration: InputDecoration(
      labelText: 'Email',
      border: OutlineInputBorder(),
      fillColor: Color(0xFF424242),
      filled: true,
      labelStyle: TextStyle(color: Colors.white70),
    ),
    passwordDecoration: InputDecoration(
      labelText: 'Password',
      border: OutlineInputBorder(),
      fillColor: Color(0xFF424242),
      filled: true,
      labelStyle: TextStyle(color: Colors.white70),
    ),
    emailKeyboardType: TextInputType.emailAddress,
    obscurePassword: true,
    marginBottom: EdgeInsets.only(bottom: 24),
  );

  static LoginButtonStyleModel get loginButtonStyle =>
      const LoginButtonStyleModel(
        width: double.infinity,
        height: 56,
        loadingIndicatorSize: 20,
        loadingStrokeWidth: 2,
        loadingColor: Color(0xFF81C784), // Light green
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        marginBottom: EdgeInsets.only(bottom: 16),
      );

  static SignupLinkStyleModel get signupLinkStyle => const SignupLinkStyleModel(
    alignment: MainAxisAlignment.center,
    enabledLinkColor: Color(0xFF81C784), // Light green
    disabledLinkColor: Colors.grey,
    linkFontWeight: FontWeight.bold,
    prefixTextStyle: TextStyle(fontSize: 14, color: Colors.white70),
    spacing: 0,
    marginTop: EdgeInsets.only(top: 16),
  );
}

/// Compact theme variants (smaller components)
class LoginCompactTheme {
  static ErrorBannerStyleModel get errorBannerStyle =>
      const ErrorBannerStyleModel(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(bottom: 12),
        backgroundColor: Color(0xFFFFEBEE),
        borderColor: Color(0xFFE57373),
        borderWidth: 1,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        iconColor: Color(0xFFD32F2F),
        iconSize: 18,
        textColor: Color(0xFFC62828),
        fontSize: 12,
        textHeight: 1.4,
        spacingBetweenIconAndText: 6,
        marginBottom: EdgeInsets.only(bottom: 20),
      );

  static LoginFormStyleModel get loginFormStyle => const LoginFormStyleModel(
    fieldSpacing: 8,
    emailDecoration: InputDecoration(
      labelText: 'Email',
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
    ),
    passwordDecoration: InputDecoration(
      labelText: 'Password',
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
    ),
    emailKeyboardType: TextInputType.emailAddress,
    obscurePassword: true,
    marginBottom: EdgeInsets.only(bottom: 20),
  );

  static LoginButtonStyleModel get loginButtonStyle =>
      const LoginButtonStyleModel(
        width: double.infinity,
        height: 40,
        loadingIndicatorSize: 16,
        loadingStrokeWidth: 2,
        loadingColor: Colors.white,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        marginBottom: EdgeInsets.only(bottom: 12),
      );

  static SignupLinkStyleModel get signupLinkStyle => const SignupLinkStyleModel(
    alignment: MainAxisAlignment.center,
    enabledLinkColor: Colors.blue,
    disabledLinkColor: Colors.grey,
    linkFontWeight: FontWeight.w600,
    prefixTextStyle: TextStyle(fontSize: 13, color: Colors.black87),
    spacing: 0,
    marginTop: EdgeInsets.only(top: 12),
  );
}
