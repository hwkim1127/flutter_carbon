import 'dart:ui' show Color;

import '../../../../foundation/colors.dart';
import '../../../component_themes/button_theme_data.dart';

/// Gray 100 Theme implementation of [CarbonButtonThemeData].
class G100ButtonThemeData extends CarbonButtonThemeData {
  const G100ButtonThemeData()
      : super(
          buttonPrimary: CarbonPalette.blue60,
          buttonPrimaryActive:
              CarbonPalette.blue80, // buttonPrimaryActive = #002d9c (blue80)
          buttonPrimaryHover:
              CarbonPalette.blue50, // buttonPrimaryHover = #0050e6 (blue50)
          buttonSecondary:
              CarbonPalette.gray60, // buttonSecondary = #6f6f6f (gray60)
          buttonSecondaryActive:
              CarbonPalette.gray80, // buttonSecondaryActive = #393939 (gray80)
          buttonSecondaryHover:
              CarbonPalette.gray70, // buttonSecondaryHover = #5e5e5e (gray70)
          buttonTertiary: CarbonPalette.white, // buttonTertiary = #ffffff
          buttonTertiaryActive:
              CarbonPalette.gray30, // buttonTertiaryActive = #c6c6c6 (gray30)
          buttonTertiaryHover:
              CarbonPalette.gray10, // buttonTertiaryHover = #f4f4f4 (gray10)
          buttonDangerPrimary:
              CarbonPalette.red60, // buttonDangerPrimary = #da1e28 (red60)
          buttonDangerSecondary:
              CarbonPalette.red50, // buttonDangerSecondary = #fa4d56 (red50)
          buttonDangerActive:
              CarbonPalette.red80, // buttonDangerActive = #750e13 (red80)
          buttonDangerHover:
              CarbonPalette.red70, // buttonDangerHover = #b81921 (red70)
          buttonSeparator:
              CarbonPalette.gray100, // buttonSeparator = #161616 (gray100)
          buttonDisabled: const Color(0x4D8D8D8D), // gray50 (0.3)
        );
}
