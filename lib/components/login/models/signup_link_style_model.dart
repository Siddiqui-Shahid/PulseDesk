import 'package:flutter/material.dart';

/// Style model for signup link component
class SignupLinkStyleModel {
  final MainAxisAlignment alignment;
  final Color enabledLinkColor;
  final Color disabledLinkColor;
  final FontWeight linkFontWeight;
  final TextStyle? prefixTextStyle;
  final double spacing;
  final EdgeInsets marginTop; // Spacing before component

  const SignupLinkStyleModel({
    this.alignment = MainAxisAlignment.center,
    this.enabledLinkColor = Colors.blue,
    this.disabledLinkColor = Colors.grey,
    this.linkFontWeight = FontWeight.bold,
    this.prefixTextStyle,
    this.spacing = 0,
    this.marginTop = const EdgeInsets.only(top: 0),
  });

  SignupLinkStyleModel copyWith({
    MainAxisAlignment? alignment,
    Color? enabledLinkColor,
    Color? disabledLinkColor,
    FontWeight? linkFontWeight,
    TextStyle? prefixTextStyle,
    double? spacing,
    EdgeInsets? marginTop,
  }) {
    return SignupLinkStyleModel(
      alignment: alignment ?? this.alignment,
      enabledLinkColor: enabledLinkColor ?? this.enabledLinkColor,
      disabledLinkColor: disabledLinkColor ?? this.disabledLinkColor,
      linkFontWeight: linkFontWeight ?? this.linkFontWeight,
      prefixTextStyle: prefixTextStyle ?? this.prefixTextStyle,
      spacing: spacing ?? this.spacing,
      marginTop: marginTop ?? this.marginTop,
    );
  }
}
