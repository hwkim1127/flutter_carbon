import 'dart:ui' show Color;

import '../../../../foundation/colors.dart';
import '../../../component_themes/toggle_theme_data.dart';

/// Gray 100 Theme implementation of [CarbonToggleThemeData].
class G100ToggleThemeData extends CarbonToggleThemeData {
  const G100ToggleThemeData()
      : super(
          toggleOff: CarbonPalette.gray70, // Dark gray background when off
          toggleOn: CarbonPalette.green50, // Success green when on
          thumbColor: CarbonPalette.white, // White circle
          thumbColorDisabled:
              const Color(0x4D8D8D8D), // gray50 @ 0.3 - Disabled thumb
          backgroundDisabled:
              const Color(0x4D8D8D8D), // gray50 @ 0.3 - Disabled background
          borderReadOnly: CarbonPalette.gray60, // Read-only border
          thumbReadOnly: CarbonPalette.gray70, // Read-only thumb
          focusColor: CarbonPalette.blue60, // Focus indicator
          labelColor: CarbonPalette.gray10, // Label text (light)
          stateTextColor: CarbonPalette.gray10, // On/Off text (light)
          textDisabled:
              const Color(0x4D8D8D8D), // gray50 @ 0.3 - Disabled text
          checkmarkColor: CarbonPalette.gray100, // Checkmark icon (small)
        );
}
