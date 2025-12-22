import 'package:flutter/material.dart';
import '../../../../foundation/colors.dart';
import '../../../component_themes/overflow_menu_theme_data.dart';

class WhiteOverflowMenuThemeData extends CarbonOverflowMenuThemeData {
  const WhiteOverflowMenuThemeData()
      : super(
          triggerBackground: Colors.transparent,
          triggerBackgroundHover: CarbonPalette.gray20Hover,
          triggerIcon: CarbonPalette.gray100,
          menuBackground: CarbonPalette.white,
          menuBorder: CarbonPalette.gray30,
          menuShadow: CarbonPalette.gray100,
          itemBackground: Colors.transparent,
          itemBackgroundHover: CarbonPalette.gray20Hover,
          itemText: CarbonPalette.gray100,
          itemTextHover: CarbonPalette.gray100,
          itemDangerText: CarbonPalette.red60,
          itemDangerTextHover: CarbonPalette.red70,
          divider: CarbonPalette.gray30,
        );
}
