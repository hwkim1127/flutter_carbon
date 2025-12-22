import '../../../component_themes/number_input_theme_data.dart';
import '../../../../foundation/colors.dart';

/// Gray 100 theme for Carbon number input.
class G100NumberInputThemeData extends CarbonNumberInputThemeData {
  const G100NumberInputThemeData()
      : super(
          controlButtonBackground: CarbonPalette.gray100,
          controlButtonBackgroundHover: CarbonPalette.gray90Hover,
          controlButtonBackgroundActive: CarbonPalette.gray70,
          controlButtonIcon: CarbonPalette.gray10,
          controlButtonBorder: CarbonPalette.gray70,
          controlButtonDivider: CarbonPalette.gray70,
        );
}
