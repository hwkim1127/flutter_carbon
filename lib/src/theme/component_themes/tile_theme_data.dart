import 'package:flutter/material.dart';

/// Tile theme data for Carbon Design System.
class CarbonTileThemeData {
  const CarbonTileThemeData({
    required this.background,
    required this.backgroundHover,
    required this.backgroundSelected,
    required this.border,
    required this.borderHover,
    required this.text,
    required this.textSecondary,
  });

  /// Background color for the tile.
  final Color background;

  /// Background color when hovering.
  final Color backgroundHover;

  /// Background color when selected.
  final Color backgroundSelected;

  /// Border color.
  final Color border;

  /// Border color when hovering.
  final Color borderHover;

  /// Primary text color.
  final Color text;

  /// Secondary text color.
  final Color textSecondary;

  CarbonTileThemeData copyWith({
    Color? background,
    Color? backgroundHover,
    Color? backgroundSelected,
    Color? border,
    Color? borderHover,
    Color? text,
    Color? textSecondary,
  }) {
    return CarbonTileThemeData(
      background: background ?? this.background,
      backgroundHover: backgroundHover ?? this.backgroundHover,
      backgroundSelected: backgroundSelected ?? this.backgroundSelected,
      border: border ?? this.border,
      borderHover: borderHover ?? this.borderHover,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }
}
