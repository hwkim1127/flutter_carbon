import '../../../component_themes/number_input_theme_data.dart';
import '../../../../foundation/colors.dart';

/// White theme for Carbon number input.
class WhiteNumberInputThemeData extends CarbonNumberInputThemeData {
  const WhiteNumberInputThemeData()
      : super(
          controlButtonBackground: CarbonPalette.white,
          controlButtonBackgroundHover: CarbonPalette.gray10Hover,
          controlButtonBackgroundActive: CarbonPalette.gray30,
          controlButtonIcon: CarbonPalette.gray100,
          controlButtonBorder: CarbonPalette.gray30,
          controlButtonDivider: CarbonPalette.gray30,
        );
}
