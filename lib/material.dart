/// Material interop for flutter_carbon.
///
/// Import this library when embedding Carbon widgets in a Material app:
///
/// ```dart
/// import 'package:flutter_carbon/material.dart';
///
/// MaterialApp(
///   theme: carbonTheme(carbon: WhiteTheme.theme),
///   builder: (context, child) => CarbonMaterialBridge(child: child!),
/// )
/// ```
///
/// Pure-Carbon apps (using `CarbonApp`) do not need this library.
library;

export 'flutter_carbon.dart';
export 'src/material/carbon_material_bridge.dart';
export 'src/material/carbon_material_theme.dart';
export 'src/material/carbon_theme_extension.dart';
