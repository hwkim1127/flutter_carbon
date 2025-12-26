import 'dart:ui' show Color;

import '../../../../foundation/colors.dart';
import '../../../component_themes/button_theme_data.dart';

/// White Theme implementation of [CarbonButtonThemeData].
class WhiteButtonThemeData extends CarbonButtonThemeData {
  const WhiteButtonThemeData()
      : super(
          buttonSeparator: const Color(0xFFe0e0e0), // gray20
          buttonPrimary: CarbonPalette.blue60,
          buttonSecondary: const Color(0xFF393939), // gray80
          buttonTertiary: CarbonPalette.blue60,
          buttonDangerPrimary: CarbonPalette.red60,
          buttonDangerSecondary: CarbonPalette.red60,
          buttonDangerActive: const Color(0xFF750e13), // red80
          buttonPrimaryActive: CarbonPalette.blue80,
          buttonSecondaryActive: CarbonPalette.gray60,
          buttonTertiaryActive: CarbonPalette.blue80,
          buttonDangerHover: CarbonPalette.red70,
          buttonPrimaryHover: CarbonPalette.blue70,
          buttonSecondaryHover: CarbonPalette.gray70,
          buttonTertiaryHover: CarbonPalette.blue70,
          buttonDisabled: const Color(0xFFc6c6c6), // gray30
        );
}
