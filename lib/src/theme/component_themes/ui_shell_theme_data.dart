import 'package:flutter/material.dart';

/// Theme data for Carbon UI Shell component.
///
/// The UI Shell provides the global navigation framework including header,
/// side navigation, and panels.
@immutable
class CarbonUIShellThemeData extends ThemeExtension<CarbonUIShellThemeData> {
  // Header colors
  final Color headerBackground;
  final Color headerBorder;
  final Color headerText;
  final Color headerIconPrimary;
  final Color headerIconSecondary;

  // Header nav item colors
  final Color headerNavItemBackground;
  final Color headerNavItemBackgroundHover;
  final Color headerNavItemBackgroundActive;
  final Color headerNavItemBackgroundSelected;
  final Color headerNavItemBackgroundSelectedHover;
  final Color headerNavItemText;
  final Color headerNavItemTextHover;
  final Color headerNavItemBorderActive;

  // Side nav colors
  final Color sideNavBackground;
  final Color sideNavOverlay;
  final Color sideNavItemBackground;
  final Color sideNavItemBackgroundHover;
  final Color sideNavItemBackgroundActive;
  final Color sideNavItemText;
  final Color sideNavItemTextHover;
  final Color sideNavItemIcon;
  final Color sideNavItemBorderActive;
  final Color sideNavDivider;

  // Panel colors
  final Color panelBackground;
  final Color panelBorder;

  const CarbonUIShellThemeData({
    required this.headerBackground,
    required this.headerBorder,
    required this.headerText,
    required this.headerIconPrimary,
    required this.headerIconSecondary,
    required this.headerNavItemBackground,
    required this.headerNavItemBackgroundHover,
    required this.headerNavItemBackgroundActive,
    required this.headerNavItemBackgroundSelected,
    required this.headerNavItemBackgroundSelectedHover,
    required this.headerNavItemText,
    required this.headerNavItemTextHover,
    required this.headerNavItemBorderActive,
    required this.sideNavBackground,
    required this.sideNavOverlay,
    required this.sideNavItemBackground,
    required this.sideNavItemBackgroundHover,
    required this.sideNavItemBackgroundActive,
    required this.sideNavItemText,
    required this.sideNavItemTextHover,
    required this.sideNavItemIcon,
    required this.sideNavItemBorderActive,
    required this.sideNavDivider,
    required this.panelBackground,
    required this.panelBorder,
  });

  @override
  CarbonUIShellThemeData copyWith({
    Color? headerBackground,
    Color? headerBorder,
    Color? headerText,
    Color? headerIconPrimary,
    Color? headerIconSecondary,
    Color? headerNavItemBackground,
    Color? headerNavItemBackgroundHover,
    Color? headerNavItemBackgroundActive,
    Color? headerNavItemBackgroundSelected,
    Color? headerNavItemBackgroundSelectedHover,
    Color? headerNavItemText,
    Color? headerNavItemTextHover,
    Color? headerNavItemBorderActive,
    Color? sideNavBackground,
    Color? sideNavOverlay,
    Color? sideNavItemBackground,
    Color? sideNavItemBackgroundHover,
    Color? sideNavItemBackgroundActive,
    Color? sideNavItemText,
    Color? sideNavItemTextHover,
    Color? sideNavItemIcon,
    Color? sideNavItemBorderActive,
    Color? sideNavDivider,
    Color? panelBackground,
    Color? panelBorder,
  }) {
    return CarbonUIShellThemeData(
      headerBackground: headerBackground ?? this.headerBackground,
      headerBorder: headerBorder ?? this.headerBorder,
      headerText: headerText ?? this.headerText,
      headerIconPrimary: headerIconPrimary ?? this.headerIconPrimary,
      headerIconSecondary: headerIconSecondary ?? this.headerIconSecondary,
      headerNavItemBackground: headerNavItemBackground ?? this.headerNavItemBackground,
      headerNavItemBackgroundHover: headerNavItemBackgroundHover ?? this.headerNavItemBackgroundHover,
      headerNavItemBackgroundActive: headerNavItemBackgroundActive ?? this.headerNavItemBackgroundActive,
      headerNavItemBackgroundSelected: headerNavItemBackgroundSelected ?? this.headerNavItemBackgroundSelected,
      headerNavItemBackgroundSelectedHover: headerNavItemBackgroundSelectedHover ?? this.headerNavItemBackgroundSelectedHover,
      headerNavItemText: headerNavItemText ?? this.headerNavItemText,
      headerNavItemTextHover: headerNavItemTextHover ?? this.headerNavItemTextHover,
      headerNavItemBorderActive: headerNavItemBorderActive ?? this.headerNavItemBorderActive,
      sideNavBackground: sideNavBackground ?? this.sideNavBackground,
      sideNavOverlay: sideNavOverlay ?? this.sideNavOverlay,
      sideNavItemBackground: sideNavItemBackground ?? this.sideNavItemBackground,
      sideNavItemBackgroundHover: sideNavItemBackgroundHover ?? this.sideNavItemBackgroundHover,
      sideNavItemBackgroundActive: sideNavItemBackgroundActive ?? this.sideNavItemBackgroundActive,
      sideNavItemText: sideNavItemText ?? this.sideNavItemText,
      sideNavItemTextHover: sideNavItemTextHover ?? this.sideNavItemTextHover,
      sideNavItemIcon: sideNavItemIcon ?? this.sideNavItemIcon,
      sideNavItemBorderActive: sideNavItemBorderActive ?? this.sideNavItemBorderActive,
      sideNavDivider: sideNavDivider ?? this.sideNavDivider,
      panelBackground: panelBackground ?? this.panelBackground,
      panelBorder: panelBorder ?? this.panelBorder,
    );
  }

  @override
  CarbonUIShellThemeData lerp(
    ThemeExtension<CarbonUIShellThemeData>? other,
    double t,
  ) {
    if (other is! CarbonUIShellThemeData) return this;
    return CarbonUIShellThemeData(
      headerBackground: Color.lerp(headerBackground, other.headerBackground, t)!,
      headerBorder: Color.lerp(headerBorder, other.headerBorder, t)!,
      headerText: Color.lerp(headerText, other.headerText, t)!,
      headerIconPrimary: Color.lerp(headerIconPrimary, other.headerIconPrimary, t)!,
      headerIconSecondary: Color.lerp(headerIconSecondary, other.headerIconSecondary, t)!,
      headerNavItemBackground: Color.lerp(headerNavItemBackground, other.headerNavItemBackground, t)!,
      headerNavItemBackgroundHover: Color.lerp(headerNavItemBackgroundHover, other.headerNavItemBackgroundHover, t)!,
      headerNavItemBackgroundActive: Color.lerp(headerNavItemBackgroundActive, other.headerNavItemBackgroundActive, t)!,
      headerNavItemBackgroundSelected: Color.lerp(headerNavItemBackgroundSelected, other.headerNavItemBackgroundSelected, t)!,
      headerNavItemBackgroundSelectedHover: Color.lerp(headerNavItemBackgroundSelectedHover, other.headerNavItemBackgroundSelectedHover, t)!,
      headerNavItemText: Color.lerp(headerNavItemText, other.headerNavItemText, t)!,
      headerNavItemTextHover: Color.lerp(headerNavItemTextHover, other.headerNavItemTextHover, t)!,
      headerNavItemBorderActive: Color.lerp(headerNavItemBorderActive, other.headerNavItemBorderActive, t)!,
      sideNavBackground: Color.lerp(sideNavBackground, other.sideNavBackground, t)!,
      sideNavOverlay: Color.lerp(sideNavOverlay, other.sideNavOverlay, t)!,
      sideNavItemBackground: Color.lerp(sideNavItemBackground, other.sideNavItemBackground, t)!,
      sideNavItemBackgroundHover: Color.lerp(sideNavItemBackgroundHover, other.sideNavItemBackgroundHover, t)!,
      sideNavItemBackgroundActive: Color.lerp(sideNavItemBackgroundActive, other.sideNavItemBackgroundActive, t)!,
      sideNavItemText: Color.lerp(sideNavItemText, other.sideNavItemText, t)!,
      sideNavItemTextHover: Color.lerp(sideNavItemTextHover, other.sideNavItemTextHover, t)!,
      sideNavItemIcon: Color.lerp(sideNavItemIcon, other.sideNavItemIcon, t)!,
      sideNavItemBorderActive: Color.lerp(sideNavItemBorderActive, other.sideNavItemBorderActive, t)!,
      sideNavDivider: Color.lerp(sideNavDivider, other.sideNavDivider, t)!,
      panelBackground: Color.lerp(panelBackground, other.panelBackground, t)!,
      panelBorder: Color.lerp(panelBorder, other.panelBorder, t)!,
    );
  }
}
