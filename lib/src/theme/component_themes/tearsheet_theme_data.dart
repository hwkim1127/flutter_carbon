import 'package:flutter/material.dart';

/// Theme data for Carbon tearsheet (full-height slide-in panel from bottom).
@immutable
class CarbonTearsheetThemeData
    extends ThemeExtension<CarbonTearsheetThemeData> {
  /// Background color for the tearsheet.
  final Color background;

  /// Background color for the overlay/scrim.
  final Color overlayColor;

  /// Text color for title.
  final Color titleColor;

  /// Text color for subtitle/description.
  final Color subtitleColor;

  /// Text color for label.
  final Color labelColor;

  /// Border color for the tearsheet.
  final Color borderColor;

  /// Icon color for close/back buttons.
  final Color iconColor;

  /// Divider color between sections.
  final Color dividerColor;

  /// Background color for the influencer section.
  final Color influencerBackground;

  const CarbonTearsheetThemeData({
    required this.background,
    required this.overlayColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.labelColor,
    required this.borderColor,
    required this.iconColor,
    required this.dividerColor,
    required this.influencerBackground,
  });

  @override
  CarbonTearsheetThemeData copyWith({
    Color? background,
    Color? overlayColor,
    Color? titleColor,
    Color? subtitleColor,
    Color? labelColor,
    Color? borderColor,
    Color? iconColor,
    Color? dividerColor,
    Color? influencerBackground,
  }) {
    return CarbonTearsheetThemeData(
      background: background ?? this.background,
      overlayColor: overlayColor ?? this.overlayColor,
      titleColor: titleColor ?? this.titleColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      labelColor: labelColor ?? this.labelColor,
      borderColor: borderColor ?? this.borderColor,
      iconColor: iconColor ?? this.iconColor,
      dividerColor: dividerColor ?? this.dividerColor,
      influencerBackground: influencerBackground ?? this.influencerBackground,
    );
  }

  @override
  CarbonTearsheetThemeData lerp(
      ThemeExtension<CarbonTearsheetThemeData>? other, double t) {
    if (other is! CarbonTearsheetThemeData) return this;
    return CarbonTearsheetThemeData(
      background: Color.lerp(background, other.background, t)!,
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t)!,
      titleColor: Color.lerp(titleColor, other.titleColor, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
      labelColor: Color.lerp(labelColor, other.labelColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      influencerBackground:
          Color.lerp(influencerBackground, other.influencerBackground, t)!,
    );
  }
}
