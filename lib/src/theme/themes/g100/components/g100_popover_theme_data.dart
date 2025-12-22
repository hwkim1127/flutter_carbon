import '../../../../foundation/colors.dart';
import '../../../component_themes/popover_theme_data.dart';

class G100PopoverThemeData extends CarbonPopoverThemeData {
  const G100PopoverThemeData()
      : super(
          background: CarbonPalette.gray90,
          backgroundHighContrast: CarbonPalette.gray100,
          border: CarbonPalette.gray70,
          borderHighContrast: CarbonPalette.gray60,
          caretBackground: CarbonPalette.gray90,
          caretBackgroundHighContrast: CarbonPalette.gray100,
          dropShadow: CarbonPalette.black,
          dropShadowHighContrast: CarbonPalette.black,
        );
}
