import 'package:flutter/material.dart';
import '../models/login_button_data_model.dart';
import '../models/login_button_style_model.dart';
import '../login_component_di.dart';

/// Login button component with dependency injection
class LoginButtonComponent extends StatelessWidget {
  final LoginButtonDataModel dataModel;
  final LoginButtonStyleModel? styleModel;
  late final LoginComponentDI _di;

  LoginButtonComponent({super.key, required this.dataModel, this.styleModel}) {
    _di = LoginComponentDI();
  }

  @override
  Widget build(BuildContext context) {
    final style = styleModel ?? _di.getLoginButtonStyleModel();

    return SizedBox(
      width: style.width,
      height: style.height,
      child: ElevatedButton(
        onPressed: dataModel.isEnabled && !dataModel.isLoading
            ? dataModel.onPressed
            : null,
        child: dataModel.isLoading
            ? SizedBox(
                height: style.loadingIndicatorSize,
                width: style.loadingIndicatorSize,
                child: CircularProgressIndicator(
                  strokeWidth: style.loadingStrokeWidth,
                  color: style.loadingColor,
                ),
              )
            : Text(dataModel.buttonText),
      ),
    );
  }
}
