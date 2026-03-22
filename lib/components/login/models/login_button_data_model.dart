import 'package:flutter/material.dart';

/// Data model for login button component
class LoginButtonDataModel {
  final bool isLoading;
  final bool isEnabled;
  final String buttonText;
  final VoidCallback? onPressed;

  const LoginButtonDataModel({
    required this.isLoading,
    required this.isEnabled,
    this.buttonText = 'Login',
    this.onPressed,
  });

  LoginButtonDataModel copyWith({
    bool? isLoading,
    bool? isEnabled,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return LoginButtonDataModel(
      isLoading: isLoading ?? this.isLoading,
      isEnabled: isEnabled ?? this.isEnabled,
      buttonText: buttonText ?? this.buttonText,
      onPressed: onPressed ?? this.onPressed,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginButtonDataModel &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          isEnabled == other.isEnabled &&
          buttonText == other.buttonText;

  @override
  int get hashCode =>
      isLoading.hashCode ^ isEnabled.hashCode ^ buttonText.hashCode;
}
