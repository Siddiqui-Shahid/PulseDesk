import 'package:flutter/material.dart';
import '../models/error_banner_data_model.dart';
import '../models/error_banner_style_model.dart';
import '../models/login_form_data_model.dart';
import '../models/login_form_style_model.dart';
import '../models/login_button_data_model.dart';
import '../models/login_button_style_model.dart';
import '../models/signup_link_data_model.dart';
import '../models/signup_link_style_model.dart';
import 'login_default_themes.dart';

/// Theme types available for login components
enum LoginThemeType {
  /// Standard theme with default sizing and colors
  standard,

  /// Dark theme with dark backgrounds and light text
  dark,

  /// Compact theme with smaller components
  compact,
}

/// Manages themes for login components with override capability
class LoginThemeManager {
  static final LoginThemeManager _instance = LoginThemeManager._internal();
  factory LoginThemeManager() => _instance;
  LoginThemeManager._internal();

  LoginThemeType _currentTheme = LoginThemeType.standard;

  // Override storage for custom themes from view models
  ErrorBannerDataModel? _errorBannerDataOverride;
  ErrorBannerStyleModel? _errorBannerStyleOverride;
  LoginFormDataModel? _loginFormDataOverride;
  LoginFormStyleModel? _loginFormStyleOverride;
  LoginButtonDataModel? _loginButtonDataOverride;
  LoginButtonStyleModel? _loginButtonStyleOverride;
  SignupLinkDataModel? _signupLinkDataOverride;
  SignupLinkStyleModel? _signupLinkStyleOverride;

  /// Set the active theme type
  void setTheme(LoginThemeType theme) {
    _currentTheme = theme;
  }

  /// Get current theme type
  LoginThemeType get currentTheme => _currentTheme;

  // ================================
  // DATA MODEL GETTERS WITH OVERRIDES
  // ================================

  /// Get error banner data model (override takes priority)
  ErrorBannerDataModel getErrorBannerData({
    String? errorMessage,
    bool? isVisible,
  }) {
    // If override exists, merge with provided parameters
    if (_errorBannerDataOverride != null) {
      return _errorBannerDataOverride!.copyWith(
        errorMessage: errorMessage ?? _errorBannerDataOverride!.errorMessage,
        isVisible: isVisible ?? _errorBannerDataOverride!.isVisible,
      );
    }

    // Otherwise use defaults with provided parameters
    return LoginDefaultThemes.defaultErrorBannerData.copyWith(
      errorMessage: errorMessage,
      isVisible:
          isVisible ?? LoginDefaultThemes.defaultErrorBannerData.isVisible,
    );
  }

  /// Get login form data model (override takes priority)
  LoginFormDataModel getLoginFormData({
    String? emailValue,
    String? passwordValue,
    bool? isEnabled,
    String? emailLabel,
    String? passwordLabel,
  }) {
    if (_loginFormDataOverride != null) {
      return _loginFormDataOverride!.copyWith(
        emailValue: emailValue ?? _loginFormDataOverride!.emailValue,
        passwordValue: passwordValue ?? _loginFormDataOverride!.passwordValue,
        isEnabled: isEnabled ?? _loginFormDataOverride!.isEnabled,
        emailLabel: emailLabel ?? _loginFormDataOverride!.emailLabel,
        passwordLabel: passwordLabel ?? _loginFormDataOverride!.passwordLabel,
      );
    }

    return LoginDefaultThemes.defaultLoginFormData.copyWith(
      emailValue:
          emailValue ?? LoginDefaultThemes.defaultLoginFormData.emailValue,
      passwordValue:
          passwordValue ??
          LoginDefaultThemes.defaultLoginFormData.passwordValue,
      isEnabled: isEnabled ?? LoginDefaultThemes.defaultLoginFormData.isEnabled,
      emailLabel:
          emailLabel ?? LoginDefaultThemes.defaultLoginFormData.emailLabel,
      passwordLabel:
          passwordLabel ??
          LoginDefaultThemes.defaultLoginFormData.passwordLabel,
    );
  }

  /// Get login button data model (override takes priority)
  LoginButtonDataModel getLoginButtonData({
    bool? isLoading,
    bool? isEnabled,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    if (_loginButtonDataOverride != null) {
      return _loginButtonDataOverride!.copyWith(
        isLoading: isLoading ?? _loginButtonDataOverride!.isLoading,
        isEnabled: isEnabled ?? _loginButtonDataOverride!.isEnabled,
        buttonText: buttonText ?? _loginButtonDataOverride!.buttonText,
        onPressed: onPressed ?? _loginButtonDataOverride!.onPressed,
      );
    }

    return LoginDefaultThemes.defaultLoginButtonData.copyWith(
      isLoading:
          isLoading ?? LoginDefaultThemes.defaultLoginButtonData.isLoading,
      isEnabled:
          isEnabled ?? LoginDefaultThemes.defaultLoginButtonData.isEnabled,
      buttonText:
          buttonText ?? LoginDefaultThemes.defaultLoginButtonData.buttonText,
      onPressed: onPressed,
    );
  }

  /// Get signup link data model (override takes priority)
  SignupLinkDataModel getSignupLinkData({
    bool? isEnabled,
    String? prefixText,
    String? linkText,
    VoidCallback? onTap,
  }) {
    if (_signupLinkDataOverride != null) {
      return _signupLinkDataOverride!.copyWith(
        isEnabled: isEnabled ?? _signupLinkDataOverride!.isEnabled,
        prefixText: prefixText ?? _signupLinkDataOverride!.prefixText,
        linkText: linkText ?? _signupLinkDataOverride!.linkText,
        onTap: onTap ?? _signupLinkDataOverride!.onTap,
      );
    }

    return LoginDefaultThemes.defaultSignupLinkData.copyWith(
      isEnabled:
          isEnabled ?? LoginDefaultThemes.defaultSignupLinkData.isEnabled,
      prefixText:
          prefixText ?? LoginDefaultThemes.defaultSignupLinkData.prefixText,
      linkText: linkText ?? LoginDefaultThemes.defaultSignupLinkData.linkText,
      onTap: onTap,
    );
  }

  // ================================
  // STYLE MODEL GETTERS WITH THEMES
  // ================================

  /// Get error banner style model based on current theme or override
  ErrorBannerStyleModel getErrorBannerStyle() {
    if (_errorBannerStyleOverride != null) {
      return _errorBannerStyleOverride!;
    }

    switch (_currentTheme) {
      case LoginThemeType.dark:
        return LoginDarkTheme.errorBannerStyle;
      case LoginThemeType.compact:
        return LoginCompactTheme.errorBannerStyle;
      case LoginThemeType.standard:
      default:
        return LoginDefaultThemes.defaultErrorBannerStyle;
    }
  }

  /// Get login form style model based on current theme or override
  LoginFormStyleModel getLoginFormStyle() {
    if (_loginFormStyleOverride != null) {
      return _loginFormStyleOverride!;
    }

    switch (_currentTheme) {
      case LoginThemeType.dark:
        return LoginDarkTheme.loginFormStyle;
      case LoginThemeType.compact:
        return LoginCompactTheme.loginFormStyle;
      case LoginThemeType.standard:
      default:
        return LoginDefaultThemes.defaultLoginFormStyle;
    }
  }

  /// Get login button style model based on current theme or override
  LoginButtonStyleModel getLoginButtonStyle() {
    if (_loginButtonStyleOverride != null) {
      return _loginButtonStyleOverride!;
    }

    switch (_currentTheme) {
      case LoginThemeType.dark:
        return LoginDarkTheme.loginButtonStyle;
      case LoginThemeType.compact:
        return LoginCompactTheme.loginButtonStyle;
      case LoginThemeType.standard:
      default:
        return LoginDefaultThemes.defaultLoginButtonStyle;
    }
  }

  /// Get signup link style model based on current theme or override
  SignupLinkStyleModel getSignupLinkStyle() {
    if (_signupLinkStyleOverride != null) {
      return _signupLinkStyleOverride!;
    }

    switch (_currentTheme) {
      case LoginThemeType.dark:
        return LoginDarkTheme.signupLinkStyle;
      case LoginThemeType.compact:
        return LoginCompactTheme.signupLinkStyle;
      case LoginThemeType.standard:
      default:
        return LoginDefaultThemes.defaultSignupLinkStyle;
    }
  }

  // ================================
  // OVERRIDE METHODS FOR VIEW MODELS
  // ================================

  /// Set overrides that will take priority over theme defaults
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
    _errorBannerDataOverride = errorBannerData;
    _errorBannerStyleOverride = errorBannerStyle;
    _loginFormDataOverride = loginFormData;
    _loginFormStyleOverride = loginFormStyle;
    _loginButtonDataOverride = loginButtonData;
    _loginButtonStyleOverride = loginButtonStyle;
    _signupLinkDataOverride = signupLinkData;
    _signupLinkStyleOverride = signupLinkStyle;
  }

  /// Clear all overrides (return to theme defaults)
  void clearOverrides() {
    _errorBannerDataOverride = null;
    _errorBannerStyleOverride = null;
    _loginFormDataOverride = null;
    _loginFormStyleOverride = null;
    _loginButtonDataOverride = null;
    _loginButtonStyleOverride = null;
    _signupLinkDataOverride = null;
    _signupLinkStyleOverride = null;
  }

  /// Clear specific component override
  void clearOverride({
    bool errorBannerData = false,
    bool errorBannerStyle = false,
    bool loginFormData = false,
    bool loginFormStyle = false,
    bool loginButtonData = false,
    bool loginButtonStyle = false,
    bool signupLinkData = false,
    bool signupLinkStyle = false,
  }) {
    if (errorBannerData) _errorBannerDataOverride = null;
    if (errorBannerStyle) _errorBannerStyleOverride = null;
    if (loginFormData) _loginFormDataOverride = null;
    if (loginFormStyle) _loginFormStyleOverride = null;
    if (loginButtonData) _loginButtonDataOverride = null;
    if (loginButtonStyle) _loginButtonStyleOverride = null;
    if (signupLinkData) _signupLinkDataOverride = null;
    if (signupLinkStyle) _signupLinkStyleOverride = null;
  }
}
