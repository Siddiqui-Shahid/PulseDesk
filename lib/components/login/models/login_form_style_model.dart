import 'package:flutter/material.dart';

/// Style model for login form component
class LoginFormStyleModel {
  final double fieldSpacing;
  final InputDecoration emailDecoration;
  final InputDecoration passwordDecoration;
  final TextInputType emailKeyboardType;
  final bool obscurePassword;
  final EdgeInsets marginBottom; // Spacing after component

  const LoginFormStyleModel({
    this.fieldSpacing = 12,
    this.emailDecoration = const InputDecoration(
      labelText: 'Email',
      border: OutlineInputBorder(),
    ),
    this.passwordDecoration = const InputDecoration(
      labelText: 'Password',
      border: OutlineInputBorder(),
    ),
    this.emailKeyboardType = TextInputType.emailAddress,
    this.obscurePassword = true,
    this.marginBottom = const EdgeInsets.only(bottom: 24),
  });

  LoginFormStyleModel copyWith({
    double? fieldSpacing,
    InputDecoration? emailDecoration,
    InputDecoration? passwordDecoration,
    TextInputType? emailKeyboardType,
    bool? obscurePassword,
    EdgeInsets? marginBottom,
  }) {
    return LoginFormStyleModel(
      fieldSpacing: fieldSpacing ?? this.fieldSpacing,
      emailDecoration: emailDecoration ?? this.emailDecoration,
      passwordDecoration: passwordDecoration ?? this.passwordDecoration,
      emailKeyboardType: emailKeyboardType ?? this.emailKeyboardType,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      marginBottom: marginBottom ?? this.marginBottom,
    );
  }
}
