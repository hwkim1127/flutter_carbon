import 'package:flutter/material.dart';

@immutable
class CarbonStatusThemeData extends ThemeExtension<CarbonStatusThemeData> {
  final Color statusRed;
  final Color statusOrange;
  final Color statusOrangeOutline;
  final Color statusYellow;
  final Color statusYellowOutline;
  final Color statusPurple;
  final Color statusGreen;
  final Color statusBlue;
  final Color statusGray;
  final Color statusAccessibilityBackground;

  const CarbonStatusThemeData({
    required this.statusRed,
    required this.statusOrange,
    required this.statusOrangeOutline,
    required this.statusYellow,
    required this.statusYellowOutline,
    required this.statusPurple,
    required this.statusGreen,
    required this.statusBlue,
    required this.statusGray,
    required this.statusAccessibilityBackground,
  });

  @override
  CarbonStatusThemeData copyWith({
    Color? statusRed,
    Color? statusOrange,
    Color? statusOrangeOutline,
    Color? statusYellow,
    Color? statusYellowOutline,
    Color? statusPurple,
    Color? statusGreen,
    Color? statusBlue,
    Color? statusGray,
    Color? statusAccessibilityBackground,
  }) {
    return CarbonStatusThemeData(
      statusRed: statusRed ?? this.statusRed,
      statusOrange: statusOrange ?? this.statusOrange,
      statusOrangeOutline: statusOrangeOutline ?? this.statusOrangeOutline,
      statusYellow: statusYellow ?? this.statusYellow,
      statusYellowOutline: statusYellowOutline ?? this.statusYellowOutline,
      statusPurple: statusPurple ?? this.statusPurple,
      statusGreen: statusGreen ?? this.statusGreen,
      statusBlue: statusBlue ?? this.statusBlue,
      statusGray: statusGray ?? this.statusGray,
      statusAccessibilityBackground:
          statusAccessibilityBackground ?? this.statusAccessibilityBackground,
    );
  }

  @override
  CarbonStatusThemeData lerp(
    ThemeExtension<CarbonStatusThemeData>? other,
    double t,
  ) {
    if (other is! CarbonStatusThemeData) return this;
    return CarbonStatusThemeData(
      statusRed: Color.lerp(statusRed, other.statusRed, t)!,
      statusOrange: Color.lerp(statusOrange, other.statusOrange, t)!,
      statusOrangeOutline: Color.lerp(
        statusOrangeOutline,
        other.statusOrangeOutline,
        t,
      )!,
      statusYellow: Color.lerp(statusYellow, other.statusYellow, t)!,
      statusYellowOutline: Color.lerp(
        statusYellowOutline,
        other.statusYellowOutline,
        t,
      )!,
      statusPurple: Color.lerp(statusPurple, other.statusPurple, t)!,
      statusGreen: Color.lerp(statusGreen, other.statusGreen, t)!,
      statusBlue: Color.lerp(statusBlue, other.statusBlue, t)!,
      statusGray: Color.lerp(statusGray, other.statusGray, t)!,
      statusAccessibilityBackground: Color.lerp(
        statusAccessibilityBackground,
        other.statusAccessibilityBackground,
        t,
      )!,
    );
  }
}
