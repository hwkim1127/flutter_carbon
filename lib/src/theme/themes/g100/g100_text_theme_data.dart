import 'package:flutter/material.dart';
import '../../../foundation/colors.dart';
import '../../component_themes/text_theme_data.dart';

/// Gray 100 Theme implementation of [CarbonTextThemeData].
class G100TextThemeData extends CarbonTextThemeData {
  const G100TextThemeData()
      : super(
          textPrimary: CarbonPalette.gray10,
          textSecondary: CarbonPalette.gray30,
          textPlaceholder: const Color(0x66F4F4F4), // gray10 (0.4)
          textHelper: CarbonPalette.gray40,
          textError: CarbonPalette.red40,
          textInverse: CarbonPalette.gray100,
          textOnColor: CarbonPalette.white,
          textOnColorDisabled: const Color(0x40FFFFFF), // white (0.25)
          textDisabled: const Color(0x40F4F4F4), // gray10 (0.25)
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
          iconOnColorDisabled: const Color(0x40FFFFFF), // white (0.25)
          iconDisabled: const Color(0x40F4F4F4), // gray10 (0.25)
          iconInteractive: CarbonPalette.white,
        );
}
