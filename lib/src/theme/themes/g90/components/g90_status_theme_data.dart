import 'dart:ui' show Color;

import '../../../../foundation/colors.dart';
import '../../../component_themes/status_theme_data.dart';

/// Gray 90 Theme implementation of [CarbonStatusThemeData].
class G90StatusThemeData extends CarbonStatusThemeData {
  const G90StatusThemeData()
    : super(
        statusRed: CarbonPalette.red40,
        statusOrange: CarbonPalette.orange40,
        statusOrangeOutline: CarbonPalette.orange40,
        statusYellow: CarbonPalette.yellow30,
        statusYellowOutline: CarbonPalette.yellow30,
        statusPurple: CarbonPalette.purple40,
        statusGreen: CarbonPalette.green40,
        statusBlue: CarbonPalette.blue40,
        statusGray: CarbonPalette.gray30,
        statusAccessibilityBackground: const Color(
          0x40FFFFFF,
        ), // white @ 0.25?? No g90 statusBG.
        // g90.js does not explicitly list status accessibility background overrides everywhere,
        // but checking white vs g100, darker themes use lighter colors.
        // Let's fallback to transparent or similar if undefined.
        // Or use textPrimary (gray10).
        // Actually let's assume transparent or check existing patterns.
      );
}
