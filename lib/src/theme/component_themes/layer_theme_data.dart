import 'package:flutter/material.dart';

/// Semantic layer colors for Carbon Design System.
/// Includes Background, Layer, Field, and Border tokens.
@immutable
class CarbonLayerThemeData extends ThemeExtension<CarbonLayerThemeData> {
  // Background
  final Color background;
  final Color backgroundInverse;
  final Color backgroundBrand;
  final Color backgroundActive;
  final Color backgroundHover;
  final Color backgroundInverseHover;
  final Color backgroundSelected;
  final Color backgroundSelectedHover;

  // Layer 01
  final Color layer01;
  final Color layerActive01;
  final Color layerBackground01;
  final Color layerHover01;
  final Color layerSelected01;
  final Color layerSelectedHover01;

  // Layer 02
  final Color layer02;
  final Color layerActive02;
  final Color layerBackground02;
  final Color layerHover02;
  final Color layerSelected02;
  final Color layerSelectedHover02;

  // Layer 03
  final Color layer03;
  final Color layerActive03;
  final Color layerBackground03;
  final Color layerHover03;
  final Color layerSelected03;
  final Color layerSelectedHover03;

  // Layer Misc
  final Color layerSelectedInverse;
  final Color layerSelectedDisabled;

  // Layer Accent 01
  final Color layerAccent01;
  final Color layerAccentActive01;
  final Color layerAccentHover01;

  // Layer Accent 02
  final Color layerAccent02;
  final Color layerAccentActive02;
  final Color layerAccentHover02;

  // Layer Accent 03
  final Color layerAccent03;
  final Color layerAccentActive03;
  final Color layerAccentHover03;

  // Field
  final Color field01;
  final Color fieldHover01;
  final Color field02;
  final Color fieldHover02;
  final Color field03;
  final Color fieldHover03;

  // Border
  final Color borderSubtle00;
  final Color borderSubtle01;
  final Color borderSubtleSelected01;
  final Color borderSubtle02;
  final Color borderSubtleSelected02;
  final Color borderSubtle03;
  final Color borderSubtleSelected03;
  final Color borderStrong01;
  final Color borderStrong02;
  final Color borderStrong03;
  final Color borderTile01;
  final Color borderTile02;
  final Color borderTile03;
  final Color borderInverse;
  final Color borderInteractive;
  final Color borderDisabled;

  // Focus
  final Color focus;
  final Color focusInset;
  final Color focusInverse;

  // Misc
  final Color interactive;
  final Color highlight;
  final Color overlay;
  final Color toggleOff;
  final Color shadow;

  // Support
  final Color supportError;
  final Color supportSuccess;
  final Color supportWarning;
  final Color supportInfo;
  final Color supportErrorInverse;
  final Color supportSuccessInverse;
  final Color supportWarningInverse;
  final Color supportInfoInverse;
  final Color supportCautionMinor;
  final Color supportCautionMajor;
  final Color supportCautionUndefined;

  const CarbonLayerThemeData({
    required this.background,
    required this.backgroundInverse,
    required this.backgroundBrand,
    required this.backgroundActive,
    required this.backgroundHover,
    required this.backgroundInverseHover,
    required this.backgroundSelected,
    required this.backgroundSelectedHover,
    required this.layer01,
    required this.layerActive01,
    required this.layerBackground01,
    required this.layerHover01,
    required this.layerSelected01,
    required this.layerSelectedHover01,
    required this.layer02,
    required this.layerActive02,
    required this.layerBackground02,
    required this.layerHover02,
    required this.layerSelected02,
    required this.layerSelectedHover02,
    required this.layer03,
    required this.layerActive03,
    required this.layerBackground03,
    required this.layerHover03,
    required this.layerSelected03,
    required this.layerSelectedHover03,
    required this.layerSelectedInverse,
    required this.layerSelectedDisabled,
    required this.layerAccent01,
    required this.layerAccentActive01,
    required this.layerAccentHover01,
    required this.layerAccent02,
    required this.layerAccentActive02,
    required this.layerAccentHover02,
    required this.layerAccent03,
    required this.layerAccentActive03,
    required this.layerAccentHover03,
    required this.field01,
    required this.fieldHover01,
    required this.field02,
    required this.fieldHover02,
    required this.field03,
    required this.fieldHover03,
    required this.borderSubtle00,
    required this.borderSubtle01,
    required this.borderSubtleSelected01,
    required this.borderSubtle02,
    required this.borderSubtleSelected02,
    required this.borderSubtle03,
    required this.borderSubtleSelected03,
    required this.borderStrong01,
    required this.borderStrong02,
    required this.borderStrong03,
    required this.borderTile01,
    required this.borderTile02,
    required this.borderTile03,
    required this.borderInverse,
    required this.borderInteractive,
    required this.borderDisabled,
    required this.focus,
    required this.focusInset,
    required this.focusInverse,
    required this.interactive,
    required this.highlight,
    required this.overlay,
    required this.toggleOff,
    required this.shadow,
    required this.supportError,
    required this.supportSuccess,
    required this.supportWarning,
    required this.supportInfo,
    required this.supportErrorInverse,
    required this.supportSuccessInverse,
    required this.supportWarningInverse,
    required this.supportInfoInverse,
    required this.supportCautionMinor,
    required this.supportCautionMajor,
    required this.supportCautionUndefined,
  });

  @override
  CarbonLayerThemeData copyWith({
    Color? background,
    Color? backgroundInverse,
    Color? backgroundBrand,
    Color? backgroundActive,
    Color? backgroundHover,
    Color? backgroundInverseHover,
    Color? backgroundSelected,
    Color? backgroundSelectedHover,
    Color? layer01,
    Color? layerActive01,
    Color? layerBackground01,
    Color? layerHover01,
    Color? layerSelected01,
    Color? layerSelectedHover01,
    Color? layer02,
    Color? layerActive02,
    Color? layerBackground02,
    Color? layerHover02,
    Color? layerSelected02,
    Color? layerSelectedHover02,
    Color? layer03,
    Color? layerActive03,
    Color? layerBackground03,
    Color? layerHover03,
    Color? layerSelected03,
    Color? layerSelectedHover03,
    Color? layerSelectedInverse,
    Color? layerSelectedDisabled,
    Color? layerAccent01,
    Color? layerAccentActive01,
    Color? layerAccentHover01,
    Color? layerAccent02,
    Color? layerAccentActive02,
    Color? layerAccentHover02,
    Color? layerAccent03,
    Color? layerAccentActive03,
    Color? layerAccentHover03,
    Color? field01,
    Color? fieldHover01,
    Color? field02,
    Color? fieldHover02,
    Color? field03,
    Color? fieldHover03,
    Color? borderSubtle00,
    Color? borderSubtle01,
    Color? borderSubtleSelected01,
    Color? borderSubtle02,
    Color? borderSubtleSelected02,
    Color? borderSubtle03,
    Color? borderSubtleSelected03,
    Color? borderStrong01,
    Color? borderStrong02,
    Color? borderStrong03,
    Color? borderTile01,
    Color? borderTile02,
    Color? borderTile03,
    Color? borderInverse,
    Color? borderInteractive,
    Color? borderDisabled,
    Color? focus,
    Color? focusInset,
    Color? focusInverse,
    Color? interactive,
    Color? highlight,
    Color? overlay,
    Color? toggleOff,
    Color? shadow,
    Color? supportError,
    Color? supportSuccess,
    Color? supportWarning,
    Color? supportInfo,
    Color? supportErrorInverse,
    Color? supportSuccessInverse,
    Color? supportWarningInverse,
    Color? supportInfoInverse,
    Color? supportCautionMinor,
    Color? supportCautionMajor,
    Color? supportCautionUndefined,
  }) {
    return CarbonLayerThemeData(
      background: background ?? this.background,
      backgroundInverse: backgroundInverse ?? this.backgroundInverse,
      backgroundBrand: backgroundBrand ?? this.backgroundBrand,
      backgroundActive: backgroundActive ?? this.backgroundActive,
      backgroundHover: backgroundHover ?? this.backgroundHover,
      backgroundInverseHover:
          backgroundInverseHover ?? this.backgroundInverseHover,
      backgroundSelected: backgroundSelected ?? this.backgroundSelected,
      backgroundSelectedHover:
          backgroundSelectedHover ?? this.backgroundSelectedHover,
      layer01: layer01 ?? this.layer01,
      layerActive01: layerActive01 ?? this.layerActive01,
      layerBackground01: layerBackground01 ?? this.layerBackground01,
      layerHover01: layerHover01 ?? this.layerHover01,
      layerSelected01: layerSelected01 ?? this.layerSelected01,
      layerSelectedHover01: layerSelectedHover01 ?? this.layerSelectedHover01,
      layer02: layer02 ?? this.layer02,
      layerActive02: layerActive02 ?? this.layerActive02,
      layerBackground02: layerBackground02 ?? this.layerBackground02,
      layerHover02: layerHover02 ?? this.layerHover02,
      layerSelected02: layerSelected02 ?? this.layerSelected02,
      layerSelectedHover02: layerSelectedHover02 ?? this.layerSelectedHover02,
      layer03: layer03 ?? this.layer03,
      layerActive03: layerActive03 ?? this.layerActive03,
      layerBackground03: layerBackground03 ?? this.layerBackground03,
      layerHover03: layerHover03 ?? this.layerHover03,
      layerSelected03: layerSelected03 ?? this.layerSelected03,
      layerSelectedHover03: layerSelectedHover03 ?? this.layerSelectedHover03,
      layerSelectedInverse: layerSelectedInverse ?? this.layerSelectedInverse,
      layerSelectedDisabled:
          layerSelectedDisabled ?? this.layerSelectedDisabled,
      layerAccent01: layerAccent01 ?? this.layerAccent01,
      layerAccentActive01: layerAccentActive01 ?? this.layerAccentActive01,
      layerAccentHover01: layerAccentHover01 ?? this.layerAccentHover01,
      layerAccent02: layerAccent02 ?? this.layerAccent02,
      layerAccentActive02: layerAccentActive02 ?? this.layerAccentActive02,
      layerAccentHover02: layerAccentHover02 ?? this.layerAccentHover02,
      layerAccent03: layerAccent03 ?? this.layerAccent03,
      layerAccentActive03: layerAccentActive03 ?? this.layerAccentActive03,
      layerAccentHover03: layerAccentHover03 ?? this.layerAccentHover03,
      field01: field01 ?? this.field01,
      fieldHover01: fieldHover01 ?? this.fieldHover01,
      field02: field02 ?? this.field02,
      fieldHover02: fieldHover02 ?? this.fieldHover02,
      field03: field03 ?? this.field03,
      fieldHover03: fieldHover03 ?? this.fieldHover03,
      borderSubtle00: borderSubtle00 ?? this.borderSubtle00,
      borderSubtle01: borderSubtle01 ?? this.borderSubtle01,
      borderSubtleSelected01:
          borderSubtleSelected01 ?? this.borderSubtleSelected01,
      borderSubtle02: borderSubtle02 ?? this.borderSubtle02,
      borderSubtleSelected02:
          borderSubtleSelected02 ?? this.borderSubtleSelected02,
      borderSubtle03: borderSubtle03 ?? this.borderSubtle03,
      borderSubtleSelected03:
          borderSubtleSelected03 ?? this.borderSubtleSelected03,
      borderStrong01: borderStrong01 ?? this.borderStrong01,
      borderStrong02: borderStrong02 ?? this.borderStrong02,
      borderStrong03: borderStrong03 ?? this.borderStrong03,
      borderTile01: borderTile01 ?? this.borderTile01,
      borderTile02: borderTile02 ?? this.borderTile02,
      borderTile03: borderTile03 ?? this.borderTile03,
      borderInverse: borderInverse ?? this.borderInverse,
      borderInteractive: borderInteractive ?? this.borderInteractive,
      borderDisabled: borderDisabled ?? this.borderDisabled,
      focus: focus ?? this.focus,
      focusInset: focusInset ?? this.focusInset,
      focusInverse: focusInverse ?? this.focusInverse,
      interactive: interactive ?? this.interactive,
      highlight: highlight ?? this.highlight,
      overlay: overlay ?? this.overlay,
      toggleOff: toggleOff ?? this.toggleOff,
      shadow: shadow ?? this.shadow,
      supportError: supportError ?? this.supportError,
      supportSuccess: supportSuccess ?? this.supportSuccess,
      supportWarning: supportWarning ?? this.supportWarning,
      supportInfo: supportInfo ?? this.supportInfo,
      supportErrorInverse: supportErrorInverse ?? this.supportErrorInverse,
      supportSuccessInverse:
          supportSuccessInverse ?? this.supportSuccessInverse,
      supportWarningInverse:
          supportWarningInverse ?? this.supportWarningInverse,
      supportInfoInverse: supportInfoInverse ?? this.supportInfoInverse,
      supportCautionMinor: supportCautionMinor ?? this.supportCautionMinor,
      supportCautionMajor: supportCautionMajor ?? this.supportCautionMajor,
      supportCautionUndefined:
          supportCautionUndefined ?? this.supportCautionUndefined,
    );
  }

  @override
  CarbonLayerThemeData lerp(
    ThemeExtension<CarbonLayerThemeData>? other,
    double t,
  ) {
    if (other is! CarbonLayerThemeData) return this;
    return CarbonLayerThemeData(
      background: Color.lerp(background, other.background, t)!,
      backgroundInverse: Color.lerp(
        backgroundInverse,
        other.backgroundInverse,
        t,
      )!,
      backgroundBrand: Color.lerp(backgroundBrand, other.backgroundBrand, t)!,
      backgroundActive: Color.lerp(
        backgroundActive,
        other.backgroundActive,
        t,
      )!,
      backgroundHover: Color.lerp(backgroundHover, other.backgroundHover, t)!,
      backgroundInverseHover: Color.lerp(
        backgroundInverseHover,
        other.backgroundInverseHover,
        t,
      )!,
      backgroundSelected: Color.lerp(
        backgroundSelected,
        other.backgroundSelected,
        t,
      )!,
      backgroundSelectedHover: Color.lerp(
        backgroundSelectedHover,
        other.backgroundSelectedHover,
        t,
      )!,
      layer01: Color.lerp(layer01, other.layer01, t)!,
      layerActive01: Color.lerp(layerActive01, other.layerActive01, t)!,
      layerBackground01: Color.lerp(
        layerBackground01,
        other.layerBackground01,
        t,
      )!,
      layerHover01: Color.lerp(layerHover01, other.layerHover01, t)!,
      layerSelected01: Color.lerp(layerSelected01, other.layerSelected01, t)!,
      layerSelectedHover01: Color.lerp(
        layerSelectedHover01,
        other.layerSelectedHover01,
        t,
      )!,
      layer02: Color.lerp(layer02, other.layer02, t)!,
      layerActive02: Color.lerp(layerActive02, other.layerActive02, t)!,
      layerBackground02: Color.lerp(
        layerBackground02,
        other.layerBackground02,
        t,
      )!,
      layerHover02: Color.lerp(layerHover02, other.layerHover02, t)!,
      layerSelected02: Color.lerp(layerSelected02, other.layerSelected02, t)!,
      layerSelectedHover02: Color.lerp(
        layerSelectedHover02,
        other.layerSelectedHover02,
        t,
      )!,
      layer03: Color.lerp(layer03, other.layer03, t)!,
      layerActive03: Color.lerp(layerActive03, other.layerActive03, t)!,
      layerBackground03: Color.lerp(
        layerBackground03,
        other.layerBackground03,
        t,
      )!,
      layerHover03: Color.lerp(layerHover03, other.layerHover03, t)!,
      layerSelected03: Color.lerp(layerSelected03, other.layerSelected03, t)!,
      layerSelectedHover03: Color.lerp(
        layerSelectedHover03,
        other.layerSelectedHover03,
        t,
      )!,
      layerSelectedInverse: Color.lerp(
        layerSelectedInverse,
        other.layerSelectedInverse,
        t,
      )!,
      layerSelectedDisabled: Color.lerp(
        layerSelectedDisabled,
        other.layerSelectedDisabled,
        t,
      )!,
      layerAccent01: Color.lerp(layerAccent01, other.layerAccent01, t)!,
      layerAccentActive01: Color.lerp(
        layerAccentActive01,
        other.layerAccentActive01,
        t,
      )!,
      layerAccentHover01: Color.lerp(
        layerAccentHover01,
        other.layerAccentHover01,
        t,
      )!,
      layerAccent02: Color.lerp(layerAccent02, other.layerAccent02, t)!,
      layerAccentActive02: Color.lerp(
        layerAccentActive02,
        other.layerAccentActive02,
        t,
      )!,
      layerAccentHover02: Color.lerp(
        layerAccentHover02,
        other.layerAccentHover02,
        t,
      )!,
      layerAccent03: Color.lerp(layerAccent03, other.layerAccent03, t)!,
      layerAccentActive03: Color.lerp(
        layerAccentActive03,
        other.layerAccentActive03,
        t,
      )!,
      layerAccentHover03: Color.lerp(
        layerAccentHover03,
        other.layerAccentHover03,
        t,
      )!,
      field01: Color.lerp(field01, other.field01, t)!,
      fieldHover01: Color.lerp(fieldHover01, other.fieldHover01, t)!,
      field02: Color.lerp(field02, other.field02, t)!,
      fieldHover02: Color.lerp(fieldHover02, other.fieldHover02, t)!,
      field03: Color.lerp(field03, other.field03, t)!,
      fieldHover03: Color.lerp(fieldHover03, other.fieldHover03, t)!,
      borderSubtle00: Color.lerp(borderSubtle00, other.borderSubtle00, t)!,
      borderSubtle01: Color.lerp(borderSubtle01, other.borderSubtle01, t)!,
      borderSubtleSelected01: Color.lerp(
        borderSubtleSelected01,
        other.borderSubtleSelected01,
        t,
      )!,
      borderSubtle02: Color.lerp(borderSubtle02, other.borderSubtle02, t)!,
      borderSubtleSelected02: Color.lerp(
        borderSubtleSelected02,
        other.borderSubtleSelected02,
        t,
      )!,
      borderSubtle03: Color.lerp(borderSubtle03, other.borderSubtle03, t)!,
      borderSubtleSelected03: Color.lerp(
        borderSubtleSelected03,
        other.borderSubtleSelected03,
        t,
      )!,
      borderStrong01: Color.lerp(borderStrong01, other.borderStrong01, t)!,
      borderStrong02: Color.lerp(borderStrong02, other.borderStrong02, t)!,
      borderStrong03: Color.lerp(borderStrong03, other.borderStrong03, t)!,
      borderTile01: Color.lerp(borderTile01, other.borderTile01, t)!,
      borderTile02: Color.lerp(borderTile02, other.borderTile02, t)!,
      borderTile03: Color.lerp(borderTile03, other.borderTile03, t)!,
      borderInverse: Color.lerp(borderInverse, other.borderInverse, t)!,
      borderInteractive: Color.lerp(
        borderInteractive,
        other.borderInteractive,
        t,
      )!,
      borderDisabled: Color.lerp(borderDisabled, other.borderDisabled, t)!,
      focus: Color.lerp(focus, other.focus, t)!,
      focusInset: Color.lerp(focusInset, other.focusInset, t)!,
      focusInverse: Color.lerp(focusInverse, other.focusInverse, t)!,
      interactive: Color.lerp(interactive, other.interactive, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      toggleOff: Color.lerp(toggleOff, other.toggleOff, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      supportError: Color.lerp(supportError, other.supportError, t)!,
      supportSuccess: Color.lerp(supportSuccess, other.supportSuccess, t)!,
      supportWarning: Color.lerp(supportWarning, other.supportWarning, t)!,
      supportInfo: Color.lerp(supportInfo, other.supportInfo, t)!,
      supportErrorInverse: Color.lerp(
        supportErrorInverse,
        other.supportErrorInverse,
        t,
      )!,
      supportSuccessInverse: Color.lerp(
        supportSuccessInverse,
        other.supportSuccessInverse,
        t,
      )!,
      supportWarningInverse: Color.lerp(
        supportWarningInverse,
        other.supportWarningInverse,
        t,
      )!,
      supportInfoInverse: Color.lerp(
        supportInfoInverse,
        other.supportInfoInverse,
        t,
      )!,
      supportCautionMinor: Color.lerp(
        supportCautionMinor,
        other.supportCautionMinor,
        t,
      )!,
      supportCautionMajor: Color.lerp(
        supportCautionMajor,
        other.supportCautionMajor,
        t,
      )!,
      supportCautionUndefined: Color.lerp(
        supportCautionUndefined,
        other.supportCautionUndefined,
        t,
      )!,
    );
  }
}
