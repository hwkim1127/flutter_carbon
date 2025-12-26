import 'package:flutter/material.dart';

@immutable
class CarbonAIThemeData extends ThemeExtension<CarbonAIThemeData> {
  final Color aiInnerShadow;
  final Color aiAuraStartSm;
  final Color aiAuraStart;
  final Color aiAuraEnd;
  final Color aiBorderStrong;
  final Color aiBorderStart;
  final Color aiBorderEnd;
  final Color aiDropShadow;
  final Color aiAuraHoverBackground;
  final Color aiAuraHoverStart;
  final Color aiAuraHoverEnd;

  final Color aiPopoverBackground;
  final Color aiPopoverShadowOuter01;
  final Color aiPopoverShadowOuter02;

  final Color aiSkeletonBackground;
  final Color aiSkeletonElementBackground;

  final Color aiOverlay;

  final Color aiPopoverCaretCenter;
  final Color aiPopoverCaretBottom;
  final Color aiPopoverCaretBottomBackgroundActions;
  final Color aiPopoverCaretBottomBackground;

  const CarbonAIThemeData({
    required this.aiInnerShadow,
    required this.aiAuraStartSm,
    required this.aiAuraStart,
    required this.aiAuraEnd,
    required this.aiBorderStrong,
    required this.aiBorderStart,
    required this.aiBorderEnd,
    required this.aiDropShadow,
    required this.aiAuraHoverBackground,
    required this.aiAuraHoverStart,
    required this.aiAuraHoverEnd,
    required this.aiPopoverBackground,
    required this.aiPopoverShadowOuter01,
    required this.aiPopoverShadowOuter02,
    required this.aiSkeletonBackground,
    required this.aiSkeletonElementBackground,
    required this.aiOverlay,
    required this.aiPopoverCaretCenter,
    required this.aiPopoverCaretBottom,
    required this.aiPopoverCaretBottomBackgroundActions,
    required this.aiPopoverCaretBottomBackground,
  });

  @override
  CarbonAIThemeData copyWith({
    Color? aiInnerShadow,
    Color? aiAuraStartSm,
    Color? aiAuraStart,
    Color? aiAuraEnd,
    Color? aiBorderStrong,
    Color? aiBorderStart,
    Color? aiBorderEnd,
    Color? aiDropShadow,
    Color? aiAuraHoverBackground,
    Color? aiAuraHoverStart,
    Color? aiAuraHoverEnd,
    Color? aiPopoverBackground,
    Color? aiPopoverShadowOuter01,
    Color? aiPopoverShadowOuter02,
    Color? aiSkeletonBackground,
    Color? aiSkeletonElementBackground,
    Color? aiOverlay,
    Color? aiPopoverCaretCenter,
    Color? aiPopoverCaretBottom,
    Color? aiPopoverCaretBottomBackgroundActions,
    Color? aiPopoverCaretBottomBackground,
  }) {
    return CarbonAIThemeData(
      aiInnerShadow: aiInnerShadow ?? this.aiInnerShadow,
      aiAuraStartSm: aiAuraStartSm ?? this.aiAuraStartSm,
      aiAuraStart: aiAuraStart ?? this.aiAuraStart,
      aiAuraEnd: aiAuraEnd ?? this.aiAuraEnd,
      aiBorderStrong: aiBorderStrong ?? this.aiBorderStrong,
      aiBorderStart: aiBorderStart ?? this.aiBorderStart,
      aiBorderEnd: aiBorderEnd ?? this.aiBorderEnd,
      aiDropShadow: aiDropShadow ?? this.aiDropShadow,
      aiAuraHoverBackground:
          aiAuraHoverBackground ?? this.aiAuraHoverBackground,
      aiAuraHoverStart: aiAuraHoverStart ?? this.aiAuraHoverStart,
      aiAuraHoverEnd: aiAuraHoverEnd ?? this.aiAuraHoverEnd,
      aiPopoverBackground: aiPopoverBackground ?? this.aiPopoverBackground,
      aiPopoverShadowOuter01:
          aiPopoverShadowOuter01 ?? this.aiPopoverShadowOuter01,
      aiPopoverShadowOuter02:
          aiPopoverShadowOuter02 ?? this.aiPopoverShadowOuter02,
      aiSkeletonBackground: aiSkeletonBackground ?? this.aiSkeletonBackground,
      aiSkeletonElementBackground:
          aiSkeletonElementBackground ?? this.aiSkeletonElementBackground,
      aiOverlay: aiOverlay ?? this.aiOverlay,
      aiPopoverCaretCenter: aiPopoverCaretCenter ?? this.aiPopoverCaretCenter,
      aiPopoverCaretBottom: aiPopoverCaretBottom ?? this.aiPopoverCaretBottom,
      aiPopoverCaretBottomBackgroundActions:
          aiPopoverCaretBottomBackgroundActions ??
              this.aiPopoverCaretBottomBackgroundActions,
      aiPopoverCaretBottomBackground:
          aiPopoverCaretBottomBackground ?? this.aiPopoverCaretBottomBackground,
    );
  }

  @override
  CarbonAIThemeData lerp(ThemeExtension<CarbonAIThemeData>? other, double t) {
    if (other is! CarbonAIThemeData) return this;
    return CarbonAIThemeData(
      aiInnerShadow: Color.lerp(aiInnerShadow, other.aiInnerShadow, t)!,
      aiAuraStartSm: Color.lerp(aiAuraStartSm, other.aiAuraStartSm, t)!,
      aiAuraStart: Color.lerp(aiAuraStart, other.aiAuraStart, t)!,
      aiAuraEnd: Color.lerp(aiAuraEnd, other.aiAuraEnd, t)!,
      aiBorderStrong: Color.lerp(aiBorderStrong, other.aiBorderStrong, t)!,
      aiBorderStart: Color.lerp(aiBorderStart, other.aiBorderStart, t)!,
      aiBorderEnd: Color.lerp(aiBorderEnd, other.aiBorderEnd, t)!,
      aiDropShadow: Color.lerp(aiDropShadow, other.aiDropShadow, t)!,
      aiAuraHoverBackground: Color.lerp(
        aiAuraHoverBackground,
        other.aiAuraHoverBackground,
        t,
      )!,
      aiAuraHoverStart: Color.lerp(
        aiAuraHoverStart,
        other.aiAuraHoverStart,
        t,
      )!,
      aiAuraHoverEnd: Color.lerp(aiAuraHoverEnd, other.aiAuraHoverEnd, t)!,
      aiPopoverBackground: Color.lerp(
        aiPopoverBackground,
        other.aiPopoverBackground,
        t,
      )!,
      aiPopoverShadowOuter01: Color.lerp(
        aiPopoverShadowOuter01,
        other.aiPopoverShadowOuter01,
        t,
      )!,
      aiPopoverShadowOuter02: Color.lerp(
        aiPopoverShadowOuter02,
        other.aiPopoverShadowOuter02,
        t,
      )!,
      aiSkeletonBackground: Color.lerp(
        aiSkeletonBackground,
        other.aiSkeletonBackground,
        t,
      )!,
      aiSkeletonElementBackground: Color.lerp(
        aiSkeletonElementBackground,
        other.aiSkeletonElementBackground,
        t,
      )!,
      aiOverlay: Color.lerp(aiOverlay, other.aiOverlay, t)!,
      aiPopoverCaretCenter: Color.lerp(
        aiPopoverCaretCenter,
        other.aiPopoverCaretCenter,
        t,
      )!,
      aiPopoverCaretBottom: Color.lerp(
        aiPopoverCaretBottom,
        other.aiPopoverCaretBottom,
        t,
      )!,
      aiPopoverCaretBottomBackgroundActions: Color.lerp(
        aiPopoverCaretBottomBackgroundActions,
        other.aiPopoverCaretBottomBackgroundActions,
        t,
      )!,
      aiPopoverCaretBottomBackground: Color.lerp(
        aiPopoverCaretBottomBackground,
        other.aiPopoverCaretBottomBackground,
        t,
      )!,
    );
  }
}
