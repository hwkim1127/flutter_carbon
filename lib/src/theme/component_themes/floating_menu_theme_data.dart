import 'package:flutter/material.dart';

/// Floating menu theme data for Carbon Design System.
class CarbonFloatingMenuThemeData {
  const CarbonFloatingMenuThemeData({
    required this.fabBackground,
    required this.fabForeground,
    required this.menuBackground,
    required this.menuItemBackground,
    required this.menuItemBackgroundHover,
    required this.text,
  });

  /// FAB background color.
  final Color fabBackground;

  /// FAB foreground/icon color.
  final Color fabForeground;

  /// Menu background color.
  final Color menuBackground;

  /// Menu item background color.
  final Color menuItemBackground;

  /// Menu item background color on hover.
  final Color menuItemBackgroundHover;

  /// Text color.
  final Color text;

  CarbonFloatingMenuThemeData copyWith({
    Color? fabBackground,
    Color? fabForeground,
    Color? menuBackground,
    Color? menuItemBackground,
    Color? menuItemBackgroundHover,
    Color? text,
  }) {
    return CarbonFloatingMenuThemeData(
      fabBackground: fabBackground ?? this.fabBackground,
      fabForeground: fabForeground ?? this.fabForeground,
      menuBackground: menuBackground ?? this.menuBackground,
      menuItemBackground: menuItemBackground ?? this.menuItemBackground,
      menuItemBackgroundHover:
          menuItemBackgroundHover ?? this.menuItemBackgroundHover,
      text: text ?? this.text,
    );
  }
}
