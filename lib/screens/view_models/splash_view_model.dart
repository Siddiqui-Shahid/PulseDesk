import 'package:flutter/material.dart';
import '../../router/app_router.dart';
import '../../router/app_route.dart';

/// ViewModel for Splash Screen
///
/// Handles splash screen logic and initialization
class SplashViewModel extends ChangeNotifier {
  final AppRouter _appRouter = AppRouter();
  bool _isInitializing = true;
  double _progress = 0.0;
  String _statusMessage = 'Initializing system...';

  bool get isInitializing => _isInitializing;
  double get progress => _progress;
  String get statusMessage => _statusMessage;

  /// Start initialization process with 3-second simulated loading
  Future<void> initializeApp(BuildContext context) async {
    try {
      // Stage 1: Configuration loading (0-30%)
      await Future.delayed(const Duration(milliseconds: 500));
      _updateProgress(0.3, 'Loading configuration...');

      // Stage 2: Service connection (30-70%)
      await Future.delayed(const Duration(milliseconds: 1000));
      _updateProgress(0.7, 'Connecting to services...');

      // Stage 3: Final initialization (70-100%)
      await Future.delayed(const Duration(milliseconds: 800));
      _updateProgress(1.0, 'System ready');

      // Wait a bit to show completion
      await Future.delayed(const Duration(milliseconds: 200));

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

  /// Update progress and status message
  void _updateProgress(double progress, String message) {
    _progress = progress.clamp(0.0, 1.0);
    _statusMessage = message;
    notifyListeners();
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
