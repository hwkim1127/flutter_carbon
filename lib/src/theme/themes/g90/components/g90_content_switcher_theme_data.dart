import 'dart:ui' show Color;

import 'package:flutter/material.dart' show Colors;

import '../../../../foundation/colors.dart';
import '../../../component_themes/content_switcher_theme_data.dart';

/// Gray 90 Theme implementation of [CarbonContentSwitcherThemeData].
class G90ContentSwitcherThemeData extends CarbonContentSwitcherThemeData {
  const G90ContentSwitcherThemeData()
      : super(
          contentSwitcherSelected:
              const Color(0x3D8D8D8D), // rgba(gray50, 0.24)
          contentSwitcherDivider: const Color(
            0x3D8D8D8D,
          ), // using selected color for divider
          contentSwitcherTextOnColor: CarbonPalette.white,
          contentSwitcherBackground: Colors.transparent,
          contentSwitcherBackgroundHover: const Color(
            0x1F8D8D8D,
          ), // rgba(gray50, 0.12)
        );
}
