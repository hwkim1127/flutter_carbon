import '../../../../foundation/colors.dart';
import '../../../component_themes/notification_theme_data.dart';

/// White Theme implementation of [CarbonNotificationThemeData].
class WhiteNotificationThemeData extends CarbonNotificationThemeData {
  const WhiteNotificationThemeData()
      : super(
          notificationBackgroundError: CarbonPalette.red10,
          notificationBackgroundSuccess: CarbonPalette.green10,
          notificationBackgroundInfo: CarbonPalette.blue10,
          notificationBackgroundWarning: CarbonPalette.yellow10,
          notificationActionHover: CarbonPalette.white,
          notificationActionTertiaryInverse: CarbonPalette.white,
          notificationActionTertiaryInverseActive: CarbonPalette.gray10,
          notificationActionTertiaryInverseHover: CarbonPalette.gray10,
          notificationActionTertiaryInverseText: CarbonPalette.gray100,
          notificationActionTertiaryInverseTextOnColorDisabled:
              CarbonPalette.gray50,
        );
}
