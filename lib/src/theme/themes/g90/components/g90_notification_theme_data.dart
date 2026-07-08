import '../../../../foundation/colors.dart';
import '../../../component_themes/notification_theme_data.dart';

/// Gray 90 Theme implementation of [CarbonNotificationThemeData].
class G90NotificationThemeData extends CarbonNotificationThemeData {
  const G90NotificationThemeData()
      : super(
          // Dark themes use a neutral layer background; the kind is conveyed
          // by the colored border/icon (Carbon v11 component tokens: gray-80).
          notificationBackgroundError: CarbonPalette.gray80,
          notificationBackgroundSuccess: CarbonPalette.gray80,
          notificationBackgroundInfo: CarbonPalette.gray80,
          notificationBackgroundWarning: CarbonPalette.gray80,
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
