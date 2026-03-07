import 'package:flutter/material.dart';
import '../router/app_router.dart';
import '../router/app_route.dart';

class LoginViewModel extends ChangeNotifier {
  final AppRouter _router = AppRouter();

  void login(String username, String password) {
    // TODO: implement real authentication
    // For now navigate back to home after "login"
    _router.pushRoute(AppRoute.home);
  }
}
