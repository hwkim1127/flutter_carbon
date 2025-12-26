import 'dart:ui' show Color;

import '../../../../foundation/colors.dart';
import '../../../component_themes/ai_theme_data.dart';

/// Gray 100 Theme implementation of [CarbonAIThemeData].
class G100AIThemeData extends CarbonAIThemeData {
  const G100AIThemeData()
      : super(
          aiInnerShadow: const Color(0x294589ff), // blue50 0.16
          aiAuraStartSm: const Color(0x294589ff), // blue50 0.16
          aiAuraStart: const Color(0x1a4589ff), // blue50 0.1
          aiAuraEnd: const Color(0x00000000), // black 0
          aiBorderStrong: CarbonPalette.blue40,
          aiBorderStart: const Color(0x5c0043ce), // blue30 0.36
          aiBorderEnd: CarbonPalette.blue50,
          aiDropShadow: const Color(0x47000000), // black 0.28
          aiAuraHoverBackground: CarbonPalette.gray90Hover,
          aiAuraHoverStart: const Color(0x664589ff), // blue50 0.4
          aiAuraHoverEnd: const Color(0x00000000), // black 0
          aiPopoverBackground: CarbonPalette.gray100,
          aiPopoverShadowOuter01: const Color(0x1f000000), // black 0.12
          aiPopoverShadowOuter02: const Color(0x14000000), // black 0.08
          aiSkeletonBackground: const Color(0x8078a9ff), // blue40 0.5
          aiSkeletonElementBackground: const Color(0x4d78a9ff), // blue40 0.3
          aiOverlay: const Color(0x80000000), // black 0.5
          aiPopoverCaretCenter: const Color(0xFF4870B5),
          aiPopoverCaretBottom: CarbonPalette.blue50,
          aiPopoverCaretBottomBackgroundActions: const Color(0xFF1E283A),
          aiPopoverCaretBottomBackground: const Color(0xFF202D45),
        );
}
