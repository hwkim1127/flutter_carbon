# 03 — Material Bridge (additive)

## Goal

Create the bridge library skeleton without breaking anything: the ThemeData
holder extension and the moved `carbonTheme()`. The bridge *widget* needs the
new `CarbonTheme` and is added in step 04.

## New files

### `lib/src/material/carbon_theme_extension.dart`

```dart
import 'package:flutter/material.dart';

import '../theme/carbon_theme_data.dart';

/// Carries a [CarbonThemeData] through Material's [ThemeData.extensions] so
/// [CarbonMaterialBridge] can pick it up beneath a [MaterialApp].
class CarbonMaterialThemeExtension
    extends ThemeExtension<CarbonMaterialThemeExtension> {
  const CarbonMaterialThemeExtension(this.data);

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
    // Delegating keeps MaterialApp's AnimatedTheme switching smooth, as in v1.
    return CarbonMaterialThemeExtension(data.lerp(other.data, t));
  }
}
```

Note: in this step `CarbonThemeData.lerp` still has the v1 signature
(`lerp(ThemeExtension<CarbonThemeData>? other, double t)`); the delegation call
compiles under both signatures since `CarbonThemeData` satisfies both. Adjust
if the analyzer complains, and re-check after step 04 changes the signature.

### `lib/src/material/carbon_material_theme.dart`

Verbatim move of `carbonTheme()` + `CarbonInputDecorationHelper` from
`lib/src/theme/carbon_theme.dart` (everything below the
`CarbonThemeContext` extension, i.e. current lines ~29–1131). Do the move with
shell (copy file, delete the extension block from the copy, delete the
`carbonTheme` block from the original **in step 04**, not now).

Edits to the copy:

1. Imports: keep `material.dart` and `cupertino.dart` (for
   `CupertinoPageTransitionsBuilder`); `'carbon_theme_data.dart'` →
   `'../theme/carbon_theme_data.dart'`; `'../foundation/layout.dart'` is the
   same depth from `src/material/` — unchanged. Add
   `'../theme/carbon_theme.dart'` if `CarbonInputDecorationHelper` uses
   `context.carbon` (it does).
2. `extensions: [carbon]` → `extensions: [CarbonMaterialThemeExtension(carbon)]`
   (+ import `carbon_theme_extension.dart`).

### `lib/material.dart`

```dart
/// Material interop for flutter_carbon.
///
/// Import this library when embedding Carbon widgets in a MaterialApp:
/// ```dart
/// import 'package:flutter_carbon/material.dart';
/// ```
library;

export 'src/material/carbon_material_theme.dart';
export 'src/material/carbon_theme_extension.dart';
// export 'flutter_carbon.dart';            // added in step 04
// export 'src/material/carbon_material_bridge.dart'; // added in step 04
```

**Do not** add `export 'flutter_carbon.dart';` yet — the core still exports the
old `carbonTheme` from `carbon_theme.dart`, and co-exporting both would be an
ambiguous-export error.

## Verification

- `flutter analyze` — zero issues (two `carbonTheme` top-level functions in
  different libraries is fine as long as no library exports both).
- `flutter test` — unchanged.
