import 'package:flutter/material.dart';

/// Contained list theme data for Carbon Design System.
class CarbonContainedListThemeData {
  const CarbonContainedListThemeData({
    required this.background,
    required this.border,
    required this.headerBackground,
    required this.itemBackground,
    required this.itemBackgroundHover,
    required this.divider,
    required this.text,
    required this.textSecondary,
  });

  /// Background color for the container.
  final Color background;

  /// Border color.
  final Color border;

  /// Header background color.
  final Color headerBackground;

  /// List item background color.
  final Color itemBackground;

  /// List item background color on hover.
  final Color itemBackgroundHover;

  /// Divider color between items.
  final Color divider;

  /// Primary text color.
  final Color text;

  /// Secondary text color.
  final Color textSecondary;

  CarbonContainedListThemeData copyWith({
    Color? background,
    Color? border,
    Color? headerBackground,
    Color? itemBackground,
    Color? itemBackgroundHover,
    Color? divider,
    Color? text,
    Color? textSecondary,
  }) {
    return CarbonContainedListThemeData(
      background: background ?? this.background,
      border: border ?? this.border,
      headerBackground: headerBackground ?? this.headerBackground,
      itemBackground: itemBackground ?? this.itemBackground,
      itemBackgroundHover: itemBackgroundHover ?? this.itemBackgroundHover,
      divider: divider ?? this.divider,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }
}
