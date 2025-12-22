import 'package:flutter/material.dart';

@immutable
class CarbonButtonThemeData extends ThemeExtension<CarbonButtonThemeData> {
  // Primary
  final Color buttonPrimary;
  final Color buttonPrimaryActive;
  final Color buttonPrimaryHover;

  // Secondary
  final Color buttonSecondary;
  final Color buttonSecondaryActive;
  final Color buttonSecondaryHover;

  // Tertiary
  final Color buttonTertiary;
  final Color buttonTertiaryActive;
  final Color buttonTertiaryHover;

  // Danger Primary
  final Color buttonDangerPrimary;
  final Color buttonDangerActive; // Shared active state in token names usually?
  final Color buttonDangerHover;

  // Danger Secondary
  final Color buttonDangerSecondary;
  // Danger Secondary Active/Hover often share values or patterns,
  // but tokens.js often lists unique ones.
  // In `button/tokens.js`, we have:
  // buttonDangerActive (shared?)
  // buttonDangerHover (shared?)

  // Separator
  final Color buttonSeparator;

  // Disabled
  final Color buttonDisabled;

  const CarbonButtonThemeData({
    required this.buttonPrimary,
    required this.buttonPrimaryActive,
    required this.buttonPrimaryHover,
    required this.buttonSecondary,
    required this.buttonSecondaryActive,
    required this.buttonSecondaryHover,
    required this.buttonTertiary,
    required this.buttonTertiaryActive,
    required this.buttonTertiaryHover,
    required this.buttonDangerPrimary,
    required this.buttonDangerActive,
    required this.buttonDangerHover,
    required this.buttonDangerSecondary,
    required this.buttonSeparator,
    required this.buttonDisabled,
  });

  @override
  CarbonButtonThemeData copyWith({
    Color? buttonPrimary,
    Color? buttonPrimaryActive,
    Color? buttonPrimaryHover,
    Color? buttonSecondary,
    Color? buttonSecondaryActive,
    Color? buttonSecondaryHover,
    Color? buttonTertiary,
    Color? buttonTertiaryActive,
    Color? buttonTertiaryHover,
    Color? buttonDangerPrimary,
    Color? buttonDangerActive,
    Color? buttonDangerHover,
    Color? buttonDangerSecondary,
    Color? buttonSeparator,
    Color? buttonDisabled,
  }) {
    return CarbonButtonThemeData(
      buttonPrimary: buttonPrimary ?? this.buttonPrimary,
      buttonPrimaryActive: buttonPrimaryActive ?? this.buttonPrimaryActive,
      buttonPrimaryHover: buttonPrimaryHover ?? this.buttonPrimaryHover,
      buttonSecondary: buttonSecondary ?? this.buttonSecondary,
      buttonSecondaryActive:
          buttonSecondaryActive ?? this.buttonSecondaryActive,
      buttonSecondaryHover: buttonSecondaryHover ?? this.buttonSecondaryHover,
      buttonTertiary: buttonTertiary ?? this.buttonTertiary,
      buttonTertiaryActive: buttonTertiaryActive ?? this.buttonTertiaryActive,
      buttonTertiaryHover: buttonTertiaryHover ?? this.buttonTertiaryHover,
      buttonDangerPrimary: buttonDangerPrimary ?? this.buttonDangerPrimary,
      buttonDangerActive: buttonDangerActive ?? this.buttonDangerActive,
      buttonDangerHover: buttonDangerHover ?? this.buttonDangerHover,
      buttonDangerSecondary:
          buttonDangerSecondary ?? this.buttonDangerSecondary,
      buttonSeparator: buttonSeparator ?? this.buttonSeparator,
      buttonDisabled: buttonDisabled ?? this.buttonDisabled,
    );
  }

  @override
  CarbonButtonThemeData lerp(
    ThemeExtension<CarbonButtonThemeData>? other,
    double t,
  ) {
    if (other is! CarbonButtonThemeData) return this;
    return CarbonButtonThemeData(
      buttonPrimary: Color.lerp(buttonPrimary, other.buttonPrimary, t)!,
      buttonPrimaryActive: Color.lerp(
        buttonPrimaryActive,
        other.buttonPrimaryActive,
        t,
      )!,
      buttonPrimaryHover: Color.lerp(
        buttonPrimaryHover,
        other.buttonPrimaryHover,
        t,
      )!,
      buttonSecondary: Color.lerp(buttonSecondary, other.buttonSecondary, t)!,
      buttonSecondaryActive: Color.lerp(
        buttonSecondaryActive,
        other.buttonSecondaryActive,
        t,
      )!,
      buttonSecondaryHover: Color.lerp(
        buttonSecondaryHover,
        other.buttonSecondaryHover,
        t,
      )!,
      buttonTertiary: Color.lerp(buttonTertiary, other.buttonTertiary, t)!,
      buttonTertiaryActive: Color.lerp(
        buttonTertiaryActive,
        other.buttonTertiaryActive,
        t,
      )!,
      buttonTertiaryHover: Color.lerp(
        buttonTertiaryHover,
        other.buttonTertiaryHover,
        t,
      )!,
      buttonDangerPrimary: Color.lerp(
        buttonDangerPrimary,
        other.buttonDangerPrimary,
        t,
      )!,
      buttonDangerActive: Color.lerp(
        buttonDangerActive,
        other.buttonDangerActive,
        t,
      )!,
      buttonDangerHover: Color.lerp(
        buttonDangerHover,
        other.buttonDangerHover,
        t,
      )!,
      buttonDangerSecondary: Color.lerp(
        buttonDangerSecondary,
        other.buttonDangerSecondary,
        t,
      )!,
      buttonSeparator: Color.lerp(buttonSeparator, other.buttonSeparator, t)!,
      buttonDisabled: Color.lerp(buttonDisabled, other.buttonDisabled, t)!,
    );
  }
}
