import 'package:flutter/material.dart';
import 'view_models/home_view_model.dart';
import 'widgets/home_widgets.dart';
import '../router/app_router.dart';
import '../router/app_route.dart';

/// Home screen - the initial route of the application
///
/// Uses a widgetized approach with ViewModel pattern
/// Data flows from ViewModel to custom widgets
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

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
              // Welcome Header Widget - displays welcome message and icon
              WelcomeHeaderWidget(data: _viewModel.welcomeData),
              const SizedBox(height: 48),
              // Navigation Buttons Widget - displays all navigation options
              NavigationButtonsWidget(items: _viewModel.navigationItems),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => AppRouter().pushRoute(AppRoute.login),
                child: const Text('Login'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => AppRouter().pushRoute(AppRoute.signup),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
