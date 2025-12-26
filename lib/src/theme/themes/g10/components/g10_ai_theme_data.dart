import 'dart:ui' show Color;

import '../../../../foundation/colors.dart';
import '../../../component_themes/ai_theme_data.dart';

/// Gray 10 Theme implementation of [CarbonAIThemeData].
class G10AIThemeData extends CarbonAIThemeData {
  const G10AIThemeData()
      : super(
          aiInnerShadow: const Color(0x1A4589FF), // rgba(blue50, 0.1)
          aiAuraStartSm: const Color(0x294589FF), // rgba(blue50, 0.16)
          aiAuraStart: const Color(0x1A4589FF), // rgba(blue50, 0.1)
          aiAuraEnd: const Color(0x00FFFFFF), // rgba(white, 0)
          aiBorderStrong: CarbonPalette.blue50,
          aiBorderStart: const Color(
            0xA3A820FF,
          ), // rgba(blue30, 0.64). NOTE: Assuming blue30 is correct.
          aiBorderEnd: CarbonPalette.blue40,
          aiDropShadow: const Color(0x1A0F62FE), // rgba(blue60, 0.1)
          aiAuraHoverBackground: CarbonPalette.blue10,
          aiAuraHoverStart: const Color(0x524589FF), // rgba(blue50, 0.32)
          aiAuraHoverEnd: const Color(0x00FFFFFF), // rgba(white, 0)
          aiPopoverBackground: CarbonPalette.white,
          aiPopoverShadowOuter01: const Color(0x0F0043CE), // rgba(blue70, 0.06)
          aiPopoverShadowOuter02: const Color(0x0A000000), // rgba(black, 0.04)
          aiSkeletonBackground: CarbonPalette.blue20,
          aiSkeletonElementBackground: CarbonPalette.blue50,
          aiOverlay: const Color(0x80001D6C), // rgba(blue100, 0.5)
          aiPopoverCaretCenter: const Color(0xFFA0C3FF),
          aiPopoverCaretBottom: CarbonPalette.blue40,
          aiPopoverCaretBottomBackgroundActions: const Color(0xFFE9EFFA),
          aiPopoverCaretBottomBackground: const Color(0xFFEAF1FF),
        );
}
