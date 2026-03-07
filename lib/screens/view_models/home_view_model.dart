import 'package:flutter/material.dart';
import '../../router/app_router.dart';
import '../../router/app_route.dart';
import '../../router/route_models.dart';

/// ViewModel for Home Screen
///
/// Handles business logic and data management for the home screen
class HomeViewModel extends ChangeNotifier {
  final AppRouter _appRouter = AppRouter();

  /// List of navigation items available from home screen
  List<NavigationItem> get navigationItems => _getNavigationItems();

  /// Get welcome data for the header
  WelcomeData get welcomeData => WelcomeData(
    title: 'Welcome to PulseDesk',
    subtitle: 'A Flutter Router System Example',
    icon: Icons.home,
  );

  /// Navigate to Details screen without data
  void navigateToDetailsWithoutData(BuildContext context) {
    _appRouter.pushRoute(AppRoute.details);
  }

  /// Navigate to Details screen with data
  void navigateToDetailsWithData(BuildContext context) {
    final arguments = RouteArguments(
      id: 'PROD-12345',
      title: 'Premium Widget',
      data: {
        'price': 99.99,
        'description': 'A high-quality premium widget',
        'inStock': true,
      },
    );
    _appRouter.pushRoute(AppRoute.details, data: arguments);
  }

  /// Navigate to Profile screen
  void navigateToProfile(BuildContext context) {
    final userProfile = RouteArguments(
      id: 'user-001',
      title: 'John Doe',
      data: {
        'email': 'john@example.com',
        'phone': '+1-234-567-8900',
        'joinDate': '2023-01-15',
      },
    );
    _appRouter.pushRoute(AppRoute.profile, data: userProfile);
  }

  /// Navigate to Settings screen
  void navigateToSettings(BuildContext context) {
    _appRouter.pushRoute(AppRoute.settings);
  }

  /// Get list of navigation items
  List<NavigationItem> _getNavigationItems() {
    return [
      NavigationItem(
        label: 'Go to Details (no data)',
        icon: Icons.arrow_forward,
        color: Colors.blue,
        onTap: navigateToDetailsWithoutData,
      ),
      NavigationItem(
        label: 'Go to Details (with data)',
        icon: Icons.arrow_forward,
        color: Colors.green,
        onTap: navigateToDetailsWithData,
      ),
      NavigationItem(
        label: 'Go to Profile',
        icon: Icons.person,
        color: Colors.orange,
        onTap: navigateToProfile,
      ),
      NavigationItem(
        label: 'Go to Settings',
        icon: Icons.settings,
        color: Colors.purple,
        onTap: navigateToSettings,
      ),
    ];
  }
}

/// Model for Welcome Header Data
class WelcomeData {
  final String title;
  final String subtitle;
  final IconData icon;

  WelcomeData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

/// Model for Navigation Item
class NavigationItem {
  final String label;
  final IconData icon;
  final Color color;
  final Function(BuildContext) onTap;

  NavigationItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
