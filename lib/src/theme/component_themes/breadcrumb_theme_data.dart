import 'package:flutter/material.dart';

@immutable
class CarbonBreadcrumbThemeData
    extends ThemeExtension<CarbonBreadcrumbThemeData> {
  /// Text color for breadcrumb links
  final Color linkColor;

  /// Text color for the current page (non-link)
  final Color currentColor;

  /// Separator color
  final Color separatorColor;

  /// Link color on hover
  final Color linkHoverColor;

  const CarbonBreadcrumbThemeData({
    required this.linkColor,
    required this.currentColor,
    required this.separatorColor,
    required this.linkHoverColor,
  });

  @override
  CarbonBreadcrumbThemeData copyWith({
    Color? linkColor,
    Color? currentColor,
    Color? separatorColor,
    Color? linkHoverColor,
  }) {
    return CarbonBreadcrumbThemeData(
      linkColor: linkColor ?? this.linkColor,
      currentColor: currentColor ?? this.currentColor,
      separatorColor: separatorColor ?? this.separatorColor,
      linkHoverColor: linkHoverColor ?? this.linkHoverColor,
    );
  }

  @override
  CarbonBreadcrumbThemeData lerp(
    ThemeExtension<CarbonBreadcrumbThemeData>? other,
    double t,
  ) {
    if (other is! CarbonBreadcrumbThemeData) return this;
    return CarbonBreadcrumbThemeData(
      linkColor: Color.lerp(linkColor, other.linkColor, t)!,
      currentColor: Color.lerp(currentColor, other.currentColor, t)!,
      separatorColor: Color.lerp(separatorColor, other.separatorColor, t)!,
      linkHoverColor: Color.lerp(linkHoverColor, other.linkHoverColor, t)!,
    );
  }
}
