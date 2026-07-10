import 'package:flutter/widgets.dart';

/// Theme data for Carbon code snippet.
@immutable
class CarbonCodeSnippetThemeData {
  /// Background color for code snippet.
  final Color background;

  /// Text color for code.
  final Color codeText;

  /// Copy button background color.
  final Color copyButtonBackground;

  /// Copy button background color on hover.
  final Color copyButtonBackgroundHover;

  /// Copy button background color while pressed.
  final Color copyButtonBackgroundActive;

  /// Copy button icon color.
  final Color copyButtonIcon;

  const CarbonCodeSnippetThemeData({
    required this.background,
    required this.codeText,
    required this.copyButtonBackground,
    required this.copyButtonBackgroundHover,
    required this.copyButtonBackgroundActive,
    required this.copyButtonIcon,
  });

  CarbonCodeSnippetThemeData copyWith({
    Color? background,
    Color? codeText,
    Color? copyButtonBackground,
    Color? copyButtonBackgroundHover,
    Color? copyButtonBackgroundActive,
    Color? copyButtonIcon,
  }) {
    return CarbonCodeSnippetThemeData(
      background: background ?? this.background,
      codeText: codeText ?? this.codeText,
      copyButtonBackground: copyButtonBackground ?? this.copyButtonBackground,
      copyButtonBackgroundHover:
          copyButtonBackgroundHover ?? this.copyButtonBackgroundHover,
      copyButtonBackgroundActive:
          copyButtonBackgroundActive ?? this.copyButtonBackgroundActive,
      copyButtonIcon: copyButtonIcon ?? this.copyButtonIcon,
    );
  }

  CarbonCodeSnippetThemeData lerp(
      CarbonCodeSnippetThemeData? other, double t) {
    if (other == null) return this;
    return CarbonCodeSnippetThemeData(
      background: Color.lerp(background, other.background, t)!,
      codeText: Color.lerp(codeText, other.codeText, t)!,
      copyButtonBackground:
          Color.lerp(copyButtonBackground, other.copyButtonBackground, t)!,
      copyButtonBackgroundHover: Color.lerp(
          copyButtonBackgroundHover, other.copyButtonBackgroundHover, t)!,
      copyButtonBackgroundActive: Color.lerp(
          copyButtonBackgroundActive, other.copyButtonBackgroundActive, t)!,
      copyButtonIcon: Color.lerp(copyButtonIcon, other.copyButtonIcon, t)!,
    );
  }
}
