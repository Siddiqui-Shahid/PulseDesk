import 'package:flutter/material.dart';
import '../models/error_banner_data_model.dart';
import '../models/error_banner_style_model.dart';
import '../login_component_di.dart';

/// Error banner component with dependency injection
class ErrorBannerComponent extends StatelessWidget {
  final ErrorBannerDataModel dataModel;
  final ErrorBannerStyleModel? styleModel;
  late final LoginComponentDI _di;

  ErrorBannerComponent({super.key, required this.dataModel, this.styleModel}) {
    _di = LoginComponentDI();
  }

  @override
  Widget build(BuildContext context) {
    final style = styleModel ?? _di.getErrorBannerStyleModel();

    if (!dataModel.isVisible || dataModel.errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: style.padding,
      margin: style.margin,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        border: Border.all(color: style.borderColor, width: style.borderWidth),
        borderRadius: style.borderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            color: style.iconColor,
            size: style.iconSize,
          ),
          SizedBox(width: style.spacingBetweenIconAndText),
          Expanded(
            child: Text(
              dataModel.errorMessage!,
              style: TextStyle(
                color: style.textColor,
                fontSize: style.fontSize,
                height: style.textHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
