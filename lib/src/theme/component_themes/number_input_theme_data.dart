import 'package:flutter/material.dart';

/// Theme data for Carbon number input control buttons.
@immutable
class CarbonNumberInputThemeData
    extends ThemeExtension<CarbonNumberInputThemeData> {
  /// Background color for control buttons.
  final Color controlButtonBackground;

  /// Background color for control buttons on hover.
  final Color controlButtonBackgroundHover;

  /// Background color for control buttons when active/pressed.
  final Color controlButtonBackgroundActive;

  /// Icon color for control buttons.
  final Color controlButtonIcon;

  /// Border color for control buttons.
  final Color controlButtonBorder;

  /// Border color between increment and decrement buttons.
  final Color controlButtonDivider;

  const CarbonNumberInputThemeData({
    required this.controlButtonBackground,
    required this.controlButtonBackgroundHover,
    required this.controlButtonBackgroundActive,
    required this.controlButtonIcon,
    required this.controlButtonBorder,
    required this.controlButtonDivider,
  });

  @override
  CarbonNumberInputThemeData copyWith({
    Color? controlButtonBackground,
    Color? controlButtonBackgroundHover,
    Color? controlButtonBackgroundActive,
    Color? controlButtonIcon,
    Color? controlButtonBorder,
    Color? controlButtonDivider,
  }) {
    return CarbonNumberInputThemeData(
      controlButtonBackground:
          controlButtonBackground ?? this.controlButtonBackground,
      controlButtonBackgroundHover:
          controlButtonBackgroundHover ?? this.controlButtonBackgroundHover,
      controlButtonBackgroundActive:
          controlButtonBackgroundActive ?? this.controlButtonBackgroundActive,
      controlButtonIcon: controlButtonIcon ?? this.controlButtonIcon,
      controlButtonBorder: controlButtonBorder ?? this.controlButtonBorder,
      controlButtonDivider: controlButtonDivider ?? this.controlButtonDivider,
    );
  }

  @override
  CarbonNumberInputThemeData lerp(
      ThemeExtension<CarbonNumberInputThemeData>? other, double t) {
    if (other is! CarbonNumberInputThemeData) return this;
    return CarbonNumberInputThemeData(
      controlButtonBackground: Color.lerp(
          controlButtonBackground, other.controlButtonBackground, t)!,
      controlButtonBackgroundHover: Color.lerp(
          controlButtonBackgroundHover, other.controlButtonBackgroundHover, t)!,
      controlButtonBackgroundActive: Color.lerp(controlButtonBackgroundActive,
          other.controlButtonBackgroundActive, t)!,
      controlButtonIcon: Color.lerp(controlButtonIcon, other.controlButtonIcon, t)!,
      controlButtonBorder:
          Color.lerp(controlButtonBorder, other.controlButtonBorder, t)!,
      controlButtonDivider:
          Color.lerp(controlButtonDivider, other.controlButtonDivider, t)!,
    );
  }
}
