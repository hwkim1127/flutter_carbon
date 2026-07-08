import '../../../../foundation/colors.dart';
import '../../../component_themes/toggle_tip_theme_data.dart';

class G90ToggleTipThemeData extends CarbonToggleTipThemeData {
  const G90ToggleTipThemeData()
      : super(
          buttonBackground: CarbonPalette.transparent,
          buttonBackgroundHover: CarbonPalette.gray70Hover,
          buttonIcon: CarbonPalette.gray10,
          contentBackground: CarbonPalette.gray90,
          contentText: CarbonPalette.gray10,
          border: CarbonPalette.gray50,
          caret: CarbonPalette.gray90,
          actionButtonText: CarbonPalette.blue40,
          actionButtonTextHover: CarbonPalette.blue30,
        );
}
