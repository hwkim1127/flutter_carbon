import '../../../../foundation/colors.dart';
import '../../../component_themes/button_theme_data.dart';

/// Gray 10 Theme implementation of [CarbonButtonThemeData].
class G10ButtonThemeData extends CarbonButtonThemeData {
  const G10ButtonThemeData()
    : super(
        buttonPrimary: CarbonPalette.blue60,
        buttonPrimaryHover: CarbonPalette.blue70,
        buttonPrimaryActive: CarbonPalette.blue80,
        buttonSecondary: CarbonPalette.gray80,
        buttonSecondaryHover: CarbonPalette.gray70,
        buttonSecondaryActive: CarbonPalette.gray60,
        buttonTertiary: CarbonPalette.blue60,
        buttonTertiaryHover: CarbonPalette.blue70,
        buttonTertiaryActive: CarbonPalette.blue80,
        buttonDangerPrimary: CarbonPalette.red60,
        buttonDangerSecondary: CarbonPalette.red60,
        buttonDangerActive: CarbonPalette.red80,
        buttonDangerHover: CarbonPalette.red70,
        buttonSeparator: CarbonPalette.gray20,
        buttonDisabled: CarbonPalette.gray30,
      );
}
