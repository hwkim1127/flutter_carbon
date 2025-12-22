import '../../../../foundation/colors.dart';
import '../../../component_themes/notification_theme_data.dart';

/// Gray 90 Theme implementation of [CarbonNotificationThemeData].
class G90NotificationThemeData extends CarbonNotificationThemeData {
  const G90NotificationThemeData()
    : super(
        notificationBackgroundError: CarbonPalette.red90,
        notificationBackgroundSuccess: CarbonPalette.green90,
        notificationBackgroundInfo: CarbonPalette.blue90,
        notificationBackgroundWarning: CarbonPalette.yellow90,
        notificationActionHover:
            CarbonPalette.gray90Hover, // approximate/fallback
        notificationActionTertiaryInverse: CarbonPalette.white,
        notificationActionTertiaryInverseActive: CarbonPalette.gray10,
        notificationActionTertiaryInverseHover: CarbonPalette.gray10,
        notificationActionTertiaryInverseText: CarbonPalette.gray100,
        notificationActionTertiaryInverseTextOnColorDisabled:
            CarbonPalette.gray50,
      );
}
