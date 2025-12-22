import 'dart:ui' show Color;

import '../../../../foundation/colors.dart';
import '../../../component_themes/button_theme_data.dart';

/// Gray 90 Theme implementation of [CarbonButtonThemeData].
class G90ButtonThemeData extends CarbonButtonThemeData {
  const G90ButtonThemeData()
    : super(
        buttonPrimary: CarbonPalette.blue60,
        buttonPrimaryHover:
            CarbonPalette.blue70, // using standard map for consistency
        buttonPrimaryActive: CarbonPalette.blue80,
        buttonSecondary: CarbonPalette.gray60,
        buttonSecondaryHover: CarbonPalette.gray60Hover,
        buttonSecondaryActive: CarbonPalette.gray80,
        buttonTertiary: CarbonPalette.white,
        buttonTertiaryHover: CarbonPalette.gray10,
        buttonTertiaryActive: CarbonPalette.gray30,
        buttonDangerPrimary: CarbonPalette.red60,
        buttonDangerSecondary: CarbonPalette.red60,
        buttonDangerActive: CarbonPalette.red80,
        buttonDangerHover: CarbonPalette.red70,
        buttonSeparator: CarbonPalette.gray100,
        buttonDisabled: const Color(0x4D8D8D8D), // gray50 @ 0.3
      );
}
