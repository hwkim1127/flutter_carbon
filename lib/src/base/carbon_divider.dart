import 'package:flutter/widgets.dart';

import '../theme/carbon_theme.dart';

/// Internal 1px rule replacing Material's [Divider].
///
/// Defaults match the Carbon divider spec (and the values `carbonTheme()`
/// previously fed Material's `DividerThemeData`): 1px thick,
/// `borderSubtle01` color, no extra whitespace.
///
/// Not exported — this is a building block for Carbon widgets, not public API.
class CarbonDivider extends StatelessWidget {
  const CarbonDivider({
    super.key,
    this.color,
    this.thickness = 1,
    this.vertical = false,
  });

  /// Line color. Defaults to `carbon.layer.borderSubtle01`.
  final Color? color;

  /// Line thickness in logical pixels.
  final double thickness;

  /// When true renders a vertical rule (full height, [thickness] wide).
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? context.carbon.layer.borderSubtle01;
    if (vertical) {
      // Fills the available height (requires bounded height, matching
      // Material's VerticalDivider behavior).
      return SizedBox(
        width: thickness,
        child: ColoredBox(color: resolved, child: const SizedBox.expand()),
      );
    }
    return SizedBox(
      height: thickness,
      child: ColoredBox(color: resolved, child: const SizedBox.expand()),
    );
  }
}
