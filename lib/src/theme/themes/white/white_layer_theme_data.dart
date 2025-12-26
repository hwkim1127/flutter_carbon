import 'package:flutter/material.dart';
import '../../../foundation/colors.dart';
import '../../component_themes/layer_theme_data.dart';

/// White Theme implementation of [CarbonLayerThemeData].
class WhiteLayerThemeData extends CarbonLayerThemeData {
  const WhiteLayerThemeData()
      : super(
          // Backgrounds
          background: CarbonPalette.white,
          backgroundInverse: CarbonPalette.gray80,
          backgroundBrand: CarbonPalette.blue60,
          backgroundActive: const Color(0x808D8D8D), // gray50 (0.5)
          backgroundHover: const Color(0x1F8D8D8D), // gray50 (0.12)
          backgroundInverseHover: CarbonPalette
              .gray80Hover, // Need to verify if this token exists in Palette or use generic hover logic
          backgroundSelected: const Color(0x338D8D8D), // gray50 (0.2)
          backgroundSelectedHover: const Color(0x528D8D8D), // gray50 (0.32)
          // Layer 01
          layer01: CarbonPalette.gray10,
          layerActive01: CarbonPalette.gray30,
          layerBackground01: CarbonPalette.white,
          layerHover01: CarbonPalette.gray10Hover, // Verify Palette
          layerSelected01: CarbonPalette.gray20,
          layerSelectedHover01: CarbonPalette.gray20Hover, // Verify Palette
          // Layer 02
          layer02: CarbonPalette.white,
          layerActive02: CarbonPalette.gray30,
          layerBackground02: CarbonPalette.gray10,
          layerHover02: CarbonPalette.whiteHover, // Verify Palette
          layerSelected02: CarbonPalette.gray20,
          layerSelectedHover02: CarbonPalette.gray20Hover,

          // Layer 03
          layer03: CarbonPalette.gray10,
          layerActive03: CarbonPalette.gray30,
          layerBackground03: CarbonPalette.white,
          layerHover03: CarbonPalette.gray10Hover,
          layerSelected03: CarbonPalette.gray20,
          layerSelectedHover03: CarbonPalette.gray20Hover,

          // Generic Layer
          layerSelectedInverse: CarbonPalette.gray100,
          layerSelectedDisabled: CarbonPalette.gray50,

          // Layer Accents
          layerAccent01: CarbonPalette.gray20,
          layerAccentActive01: CarbonPalette.gray40,
          layerAccentHover01: CarbonPalette.gray20Hover,
          layerAccent02: CarbonPalette.gray20,
          layerAccentActive02: CarbonPalette.gray40,
          layerAccentHover02: CarbonPalette.gray20Hover,
          layerAccent03: CarbonPalette.gray20,
          layerAccentActive03: CarbonPalette.gray40,
          layerAccentHover03: CarbonPalette.gray20Hover,

          // Field
          field01: CarbonPalette.gray10,
          fieldHover01: CarbonPalette.gray10Hover,
          field02: CarbonPalette.white,
          fieldHover02: CarbonPalette.whiteHover,
          field03: CarbonPalette.gray10,
          fieldHover03: CarbonPalette.gray10Hover,

          // Border
          borderSubtle00: CarbonPalette.gray20,
          borderSubtle01: CarbonPalette.gray30,
          borderSubtleSelected01: CarbonPalette.gray30,
          borderSubtle02: CarbonPalette.gray20,
          borderSubtleSelected02: CarbonPalette.gray30,
          borderSubtle03: CarbonPalette.gray30,
          borderSubtleSelected03: CarbonPalette.gray30,
          borderStrong01: CarbonPalette.gray50,
          borderStrong02: CarbonPalette.gray50,
          borderStrong03: CarbonPalette.gray50,
          borderTile01: CarbonPalette.gray30,
          borderTile02: CarbonPalette.gray40,
          borderTile03: CarbonPalette.gray30,
          borderInverse: CarbonPalette.gray100,
          borderInteractive: CarbonPalette.blue60,
          borderDisabled: CarbonPalette.gray30,

          // Focus
          focus: CarbonPalette.blue60,
          focusInset: CarbonPalette.white,
          focusInverse: CarbonPalette.white,

          // Misc
          interactive: CarbonPalette.blue60,
          highlight: CarbonPalette.blue20,
          overlay: CarbonPalette.overlay, // rgba(black, 0.6)
          toggleOff: CarbonPalette.gray50,
          shadow: const Color(0x4D000000), // rgba(0,0,0,0.3)
          // Support
          supportError: CarbonPalette.red60,
          supportSuccess: CarbonPalette.green50,
          supportWarning: CarbonPalette.yellow30,
          supportInfo: CarbonPalette.blue70,
          supportErrorInverse: CarbonPalette.red50,
          supportSuccessInverse: CarbonPalette.green40,
          supportWarningInverse: CarbonPalette.yellow30,
          supportInfoInverse: CarbonPalette.blue50,
          supportCautionMinor: CarbonPalette.yellow30,
          supportCautionMajor: CarbonPalette.orange40,
          supportCautionUndefined: CarbonPalette.purple60,
        );
}
