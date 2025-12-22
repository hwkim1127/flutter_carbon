import '../../../component_themes/number_input_theme_data.dart';
import '../../../../foundation/colors.dart';

/// Gray 10 theme for Carbon number input.
class G10NumberInputThemeData extends CarbonNumberInputThemeData {
  const G10NumberInputThemeData()
      : super(
          controlButtonBackground: CarbonPalette.gray10,
          controlButtonBackgroundHover: CarbonPalette.gray10Hover,
          controlButtonBackgroundActive: CarbonPalette.gray30,
          controlButtonIcon: CarbonPalette.gray100,
          controlButtonBorder: CarbonPalette.gray30,
          controlButtonDivider: CarbonPalette.gray30,
        );
}
