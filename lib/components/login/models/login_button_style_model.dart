import 'package:flutter/material.dart';

/// Style model for login button component
class LoginButtonStyleModel {
  final double width;
  final double height;
  final double loadingIndicatorSize;
  final double loadingStrokeWidth;
  final Color loadingColor;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final EdgeInsets marginBottom; // Spacing after component

  const LoginButtonStyleModel({
    this.width = double.infinity,
    this.height = 48,
    this.loadingIndicatorSize = 20,
    this.loadingStrokeWidth = 2,
    this.loadingColor = Colors.white,
    this.padding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.marginBottom = const EdgeInsets.only(bottom: 16),
  });

  LoginButtonStyleModel copyWith({
    double? width,
    double? height,
    double? loadingIndicatorSize,
    double? loadingStrokeWidth,
    Color? loadingColor,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    EdgeInsets? marginBottom,
  }) {
    return LoginButtonStyleModel(
      width: width ?? this.width,
      height: height ?? this.height,
      loadingIndicatorSize: loadingIndicatorSize ?? this.loadingIndicatorSize,
      loadingStrokeWidth: loadingStrokeWidth ?? this.loadingStrokeWidth,
      loadingColor: loadingColor ?? this.loadingColor,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      marginBottom: marginBottom ?? this.marginBottom,
    );
  }
}
