import '../../../../foundation/colors.dart';
import '../../../component_themes/notification_theme_data.dart';

/// Gray 10 Theme implementation of [CarbonNotificationThemeData].
class G10NotificationThemeData extends CarbonNotificationThemeData {
  const G10NotificationThemeData()
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
