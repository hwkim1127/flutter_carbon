import 'package:flutter/material.dart';

@immutable
class CarbonToggleTipThemeData
    extends ThemeExtension<CarbonToggleTipThemeData> {
  final Color buttonBackground;
  final Color buttonBackgroundHover;
  final Color buttonIcon;
  final Color contentBackground;
  final Color contentText;
  final Color border;
  final Color caret;
  final Color actionButtonText;
  final Color actionButtonTextHover;

  const CarbonToggleTipThemeData({
    required this.buttonBackground,
    required this.buttonBackgroundHover,
    required this.buttonIcon,
    required this.contentBackground,
    required this.contentText,
    required this.border,
    required this.caret,
    required this.actionButtonText,
    required this.actionButtonTextHover,
  });

  @override
  CarbonToggleTipThemeData copyWith({
    Color? buttonBackground,
    Color? buttonBackgroundHover,
    Color? buttonIcon,
    Color? contentBackground,
    Color? contentText,
    Color? border,
    Color? caret,
    Color? actionButtonText,
    Color? actionButtonTextHover,
  }) {
    return CarbonToggleTipThemeData(
      buttonBackground: buttonBackground ?? this.buttonBackground,
      buttonBackgroundHover:
          buttonBackgroundHover ?? this.buttonBackgroundHover,
      buttonIcon: buttonIcon ?? this.buttonIcon,
      contentBackground: contentBackground ?? this.contentBackground,
      contentText: contentText ?? this.contentText,
      border: border ?? this.border,
      caret: caret ?? this.caret,
      actionButtonText: actionButtonText ?? this.actionButtonText,
      actionButtonTextHover:
          actionButtonTextHover ?? this.actionButtonTextHover,
    );
  }

  @override
  CarbonToggleTipThemeData lerp(
    ThemeExtension<CarbonToggleTipThemeData>? other,
    double t,
  ) {
    if (other is! CarbonToggleTipThemeData) return this;
    return CarbonToggleTipThemeData(
      buttonBackground:
          Color.lerp(buttonBackground, other.buttonBackground, t)!,
      buttonBackgroundHover: Color.lerp(
        buttonBackgroundHover,
        other.buttonBackgroundHover,
        t,
      )!,
      buttonIcon: Color.lerp(buttonIcon, other.buttonIcon, t)!,
      contentBackground: Color.lerp(
        contentBackground,
        other.contentBackground,
        t,
      )!,
      contentText: Color.lerp(contentText, other.contentText, t)!,
      border: Color.lerp(border, other.border, t)!,
      caret: Color.lerp(caret, other.caret, t)!,
      actionButtonText:
          Color.lerp(actionButtonText, other.actionButtonText, t)!,
      actionButtonTextHover: Color.lerp(
        actionButtonTextHover,
        other.actionButtonTextHover,
        t,
      )!,
    );
  }
}
