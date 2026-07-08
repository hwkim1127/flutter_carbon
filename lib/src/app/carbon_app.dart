import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';
import 'carbon_page_route.dart';

/// A pure-Carbon application shell — no `MaterialApp` required.
///
/// Builds on [WidgetsApp] (Navigator, Overlay, localizations, media query)
/// and installs an [AnimatedCarbonTheme] above the Navigator so
/// `context.carbon` works everywhere, including routes and overlay entries.
/// Page navigation uses [CarbonPageRoute] (fade + slight rise, Carbon
/// productive motion).
///
/// ```dart
/// CarbonApp(
///   theme: WhiteTheme.theme,
///   home: const HomePage(),
/// )
/// ```
///
/// ## Widgets that still require a Material host
///
/// Until their native Carbon primitives land, the following widgets depend on
/// Material internals (`TextField`, `Checkbox`, `Scaffold`, …) and will throw
/// inside a pure [CarbonApp]. Use `MaterialApp` + `CarbonMaterialBridge`
/// (from `package:flutter_carbon/material.dart`) when you need them:
///
/// `CarbonComboBox`, `CarbonNumberInput`, `CarbonToolbar` (search),
/// `CarbonMultiSelect`, `CarbonModal`, `CarbonDataTable` (selectable rows),
/// `CarbonLoading`, `CarbonFileUploader`, `CarbonPagination`,
/// `CarbonComboButton`, `CarbonFloatingMenu`, `CarbonUIShell`,
/// `CarbonCodeSnippet`.
class CarbonApp extends StatelessWidget {
  /// Creates a Carbon application shell.
  const CarbonApp({
    super.key,
    required this.theme,
    this.navigatorKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
  });

  /// The Carbon theme applied to the whole app.
  ///
  /// Theme changes animate via [AnimatedCarbonTheme].
  final CarbonThemeData theme;

  /// See [WidgetsApp.navigatorKey].
  final GlobalKey<NavigatorState>? navigatorKey;

  /// See [WidgetsApp.home].
  final Widget? home;

  /// See [WidgetsApp.routes].
  final Map<String, WidgetBuilder> routes;

  /// See [WidgetsApp.initialRoute].
  final String? initialRoute;

  /// See [WidgetsApp.onGenerateRoute].
  final RouteFactory? onGenerateRoute;

  /// See [WidgetsApp.onGenerateInitialRoutes].
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// See [WidgetsApp.onUnknownRoute].
  final RouteFactory? onUnknownRoute;

  /// See [WidgetsApp.navigatorObservers].
  final List<NavigatorObserver> navigatorObservers;

  /// See [WidgetsApp.builder].
  final TransitionBuilder? builder;

  /// See [WidgetsApp.title].
  final String title;

  /// See [WidgetsApp.onGenerateTitle].
  final GenerateAppTitle? onGenerateTitle;

  /// The primary color used by the OS task switcher.
  /// Defaults to the theme's primary button color.
  final Color? color;

  /// See [WidgetsApp.locale].
  final Locale? locale;

  /// See [WidgetsApp.localizationsDelegates].
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// See [WidgetsApp.localeListResolutionCallback].
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// See [WidgetsApp.localeResolutionCallback].
  final LocaleResolutionCallback? localeResolutionCallback;

  /// See [WidgetsApp.supportedLocales].
  final Iterable<Locale> supportedLocales;

  /// See [WidgetsApp.showPerformanceOverlay].
  final bool showPerformanceOverlay;

  /// See [WidgetsApp.debugShowCheckedModeBanner].
  final bool debugShowCheckedModeBanner;

  /// See [WidgetsApp.shortcuts].
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// See [WidgetsApp.actions].
  final Map<Type, Action<Intent>>? actions;

  /// See [WidgetsApp.restorationScopeId].
  final String? restorationScopeId;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      key: GlobalObjectKey(this),
      navigatorKey: navigatorKey,
      home: home,
      routes: routes,
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onUnknownRoute: onUnknownRoute,
      navigatorObservers: navigatorObservers,
      title: title,
      onGenerateTitle: onGenerateTitle,
      color: color ?? theme.button.buttonPrimary,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      showPerformanceOverlay: showPerformanceOverlay,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
      textStyle: CarbonTypography.bodyCompact01.copyWith(
        color: theme.text.textPrimary,
      ),
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
          CarbonPageRoute<T>(settings: settings, builder: builder),
      builder: (context, child) => AnimatedCarbonTheme(
        data: theme,
        duration: CarbonMotion.durationModerate01,
        curve: CarbonMotion.standardProductive,
        child: DefaultSelectionStyle(
          cursorColor: theme.button.buttonPrimary,
          selectionColor: theme.button.buttonPrimary.withValues(alpha: 0.3),
          child: builder != null
              ? builder!(context, child)
              : (child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
