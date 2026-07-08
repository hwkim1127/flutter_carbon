import 'package:flutter/widgets.dart';

import '../foundation/typography.dart';
import '../theme/carbon_theme.dart';

/// Internal overlay root replacing `Material(color: transparent)` wrappers.
///
/// Overlay entries have no [DefaultTextStyle] ancestor, so without a wrapper
/// any [Text] falls back to the framework's debug error style. This installs
/// Carbon's body style (the role Material was playing) with no Material
/// dependency.
///
/// Not exported — this is a building block for Carbon widgets, not public API.
class CarbonOverlaySurface extends StatelessWidget {
  const CarbonOverlaySurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: CarbonTypography.bodyCompact01.copyWith(
        color: context.carbon.text.textPrimary,
      ),
      child: child,
    );
  }
}
