import 'package:flutter/material.dart';
import '../models/signup_link_data_model.dart';
import '../models/signup_link_style_model.dart';
import '../login_component_di.dart';

/// Signup link component with dependency injection
class SignupLinkComponent extends StatelessWidget {
  final SignupLinkDataModel dataModel;
  final SignupLinkStyleModel? styleModel;
  late final LoginComponentDI _di;

  SignupLinkComponent({super.key, required this.dataModel, this.styleModel}) {
    _di = LoginComponentDI();
  }

  @override
  Widget build(BuildContext context) {
    final style = styleModel ?? _di.getSignupLinkStyleModel();

    return Row(
      mainAxisAlignment: style.alignment,
      children: [
        Text(dataModel.prefixText, style: style.prefixTextStyle),
        if (style.spacing > 0) SizedBox(width: style.spacing),
        GestureDetector(
          onTap: dataModel.isEnabled ? dataModel.onTap : null,
          child: Text(
            dataModel.linkText,
            style: TextStyle(
              color: dataModel.isEnabled
                  ? style.enabledLinkColor
                  : style.disabledLinkColor,
              fontWeight: style.linkFontWeight,
            ),
          ),
        ),
      ],
    );
  }
}
