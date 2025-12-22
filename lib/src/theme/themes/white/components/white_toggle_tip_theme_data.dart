import 'package:flutter/material.dart';
import '../../../../foundation/colors.dart';
import '../../../component_themes/toggle_tip_theme_data.dart';

class WhiteToggleTipThemeData extends CarbonToggleTipThemeData {
  const WhiteToggleTipThemeData()
      : super(
          buttonBackground: Colors.transparent,
          buttonBackgroundHover: CarbonPalette.gray20Hover,
          buttonIcon: CarbonPalette.gray100,
          contentBackground: CarbonPalette.gray10,
          contentText: CarbonPalette.gray100,
          border: CarbonPalette.gray40,
          caret: CarbonPalette.gray10,
          actionButtonText: CarbonPalette.blue60,
          actionButtonTextHover: CarbonPalette.blue70,
        );
}
