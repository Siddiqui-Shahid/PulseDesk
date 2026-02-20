import 'package:flutter/material.dart';
import '../router/app_router.dart';
import '../router/app_route.dart';
import '../router/route_models.dart';

/// Home screen - the initial route of the application
///
/// Demonstrates navigation with and without data
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen'), elevation: 0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'Welcome to PulseDesk',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'A Flutter Router System Example',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              // Navigation without data
              ElevatedButton.icon(
                onPressed: () {
                  _navigateToDetails(context, withData: false);
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go to Details (no data)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Navigation with data
              ElevatedButton.icon(
                onPressed: () {
                  _navigateToDetails(context, withData: true);
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go to Details (with data)'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              // Navigation to Profile
              ElevatedButton.icon(
                onPressed: () {
                  _navigateToProfile(context);
                },
                icon: const Icon(Icons.person),
                label: const Text('Go to Profile'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              // Navigation to Settings
              ElevatedButton.icon(
                onPressed: () {
                  _navigateToSettings(context);
                },
                icon: const Icon(Icons.settings),
                label: const Text('Go to Settings'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the Details screen
  /// Demonstrates both with and without data
  void _navigateToDetails(BuildContext context, {required bool withData}) {
    final appRouter = AppRouter();

    if (withData) {
      // Navigation with typed data
      final arguments = RouteArguments(
        id: 'PROD-12345',
        title: 'Premium Widget',
        data: {
          'price': 99.99,
          'description': 'A high-quality premium widget',
          'inStock': true,
        },
      );

      appRouter.pushRoute(AppRoute.details, data: arguments);
    } else {
      // Navigation without data
      appRouter.pushRoute(AppRoute.details);
    }
  }

  /// Navigates to the Profile screen
  void _navigateToProfile(BuildContext context) {
    final appRouter = AppRouter();
    final userProfile = RouteArguments(
      id: 'user-001',
      title: 'John Doe',
      data: {
        'email': 'john@example.com',
        'phone': '+1-234-567-8900',
        'joinDate': '2023-01-15',
      },
    );

    appRouter.pushRoute(AppRoute.profile, data: userProfile);
  }

  /// Navigates to the Settings screen
  void _navigateToSettings(BuildContext context) {
    final appRouter = AppRouter();
    appRouter.pushRoute(AppRoute.settings);
  }
}
