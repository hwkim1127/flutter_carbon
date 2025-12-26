import 'package:flutter/material.dart';

/// Theme data for Carbon structured list (table-like list with rows/columns).
@immutable
class CarbonStructuredListThemeData
    extends ThemeExtension<CarbonStructuredListThemeData> {
  /// Background color for the list.
  final Color background;

  /// Background color for row on hover.
  final Color rowHover;

  /// Background color for selected row.
  final Color rowSelected;

  /// Border color for rows.
  final Color borderColor;

  /// Border color for header row.
  final Color headerBorderColor;

  /// Text color for header.
  final Color headerTextColor;

  /// Text color for row content.
  final Color rowTextColor;

  /// Text color for secondary/helper text.
  final Color helperTextColor;

  /// Background color for header.
  final Color headerBackground;

  const CarbonStructuredListThemeData({
    required this.background,
    required this.rowHover,
    required this.rowSelected,
    required this.borderColor,
    required this.headerBorderColor,
    required this.headerTextColor,
    required this.rowTextColor,
    required this.helperTextColor,
    required this.headerBackground,
  });

  @override
  CarbonStructuredListThemeData copyWith({
    Color? background,
    Color? rowHover,
    Color? rowSelected,
    Color? borderColor,
    Color? headerBorderColor,
    Color? headerTextColor,
    Color? rowTextColor,
    Color? helperTextColor,
    Color? headerBackground,
  }) {
    return CarbonStructuredListThemeData(
      background: background ?? this.background,
      rowHover: rowHover ?? this.rowHover,
      rowSelected: rowSelected ?? this.rowSelected,
      borderColor: borderColor ?? this.borderColor,
      headerBorderColor: headerBorderColor ?? this.headerBorderColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      rowTextColor: rowTextColor ?? this.rowTextColor,
      helperTextColor: helperTextColor ?? this.helperTextColor,
      headerBackground: headerBackground ?? this.headerBackground,
    );
  }

  @override
  CarbonStructuredListThemeData lerp(
      ThemeExtension<CarbonStructuredListThemeData>? other, double t) {
    if (other is! CarbonStructuredListThemeData) return this;
    return CarbonStructuredListThemeData(
      background: Color.lerp(background, other.background, t)!,
      rowHover: Color.lerp(rowHover, other.rowHover, t)!,
      rowSelected: Color.lerp(rowSelected, other.rowSelected, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      headerBorderColor:
          Color.lerp(headerBorderColor, other.headerBorderColor, t)!,
      headerTextColor: Color.lerp(headerTextColor, other.headerTextColor, t)!,
      rowTextColor: Color.lerp(rowTextColor, other.rowTextColor, t)!,
      helperTextColor: Color.lerp(helperTextColor, other.helperTextColor, t)!,
      headerBackground:
          Color.lerp(headerBackground, other.headerBackground, t)!,
    );
  }
}
