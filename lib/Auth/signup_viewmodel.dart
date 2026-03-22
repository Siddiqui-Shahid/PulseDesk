import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../router/app_router.dart';
import '../router/app_route.dart';
import '../repositories/repositories.dart';
import '../network/network_service_protocol.dart';
import '../models/api_error.dart';

class SignupViewModel extends ChangeNotifier {
  final AppRouter _router = AppRouter();

  bool _isLoading = false;
  String? _errorMessage;
  String _currentPassword = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentPassword => _currentPassword;

  // Password validation checkers
  bool get hasUpperCase => _currentPassword.contains(RegExp(r'[A-Z]'));
  bool get hasLowerCase => _currentPassword.contains(RegExp(r'[a-z]'));
  bool get hasNumber => _currentPassword.contains(RegExp(r'[0-9]'));
  bool get hasMinLength => _currentPassword.length >= 8;

  bool get isPasswordValid =>
      hasUpperCase && hasLowerCase && hasNumber && hasMinLength;

  // Update password and validate in real-time
  void updatePassword(String password) {
    _currentPassword = password;
    notifyListeners();
  }

  // Get list of password requirement errors
  List<String> getPasswordErrors() {
    final errors = <String>[];
    if (!hasUpperCase) {
      errors.add('must contain at least one uppercase letter (A-Z)');
    }
    if (!hasLowerCase) {
      errors.add('must contain at least one lowercase letter (a-z)');
    }
    if (!hasNumber) errors.add('must contain at least one number (0-9)');
    if (!hasMinLength) errors.add('must be at least 8 characters long');
    return errors;
  }

  Future<void> signup(String username, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Log signup attempt
    developer.log('=== SIGNUP ATTEMPT ===');
    developer.log('Username: $username');
    developer.log('Email: $email');
    developer.log('Password length: ${password.length}');

    try {
      // Validate inputs
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        _errorMessage = 'All fields are required';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Validate password strength client-side
      final passwordErrors = getPasswordErrors();
      if (passwordErrors.isNotEmpty) {
        _errorMessage =
            'Password requirements not met:\n${passwordErrors.join('\n')}';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Call signup from AuthRepository
      developer.log('Making signup request to backend...');
      final authRepo = RepositoryLocator.auth;
      developer.log('AuthRepository initialized');

      await authRepo.signup(
        email: email,
        username: username,
        password: password,
      );

      // Navigate to home on success
      developer.log('Signup successful! Navigating to home...');
      _isLoading = false;
      notifyListeners();
      _router.pushRoute(AppRoute.home);
    } on NetworkException catch (e) {
      // Log network error
      developer.log('🔴 NetworkException: ${e.message}');
      developer.log('Response Body: ${e.responseBody}');
      developer.log('Status Code: ${e.statusCode}');

      // Try to parse backend error response
      try {
        final jsonResponse = e.responseBody is Map ? e.responseBody : null;
        if (jsonResponse != null) {
          final apiError = ApiError.fromJson(jsonResponse);
          _errorMessage = apiError.getFormattedMessage();
        } else {
          _errorMessage = e.message;
        }
      } catch (_) {
        // Fallback to raw message if parsing fails
        _errorMessage = e.message;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      developer.log('🔴 Signup Exception: ${e.toString()}');
      developer.log('Stack trace: $stackTrace');
      _errorMessage = 'Signup failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
}
