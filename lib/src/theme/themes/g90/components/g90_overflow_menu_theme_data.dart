import 'package:flutter/material.dart';
import '../../../../foundation/colors.dart';
import '../../../component_themes/overflow_menu_theme_data.dart';

class G90OverflowMenuThemeData extends CarbonOverflowMenuThemeData {
  const G90OverflowMenuThemeData()
      : super(
          triggerBackground: Colors.transparent,
          triggerBackgroundHover: CarbonPalette.gray70Hover,
          triggerIcon: CarbonPalette.gray10,
          menuBackground: CarbonPalette.gray80,
          menuBorder: CarbonPalette.gray60,
          menuShadow: CarbonPalette.black,
          itemBackground: Colors.transparent,
          itemBackgroundHover: CarbonPalette.gray70Hover,
          itemText: CarbonPalette.gray10,
          itemTextHover: CarbonPalette.gray10,
          itemDangerText: CarbonPalette.red40,
          itemDangerTextHover: CarbonPalette.red30,
          divider: CarbonPalette.gray60,
        );
}
