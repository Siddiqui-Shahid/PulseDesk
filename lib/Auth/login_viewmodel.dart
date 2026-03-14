import 'package:flutter/material.dart';
import '../router/app_router.dart';
import '../router/app_route.dart';
import '../repositories/repositories.dart';
import '../network/network_service_protocol.dart';
import '../models/api_error.dart';

class LoginViewModel extends ChangeNotifier {
  final AppRouter _router = AppRouter();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Clear any displayed error (call when the user starts editing a field).
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email and password are required';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authRepo = RepositoryLocator.auth;
      await authRepo.login(email: email, password: password);

      _isLoading = false;
      notifyListeners();
      _router.pushRoute(AppRoute.home);
    } on NetworkException catch (e) {
      // Extract the backend message from the structured JSON body.
      try {
        final body = e.responseBody is Map ? e.responseBody as Map<String, dynamic> : null;
        if (body != null) {
          final apiError = ApiError.fromJson(body);
          _errorMessage = apiError.getUserMessage();
        } else {
          _errorMessage = e.message;
        }
      } catch (_) {
        _errorMessage = e.message;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
}
