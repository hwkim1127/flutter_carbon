import '../../../../foundation/colors.dart';
import '../../../component_themes/toggle_theme_data.dart';

/// White Theme implementation of [CarbonToggleThemeData].
class WhiteToggleThemeData extends CarbonToggleThemeData {
  const WhiteToggleThemeData()
      : super(
          toggleOff: CarbonPalette.gray30, // Light gray background when off
          toggleOn: CarbonPalette.green50, // Success green when on
          thumbColor: CarbonPalette.white, // White circle
          thumbColorDisabled: CarbonPalette.gray30, // Disabled thumb
          backgroundDisabled: CarbonPalette.gray30, // Disabled background
          borderReadOnly: CarbonPalette.gray40, // Read-only border
          thumbReadOnly: CarbonPalette.gray50, // Read-only thumb
          focusColor: CarbonPalette.blue60, // Focus indicator
          labelColor: CarbonPalette.gray100, // Label text (dark)
          stateTextColor: CarbonPalette.gray100, // On/Off text (dark)
          textDisabled: CarbonPalette.gray30, // Disabled text
          checkmarkColor: CarbonPalette.green60, // Checkmark icon (small)
        );
}
