import 'package:flutter/material.dart';
import 'login_viewmodel.dart';
import '../router/app_router.dart';
import '../router/app_route.dart';
import '../models/api_error.dart'; // ignore: unused_import — kept for symmetry
import '../components/login/login_components.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final LoginViewModel _vm;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = LoginViewModel();
    // Clear error whenever the user types
    _usernameController.addListener(_vm.clearError);
    _passwordController.addListener(_vm.clearError);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) {
          return LoginScreenContainer(
            errorMessage: _vm.errorMessage,
            isLoading: _vm.isLoading,
            emailController: _usernameController,
            passwordController: _passwordController,
            onLoginPressed: () => _vm.login(
              _usernameController.text.trim(),
              _passwordController.text,
            ),
            onSignupPressed: () => AppRouter().pushRoute(AppRoute.signup),
          );
        },
      ),
    );
  }
}
