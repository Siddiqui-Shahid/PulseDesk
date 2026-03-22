import 'package:flutter/material.dart';
import '../components/login/login_components.dart';

/// Example showing how to use the new default theme system with overrides
class LoginThemeExample extends StatefulWidget {
  const LoginThemeExample({super.key});

  @override
  State<LoginThemeExample> createState() => _LoginThemeExampleState();
}

class _LoginThemeExampleState extends State<LoginThemeExample> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Set up default theme on initialization
    _setupTheme();
  }

  void _setupTheme() {
    final di = LoginComponentDI();

    // Option 1: Use one of the built-in themes
    di.setTheme(LoginThemeType.standard); // or .dark, .compact

    // Option 2: Override specific components from view model
    // This example shows custom error styling while keeping other defaults
    di.setOverrides(
      errorBannerStyle: const ErrorBannerStyleModel(
        backgroundColor: Color(0xFFFFF3CD), // Yellow background
        borderColor: Color(0xFFFFD60A), // Yellow border
        iconColor: Color(0xFF664D03), // Dark yellow icon
        textColor: Color(0xFF664D03), // Dark yellow text
      ),
      // You can also override data models
      signupLinkData: const SignupLinkDataModel(
        isEnabled: true,
        prefixText: "New here? ",
        linkText: 'Create Account',
      ),
    );
  }

  void _switchToDarkTheme() {
    final di = LoginComponentDI();
    di.setTheme(LoginThemeType.dark);
    setState(() {}); // Trigger rebuild
  }

  void _switchToCompactTheme() {
    final di = LoginComponentDI();
    di.setTheme(LoginThemeType.compact);
    setState(() {}); // Trigger rebuild
  }

  void _resetToDefault() {
    final di = LoginComponentDI();
    di.setTheme(LoginThemeType.standard);
    di.clearOverrides(); // Remove any custom overrides
    setState(() {}); // Trigger rebuild
  }

  void _handleLogin() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate login process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _errorMessage = "Invalid email or password. Please try again.";
      });
    });
  }

  void _handleSignup() {
    // Navigate to signup
    debugPrint('Navigate to signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Theme Example'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'standard':
                  _resetToDefault();
                  break;
                case 'dark':
                  _switchToDarkTheme();
                  break;
                case 'compact':
                  _switchToCompactTheme();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'standard',
                child: Text('Standard Theme'),
              ),
              const PopupMenuItem(value: 'dark', child: Text('Dark Theme')),
              const PopupMenuItem(
                value: 'compact',
                child: Text('Compact Theme'),
              ),
            ],
          ),
        ],
      ),
      body: LoginScreenContainer(
        errorMessage: _errorMessage,
        isLoading: _isLoading,
        emailController: _emailController,
        passwordController: _passwordController,
        onLoginPressed: _handleLogin,
        onSignupPressed: _handleSignup,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example: Override theme at runtime from view model data
          final di = LoginComponentDI();
          di.setOverrides(
            errorBannerData: ErrorBannerDataModel(
              errorMessage: "Custom runtime error from view model!",
              isVisible: true,
            ),
          );
          setState(() {
            _errorMessage = "Custom runtime error from view model!";
          });
        },
        child: const Icon(Icons.error),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
