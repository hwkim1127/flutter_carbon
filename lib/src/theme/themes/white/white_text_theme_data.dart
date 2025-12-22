import 'package:flutter/material.dart';
import '../../../foundation/colors.dart';
import '../../component_themes/text_theme_data.dart';

/// White Theme implementation of [CarbonTextThemeData].
class WhiteTextThemeData extends CarbonTextThemeData {
  const WhiteTextThemeData()
    : super(
        textPrimary: CarbonPalette.gray100,
        textSecondary: CarbonPalette.gray70,
        textPlaceholder: const Color(0x66161616), // gray100 (0.4)
        textHelper: CarbonPalette.gray60,
        textError: CarbonPalette.red60,
        textInverse: CarbonPalette.white,
        textOnColor: CarbonPalette.white,
        textOnColorDisabled: CarbonPalette.gray50,
        textDisabled: const Color(0x40161616), // gray100 (0.25)
        linkPrimary: CarbonPalette.blue60,
        linkPrimaryHover: CarbonPalette.blue70,
        linkSecondary: CarbonPalette.blue70,
        linkInverse: CarbonPalette.blue40,
        linkVisited: CarbonPalette.purple60,
        linkInverseVisited: CarbonPalette.purple40,
        linkInverseActive: CarbonPalette.gray10,
        linkInverseHover: CarbonPalette.blue30,
        iconPrimary: CarbonPalette.gray100,
        iconSecondary: CarbonPalette.gray70,
        iconInverse: CarbonPalette.white,
        iconOnColor: CarbonPalette.white,
        iconOnColorDisabled: CarbonPalette.gray50,
        iconDisabled: const Color(0x40161616), // gray100 (0.25)
        iconInteractive: CarbonPalette.blue60,
      );
}
