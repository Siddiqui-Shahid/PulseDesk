import 'package:flutter/material.dart';
import 'login_theme_config.dart';
import '../login/themes/login_theme_manager.dart';

/// Example of how to integrate component theming in your main app
class AppThemeManager {
  
  /// Initialize component themes based on system or app theme mode
  static void initializeComponentThemes(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.dark:
        LoginThemeConfig.setupDarkTheme();
        break;
      case ThemeMode.light:
        LoginThemeConfig.setupLightTheme();
        break;
      case ThemeMode.system:
        // Detect system theme and apply accordingly
        final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        if (brightness == Brightness.dark) {
          LoginThemeConfig.setupDarkTheme();
        } else {
          LoginThemeConfig.setupLightTheme();
        }
        break;
    }
  }

  /// Setup branded theme with your app's colors
  static void setupBrandedTheme({
    Color primaryColor = const Color(0xFF1976D2),
    Color errorColor = const Color(0xFFD32F2F),
    double borderRadius = 8,
  }) {
    LoginThemeConfig.setupCustomTheme(
      primaryColor: primaryColor,
      errorColor: errorColor,
      borderRadius: borderRadius,
    );
  }

  /// Setup compact theme for smaller screens or dense layouts
  static void setupCompactLayout() {
    LoginThemeConfig.setupCompactTheme();
  }

  /// Setup minimal theme with reduced visual elements
  static void setupMinimalDesign() {
    LoginThemeConfig.setupMinimalTheme();
  }

  /// Setup high contrast theme for accessibility
  static void setupAccessibilityTheme() {
    LoginThemeConfig.setupHighContrastTheme();
  }

  /// Reset to default theme
  static void resetToDefault() {
    LoginThemeConfig.resetTheme();
  }

  /// Apply theme based on device characteristics
  static void applyAdaptiveTheme(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    final isLargeScreen = screenSize.width > 1200;

    if (isLargeScreen) {
      // Large screens can handle standard themes
      LoginThemeConfig.setupLightTheme();
    } else if (isTablet) {
      // Tablets get standard theme
      LoginThemeConfig.setupLightTheme();
    } else {
      // Mobile devices get compact theme
      LoginThemeConfig.setupCompactTheme();
    }
  }
}

/// Example usage in your main.dart:
/// 
/// void main() {
///   // Initialize component themes based on your app theme
///   AppThemeManager.initializeComponentThemes(ThemeMode.system);
///   
///   // Or setup your branded theme
///   AppThemeManager.setupBrandedTheme(
///     primaryColor: Colors.green,
///     errorColor: Colors.orange,
///   );
///   
///   // Or apply adaptive theming in your MaterialApp builder
///   runApp(MyApp());
/// }
/// 
/// // In your MaterialApp:
/// MaterialApp(
///   builder: (context, child) {
///     AppThemeManager.applyAdaptiveTheme(context);
///     return child!;
///   },
///   // ... other properties
/// )