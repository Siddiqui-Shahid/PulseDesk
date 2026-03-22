import 'package:flutter/material.dart';

/// Style model for error banner component
class ErrorBannerStyleModel {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final Color iconColor;
  final double iconSize;
  final Color textColor;
  final double fontSize;
  final double textHeight;
  final double spacingBetweenIconAndText;
  final EdgeInsets marginBottom; // Spacing after component

  const ErrorBannerStyleModel({
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 16),
    this.backgroundColor = const Color(
      0xFFFFEBEE,
    ), // Colors.red.shade50 equivalent
    this.borderColor = const Color(
      0xFFE57373,
    ), // Colors.red.shade300 equivalent
    this.borderWidth = 1.5,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.iconColor = const Color(0xFFD32F2F), // Colors.red.shade700 equivalent
    this.iconSize = 20,
    this.textColor = const Color(0xFFC62828), // Colors.red.shade800 equivalent
    this.fontSize = 13,
    this.textHeight = 1.5,
    this.spacingBetweenIconAndText = 8,
    this.marginBottom = const EdgeInsets.only(
      bottom: 0,
    ), // No extra margin after by default
  });

  ErrorBannerStyleModel copyWith({
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    Color? iconColor,
    double? iconSize,
    Color? textColor,
    double? fontSize,
    double? textHeight,
    double? spacingBetweenIconAndText,
    EdgeInsets? marginBottom,
  }) {
    return ErrorBannerStyleModel(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
      textColor: textColor ?? this.textColor,
      fontSize: fontSize ?? this.fontSize,
      textHeight: textHeight ?? this.textHeight,
      spacingBetweenIconAndText:
          spacingBetweenIconAndText ?? this.spacingBetweenIconAndText,
      marginBottom: marginBottom ?? this.marginBottom,
    );
  }
}
