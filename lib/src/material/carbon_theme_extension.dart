import 'package:flutter/material.dart';

import '../theme/carbon_theme_data.dart';

/// Carries a [CarbonThemeData] through Material's [ThemeData.extensions] so
/// `CarbonMaterialBridge` can pick it up beneath a [MaterialApp].
///
/// Installed automatically by `carbonTheme()`; read it back with
/// `Theme.of(context).extension<CarbonMaterialThemeExtension>()`.
class CarbonMaterialThemeExtension
    extends ThemeExtension<CarbonMaterialThemeExtension> {
  const CarbonMaterialThemeExtension(this.data);

  /// The wrapped Carbon theme data.
  final CarbonThemeData data;

  @override
  CarbonMaterialThemeExtension copyWith({CarbonThemeData? data}) =>
      CarbonMaterialThemeExtension(data ?? this.data);

  @override
  CarbonMaterialThemeExtension lerp(
    ThemeExtension<CarbonMaterialThemeExtension>? other,
    double t,
  ) {
    if (other is! CarbonMaterialThemeExtension) return this;
    // Delegating keeps MaterialApp's AnimatedTheme switching smooth.
    return CarbonMaterialThemeExtension(data.lerp(other.data, t));
  }
}
