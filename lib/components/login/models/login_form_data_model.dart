/// Data model for login form component
class LoginFormDataModel {
  final String emailValue;
  final String passwordValue;
  final bool isEnabled;
  final String emailLabel;
  final String passwordLabel;

  const LoginFormDataModel({
    required this.emailValue,
    required this.passwordValue,
    required this.isEnabled,
    this.emailLabel = 'Email',
    this.passwordLabel = 'Password',
  });

  LoginFormDataModel copyWith({
    String? emailValue,
    String? passwordValue,
    bool? isEnabled,
    String? emailLabel,
    String? passwordLabel,
  }) {
    return LoginFormDataModel(
      emailValue: emailValue ?? this.emailValue,
      passwordValue: passwordValue ?? this.passwordValue,
      isEnabled: isEnabled ?? this.isEnabled,
      emailLabel: emailLabel ?? this.emailLabel,
      passwordLabel: passwordLabel ?? this.passwordLabel,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginFormDataModel &&
          runtimeType == other.runtimeType &&
          emailValue == other.emailValue &&
          passwordValue == other.passwordValue &&
          isEnabled == other.isEnabled &&
          emailLabel == other.emailLabel &&
          passwordLabel == other.passwordLabel;

  @override
  int get hashCode =>
      emailValue.hashCode ^
      passwordValue.hashCode ^
      isEnabled.hashCode ^
      emailLabel.hashCode ^
      passwordLabel.hashCode;
}
