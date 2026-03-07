import 'package:flutter/material.dart';
import 'view_models/splash_view_model.dart';
import 'widgets/splash_widgets.dart';

/// Splash Screen - the initial route of the application
///
/// Displays a beautiful splash screen with initialization animation
/// After initialization completes, navigates to the home screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SplashViewModel();
    // Start initialization when screen loads
    _viewModel.initializeApp(context);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xAA4C1E7F), // Purple background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  SplashLogoWidget(
                    icon: Icons.medical_services,
                    color: const Color(0xAA4C1E7F),
                  ),
                  const SizedBox(height: 60),

                  // App Name and Tagline
                  SplashHeaderWidget(
                    appName: 'ClinicFlow',
                    tagline: 'Smart Queue. Zero Stress.',
                  ),
                  const SizedBox(height: 80),

                  // Loading Section
                  SplashLoadingWidget(message: 'INITIALIZING SYSTEM'),
                  const SizedBox(height: 60),

                  // Status Indicator
                  SplashStatusWidget(
                    status: 'Clinic is Open',
                    statusColor: const Color(0xFF4CAF50), // Green
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
