# 05 — CarbonApp + CarbonPageRoute

## Goal

A pure-Carbon application shell on `WidgetsApp`: Navigator, Overlay,
localizations, default text style — no MaterialApp required. Additive step.

## New files

### `lib/src/app/carbon_page_route.dart`

```dart
import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';

/// Page route with Carbon's productive motion: fade + slight upward slide.
class CarbonPageRoute<T> extends PageRoute<T> {
  CarbonPageRoute({required this.builder, super.settings});

  final WidgetBuilder builder;

  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;
  @override
  bool get opaque => true;
  @override
  Duration get transitionDuration => CarbonMotion.durationModerate02; // 240ms
  @override
  Duration get reverseTransitionDuration => CarbonMotion.durationModerate01;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      builder(context);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Carbon "productive" entrance/exit easings.
    final curved = CurvedAnimation(
      parent: animation,
      curve: const Cubic(0, 0, 0.38, 0.9),      // entrance-productive
      reverseCurve: const Cubic(0.2, 0, 1, 0.9), // exit-productive
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
```

(If `CarbonMotion` already defines the easing cubics, reuse those constants
instead of inline `Cubic`s — check `lib/src/foundation/motion.dart` first and
add them there if missing: entrance `cubic-bezier(0, 0, 0.38, 0.9)`, exit
`cubic-bezier(0.2, 0, 1, 0.9)`, standard `cubic-bezier(0.2, 0, 0.38, 0.9)`
per `carbon/packages/motion/src/index.ts`.)

### `lib/src/app/carbon_app.dart`

`CarbonApp` — StatelessWidget with `required CarbonThemeData theme` plus
WidgetsApp passthroughs: `navigatorKey, home, routes = const {}, initialRoute,
onGenerateRoute, onGenerateInitialRoutes, onUnknownRoute,
navigatorObservers = const [], builder, title = '', onGenerateTitle, color,
locale, localizationsDelegates, localeListResolutionCallback,
localeResolutionCallback, supportedLocales = const [Locale('en', 'US')],
showPerformanceOverlay = false, debugShowCheckedModeBanner = true, shortcuts,
actions, restorationScopeId`.

Build:

```dart
return WidgetsApp(
  key: key == null ? null : GlobalObjectKey(this),
  navigatorKey: navigatorKey,
  home: home, routes: routes, initialRoute: initialRoute,
  onGenerateRoute: onGenerateRoute, /* ...passthroughs... */
  color: color ?? theme.button.buttonPrimary,
  textStyle: CarbonTypography.bodyCompact01
      .copyWith(color: theme.text.textPrimary),
  pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
      CarbonPageRoute<T>(settings: settings, builder: builder),
  builder: (context, child) => AnimatedCarbonTheme(
    data: theme,
    duration: CarbonMotion.durationModerate01,
    child: DefaultSelectionStyle(
      cursorColor: theme.button.buttonPrimary,
      selectionColor: theme.button.buttonPrimary.withValues(alpha: 0.3),
      child: builder != null ? builder!(context, child) : (child ?? const SizedBox.shrink()),
    ),
  ),
);
```

Dartdoc must carry the **limitation table**: these widgets require a Material
host (MaterialApp + CarbonMaterialBridge) until native primitives land —
`CarbonComboBox`, `CarbonNumberInput`, `CarbonToolbar` (search),
`CarbonMultiSelect`, `CarbonModal`, `CarbonDataTable` (selectable rows),
`CarbonLoading`, `CarbonFileUploader`, `CarbonPagination`, `CarbonComboButton`,
`CarbonFloatingMenu`, `CarbonUIShell`, `CarbonCodeSnippet`.

## Exports

`lib/flutter_carbon.dart` adds:

```dart
export 'src/app/carbon_app.dart';
export 'src/app/carbon_page_route.dart';
```

## New tests

- `test/theme/carbon_theme_widget_test.dart` — `of`/`maybeOf`, throw message
  mentions CarbonApp + bridge; dependents rebuild on data change, not on
  re-set of identical instance; DefaultTextStyle/IconTheme installed;
  `AnimatedCarbonTheme` interpolates between two themes.
- `test/app/carbon_app_test.dart` — `CarbonApp(theme: ..., home: ...)`:
  `context.carbon` resolves; `Navigator.push(CarbonPageRoute(...))` and named
  routes work; an overlay widget (`CarbonDropdown` or `CarbonPopover`) opens
  without Material.
- `test/material/carbon_material_bridge_test.dart` — resolves from
  `carbonTheme()`; switching `MaterialApp.theme` propagates new
  `context.carbon` (pumpAndSettle across the AnimatedTheme lerp); missing-theme
  error message.
- `test/theme/no_material_import_test.dart` — dart:io guard: no file under
  `lib/src/theme/`, `lib/src/foundation/`, `lib/src/base/`, `lib/src/app/`
  contains `flutter/material.dart` or `flutter/cupertino.dart`.

## Verification

- `flutter analyze` + `flutter test` green.
- Guard test passes.
