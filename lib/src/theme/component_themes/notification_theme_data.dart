import 'package:flutter/material.dart';

@immutable
class CarbonNotificationThemeData
    extends ThemeExtension<CarbonNotificationThemeData> {
  final Color notificationBackgroundError;
  final Color notificationBackgroundSuccess;
  final Color notificationBackgroundInfo;
  final Color notificationBackgroundWarning;
  final Color notificationActionHover;
  final Color notificationActionTertiaryInverse;
  final Color notificationActionTertiaryInverseActive;
  final Color notificationActionTertiaryInverseHover;
  final Color notificationActionTertiaryInverseText;
  final Color notificationActionTertiaryInverseTextOnColorDisabled;

  const CarbonNotificationThemeData({
    required this.notificationBackgroundError,
    required this.notificationBackgroundSuccess,
    required this.notificationBackgroundInfo,
    required this.notificationBackgroundWarning,
    required this.notificationActionHover,
    required this.notificationActionTertiaryInverse,
    required this.notificationActionTertiaryInverseActive,
    required this.notificationActionTertiaryInverseHover,
    required this.notificationActionTertiaryInverseText,
    required this.notificationActionTertiaryInverseTextOnColorDisabled,
  });

  @override
  CarbonNotificationThemeData copyWith({
    Color? notificationBackgroundError,
    Color? notificationBackgroundSuccess,
    Color? notificationBackgroundInfo,
    Color? notificationBackgroundWarning,
    Color? notificationActionHover,
    Color? notificationActionTertiaryInverse,
    Color? notificationActionTertiaryInverseActive,
    Color? notificationActionTertiaryInverseHover,
    Color? notificationActionTertiaryInverseText,
    Color? notificationActionTertiaryInverseTextOnColorDisabled,
  }) {
    return CarbonNotificationThemeData(
      notificationBackgroundError:
          notificationBackgroundError ?? this.notificationBackgroundError,
      notificationBackgroundSuccess:
          notificationBackgroundSuccess ?? this.notificationBackgroundSuccess,
      notificationBackgroundInfo:
          notificationBackgroundInfo ?? this.notificationBackgroundInfo,
      notificationBackgroundWarning:
          notificationBackgroundWarning ?? this.notificationBackgroundWarning,
      notificationActionHover:
          notificationActionHover ?? this.notificationActionHover,
      notificationActionTertiaryInverse:
          notificationActionTertiaryInverse ??
          this.notificationActionTertiaryInverse,
      notificationActionTertiaryInverseActive:
          notificationActionTertiaryInverseActive ??
          this.notificationActionTertiaryInverseActive,
      notificationActionTertiaryInverseHover:
          notificationActionTertiaryInverseHover ??
          this.notificationActionTertiaryInverseHover,
      notificationActionTertiaryInverseText:
          notificationActionTertiaryInverseText ??
          this.notificationActionTertiaryInverseText,
      notificationActionTertiaryInverseTextOnColorDisabled:
          notificationActionTertiaryInverseTextOnColorDisabled ??
          this.notificationActionTertiaryInverseTextOnColorDisabled,
    );
  }

  @override
  CarbonNotificationThemeData lerp(
    ThemeExtension<CarbonNotificationThemeData>? other,
    double t,
  ) {
    if (other is! CarbonNotificationThemeData) return this;
    return CarbonNotificationThemeData(
      notificationBackgroundError: Color.lerp(
        notificationBackgroundError,
        other.notificationBackgroundError,
        t,
      )!,
      notificationBackgroundSuccess: Color.lerp(
        notificationBackgroundSuccess,
        other.notificationBackgroundSuccess,
        t,
      )!,
      notificationBackgroundInfo: Color.lerp(
        notificationBackgroundInfo,
        other.notificationBackgroundInfo,
        t,
      )!,
      notificationBackgroundWarning: Color.lerp(
        notificationBackgroundWarning,
        other.notificationBackgroundWarning,
        t,
      )!,
      notificationActionHover: Color.lerp(
        notificationActionHover,
        other.notificationActionHover,
        t,
      )!,
      notificationActionTertiaryInverse: Color.lerp(
        notificationActionTertiaryInverse,
        other.notificationActionTertiaryInverse,
        t,
      )!,
      notificationActionTertiaryInverseActive: Color.lerp(
        notificationActionTertiaryInverseActive,
        other.notificationActionTertiaryInverseActive,
        t,
      )!,
      notificationActionTertiaryInverseHover: Color.lerp(
        notificationActionTertiaryInverseHover,
        other.notificationActionTertiaryInverseHover,
        t,
      )!,
      notificationActionTertiaryInverseText: Color.lerp(
        notificationActionTertiaryInverseText,
        other.notificationActionTertiaryInverseText,
        t,
      )!,
      notificationActionTertiaryInverseTextOnColorDisabled: Color.lerp(
        notificationActionTertiaryInverseTextOnColorDisabled,
        other.notificationActionTertiaryInverseTextOnColorDisabled,
        t,
      )!,
    );
  }
}
