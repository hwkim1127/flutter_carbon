import 'package:flutter/widgets.dart';

import '../foundation/typography.dart';
import 'carbon_theme_data.dart';

/// Applies a Carbon theme to descendant widgets.
///
/// Mirrors `CupertinoTheme`: install one near the top of the tree and read it
/// anywhere below with [CarbonTheme.of] or the `context.carbon` extension.
/// `CarbonApp` installs one automatically; Material apps install one via
/// `CarbonMaterialBridge` (see `package:flutter_carbon/material.dart`).
///
/// Provide a stable [CarbonThemeData] instance — the built-in themes
/// (`WhiteTheme.theme`, `G10Theme.theme`, …) are const statics. Constructing a
/// new instance on every build defeats change detection and rebuilds all
/// dependents each frame.
class CarbonTheme extends StatelessWidget {
  /// Creates a Carbon theme scope.
  const CarbonTheme({super.key, required this.data, required this.child});

  /// The Carbon design tokens to expose to descendants.
  final CarbonThemeData data;

  /// The subtree the theme applies to.
  final Widget child;

  /// The [CarbonThemeData] of the nearest [CarbonTheme] ancestor.
  ///
  /// Throws a [FlutterError] when there is no [CarbonTheme] in scope.
  static CarbonThemeData of(BuildContext context) {
    final data = maybeOf(context);
    if (data == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('CarbonTheme.of() called with no CarbonTheme ancestor.'),
        ErrorHint(
          'Wrap your app in CarbonApp, or — in a Material app — install the '
          'bridge in MaterialApp.builder:\n'
          '  MaterialApp(\n'
          '    theme: carbonTheme(carbon: WhiteTheme.theme),\n'
          '    builder: (context, child) => '
          'CarbonMaterialBridge(child: child!),\n'
          '  )\n'
          'CarbonMaterialBridge and carbonTheme() live in '
          'package:flutter_carbon/material.dart.',
        ),
      ]);
    }
    return data;
  }

  /// The [CarbonThemeData] of the nearest [CarbonTheme] ancestor, or null.
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
  bool updateShouldNotify(_InheritedCarbonTheme oldWidget) =>
      theme.data != oldWidget.theme.data;
}

/// Animated variant of [CarbonTheme] for smooth runtime theme switches.
///
/// Interpolates between the old and new [CarbonThemeData] using
/// [CarbonThemeData.lerp] whenever [data] changes.
class AnimatedCarbonTheme extends ImplicitlyAnimatedWidget {
  /// Creates an animated Carbon theme scope.
  const AnimatedCarbonTheme({
    super.key,
    required this.data,
    super.curve,
    super.duration = const Duration(milliseconds: 150),
    required this.child,
  });

  /// The target Carbon design tokens.
  final CarbonThemeData data;

  /// The subtree the theme applies to.
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
    _data = visitor(
      _data,
      widget.data,
      (dynamic value) => CarbonThemeDataTween(begin: value as CarbonThemeData),
    )! as CarbonThemeDataTween;
  }

  @override
  Widget build(BuildContext context) =>
      CarbonTheme(data: _data!.evaluate(animation), child: widget.child);
}

/// An interpolation between two [CarbonThemeData]s.
class CarbonThemeDataTween extends Tween<CarbonThemeData> {
  /// Creates a [CarbonThemeData] tween.
  CarbonThemeDataTween({super.begin, super.end});

  @override
  CarbonThemeData lerp(double t) => begin!.lerp(end, t);
}

/// Extensions to access [CarbonThemeData] from the [BuildContext].
extension CarbonThemeContext on BuildContext {
  /// The [CarbonThemeData] from the nearest [CarbonTheme]. Throws if absent.
  CarbonThemeData get carbon => CarbonTheme.of(this);

  /// Nullable variant of [carbon]. Prefer [carbon] unless a fallback is
  /// needed.
  CarbonThemeData? get carbonOrNull => CarbonTheme.maybeOf(this);
}
