import '../../../../foundation/colors.dart';
import '../../../component_themes/status_theme_data.dart';

/// Gray 10 Theme implementation of [CarbonStatusThemeData].
class G10StatusThemeData extends CarbonStatusThemeData {
  const G10StatusThemeData()
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
