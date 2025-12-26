import 'package:flutter/material.dart';
import '../../../foundation/colors.dart';
import '../../component_themes/layer_theme_data.dart';

/// Gray 100 Theme implementation of [CarbonLayerThemeData].
class G100LayerThemeData extends CarbonLayerThemeData {
  const G100LayerThemeData()
      : super(
          // Background
          background: CarbonPalette.gray100,
          backgroundInverse: CarbonPalette.gray10,
          backgroundBrand: CarbonPalette.blue60,
          backgroundActive: const Color(0x668D8D8D), // gray50 (0.4)
          backgroundHover: const Color(0x298D8D8D), // gray50 (0.16)
          backgroundInverseHover: CarbonPalette.gray10Hover,
          backgroundSelected: const Color(0x3D8D8D8D), // gray50 (0.24)
          backgroundSelectedHover: const Color(0x528D8D8D), // gray50 (0.32)
          // Layer 01
          layer01: CarbonPalette.gray90,
          layerActive01: CarbonPalette.gray70,
          layerBackground01: CarbonPalette.gray100,
          layerHover01: CarbonPalette.gray90Hover,
          layerSelected01: CarbonPalette.gray80,
          layerSelectedHover01: CarbonPalette.gray80Hover,

          // Layer 02
          layer02: CarbonPalette.gray80,
          layerActive02: CarbonPalette.gray60,
          layerBackground02: CarbonPalette.gray90,
          layerHover02: CarbonPalette.gray80Hover,
          layerSelected02: CarbonPalette.gray70,
          layerSelectedHover02: CarbonPalette.gray70Hover,

          // Layer 03
          layer03: CarbonPalette.gray70,
          layerActive03: CarbonPalette.gray50,
          layerBackground03: CarbonPalette.gray80,
          layerHover03: CarbonPalette.gray70Hover,
          layerSelected03: CarbonPalette.gray60,
          layerSelectedHover03: CarbonPalette.gray60Hover,

          // Layer General
          layerSelectedInverse: CarbonPalette.gray10,
          layerSelectedDisabled: CarbonPalette.gray40,

          // Layer Accent 01
          layerAccent01: CarbonPalette.gray80,
          layerAccentActive01: CarbonPalette.gray60,
          layerAccentHover01: CarbonPalette.gray80Hover,

          // Layer Accent 02
          layerAccent02: CarbonPalette.gray70,
          layerAccentActive02: CarbonPalette.gray50,
          layerAccentHover02: CarbonPalette.gray70Hover,

          // Layer Accent 03
          layerAccent03: CarbonPalette.gray60,
          layerAccentActive03: CarbonPalette.gray80,
          layerAccentHover03: CarbonPalette.gray60Hover,

          // Field
          field01: CarbonPalette.gray90,
          fieldHover01: CarbonPalette.gray90Hover,
          field02: CarbonPalette.gray80,
          fieldHover02: CarbonPalette.gray80Hover,
          field03: CarbonPalette.gray70,
          fieldHover03: CarbonPalette.gray70Hover,

          // Border
          borderSubtle00: CarbonPalette.gray80,
          borderSubtle01: CarbonPalette.gray70,
          borderSubtleSelected01: CarbonPalette.gray60,
          borderSubtle02: CarbonPalette.gray60,
          borderSubtleSelected02: CarbonPalette.gray50,
          borderSubtle03: CarbonPalette.gray60,
          borderSubtleSelected03: CarbonPalette.gray50,
          borderStrong01: CarbonPalette.gray60,
          borderStrong02: CarbonPalette.gray50,
          borderStrong03: CarbonPalette.gray40,
          borderTile01: CarbonPalette.gray70,
          borderTile02: CarbonPalette.gray60,
          borderTile03: CarbonPalette.gray50,
          borderInverse: CarbonPalette.gray10,
          borderInteractive: CarbonPalette.blue50,
          borderDisabled: const Color(0x808D8D8D), // gray50 (0.5)
          // Support
          supportError: CarbonPalette.red50,
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

          // Focus
          focus: CarbonPalette.white,
          focusInset: CarbonPalette.gray100,
          focusInverse: CarbonPalette.blue60,

          // Misc
          interactive: CarbonPalette.blue50,
          highlight: CarbonPalette.blue90,
          overlay: CarbonPalette.overlay, // black (0.6)
          toggleOff: CarbonPalette.gray60,
          shadow: const Color(0xCC000000), // black (0.8)
        );
}
