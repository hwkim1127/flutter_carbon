import '../../../../foundation/colors.dart';
import '../../../component_themes/popover_theme_data.dart';

class WhitePopoverThemeData extends CarbonPopoverThemeData {
  const WhitePopoverThemeData()
      : super(
          background: CarbonPalette.white,
          backgroundHighContrast: CarbonPalette.gray10,
          border: CarbonPalette.gray30,
          borderHighContrast: CarbonPalette.gray40,
          caretBackground: CarbonPalette.white,
          caretBackgroundHighContrast: CarbonPalette.gray10,
          dropShadow: CarbonPalette.gray100,
          dropShadowHighContrast: CarbonPalette.gray100,
        );
}
