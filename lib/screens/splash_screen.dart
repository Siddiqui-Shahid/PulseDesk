import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'view_models/splash_view_model.dart';
import 'widgets/splash_widgets.dart';

/// Splash Screen - the initial route of the application
///
/// Displays a beautiful splash screen with initialization animation
/// After initialization completes, navigates to the home screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late SplashViewModel _viewModel;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Setup fade-in animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _viewModel = SplashViewModel();
    // Start initialization when screen loads
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.initializeApp(context);
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _fadeController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7C3AED), // Purple background
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),

              // Logo and Header Section
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Section
                      SplashLogoWidget(
                        icon: Icons.favorite,
                        color: const Color(0xFF7C3AED),
                      ),
                      const SizedBox(height: 40),

                      // App Name and Tagline
                      SplashHeaderWidget(
                        appName: 'Pulse',
                        tagline: 'Smart Healthcare. Zero Wait.',
                      ),
                    ],
                  ),
                ),
              ),

              // Loading Section
              Expanded(
                flex: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Loading Widget with dynamic status
                      SplashLoadingWidget(
                        message: _viewModel.statusMessage,
                        progress: _viewModel.progress,
                      ),
                      const SizedBox(height: 40),

                      // Status Indicator
                      SplashStatusWidget(
                        status: _viewModel.isInitializing
                            ? 'Initializing...'
                            : 'System is ready',
                        statusColor: _viewModel.isInitializing
                            ? const Color(0xFFFFC107)
                            : const Color(0xFF4CAF50),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
