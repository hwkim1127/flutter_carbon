import 'package:flutter/material.dart';
import '../../../../foundation/colors.dart';
import '../../../component_themes/toggle_tip_theme_data.dart';

class G100ToggleTipThemeData extends CarbonToggleTipThemeData {
  const G100ToggleTipThemeData()
      : super(
          buttonBackground: Colors.transparent,
          buttonBackgroundHover: CarbonPalette.gray80Hover,
          buttonIcon: CarbonPalette.gray10,
          contentBackground: CarbonPalette.gray100,
          contentText: CarbonPalette.gray10,
          border: CarbonPalette.gray60,
          caret: CarbonPalette.gray100,
          actionButtonText: CarbonPalette.blue40,
          actionButtonTextHover: CarbonPalette.blue30,
        );
}
