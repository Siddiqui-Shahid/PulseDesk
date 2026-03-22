import 'package:flutter/material.dart';

/// Data model for signup link component
class SignupLinkDataModel {
  final bool isEnabled;
  final String prefixText;
  final String linkText;
  final VoidCallback? onTap;

  const SignupLinkDataModel({
    required this.isEnabled,
    this.prefixText = "Don't have an account? ",
    this.linkText = 'Sign Up',
    this.onTap,
  });

  SignupLinkDataModel copyWith({
    bool? isEnabled,
    String? prefixText,
    String? linkText,
    VoidCallback? onTap,
  }) {
    return SignupLinkDataModel(
      isEnabled: isEnabled ?? this.isEnabled,
      prefixText: prefixText ?? this.prefixText,
      linkText: linkText ?? this.linkText,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignupLinkDataModel &&
          runtimeType == other.runtimeType &&
          isEnabled == other.isEnabled &&
          prefixText == other.prefixText &&
          linkText == other.linkText;

  @override
  int get hashCode =>
      isEnabled.hashCode ^ prefixText.hashCode ^ linkText.hashCode;
}
