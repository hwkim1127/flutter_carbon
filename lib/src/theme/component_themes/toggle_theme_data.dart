import 'package:flutter/material.dart';

/// Theme data for Carbon toggle (switch).
@immutable
class CarbonToggleThemeData extends ThemeExtension<CarbonToggleThemeData> {
  /// Background color when toggle is off.
  final Color toggleOff;

  /// Background color when toggle is on (checked).
  final Color toggleOn;

  /// Thumb (circle) color.
  final Color thumbColor;

  /// Thumb color when disabled.
  final Color thumbColorDisabled;

  /// Background color when disabled.
  final Color backgroundDisabled;

  /// Border color for read-only state.
  final Color borderReadOnly;

  /// Thumb color for read-only state.
  final Color thumbReadOnly;

  /// Focus ring color.
  final Color focusColor;

  /// Label text color.
  final Color labelColor;

  /// State text color ("On"/"Off").
  final Color stateTextColor;

  /// Disabled text color.
  final Color textDisabled;

  /// Checkmark color (small size only).
  final Color checkmarkColor;

  const CarbonToggleThemeData({
    required this.toggleOff,
    required this.toggleOn,
    required this.thumbColor,
    required this.thumbColorDisabled,
    required this.backgroundDisabled,
    required this.borderReadOnly,
    required this.thumbReadOnly,
    required this.focusColor,
    required this.labelColor,
    required this.stateTextColor,
    required this.textDisabled,
    required this.checkmarkColor,
  });

  @override
  CarbonToggleThemeData copyWith({
    Color? toggleOff,
    Color? toggleOn,
    Color? thumbColor,
    Color? thumbColorDisabled,
    Color? backgroundDisabled,
    Color? borderReadOnly,
    Color? thumbReadOnly,
    Color? focusColor,
    Color? labelColor,
    Color? stateTextColor,
    Color? textDisabled,
    Color? checkmarkColor,
  }) {
    return CarbonToggleThemeData(
      toggleOff: toggleOff ?? this.toggleOff,
      toggleOn: toggleOn ?? this.toggleOn,
      thumbColor: thumbColor ?? this.thumbColor,
      thumbColorDisabled: thumbColorDisabled ?? this.thumbColorDisabled,
      backgroundDisabled: backgroundDisabled ?? this.backgroundDisabled,
      borderReadOnly: borderReadOnly ?? this.borderReadOnly,
      thumbReadOnly: thumbReadOnly ?? this.thumbReadOnly,
      focusColor: focusColor ?? this.focusColor,
      labelColor: labelColor ?? this.labelColor,
      stateTextColor: stateTextColor ?? this.stateTextColor,
      textDisabled: textDisabled ?? this.textDisabled,
      checkmarkColor: checkmarkColor ?? this.checkmarkColor,
    );
  }

  @override
  CarbonToggleThemeData lerp(
      ThemeExtension<CarbonToggleThemeData>? other, double t) {
    if (other is! CarbonToggleThemeData) return this;
    return CarbonToggleThemeData(
      toggleOff: Color.lerp(toggleOff, other.toggleOff, t)!,
      toggleOn: Color.lerp(toggleOn, other.toggleOn, t)!,
      thumbColor: Color.lerp(thumbColor, other.thumbColor, t)!,
      thumbColorDisabled:
          Color.lerp(thumbColorDisabled, other.thumbColorDisabled, t)!,
      backgroundDisabled:
          Color.lerp(backgroundDisabled, other.backgroundDisabled, t)!,
      borderReadOnly: Color.lerp(borderReadOnly, other.borderReadOnly, t)!,
      thumbReadOnly: Color.lerp(thumbReadOnly, other.thumbReadOnly, t)!,
      focusColor: Color.lerp(focusColor, other.focusColor, t)!,
      labelColor: Color.lerp(labelColor, other.labelColor, t)!,
      stateTextColor: Color.lerp(stateTextColor, other.stateTextColor, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      checkmarkColor: Color.lerp(checkmarkColor, other.checkmarkColor, t)!,
    );
  }
}
