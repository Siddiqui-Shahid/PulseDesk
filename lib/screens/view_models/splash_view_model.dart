import 'package:flutter/material.dart';
import '../../router/app_router.dart';
import '../../router/app_route.dart';

/// ViewModel for Splash Screen
///
/// Handles splash screen logic and initialization
class SplashViewModel extends ChangeNotifier {
  final AppRouter _appRouter = AppRouter();
  bool _isInitializing = true;

  bool get isInitializing => _isInitializing;

  /// Start initialization process
  Future<void> initializeApp(BuildContext context) async {
    try {
      // Simulate initialization tasks (database, network, etc.)
      await Future.delayed(const Duration(seconds: 2));

      _isInitializing = false;
      notifyListeners();

      // Navigate to home screen after initialization
      if (context.mounted) {
        _appRouter.pushRoute(AppRoute.home);
      }
    } catch (e) {
      debugPrint('Error during initialization: $e');
      _isInitializing = false;
      notifyListeners();
    }
  }
}

/// Model for Splash Screen Data
class SplashData {
  final String appName;
  final String tagline;
  final String statusMessage;
  final IconData appIcon;
  final Color primaryColor;

  SplashData({
    required this.appName,
    required this.tagline,
    required this.statusMessage,
    required this.appIcon,
    required this.primaryColor,
  });
}
