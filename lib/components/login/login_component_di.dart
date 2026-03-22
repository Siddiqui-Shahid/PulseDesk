import 'package:flutter/material.dart';
import 'models/error_banner_data_model.dart';
import 'models/error_banner_style_model.dart';
import 'models/login_form_data_model.dart';
import 'models/login_form_style_model.dart';
import 'models/login_button_data_model.dart';
import 'models/login_button_style_model.dart';
import 'models/signup_link_data_model.dart';
import 'models/signup_link_style_model.dart';
import 'themes/login_theme_manager.dart';

/// Dependency injection container for login components
class LoginComponentDI {
  static final LoginComponentDI _instance = LoginComponentDI._internal();
  factory LoginComponentDI() => _instance;
  LoginComponentDI._internal();

  final LoginThemeManager _themeManager = LoginThemeManager();

  // ================================
  // THEME MANAGEMENT
  // ================================

  /// Set the global theme for all login components
  void setTheme(LoginThemeType theme) {
    _themeManager.setTheme(theme);
  }

  /// Get current theme
  LoginThemeType get currentTheme => _themeManager.currentTheme;

  /// Set overrides from view models
  void setOverrides({
    ErrorBannerDataModel? errorBannerData,
    ErrorBannerStyleModel? errorBannerStyle,
    LoginFormDataModel? loginFormData,
    LoginFormStyleModel? loginFormStyle,
    LoginButtonDataModel? loginButtonData,
    LoginButtonStyleModel? loginButtonStyle,
    SignupLinkDataModel? signupLinkData,
    SignupLinkStyleModel? signupLinkStyle,
  }) {
    _themeManager.setOverrides(
      errorBannerData: errorBannerData,
      errorBannerStyle: errorBannerStyle,
      loginFormData: loginFormData,
      loginFormStyle: loginFormStyle,
      loginButtonData: loginButtonData,
      loginButtonStyle: loginButtonStyle,
      signupLinkData: signupLinkData,
      signupLinkStyle: signupLinkStyle,
    );
  }

  /// Clear all overrides
  void clearOverrides() {
    _themeManager.clearOverrides();
  }

  // ================================
  // STYLE MODEL FACTORIES
  // ================================

  /// Get error banner style model (uses theme + overrides)
  ErrorBannerStyleModel getErrorBannerStyleModel() {
    return _themeManager.getErrorBannerStyle();
  }

  /// Get login form style model (uses theme + overrides)
  LoginFormStyleModel getLoginFormStyleModel() {
    return _themeManager.getLoginFormStyle();
  }

  /// Get login button style model (uses theme + overrides)
  LoginButtonStyleModel getLoginButtonStyleModel() {
    return _themeManager.getLoginButtonStyle();
  }

  /// Get signup link style model (uses theme + overrides)
  SignupLinkStyleModel getSignupLinkStyleModel() {
    return _themeManager.getSignupLinkStyle();
  }

  // ================================
  // DATA MODEL FACTORIES WITH OVERRIDE SUPPORT
  // ================================

  /// Create error banner data model with theme defaults + parameters + overrides
  ErrorBannerDataModel createErrorBannerDataModel({
    String? errorMessage,
    bool? isVisible,
  }) {
    return _themeManager.getErrorBannerData(
      errorMessage: errorMessage,
      isVisible: isVisible,
    );
  }

  /// Create login form data model with theme defaults + parameters + overrides
  LoginFormDataModel createLoginFormDataModel({
    String? emailValue,
    String? passwordValue,
    bool? isEnabled,
    String? emailLabel,
    String? passwordLabel,
  }) {
    return _themeManager.getLoginFormData(
      emailValue: emailValue,
      passwordValue: passwordValue,
      isEnabled: isEnabled,
      emailLabel: emailLabel,
      passwordLabel: passwordLabel,
    );
  }

  /// Create login button data model with theme defaults + parameters + overrides
  LoginButtonDataModel createLoginButtonDataModel({
    bool? isLoading,
    bool? isEnabled,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return _themeManager.getLoginButtonData(
      isLoading: isLoading,
      isEnabled: isEnabled,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }

  /// Create signup link data model with theme defaults + parameters + overrides
  SignupLinkDataModel createSignupLinkDataModel({
    bool? isEnabled,
    String? prefixText,
    String? linkText,
    VoidCallback? onTap,
  }) {
    return _themeManager.getSignupLinkData(
      isEnabled: isEnabled,
      prefixText: prefixText,
      linkText: linkText,
      onTap: onTap,
    );
  }
}
