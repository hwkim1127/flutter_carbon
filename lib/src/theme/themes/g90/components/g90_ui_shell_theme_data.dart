import 'package:flutter/material.dart';
import '../../../../foundation/colors.dart';
import '../../../component_themes/ui_shell_theme_data.dart';

class G90UIShellThemeData extends CarbonUIShellThemeData {
  const G90UIShellThemeData()
      : super(
          // Header
          headerBackground: CarbonPalette.gray90,
          headerBorder: CarbonPalette.gray80,
          headerText: CarbonPalette.gray10,
          headerIconPrimary: CarbonPalette.gray10,
          headerIconSecondary: CarbonPalette.gray30,
          // Header nav items
          headerNavItemBackground: Colors.transparent,
          headerNavItemBackgroundHover: CarbonPalette.gray80Hover,
          headerNavItemBackgroundActive: CarbonPalette.gray70,
          headerNavItemBackgroundSelected: CarbonPalette.gray80,
          headerNavItemBackgroundSelectedHover: CarbonPalette.gray70Hover,
          headerNavItemText: CarbonPalette.gray10,
          headerNavItemTextHover: CarbonPalette.gray10,
          headerNavItemBorderActive: CarbonPalette.blue40,
          // Side nav
          sideNavBackground: CarbonPalette.gray90,
          sideNavOverlay: CarbonPalette.gray100,
          sideNavItemBackground: Colors.transparent,
          sideNavItemBackgroundHover: CarbonPalette.gray80Hover,
          sideNavItemBackgroundActive: CarbonPalette.gray70,
          sideNavItemText: CarbonPalette.gray10,
          sideNavItemTextHover: CarbonPalette.gray10,
          sideNavItemIcon: CarbonPalette.gray10,
          sideNavItemBorderActive: CarbonPalette.blue40,
          sideNavDivider: CarbonPalette.gray80,
          // Panel
          panelBackground: CarbonPalette.gray80,
          panelBorder: CarbonPalette.gray70,
        );
}
