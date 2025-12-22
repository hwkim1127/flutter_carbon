import 'dart:ui' show Color;

import '../../../../foundation/colors.dart';
import '../../../component_themes/chat_theme_data.dart';

/// Gray 10 Theme implementation of [CarbonChatThemeData].
class G10ChatThemeData extends CarbonChatThemeData {
  const G10ChatThemeData()
    : super(
        chatPromptBackground: CarbonPalette.white,
        chatPromptBorderStart: CarbonPalette.gray10,
        chatPromptBorderEnd: const Color(0x00F4F4F4), // rgba(gray10, 0)
        chatPromptText: CarbonPalette.gray100,
        chatBubbleUser: CarbonPalette.gray20,
        chatBubbleUserText: CarbonPalette.gray100,
        chatBubbleAgent: CarbonPalette.white,
        chatBubbleAgentText: CarbonPalette.gray100,
        chatBubbleBorder: CarbonPalette.gray20,
        chatAvatarBot: CarbonPalette.gray60,
        chatAvatarAgent: CarbonPalette.gray80,
        chatAvatarUser: CarbonPalette.blue60,
        chatShellBackground: CarbonPalette.white,
        chatHeaderBackground: CarbonPalette.white,
        chatHeaderText: CarbonPalette.gray100,
        chatButton: CarbonPalette.blue60,
        chatButtonHover: const Color(
          0x1F8D8D8D,
        ), // backgroundHover (gray50 0.12)
        chatButtonTextHover: CarbonPalette.blue70,
        chatButtonActive: const Color(
          0x808D8D8D,
        ), // backgroundActive (gray50 0.5)
        chatButtonSelected: const Color(
          0x338D8D8D,
        ), // backgroundSelected (gray50 0.2)
        chatButtonTextSelected: CarbonPalette.gray70,
      );
}
