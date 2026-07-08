import 'dart:ui' show Color;

import '../../../../foundation/colors.dart';
import '../../../component_themes/toggle_theme_data.dart';

/// Gray 10 Theme implementation of [CarbonToggleThemeData].
class G10ToggleThemeData extends CarbonToggleThemeData {
  const G10ToggleThemeData()
      : super(
          toggleOff: CarbonPalette.gray50, // $toggle-off (gray-50)
          toggleOn: CarbonPalette.green50, // Success green when on
          thumbColor: CarbonPalette.white, // White circle
          thumbColorDisabled: CarbonPalette.gray30, // Disabled thumb
          backgroundDisabled: CarbonPalette.gray30, // Disabled background
          borderReadOnly: CarbonPalette.gray40, // Read-only border
          thumbReadOnly: CarbonPalette.gray50, // Read-only thumb
          focusColor: CarbonPalette.blue60, // Focus indicator
          labelColor: CarbonPalette.gray100, // Label text (dark)
          stateTextColor: CarbonPalette.gray100, // On/Off text (dark)
          textDisabled:
              const Color(0x40161616), // $text-disabled (text-primary 25%)
          checkmarkColor: CarbonPalette.green60, // Checkmark icon (small)
        );
}
