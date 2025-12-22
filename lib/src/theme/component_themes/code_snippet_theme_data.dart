import 'package:flutter/material.dart';

/// Theme data for Carbon code snippet.
@immutable
class CarbonCodeSnippetThemeData
    extends ThemeExtension<CarbonCodeSnippetThemeData> {
  /// Background color for code snippet.
  final Color background;

  /// Text color for code.
  final Color codeText;

  /// Border color for code snippet container.
  final Color border;

  /// Copy button background color.
  final Color copyButtonBackground;

  /// Copy button background color on hover.
  final Color copyButtonBackgroundHover;

  /// Copy button icon color.
  final Color copyButtonIcon;

  const CarbonCodeSnippetThemeData({
    required this.background,
    required this.codeText,
    required this.border,
    required this.copyButtonBackground,
    required this.copyButtonBackgroundHover,
    required this.copyButtonIcon,
  });

  @override
  CarbonCodeSnippetThemeData copyWith({
    Color? background,
    Color? codeText,
    Color? border,
    Color? copyButtonBackground,
    Color? copyButtonBackgroundHover,
    Color? copyButtonIcon,
  }) {
    return CarbonCodeSnippetThemeData(
      background: background ?? this.background,
      codeText: codeText ?? this.codeText,
      border: border ?? this.border,
      copyButtonBackground: copyButtonBackground ?? this.copyButtonBackground,
      copyButtonBackgroundHover:
          copyButtonBackgroundHover ?? this.copyButtonBackgroundHover,
      copyButtonIcon: copyButtonIcon ?? this.copyButtonIcon,
    );
  }

  @override
  CarbonCodeSnippetThemeData lerp(
      ThemeExtension<CarbonCodeSnippetThemeData>? other, double t) {
    if (other is! CarbonCodeSnippetThemeData) return this;
    return CarbonCodeSnippetThemeData(
      background: Color.lerp(background, other.background, t)!,
      codeText: Color.lerp(codeText, other.codeText, t)!,
      border: Color.lerp(border, other.border, t)!,
      copyButtonBackground:
          Color.lerp(copyButtonBackground, other.copyButtonBackground, t)!,
      copyButtonBackgroundHover: Color.lerp(
          copyButtonBackgroundHover, other.copyButtonBackgroundHover, t)!,
      copyButtonIcon: Color.lerp(copyButtonIcon, other.copyButtonIcon, t)!,
    );
  }
}
