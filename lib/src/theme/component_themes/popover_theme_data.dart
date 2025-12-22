import 'package:flutter/material.dart';

@immutable
class CarbonPopoverThemeData extends ThemeExtension<CarbonPopoverThemeData> {
  final Color background;
  final Color backgroundHighContrast;
  final Color border;
  final Color borderHighContrast;
  final Color caretBackground;
  final Color caretBackgroundHighContrast;
  final Color dropShadow;
  final Color dropShadowHighContrast;

  const CarbonPopoverThemeData({
    required this.background,
    required this.backgroundHighContrast,
    required this.border,
    required this.borderHighContrast,
    required this.caretBackground,
    required this.caretBackgroundHighContrast,
    required this.dropShadow,
    required this.dropShadowHighContrast,
  });

  @override
  CarbonPopoverThemeData copyWith({
    Color? background,
    Color? backgroundHighContrast,
    Color? border,
    Color? borderHighContrast,
    Color? caretBackground,
    Color? caretBackgroundHighContrast,
    Color? dropShadow,
    Color? dropShadowHighContrast,
  }) {
    return CarbonPopoverThemeData(
      background: background ?? this.background,
      backgroundHighContrast:
          backgroundHighContrast ?? this.backgroundHighContrast,
      border: border ?? this.border,
      borderHighContrast: borderHighContrast ?? this.borderHighContrast,
      caretBackground: caretBackground ?? this.caretBackground,
      caretBackgroundHighContrast:
          caretBackgroundHighContrast ?? this.caretBackgroundHighContrast,
      dropShadow: dropShadow ?? this.dropShadow,
      dropShadowHighContrast:
          dropShadowHighContrast ?? this.dropShadowHighContrast,
    );
  }

  @override
  CarbonPopoverThemeData lerp(
    ThemeExtension<CarbonPopoverThemeData>? other,
    double t,
  ) {
    if (other is! CarbonPopoverThemeData) return this;
    return CarbonPopoverThemeData(
      background: Color.lerp(background, other.background, t)!,
      backgroundHighContrast: Color.lerp(
        backgroundHighContrast,
        other.backgroundHighContrast,
        t,
      )!,
      border: Color.lerp(border, other.border, t)!,
      borderHighContrast: Color.lerp(
        borderHighContrast,
        other.borderHighContrast,
        t,
      )!,
      caretBackground: Color.lerp(caretBackground, other.caretBackground, t)!,
      caretBackgroundHighContrast: Color.lerp(
        caretBackgroundHighContrast,
        other.caretBackgroundHighContrast,
        t,
      )!,
      dropShadow: Color.lerp(dropShadow, other.dropShadow, t)!,
      dropShadowHighContrast: Color.lerp(
        dropShadowHighContrast,
        other.dropShadowHighContrast,
        t,
      )!,
    );
  }
}
