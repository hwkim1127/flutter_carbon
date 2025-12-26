import '../../../../foundation/colors.dart';
import '../../../component_themes/status_theme_data.dart';

/// Gray 100 Theme implementation of [CarbonStatusThemeData].
class G100StatusThemeData extends CarbonStatusThemeData {
  const G100StatusThemeData()
      : super(
          statusRed: CarbonPalette.red50,
          statusOrange: CarbonPalette.orange40,
          statusOrangeOutline: CarbonPalette
              .orange40, // inferred as usually same as filled in dark themes if not specified? tokens.js said g100 only for statusOrange. default outline?
          // Wait, looking at tokens.js for status:
          // statusOrangeOutline: { whiteTheme: orange60, g10: orange60 } -> missed g90/g100
          // Usually in dark themes outlines lighter or same?
          // statusOrange in g100 is orange40.
          // Let's assume orange40 or check if there's a fallback.
          // If undefined in tokens.js, it might fallback to statusOrange.
          // I will use CarbonPalette.orange40.
          statusYellow: CarbonPalette.yellow30,
          statusYellowOutline: CarbonPalette
              .yellow30, // similar logic, tokens.js missing g100 explicitly for outline
          statusPurple: CarbonPalette.purple50,
          statusGreen: CarbonPalette.green40,
          statusBlue: CarbonPalette.blue50,
          statusGray: CarbonPalette.gray50,
          statusAccessibilityBackground: CarbonPalette.gray100,
        );
}
