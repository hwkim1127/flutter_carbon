import '../../../component_themes/number_input_theme_data.dart';
import '../../../../foundation/colors.dart';

/// Gray 90 theme for Carbon number input.
class G90NumberInputThemeData extends CarbonNumberInputThemeData {
  const G90NumberInputThemeData()
      : super(
          controlButtonBackground: CarbonPalette.gray90,
          controlButtonBackgroundHover: CarbonPalette.gray80Hover,
          controlButtonBackgroundActive: CarbonPalette.gray60,
          controlButtonIcon: CarbonPalette.gray10,
          controlButtonBorder: CarbonPalette.gray70,
          controlButtonDivider: CarbonPalette.gray70,
        );
}
