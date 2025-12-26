import '../../../../foundation/colors.dart';
import '../../../component_themes/status_theme_data.dart';

/// White Theme implementation of [CarbonStatusThemeData].
class WhiteStatusThemeData extends CarbonStatusThemeData {
  const WhiteStatusThemeData()
      : super(
          statusRed: CarbonPalette.red60,
          statusOrange: CarbonPalette.orange40,
          statusOrangeOutline: CarbonPalette.orange60,
          statusYellow: CarbonPalette.yellow30,
          statusYellowOutline: CarbonPalette.yellow60,
          statusPurple: CarbonPalette.purple60,
          statusGreen: CarbonPalette.green50,
          statusBlue: CarbonPalette.blue70,
          statusGray: CarbonPalette.gray60,
          statusAccessibilityBackground: CarbonPalette.white,
        );
}
