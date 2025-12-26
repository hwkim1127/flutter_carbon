import 'package:flutter/material.dart';
import '../../../../foundation/colors.dart';
import '../../../component_themes/notification_theme_data.dart';

/// Gray 100 Theme implementation of [CarbonNotificationThemeData].
class G100NotificationThemeData extends CarbonNotificationThemeData {
  const G100NotificationThemeData()
      : super(
          notificationBackgroundError: CarbonPalette.gray90,
          notificationBackgroundSuccess: CarbonPalette.gray90,
          notificationBackgroundInfo: CarbonPalette.gray90,
          notificationBackgroundWarning: CarbonPalette.gray90,
          notificationActionHover: CarbonPalette
              .gray10, // white0? g100.js textPrimary is gray10. tokens.js says white0.
          // tokens.js:
          // notificationActionTertiaryInverse: buttonTertiary.whiteTheme (white)
          // notificationActionTertiaryInverseActive: buttonTertiaryActive.whiteTheme (blue90 - #002d9c)
          // notificationActionTertiaryInverseHover: buttonTertiaryHover.whiteTheme (blue50 - #0050e6)
          // notificationActionTertiaryInverseText: textInverseWhite (gray100 - #161616)
          // notificationActionTertiaryInverseTextOnColorDisabled: textOnColorDisabledWhite (white 0.25)
          notificationActionTertiaryInverse: CarbonPalette.white,
          notificationActionTertiaryInverseActive: CarbonPalette.blue80,
          notificationActionTertiaryInverseHover: CarbonPalette.blue50,
          notificationActionTertiaryInverseText: CarbonPalette.gray100,
          notificationActionTertiaryInverseTextOnColorDisabled: const Color(
            0x40FFFFFF,
          ),
        );
}
