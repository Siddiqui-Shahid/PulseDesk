import 'package:flutter/material.dart';
import '../login/login_component_di.dart';
import '../login/themes/login_theme_manager.dart';
import '../login/models/error_banner_style_model.dart';
import '../login/models/login_form_style_model.dart';
import '../login/models/login_button_style_model.dart';
import '../login/models/signup_link_style_model.dart';

/// Theme configuration helper for login components
/// This class provides easy methods to apply predefined themes or custom styles
class LoginThemeConfig {
  
  /// Apply the standard light theme (default)
  static void setupLightTheme() {
    final di = LoginComponentDI();
    di.setTheme(LoginThemeType.standard);
    di.clearOverrides(); // Remove any previous overrides
  }

  /// Apply the dark theme variant
  static void setupDarkTheme() {
    final di = LoginComponentDI();
    di.setTheme(LoginThemeType.dark);
  }

  /// Apply the compact theme variant (smaller components)  
  static void setupCompactTheme() {
    final di = LoginComponentDI();
    di.setTheme(LoginThemeType.compact);
  }

  /// Apply a custom branded theme with your app's colors
  static void setupCustomTheme({
    Color? primaryColor,
    Color? errorColor,
    double? borderRadius,
    double? componentHeight,
  }) {
    final di = LoginComponentDI();
    
    // Start with standard theme as base
    di.setTheme(LoginThemeType.standard);
    
    // Apply custom overrides
    di.setOverrides(
      errorBannerStyle: ErrorBannerStyleModel(
        borderColor: errorColor ?? Colors.red.shade300,
        iconColor: errorColor ?? Colors.red.shade700,
        textColor: errorColor ?? Colors.red.shade800,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? 8),
        ),
      ),
      
      loginButtonStyle: LoginButtonStyleModel(
        width: double.infinity,
        height: componentHeight ?? 48,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius ?? 4),
        ),
      ),
      
      signupLinkStyle: SignupLinkStyleModel(
        enabledLinkColor: primaryColor ?? Colors.blue,
      ),
    );
  }

  /// Apply a minimal theme with reduced visual elements
  static void setupMinimalTheme() {
    final di = LoginComponentDI();
    di.setTheme(LoginThemeType.standard);
    
    di.setOverrides(
      errorBannerStyle: const ErrorBannerStyleModel(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 8),
        borderWidth: 0,
        backgroundColor: Colors.transparent,
        iconSize: 16,
        fontSize: 12,
      ),
      
      loginFormStyle: const LoginFormStyleModel(
        fieldSpacing: 8,
        emailDecoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        passwordDecoration: InputDecoration(
          labelText: 'Password', 
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      
      loginButtonStyle: const LoginButtonStyleModel(
        height: 36,
        loadingIndicatorSize: 16,
      ),
    );
  }

  /// Apply high contrast theme for accessibility
  static void setupHighContrastTheme() {
    final di = LoginComponentDI();
    di.setTheme(LoginThemeType.standard);
    
    di.setOverrides(
      errorBannerStyle: const ErrorBannerStyleModel(
        backgroundColor: Color(0xFFFFFFFF),
        borderColor: Color(0xFF000000),
        borderWidth: 3,
        iconColor: Color(0xFF000000),
        textColor: Color(0xFF000000),
      ),
      
      loginFormStyle: const LoginFormStyleModel(
        emailDecoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        passwordDecoration: InputDecoration(
          labelText: 'Password',  
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
      
      signupLinkStyle: const SignupLinkStyleModel(
        enabledLinkColor: Color(0xFF000080), // Dark blue
        prefixTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Reset to system default theme
  static void resetTheme() {
    final di = LoginComponentDI();
    di.setTheme(LoginThemeType.standard);
    di.clearOverrides();
  }
}