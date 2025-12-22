import 'package:flutter/material.dart';
import '../../../../foundation/colors.dart';
import '../../../component_themes/ui_shell_theme_data.dart';

class WhiteUIShellThemeData extends CarbonUIShellThemeData {
  const WhiteUIShellThemeData()
    : super(
        // Header
        headerBackground: CarbonPalette.gray100,
        headerBorder: CarbonPalette.gray80,
        headerText: CarbonPalette.gray10,
        headerIconPrimary: CarbonPalette.gray10,
        headerIconSecondary: CarbonPalette.gray30,
        // Header nav items
        headerNavItemBackground: Colors.transparent,
        headerNavItemBackgroundHover: CarbonPalette.gray90Hover,
        headerNavItemBackgroundActive: CarbonPalette.gray80,
        headerNavItemBackgroundSelected: CarbonPalette.gray90,
        headerNavItemBackgroundSelectedHover: CarbonPalette.gray80Hover,
        headerNavItemText: CarbonPalette.gray10,
        headerNavItemTextHover: CarbonPalette.gray10,
        headerNavItemBorderActive: CarbonPalette.blue40,
        // Side nav
        sideNavBackground: CarbonPalette.gray100,
        sideNavOverlay: CarbonPalette.gray100,
        sideNavItemBackground: Colors.transparent,
        sideNavItemBackgroundHover: CarbonPalette.gray90Hover,
        sideNavItemBackgroundActive: CarbonPalette.gray80,
        sideNavItemText: CarbonPalette.gray10,
        sideNavItemTextHover: CarbonPalette.gray10,
        sideNavItemIcon: CarbonPalette.gray10,
        sideNavItemBorderActive: CarbonPalette.blue40,
        sideNavDivider: CarbonPalette.gray80,
        // Panel
        panelBackground: CarbonPalette.gray90,
        panelBorder: CarbonPalette.gray80,
      );
}
