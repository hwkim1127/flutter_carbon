import 'package:flutter/material.dart';
import '../../../foundation/colors.dart';
import '../../component_themes/layer_theme_data.dart';

/// Gray 90 Theme implementation of [CarbonLayerThemeData].
class G90LayerThemeData extends CarbonLayerThemeData {
  const G90LayerThemeData()
      : super(
          background: CarbonPalette.gray90,
          backgroundInverse: CarbonPalette.gray10,
          backgroundBrand: CarbonPalette.blue60,
          // gray50 @ 0.4 (g90.js adjustAlpha)
          backgroundActive: const Color(0x668D8D8D),
          backgroundHover: const Color(0x298D8D8D), // gray50 @ 0.16
          backgroundInverseHover: CarbonPalette.gray10Hover,
          backgroundSelected: const Color(0x3D8D8D8D), // gray50 @ 0.24
          backgroundSelectedHover: const Color(0x528D8D8D), // gray50 @ 0.32
          layer01: CarbonPalette.gray80,
          layerActive01: CarbonPalette.gray60,
          layerBackground01: CarbonPalette.gray90,
          layerHover01: CarbonPalette.gray80Hover,
          layerSelected01: CarbonPalette.gray70,
          layerSelectedHover01: CarbonPalette.gray70Hover,
          layer02: CarbonPalette.gray70,
          layerActive02: CarbonPalette.gray50,
          layerBackground02: CarbonPalette.gray80,
          layerHover02: CarbonPalette.gray70Hover,
          layerSelected02: CarbonPalette.gray60,
          layerSelectedHover02: CarbonPalette.gray60Hover,
          layer03: CarbonPalette.gray60,
          layerActive03: CarbonPalette.gray80,
          layerBackground03: CarbonPalette.gray70,
          layerHover03: CarbonPalette.gray60Hover,
          layerSelected03: CarbonPalette.gray70,
          layerSelectedHover03: CarbonPalette.gray70Hover,
          layerSelectedInverse: CarbonPalette.gray10,
          layerSelectedDisabled: CarbonPalette.gray40,
          layerAccent01: CarbonPalette.gray70,
          layerAccentActive01: CarbonPalette.gray50,
          layerAccentHover01: CarbonPalette.gray70Hover,
          layerAccent02: CarbonPalette.gray60,
          layerAccentActive02: CarbonPalette.gray80,
          layerAccentHover02: CarbonPalette.gray60Hover,
          layerAccent03: CarbonPalette.gray50,
          layerAccentActive03: CarbonPalette.gray70,
          layerAccentHover03: CarbonPalette.gray50Hover,
          field01: CarbonPalette.gray80,
          fieldHover01: CarbonPalette.gray80Hover,
          field02: CarbonPalette.gray70,
          fieldHover02: CarbonPalette.gray70Hover,
          field03: CarbonPalette.gray60,
          fieldHover03: CarbonPalette.gray60Hover,
          borderSubtle00: CarbonPalette.gray70,
          borderSubtle01: CarbonPalette.gray60,
          borderSubtleSelected01: CarbonPalette.gray50,
          borderSubtle02: CarbonPalette.gray50,
          borderSubtleSelected02: CarbonPalette.gray40,
          borderSubtle03: CarbonPalette.gray50,
          borderSubtleSelected03: CarbonPalette.gray40,
          borderStrong01: CarbonPalette.gray50,
          borderStrong02: CarbonPalette.gray40,
          borderStrong03: CarbonPalette.gray30,
          borderTile01: CarbonPalette.gray60,
          borderTile02: CarbonPalette.gray50,
          borderTile03: CarbonPalette.gray40,
          borderInverse: CarbonPalette.gray10,
          borderInteractive: CarbonPalette.blue50,
          borderDisabled: const Color(0x808D8D8D), // gray50 @ 0.5
          focus: CarbonPalette.white,
          focusInset: CarbonPalette.gray100,
          focusInverse: CarbonPalette.blue60,
          interactive: CarbonPalette.blue50,
          highlight: CarbonPalette.blue80,
          overlay: CarbonPalette.overlay, // black @ 0.6
          toggleOff: CarbonPalette.gray50,
          shadow: const Color(0xCC000000), // black @ 0.8
          supportError: CarbonPalette.red40,
          supportSuccess: CarbonPalette.green40,
          supportWarning: CarbonPalette.yellow30,
          supportInfo: CarbonPalette.blue50,
          supportErrorInverse: CarbonPalette.red60,
          supportSuccessInverse: CarbonPalette.green50,
          supportWarningInverse: CarbonPalette.yellow30,
          supportInfoInverse: CarbonPalette.blue70,
          supportCautionMinor: CarbonPalette.yellow30,
          supportCautionMajor: CarbonPalette.orange40,
          supportCautionUndefined: CarbonPalette.purple50,
        );
}
