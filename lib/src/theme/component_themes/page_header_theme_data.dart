import 'package:flutter/material.dart';

/// Theme data for Carbon Page Header component.
///
/// The Page Header provides a consistent header area for pages with
/// title, breadcrumbs, actions, and optional tabs.
@immutable
class CarbonPageHeaderThemeData
    extends ThemeExtension<CarbonPageHeaderThemeData> {
  /// Background color of the page header.
  final Color background;

  /// Title text color.
  final Color titleText;

  /// Subtitle text color.
  final Color subtitleText;

  /// Description text color.
  final Color descriptionText;

  /// Icon color.
  final Color icon;

  /// Border color (for breadcrumb bar).
  final Color border;

  /// Background for breadcrumb area.
  final Color breadcrumbBackground;

  /// Action button text color.
  final Color actionText;

  /// Action button text hover color.
  final Color actionTextHover;

  const CarbonPageHeaderThemeData({
    required this.background,
    required this.titleText,
    required this.subtitleText,
    required this.descriptionText,
    required this.icon,
    required this.border,
    required this.breadcrumbBackground,
    required this.actionText,
    required this.actionTextHover,
  });

  @override
  CarbonPageHeaderThemeData copyWith({
    Color? background,
    Color? titleText,
    Color? subtitleText,
    Color? descriptionText,
    Color? icon,
    Color? border,
    Color? breadcrumbBackground,
    Color? actionText,
    Color? actionTextHover,
  }) {
    return CarbonPageHeaderThemeData(
      background: background ?? this.background,
      titleText: titleText ?? this.titleText,
      subtitleText: subtitleText ?? this.subtitleText,
      descriptionText: descriptionText ?? this.descriptionText,
      icon: icon ?? this.icon,
      border: border ?? this.border,
      breadcrumbBackground: breadcrumbBackground ?? this.breadcrumbBackground,
      actionText: actionText ?? this.actionText,
      actionTextHover: actionTextHover ?? this.actionTextHover,
    );
  }

  @override
  CarbonPageHeaderThemeData lerp(
    ThemeExtension<CarbonPageHeaderThemeData>? other,
    double t,
  ) {
    if (other is! CarbonPageHeaderThemeData) return this;
    return CarbonPageHeaderThemeData(
      background: Color.lerp(background, other.background, t)!,
      titleText: Color.lerp(titleText, other.titleText, t)!,
      subtitleText: Color.lerp(subtitleText, other.subtitleText, t)!,
      descriptionText: Color.lerp(descriptionText, other.descriptionText, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      border: Color.lerp(border, other.border, t)!,
      breadcrumbBackground:
          Color.lerp(breadcrumbBackground, other.breadcrumbBackground, t)!,
      actionText: Color.lerp(actionText, other.actionText, t)!,
      actionTextHover: Color.lerp(actionTextHover, other.actionTextHover, t)!,
    );
  }
}
