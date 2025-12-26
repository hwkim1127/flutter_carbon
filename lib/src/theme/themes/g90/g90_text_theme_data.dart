import 'dart:ui' show Color;

import '../../../foundation/colors.dart';
import '../../component_themes/text_theme_data.dart';

/// Gray 90 Theme implementation of [CarbonTextThemeData].
class G90TextThemeData extends CarbonTextThemeData {
  const G90TextThemeData()
      : super(
          textPrimary: CarbonPalette.gray10,
          textSecondary: CarbonPalette.gray30,
          textPlaceholder: const Color(0x66F4F4F4), // gray10 @ 0.4
          textOnColor: CarbonPalette.white,
          textOnColorDisabled: const Color(
            0x40FFFFFF,
          ), // white @ 0.25 (textOnColor @ 0.25)
          textHelper: CarbonPalette.gray30,
          textError: CarbonPalette.red30,
          textInverse: CarbonPalette.gray100,
          textDisabled: const Color(0x40F4F4F4), // gray10 @ 0.25
          linkPrimary: CarbonPalette.blue40,
          linkPrimaryHover: CarbonPalette.blue30,
          linkSecondary: CarbonPalette.blue30,
          linkInverse: CarbonPalette.blue60,
          linkVisited: CarbonPalette.purple40,
          linkInverseVisited: CarbonPalette.purple60,
          linkInverseActive: CarbonPalette.gray100,
          linkInverseHover: CarbonPalette.blue70,
          iconPrimary: CarbonPalette.gray10,
          iconSecondary: CarbonPalette.gray30,
          iconInverse: CarbonPalette.gray100,
          iconOnColor: CarbonPalette.white,
          iconOnColorDisabled: const Color(0x40FFFFFF), // white @ 0.25
          iconDisabled: const Color(0x40F4F4F4), // gray10 @ 0.25
          iconInteractive: CarbonPalette.white,
        );
}
