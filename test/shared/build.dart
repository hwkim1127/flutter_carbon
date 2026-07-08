import 'package:flutter/material.dart';
import 'package:flutter_carbon/material.dart';

/// Builds a Material test app with the Carbon bridge installed, matching the
/// canonical v2 Material-app setup.
Widget buildTestApp({
  required Widget child,
  CarbonThemeData theme = WhiteTheme.theme,
}) {
  return MaterialApp(
    theme: carbonTheme(carbon: theme),
    builder: (context, child) => CarbonMaterialBridge(child: child!),
    home: Scaffold(body: child),
  );
}
