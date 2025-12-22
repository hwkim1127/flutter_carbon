import 'package:flutter/material.dart';

/// Semantic text colors for Carbon Design System.
///
/// See: https://carbondesignsystem.com/guidelines/color/usage/#text
@immutable
class CarbonTextThemeData extends ThemeExtension<CarbonTextThemeData> {
  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textPlaceholder;
  final Color textHelper;
  final Color textError;
  final Color textInverse;
  final Color textOnColor;
  final Color textOnColorDisabled;
  final Color textDisabled;

  // Links
  final Color linkPrimary;
  final Color linkPrimaryHover;
  final Color linkSecondary;
  final Color linkInverse;
  final Color linkVisited;
  final Color linkInverseVisited;
  final Color linkInverseActive;
  final Color linkInverseHover;

  // Icons (Often grouped with text in Carbon's mental model for color usage)
  final Color iconPrimary;
  final Color iconSecondary;
  final Color iconInverse;
  final Color iconOnColor;
  final Color iconOnColorDisabled;
  final Color iconDisabled;
  final Color iconInteractive;

  const CarbonTextThemeData({
    required this.textPrimary,
    required this.textSecondary,
    required this.textPlaceholder,
    required this.textHelper,
    required this.textError,
    required this.textInverse,
    required this.textOnColor,
    required this.textOnColorDisabled,
    required this.textDisabled,
    required this.linkPrimary,
    required this.linkPrimaryHover,
    required this.linkSecondary,
    required this.linkInverse,
    required this.linkVisited,
    required this.linkInverseVisited,
    required this.linkInverseActive,
    required this.linkInverseHover,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconInverse,
    required this.iconOnColor,
    required this.iconOnColorDisabled,
    required this.iconDisabled,
    required this.iconInteractive,
  });

  @override
  CarbonTextThemeData copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textPlaceholder,
    Color? textHelper,
    Color? textError,
    Color? textInverse,
    Color? textOnColor,
    Color? textOnColorDisabled,
    Color? textDisabled,
    Color? linkPrimary,
    Color? linkPrimaryHover,
    Color? linkSecondary,
    Color? linkInverse,
    Color? linkVisited,
    Color? linkInverseVisited,
    Color? linkInverseActive,
    Color? linkInverseHover,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? iconInverse,
    Color? iconOnColor,
    Color? iconOnColorDisabled,
    Color? iconDisabled,
    Color? iconInteractive,
  }) {
    return CarbonTextThemeData(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textPlaceholder: textPlaceholder ?? this.textPlaceholder,
      textHelper: textHelper ?? this.textHelper,
      textError: textError ?? this.textError,
      textInverse: textInverse ?? this.textInverse,
      textOnColor: textOnColor ?? this.textOnColor,
      textOnColorDisabled: textOnColorDisabled ?? this.textOnColorDisabled,
      textDisabled: textDisabled ?? this.textDisabled,
      linkPrimary: linkPrimary ?? this.linkPrimary,
      linkPrimaryHover: linkPrimaryHover ?? this.linkPrimaryHover,
      linkSecondary: linkSecondary ?? this.linkSecondary,
      linkInverse: linkInverse ?? this.linkInverse,
      linkVisited: linkVisited ?? this.linkVisited,
      linkInverseVisited: linkInverseVisited ?? this.linkInverseVisited,
      linkInverseActive: linkInverseActive ?? this.linkInverseActive,
      linkInverseHover: linkInverseHover ?? this.linkInverseHover,
      iconPrimary: iconPrimary ?? this.iconPrimary,
      iconSecondary: iconSecondary ?? this.iconSecondary,
      iconInverse: iconInverse ?? this.iconInverse,
      iconOnColor: iconOnColor ?? this.iconOnColor,
      iconOnColorDisabled: iconOnColorDisabled ?? this.iconOnColorDisabled,
      iconDisabled: iconDisabled ?? this.iconDisabled,
      iconInteractive: iconInteractive ?? this.iconInteractive,
    );
  }

  @override
  CarbonTextThemeData lerp(
    ThemeExtension<CarbonTextThemeData>? other,
    double t,
  ) {
    if (other is! CarbonTextThemeData) return this;
    return CarbonTextThemeData(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textPlaceholder: Color.lerp(textPlaceholder, other.textPlaceholder, t)!,
      textHelper: Color.lerp(textHelper, other.textHelper, t)!,
      textError: Color.lerp(textError, other.textError, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textOnColor: Color.lerp(textOnColor, other.textOnColor, t)!,
      textOnColorDisabled: Color.lerp(
        textOnColorDisabled,
        other.textOnColorDisabled,
        t,
      )!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      linkPrimary: Color.lerp(linkPrimary, other.linkPrimary, t)!,
      linkPrimaryHover: Color.lerp(
        linkPrimaryHover,
        other.linkPrimaryHover,
        t,
      )!,
      linkSecondary: Color.lerp(linkSecondary, other.linkSecondary, t)!,
      linkInverse: Color.lerp(linkInverse, other.linkInverse, t)!,
      linkVisited: Color.lerp(linkVisited, other.linkVisited, t)!,
      linkInverseVisited: Color.lerp(
        linkInverseVisited,
        other.linkInverseVisited,
        t,
      )!,
      linkInverseActive: Color.lerp(
        linkInverseActive,
        other.linkInverseActive,
        t,
      )!,
      linkInverseHover: Color.lerp(
        linkInverseHover,
        other.linkInverseHover,
        t,
      )!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      iconInverse: Color.lerp(iconInverse, other.iconInverse, t)!,
      iconOnColor: Color.lerp(iconOnColor, other.iconOnColor, t)!,
      iconOnColorDisabled: Color.lerp(
        iconOnColorDisabled,
        other.iconOnColorDisabled,
        t,
      )!,
      iconDisabled: Color.lerp(iconDisabled, other.iconDisabled, t)!,
      iconInteractive: Color.lerp(iconInteractive, other.iconInteractive, t)!,
    );
  }
}
