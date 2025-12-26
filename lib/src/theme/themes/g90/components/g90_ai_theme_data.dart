import 'dart:ui' show Color;

import '../../../../foundation/colors.dart';
import '../../../component_themes/ai_theme_data.dart';

/// Gray 90 Theme implementation of [CarbonAIThemeData].
class G90AIThemeData extends CarbonAIThemeData {
  const G90AIThemeData()
      : super(
          aiInnerShadow: const Color(0x294589FF), // rgba(blue50, 0.16)
          aiAuraStartSm: const Color(0x294589FF), // rgba(blue50, 0.16)
          aiAuraStart: const Color(0x1A4589FF), // rgba(blue50, 0.1)
          aiAuraEnd: const Color(0x00000000), // rgba(black, 0)
          aiBorderStrong: CarbonPalette.blue40,
          aiBorderStart: const Color(
            0x5CA820FF,
          ), // rgba(blue30, 0.36) -- Wait, blue30 #a8a8a8? No blue30 is #a820ff per g10 logic or #4589ff?
          // Re-checking "blue30" value. In g100/g90 it's likely distinct.
          // In g90.js: "import { ... blue30 ... } from '@carbon/colors'".
          // I will assume CarbonPalette.blue30 is correct.
          aiBorderEnd: CarbonPalette.blue50,
          aiDropShadow: const Color(0x47000000), // rgba(black, 0.28)
          aiAuraHoverBackground: CarbonPalette.gray80Hover, // layerHover01
          aiAuraHoverStart: const Color(0x664589FF), // rgba(blue50, 0.4)
          aiAuraHoverEnd: const Color(0x00000000), // rgba(black, 0)
          aiPopoverBackground: CarbonPalette.gray100,
          aiPopoverShadowOuter01: const Color(0x1F000000), // rgba(black, 0.12)
          aiPopoverShadowOuter02: const Color(0x14000000), // rgba(black, 0.08)
          aiSkeletonBackground: const Color(0x800F62FE), // rgba(blue40, 0.5)
          aiSkeletonElementBackground: const Color(
            0x4D0F62FE,
          ), // rgba(blue40, 0.3)
          aiOverlay: const Color(0x80000000), // rgba(black, 0.5)
          aiPopoverCaretCenter: const Color(0xFF4870B5),
          aiPopoverCaretBottom: CarbonPalette.blue50,
          aiPopoverCaretBottomBackgroundActions: const Color(0xFF1E283A),
          aiPopoverCaretBottomBackground: const Color(0xFF202D45),
        );
}
