import 'package:flutter/widgets.dart';

import '../theme/carbon_theme.dart';

/// Material-free selection handles for Carbon text fields.
///
/// The [TextSelectionHandleControls] mixin is REQUIRED: `EditableText` only
/// honors `contextMenuBuilder` when its `selectionControls` mixes it in —
/// without it the framework silently falls back to the deprecated
/// `buildToolbar` path and no context menu appears.
class CarbonTextSelectionControls extends TextSelectionControls
    with TextSelectionHandleControls {
  CarbonTextSelectionControls({required this.fallbackHandleColor});

  /// Used when neither [DefaultSelectionStyle] nor [CarbonTheme] resolves
  /// from the overlay context (not expected under CarbonApp or the bridge).
  final Color fallbackHandleColor;

  /// Hit-target box (Material parity for comfortable dragging).
  static const double _handleBoxSize = 22.0;

  /// Painted square inside the box.
  static const double _handleVisualSize = 12.0;

  @override
  Size getHandleSize(double textLineHeight) =>
      const Size(_handleBoxSize, _handleBoxSize);

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    switch (type) {
      // The anchor is the point in the handle box that aligns with the
      // selection endpoint. The visual is symmetric, so top-center for all
      // types; the collapsed handle is nudged up 4px to visually join the
      // caret (same fudge Material uses).
      case TextSelectionHandleType.collapsed:
        return const Offset(_handleBoxSize / 2, -4);
      case TextSelectionHandleType.left:
      case TextSelectionHandleType.right:
        return const Offset(_handleBoxSize / 2, 0);
    }
  }

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
  ]) {
    // Handles live in the root overlay; both CarbonApp and the Material
    // bridge install DefaultSelectionStyle + CarbonTheme above the Navigator.
    final color =
        DefaultSelectionStyle.of(context).cursorColor ??
        CarbonTheme.maybeOf(context)?.button.buttonPrimary ??
        fallbackHandleColor;

    return SizedBox(
      width: _handleBoxSize,
      height: _handleBoxSize,
      child: CustomPaint(
        painter: _CarbonHandlePainter(color: color),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.translucent,
        ),
      ),
    );
  }
}

/// Paints the handle: a filled sharp-cornered square, top-centered in the
/// hit box. One symmetric shape for all handle types — unmistakably Carbon
/// (square, not a Material teardrop) and RTL-proof.
class _CarbonHandlePainter extends CustomPainter {
  const _CarbonHandlePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const visual = CarbonTextSelectionControls._handleVisualSize;
    final rect = Rect.fromLTWH((size.width - visual) / 2, 0, visual, visual);
    canvas.drawRect(rect, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_CarbonHandlePainter oldDelegate) =>
      color != oldDelegate.color;
}
