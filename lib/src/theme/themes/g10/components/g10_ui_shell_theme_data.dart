import 'package:flutter/material.dart';
import '../../../../foundation/colors.dart';
import '../../../component_themes/ui_shell_theme_data.dart';

class G10UIShellThemeData extends CarbonUIShellThemeData {
  const G10UIShellThemeData()
      : super(
          // Header
          headerBackground: CarbonPalette.white,
          headerBorder: CarbonPalette.gray20,
          headerText: CarbonPalette.gray100,
          headerIconPrimary: CarbonPalette.gray100,
          headerIconSecondary: CarbonPalette.gray70,
          // Header nav items
          headerNavItemBackground: Colors.transparent,
          headerNavItemBackgroundHover: CarbonPalette.gray10Hover,
          headerNavItemBackgroundActive: CarbonPalette.gray20,
          headerNavItemBackgroundSelected: CarbonPalette.gray10,
          headerNavItemBackgroundSelectedHover: CarbonPalette.gray20Hover,
          headerNavItemText: CarbonPalette.gray100,
          headerNavItemTextHover: CarbonPalette.gray100,
          headerNavItemBorderActive: CarbonPalette.blue60,
          // Side nav
          sideNavBackground: CarbonPalette.white,
          sideNavOverlay: CarbonPalette.gray100,
          sideNavItemBackground: Colors.transparent,
          sideNavItemBackgroundHover: CarbonPalette.gray10Hover,
          sideNavItemBackgroundActive: CarbonPalette.gray20,
          sideNavItemText: CarbonPalette.gray100,
          sideNavItemTextHover: CarbonPalette.gray100,
          sideNavItemIcon: CarbonPalette.gray100,
          sideNavItemBorderActive: CarbonPalette.blue60,
          sideNavDivider: CarbonPalette.gray20,
          // Panel
          panelBackground: CarbonPalette.gray10,
          panelBorder: CarbonPalette.gray20,
        );
}
