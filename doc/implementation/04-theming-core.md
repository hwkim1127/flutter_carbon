# 04 — Theming Core (the atomic breaking change)

## Goal

Replace the `ThemeExtension` mechanism with `CarbonTheme`. Everything in this
step lands as **one commit**: the core rewrite, the bridge widget, and the
test/example migration. Analyze/tests must be green before committing.

## 1. `lib/src/theme/carbon_theme_data.dart`

- `import 'package:flutter/material.dart';` → `import 'package:flutter/widgets.dart';`
- `class CarbonThemeData extends ThemeExtension<CarbonThemeData>` →
  `class CarbonThemeData` (keep `@immutable`).
- Remove `@override` from `copyWith` and `lerp`.
- `lerp` signature: `CarbonThemeData lerp(CarbonThemeData? other, double t)`;
  body starts `if (other == null) return this;` (drop the `is!` check).

## 2. `lib/src/theme/carbon_theme.dart` — rewritten in place

Path unchanged → the 34 widget files importing it and the
`export 'src/theme/carbon_theme.dart';` line in `flutter_carbon.dart` stay
untouched. New contents (full sketch):

```dart
import 'package:flutter/widgets.dart';

import '../foundation/typography.dart';
import 'carbon_theme_data.dart';

/// Applies a Carbon theme to descendant widgets (CupertinoTheme-style).
///
/// Provide a stable [CarbonThemeData] instance (the built-in themes are
/// const statics); constructing a new instance every build defeats
/// change-detection and rebuilds all dependents.
class CarbonTheme extends StatelessWidget {
  const CarbonTheme({super.key, required this.data, required this.child});

  final CarbonThemeData data;
  final Widget child;

  static CarbonThemeData of(BuildContext context) {
    final data = maybeOf(context);
    if (data == null) {
      throw FlutterError.fromParts([
        ErrorSummary('CarbonTheme.of() called with no CarbonTheme ancestor.'),
        ErrorHint(
          'Wrap your app in CarbonApp, or — in a Material app — install the '
          'bridge in MaterialApp.builder:\n'
          '  MaterialApp(\n'
          "    theme: carbonTheme(carbon: WhiteTheme.theme),\n"
          '    builder: (context, child) => CarbonMaterialBridge(child: child!),\n'
          '  )\n'
          'See package:flutter_carbon/material.dart.',
        ),
      ]);
    }
    return data;
  }

  static CarbonThemeData? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedCarbonTheme>()
      ?.theme
      .data;

  @override
  Widget build(BuildContext context) {
    return _InheritedCarbonTheme(
      theme: this,
      child: DefaultTextStyle(
        style: CarbonTypography.bodyCompact01.copyWith(
          color: data.text.textPrimary,
        ),
        child: IconTheme(
          data: IconThemeData(color: data.text.textPrimary, size: 20),
          child: child,
        ),
      ),
    );
  }
}

class _InheritedCarbonTheme extends InheritedWidget {
  const _InheritedCarbonTheme({required this.theme, required super.child});

  final CarbonTheme theme;

  @override
  bool updateShouldNotify(_InheritedCarbonTheme old) =>
      theme.data != old.theme.data;
}

/// Animated variant of [CarbonTheme] for smooth runtime theme switches.
class AnimatedCarbonTheme extends ImplicitlyAnimatedWidget {
  const AnimatedCarbonTheme({
    super.key,
    required this.data,
    super.curve,
    super.duration = const Duration(milliseconds: 150),
    required this.child,
  });

  final CarbonThemeData data;
  final Widget child;

  @override
  AnimatedWidgetBaseState<AnimatedCarbonTheme> createState() =>
      _AnimatedCarbonThemeState();
}

class _AnimatedCarbonThemeState
    extends AnimatedWidgetBaseState<AnimatedCarbonTheme> {
  CarbonThemeDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(_data, widget.data,
            (v) => CarbonThemeDataTween(begin: v as CarbonThemeData))!
        as CarbonThemeDataTween;
  }

  @override
  Widget build(BuildContext context) =>
      CarbonTheme(data: _data!.evaluate(animation), child: widget.child);
}

/// Tween for [CarbonThemeData], using its [CarbonThemeData.lerp].
class CarbonThemeDataTween extends Tween<CarbonThemeData> {
  CarbonThemeDataTween({super.begin, super.end});

  @override
  CarbonThemeData lerp(double t) => begin!.lerp(end, t);
}

/// Extensions to access [CarbonThemeData] from the [BuildContext].
extension CarbonThemeContext on BuildContext {
  /// The [CarbonThemeData] from the nearest [CarbonTheme]. Throws if absent.
  CarbonThemeData get carbon => CarbonTheme.of(this);

  /// Nullable variant of [carbon]. Prefer [carbon] unless a fallback is needed.
  CarbonThemeData? get carbonOrNull => CarbonTheme.maybeOf(this);
}
```

The old `carbonTheme()` + `CarbonInputDecorationHelper` bodies are **deleted**
here (already copied to `lib/src/material/carbon_material_theme.dart` in
step 03).

## 3. `lib/src/material/carbon_material_bridge.dart` (new)

```dart
import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';
import 'carbon_theme_extension.dart';

/// Installs a [CarbonTheme] beneath a [MaterialApp], resolving the theme data
/// from [CarbonMaterialThemeExtension] (put there by `carbonTheme()`).
///
/// Use in [MaterialApp.builder] so the Navigator and all overlays are covered:
/// ```dart
/// MaterialApp(
///   theme: carbonTheme(carbon: WhiteTheme.theme),
///   builder: (context, child) => CarbonMaterialBridge(child: child!),
/// )
/// ```
class CarbonMaterialBridge extends StatelessWidget {
  const CarbonMaterialBridge({super.key, this.data, required this.child});

  /// Explicit theme data; when null, resolves from the ambient Material
  /// [Theme]'s [CarbonMaterialThemeExtension].
  final CarbonThemeData? data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final resolved = data ??
        Theme.of(context).extension<CarbonMaterialThemeExtension>()?.data;
    if (resolved == null) {
      throw FlutterError(
        'CarbonMaterialBridge could not resolve a CarbonThemeData.\n'
        'Either pass `data:` explicitly or build your ThemeData with '
        'carbonTheme(carbon: ...) so the extension is installed.',
      );
    }
    return CarbonTheme(data: resolved, child: child);
  }
}
```

`Theme.of` registers a dependency → MaterialApp theme switches rebuild the
bridge and `CarbonTheme` notifies dependents, matching v1 behavior.

## 4. `lib/material.dart`

Uncomment/add:

```dart
export 'flutter_carbon.dart';
export 'src/material/carbon_material_bridge.dart';
```

## 5. Test migration

- `test/shared/build.dart`:

  ```dart
  import 'package:flutter/material.dart';
  import 'package:flutter_carbon/material.dart';

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
  ```

- ~13 test files with inline `MaterialApp(theme: carbonTheme(...))` (theme
  tests + chat_button, combo_button, contained_list, file_uploader,
  floating_menu, multi_select, structured_list, tile, toggle_tip, tree_view,
  ui_shell): switch to `buildTestApp(theme: ...)` where possible, else add the
  `builder:` bridge line. All need
  `import 'package:flutter_carbon/material.dart';` (replacing the
  flutter_carbon.dart import — material.dart re-exports it).
- `test/theme/carbon_theme_test.dart`: assertions on
  `ThemeData.extension<CarbonThemeData>()` change to
  `extension<CarbonMaterialThemeExtension>()!.data`.

## 6. Example migration

- `example/lib/main.dart`: `import 'package:flutter_carbon/material.dart';`
  (replaces flutter_carbon.dart import) + `builder:` bridge line in
  `MaterialApp`.
- Files using `CarbonInputDecorationHelper` or `carbonTheme`:
  `example/lib/pages/text_input_demo_page.dart`,
  `chat_button_demo_page.dart`, `code_snippet_demo_page.dart`,
  `example/lib/widgets/material_widgets_section.dart` — switch their import to
  `package:flutter_carbon/material.dart`.

## Verification

- `flutter analyze` (root + example) — zero issues.
- `flutter test` — full suite green.
- Manual: run example, switch all 4 themes, open dropdown/popover/modal.
- Commit as a single commit ("v2: CarbonTheme core + material bridge").
