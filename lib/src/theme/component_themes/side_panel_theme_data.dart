import 'package:flutter/material.dart';

/// Theme data for Carbon side panel (slide-in drawer from side).
@immutable
class CarbonSidePanelThemeData
    extends ThemeExtension<CarbonSidePanelThemeData> {
  /// Background color for the panel.
  final Color background;

  /// Background color for the overlay.
  final Color overlayColor;

  /// Text color for title.
  final Color titleColor;

  /// Text color for subtitle.
  final Color subtitleColor;

  /// Text color for label.
  final Color labelColor;

  /// Border color for the panel.
  final Color borderColor;

  /// Icon color for close/back buttons.
  final Color iconColor;

  /// Divider color between sections.
  final Color dividerColor;

  const CarbonSidePanelThemeData({
    required this.background,
    required this.overlayColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.labelColor,
    required this.borderColor,
    required this.iconColor,
    required this.dividerColor,
  });

  @override
  CarbonSidePanelThemeData copyWith({
    Color? background,
    Color? overlayColor,
    Color? titleColor,
    Color? subtitleColor,
    Color? labelColor,
    Color? borderColor,
    Color? iconColor,
    Color? dividerColor,
  }) {
    return CarbonSidePanelThemeData(
      background: background ?? this.background,
      overlayColor: overlayColor ?? this.overlayColor,
      titleColor: titleColor ?? this.titleColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      labelColor: labelColor ?? this.labelColor,
      borderColor: borderColor ?? this.borderColor,
      iconColor: iconColor ?? this.iconColor,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  @override
  CarbonSidePanelThemeData lerp(
      ThemeExtension<CarbonSidePanelThemeData>? other, double t) {
    if (other is! CarbonSidePanelThemeData) return this;
    return CarbonSidePanelThemeData(
      background: Color.lerp(background, other.background, t)!,
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t)!,
      titleColor: Color.lerp(titleColor, other.titleColor, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
      labelColor: Color.lerp(labelColor, other.labelColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
    );
  }
}
