import 'package:flutter/material.dart';

@immutable
class CarbonOverflowMenuThemeData
    extends ThemeExtension<CarbonOverflowMenuThemeData> {
  final Color triggerBackground;
  final Color triggerBackgroundHover;
  final Color triggerIcon;
  final Color menuBackground;
  final Color menuBorder;
  final Color menuShadow;
  final Color itemBackground;
  final Color itemBackgroundHover;
  final Color itemText;
  final Color itemTextHover;
  final Color itemDangerText;
  final Color itemDangerTextHover;
  final Color divider;

  const CarbonOverflowMenuThemeData({
    required this.triggerBackground,
    required this.triggerBackgroundHover,
    required this.triggerIcon,
    required this.menuBackground,
    required this.menuBorder,
    required this.menuShadow,
    required this.itemBackground,
    required this.itemBackgroundHover,
    required this.itemText,
    required this.itemTextHover,
    required this.itemDangerText,
    required this.itemDangerTextHover,
    required this.divider,
  });

  @override
  CarbonOverflowMenuThemeData copyWith({
    Color? triggerBackground,
    Color? triggerBackgroundHover,
    Color? triggerIcon,
    Color? menuBackground,
    Color? menuBorder,
    Color? menuShadow,
    Color? itemBackground,
    Color? itemBackgroundHover,
    Color? itemText,
    Color? itemTextHover,
    Color? itemDangerText,
    Color? itemDangerTextHover,
    Color? divider,
  }) {
    return CarbonOverflowMenuThemeData(
      triggerBackground: triggerBackground ?? this.triggerBackground,
      triggerBackgroundHover:
          triggerBackgroundHover ?? this.triggerBackgroundHover,
      triggerIcon: triggerIcon ?? this.triggerIcon,
      menuBackground: menuBackground ?? this.menuBackground,
      menuBorder: menuBorder ?? this.menuBorder,
      menuShadow: menuShadow ?? this.menuShadow,
      itemBackground: itemBackground ?? this.itemBackground,
      itemBackgroundHover: itemBackgroundHover ?? this.itemBackgroundHover,
      itemText: itemText ?? this.itemText,
      itemTextHover: itemTextHover ?? this.itemTextHover,
      itemDangerText: itemDangerText ?? this.itemDangerText,
      itemDangerTextHover: itemDangerTextHover ?? this.itemDangerTextHover,
      divider: divider ?? this.divider,
    );
  }

  @override
  CarbonOverflowMenuThemeData lerp(
    ThemeExtension<CarbonOverflowMenuThemeData>? other,
    double t,
  ) {
    if (other is! CarbonOverflowMenuThemeData) return this;
    return CarbonOverflowMenuThemeData(
      triggerBackground:
          Color.lerp(triggerBackground, other.triggerBackground, t)!,
      triggerBackgroundHover: Color.lerp(
        triggerBackgroundHover,
        other.triggerBackgroundHover,
        t,
      )!,
      triggerIcon: Color.lerp(triggerIcon, other.triggerIcon, t)!,
      menuBackground: Color.lerp(menuBackground, other.menuBackground, t)!,
      menuBorder: Color.lerp(menuBorder, other.menuBorder, t)!,
      menuShadow: Color.lerp(menuShadow, other.menuShadow, t)!,
      itemBackground: Color.lerp(itemBackground, other.itemBackground, t)!,
      itemBackgroundHover: Color.lerp(
        itemBackgroundHover,
        other.itemBackgroundHover,
        t,
      )!,
      itemText: Color.lerp(itemText, other.itemText, t)!,
      itemTextHover: Color.lerp(itemTextHover, other.itemTextHover, t)!,
      itemDangerText: Color.lerp(itemDangerText, other.itemDangerText, t)!,
      itemDangerTextHover: Color.lerp(
        itemDangerTextHover,
        other.itemDangerTextHover,
        t,
      )!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
