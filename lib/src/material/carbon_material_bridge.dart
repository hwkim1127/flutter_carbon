import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';
import 'carbon_theme_extension.dart';

/// Installs a [CarbonTheme] beneath a [MaterialApp], so `context.carbon`
/// works inside a Material app.
///
/// The theme data is resolved from the ambient Material [Theme]'s
/// [CarbonMaterialThemeExtension] — which `carbonTheme()` installs — so
/// switching `MaterialApp.theme` propagates automatically. Place it in
/// [MaterialApp.builder] so the Navigator and all overlays are covered:
///
/// ```dart
/// MaterialApp(
///   theme: carbonTheme(carbon: WhiteTheme.theme),
///   builder: (context, child) => CarbonMaterialBridge(child: child!),
/// )
/// ```
class CarbonMaterialBridge extends StatelessWidget {
  /// Creates a Material-to-Carbon theme bridge.
  const CarbonMaterialBridge({super.key, this.data, required this.child});

  /// Explicit theme data. When null, resolves from the ambient Material
  /// [Theme]'s [CarbonMaterialThemeExtension].
  final CarbonThemeData? data;

  /// The subtree the theme applies to.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final resolved =
        data ?? Theme.of(context).extension<CarbonMaterialThemeExtension>()?.data;
    if (resolved == null) {
      throw FlutterError(
        'CarbonMaterialBridge could not resolve a CarbonThemeData.\n'
        'Either pass `data:` explicitly or build your ThemeData with '
        'carbonTheme(carbon: ...) so CarbonMaterialThemeExtension is '
        'installed.',
      );
    }
    return CarbonTheme(data: resolved, child: child);
  }
}
