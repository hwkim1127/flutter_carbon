import 'package:flutter/material.dart';

@immutable
class CarbonContentSwitcherThemeData
    extends ThemeExtension<CarbonContentSwitcherThemeData> {
  final Color contentSwitcherSelected;
  final Color contentSwitcherDivider;
  final Color contentSwitcherTextOnColor; // For the active state text usually
  final Color contentSwitcherBackground;
  final Color contentSwitcherBackgroundHover;
  // The base background often comes from transparent or layer tokens,
  // but let's check if there are specific tokens.
  // In v11:
  // content-switcher-active: background-selected
  // content-switcher-divider: border-subtle-01
  // content-switcher-text-on-color: text-on-color
  // content-switcher-hover: background-hover

  // We will define specific fields if they exist in tokens.js,
  // otherwise they might just be mapped from core tokens in the implementation.
  // Let's assume we want specific overrides possible.

  const CarbonContentSwitcherThemeData({
    required this.contentSwitcherSelected,
    required this.contentSwitcherDivider,
    required this.contentSwitcherTextOnColor,
    required this.contentSwitcherBackground,
    required this.contentSwitcherBackgroundHover,
  });

  @override
  CarbonContentSwitcherThemeData copyWith({
    Color? contentSwitcherSelected,
    Color? contentSwitcherDivider,
    Color? contentSwitcherTextOnColor,
    Color? contentSwitcherBackground,
    Color? contentSwitcherBackgroundHover,
  }) {
    return CarbonContentSwitcherThemeData(
      contentSwitcherSelected:
          contentSwitcherSelected ?? this.contentSwitcherSelected,
      contentSwitcherDivider:
          contentSwitcherDivider ?? this.contentSwitcherDivider,
      contentSwitcherTextOnColor:
          contentSwitcherTextOnColor ?? this.contentSwitcherTextOnColor,
      contentSwitcherBackground:
          contentSwitcherBackground ?? this.contentSwitcherBackground,
      contentSwitcherBackgroundHover:
          contentSwitcherBackgroundHover ?? this.contentSwitcherBackgroundHover,
    );
  }

  @override
  CarbonContentSwitcherThemeData lerp(
    ThemeExtension<CarbonContentSwitcherThemeData>? other,
    double t,
  ) {
    if (other is! CarbonContentSwitcherThemeData) return this;
    return CarbonContentSwitcherThemeData(
      contentSwitcherSelected: Color.lerp(
        contentSwitcherSelected,
        other.contentSwitcherSelected,
        t,
      )!,
      contentSwitcherDivider: Color.lerp(
        contentSwitcherDivider,
        other.contentSwitcherDivider,
        t,
      )!,
      contentSwitcherTextOnColor: Color.lerp(
        contentSwitcherTextOnColor,
        other.contentSwitcherTextOnColor,
        t,
      )!,
      contentSwitcherBackground: Color.lerp(
        contentSwitcherBackground,
        other.contentSwitcherBackground,
        t,
      )!,
      contentSwitcherBackgroundHover: Color.lerp(
        contentSwitcherBackgroundHover,
        other.contentSwitcherBackgroundHover,
        t,
      )!,
    );
  }
}
