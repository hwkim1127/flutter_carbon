import 'dart:ui' show Color;

import '../../../../foundation/colors.dart';
import '../../../component_themes/chat_theme_data.dart';

/// Gray 90 Theme implementation of [CarbonChatThemeData].
class G90ChatThemeData extends CarbonChatThemeData {
  const G90ChatThemeData()
    : super(
        chatPromptBackground: CarbonPalette.gray100,
        chatPromptBorderStart: CarbonPalette.gray90,
        chatPromptBorderEnd: const Color(0x00262626), // rgba(gray90, 0)
        chatPromptText: CarbonPalette.gray10,
        chatBubbleUser: CarbonPalette.gray80,
        chatBubbleUserText: CarbonPalette.gray10,
        chatBubbleAgent: CarbonPalette.gray90,
        chatBubbleAgentText: CarbonPalette.gray10,
        chatBubbleBorder: CarbonPalette.gray70,
        chatAvatarBot: CarbonPalette.gray50,
        chatAvatarAgent: CarbonPalette.gray30,
        chatAvatarUser: CarbonPalette.blue50,
        chatShellBackground: CarbonPalette.gray90,
        chatHeaderBackground: CarbonPalette.gray90,
        chatHeaderText: CarbonPalette.gray10,
        chatButton: CarbonPalette.blue40, // linkPrimary in g90
        chatButtonHover: const Color(
          0x298D8D8D,
        ), // backgroundHover (gray50 0.16)
        chatButtonTextHover: CarbonPalette.blue30, // linkPrimaryHover
        chatButtonActive: const Color(
          0x668D8D8D,
        ), // backgroundActive (gray50 0.4)
        chatButtonSelected: const Color(
          0x3D8D8D8D,
        ), // backgroundSelected (gray50 0.24)
        chatButtonTextSelected: CarbonPalette.gray30, // textSecondary
      );
}
