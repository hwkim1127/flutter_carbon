import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';

/// A page route with Carbon's productive motion: a fade combined with a
/// slight upward slide on entrance.
///
/// Used by `CarbonApp` for `home`/`routes` navigation; can also be pushed
/// directly:
///
/// ```dart
/// Navigator.of(context).push(
///   CarbonPageRoute(builder: (context) => const DetailsPage()),
/// );
/// ```
class CarbonPageRoute<T> extends PageRoute<T> {
  /// Creates a Carbon page route.
  CarbonPageRoute({required this.builder, super.settings});

  /// Builds the page content.
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
  Duration get transitionDuration => CarbonMotion.durationModerate02;

  @override
  Duration get reverseTransitionDuration => CarbonMotion.durationModerate01;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: CarbonMotion.entranceProductive,
      reverseCurve: CarbonMotion.exitProductive,
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
