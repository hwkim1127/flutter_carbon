import 'package:flutter/material.dart';

/// Theme data for Carbon combo box (autocomplete dropdown with search).
@immutable
class CarbonComboBoxThemeData
    extends ThemeExtension<CarbonComboBoxThemeData> {
  /// Background color for the input field.
  final Color fieldBackground;

  /// Background color for the input field on hover.
  final Color fieldBackgroundHover;

  /// Border color for the input field.
  final Color fieldBorder;

  /// Border color for the input field on focus.
  final Color fieldBorderFocus;

  /// Border color for the input field with error.
  final Color fieldBorderError;

  /// Text color for the input field.
  final Color textColor;

  /// Text color for the input field when disabled.
  final Color textColorDisabled;

  /// Text color for placeholder text.
  final Color placeholderColor;

  /// Icon color for the dropdown chevron.
  final Color iconColor;

  /// Icon color when disabled.
  final Color iconColorDisabled;

  /// Background color for the dropdown menu.
  final Color menuBackground;

  /// Background color for menu items on hover.
  final Color menuItemHover;

  /// Background color for selected menu item.
  final Color menuItemSelected;

  /// Text color for menu items.
  final Color menuItemText;

  /// Text color for disabled menu items.
  final Color menuItemTextDisabled;

  /// Color for the divider between input and dropdown.
  final Color dividerColor;

  const CarbonComboBoxThemeData({
    required this.fieldBackground,
    required this.fieldBackgroundHover,
    required this.fieldBorder,
    required this.fieldBorderFocus,
    required this.fieldBorderError,
    required this.textColor,
    required this.textColorDisabled,
    required this.placeholderColor,
    required this.iconColor,
    required this.iconColorDisabled,
    required this.menuBackground,
    required this.menuItemHover,
    required this.menuItemSelected,
    required this.menuItemText,
    required this.menuItemTextDisabled,
    required this.dividerColor,
  });

  @override
  CarbonComboBoxThemeData copyWith({
    Color? fieldBackground,
    Color? fieldBackgroundHover,
    Color? fieldBorder,
    Color? fieldBorderFocus,
    Color? fieldBorderError,
    Color? textColor,
    Color? textColorDisabled,
    Color? placeholderColor,
    Color? iconColor,
    Color? iconColorDisabled,
    Color? menuBackground,
    Color? menuItemHover,
    Color? menuItemSelected,
    Color? menuItemText,
    Color? menuItemTextDisabled,
    Color? dividerColor,
  }) {
    return CarbonComboBoxThemeData(
      fieldBackground: fieldBackground ?? this.fieldBackground,
      fieldBackgroundHover: fieldBackgroundHover ?? this.fieldBackgroundHover,
      fieldBorder: fieldBorder ?? this.fieldBorder,
      fieldBorderFocus: fieldBorderFocus ?? this.fieldBorderFocus,
      fieldBorderError: fieldBorderError ?? this.fieldBorderError,
      textColor: textColor ?? this.textColor,
      textColorDisabled: textColorDisabled ?? this.textColorDisabled,
      placeholderColor: placeholderColor ?? this.placeholderColor,
      iconColor: iconColor ?? this.iconColor,
      iconColorDisabled: iconColorDisabled ?? this.iconColorDisabled,
      menuBackground: menuBackground ?? this.menuBackground,
      menuItemHover: menuItemHover ?? this.menuItemHover,
      menuItemSelected: menuItemSelected ?? this.menuItemSelected,
      menuItemText: menuItemText ?? this.menuItemText,
      menuItemTextDisabled: menuItemTextDisabled ?? this.menuItemTextDisabled,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  @override
  CarbonComboBoxThemeData lerp(
      ThemeExtension<CarbonComboBoxThemeData>? other, double t) {
    if (other is! CarbonComboBoxThemeData) return this;
    return CarbonComboBoxThemeData(
      fieldBackground: Color.lerp(fieldBackground, other.fieldBackground, t)!,
      fieldBackgroundHover:
          Color.lerp(fieldBackgroundHover, other.fieldBackgroundHover, t)!,
      fieldBorder: Color.lerp(fieldBorder, other.fieldBorder, t)!,
      fieldBorderFocus:
          Color.lerp(fieldBorderFocus, other.fieldBorderFocus, t)!,
      fieldBorderError:
          Color.lerp(fieldBorderError, other.fieldBorderError, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      textColorDisabled:
          Color.lerp(textColorDisabled, other.textColorDisabled, t)!,
      placeholderColor:
          Color.lerp(placeholderColor, other.placeholderColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      iconColorDisabled:
          Color.lerp(iconColorDisabled, other.iconColorDisabled, t)!,
      menuBackground: Color.lerp(menuBackground, other.menuBackground, t)!,
      menuItemHover: Color.lerp(menuItemHover, other.menuItemHover, t)!,
      menuItemSelected:
          Color.lerp(menuItemSelected, other.menuItemSelected, t)!,
      menuItemText: Color.lerp(menuItemText, other.menuItemText, t)!,
      menuItemTextDisabled:
          Color.lerp(menuItemTextDisabled, other.menuItemTextDisabled, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
    );
  }
}
