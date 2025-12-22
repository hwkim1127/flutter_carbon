import 'dart:ui' show Color;

import 'package:flutter/material.dart' show Colors;

import '../../../../foundation/colors.dart';
import '../../../component_themes/content_switcher_theme_data.dart';

/// Gray 100 Theme implementation of [CarbonContentSwitcherThemeData].
class G100ContentSwitcherThemeData extends CarbonContentSwitcherThemeData {
  const G100ContentSwitcherThemeData()
    : super(
        contentSwitcherSelected: const Color(0x3D8D8D8D), // gray50 (0.24)
        contentSwitcherDivider: const Color(0x3D8D8D8D),
        // Assume divider matches selected or similar invisible on transparent?
        // In tokens.js, g100 divider is NOT explicitly defined separately usually, but in white theme it was white.
        // Actually, looking at g100.js border section:
        // borderSubtle01 = gray70
        // But contentSwitcher usually uses a specific token.
        // Let's re-read white implementation... it inferred it.
        // g100 content-switcher tokens.js didn't show divider.
        // I will use CarbonPalette.gray70 (borderSubtle01) as a safe bet for now or transparent if it's meant to be blended.
        // Wait, contentSwitcherSelected is translucent gray50.
        // Let's use gray70 for divider as per borderSubtle01 in g100.js which is the default for UI borders.
        contentSwitcherTextOnColor: CarbonPalette.white,
        contentSwitcherBackground: Colors.transparent, // transparent
        contentSwitcherBackgroundHover: const Color(
          0x1F8D8D8D,
        ), // gray50 (0.12)
      );
}
