import 'package:flutter/material.dart';
import '../models/login_form_data_model.dart';
import '../models/login_form_style_model.dart';
import '../login_component_di.dart';

/// Login form component with dependency injection
class LoginFormComponent extends StatelessWidget {
  final LoginFormDataModel dataModel;
  final LoginFormStyleModel? styleModel;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  late final LoginComponentDI _di;

  LoginFormComponent({
    super.key,
    required this.dataModel,
    required this.emailController,
    required this.passwordController,
    this.styleModel,
  }) {
    _di = LoginComponentDI();
  }

  @override
  Widget build(BuildContext context) {
    final style = styleModel ?? _di.getLoginFormStyleModel();

    return Column(
      children: [
        TextField(
          controller: emailController,
          enabled: dataModel.isEnabled,
          keyboardType: style.emailKeyboardType,
          decoration: style.emailDecoration.copyWith(
            labelText: dataModel.emailLabel,
          ),
        ),
        SizedBox(height: style.fieldSpacing),
        TextField(
          controller: passwordController,
          enabled: dataModel.isEnabled,
          obscureText: style.obscurePassword,
          decoration: style.passwordDecoration.copyWith(
            labelText: dataModel.passwordLabel,
          ),
        ),
      ],
    );
  }
}
