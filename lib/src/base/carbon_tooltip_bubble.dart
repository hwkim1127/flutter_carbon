import 'package:flutter/widgets.dart';

import '../theme/carbon_theme.dart';
import 'carbon_anchored_overlay.dart';

/// The Carbon tooltip bubble: high-contrast surface
/// (`$background-inverse` / `$text-inverse`), max width 288, and a caret on
/// the side facing the trigger. Shared by [CarbonTooltip] and the
/// click-triggered copy feedback so there is exactly one bubble
/// implementation.
///
/// Not exported — this is a building block for Carbon widgets, not public API.
class CarbonTooltipBubble extends StatelessWidget {
  final String message;

  /// The post-flip alignment of the enclosing anchored overlay — orients the
  /// caret toward the trigger.
  final CarbonPopoverAlignment alignment;

  const CarbonTooltipBubble({
    super.key,
    required this.message,
    required this.alignment,
  });

  bool get _isTopAligned =>
      alignment == CarbonPopoverAlignment.top ||
      alignment == CarbonPopoverAlignment.topStart ||
      alignment == CarbonPopoverAlignment.topEnd;

  bool get _isBottomAligned =>
      alignment == CarbonPopoverAlignment.bottom ||
      alignment == CarbonPopoverAlignment.bottomStart ||
      alignment == CarbonPopoverAlignment.bottomEnd;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final background = carbon.layer.backgroundInverse;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isBottomAligned) _buildCaret(background, pointsUp: true),
        Container(
          constraints: const BoxConstraints(maxWidth: 288, minHeight: 24),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Text(
              message,
              style: TextStyle(
                color: carbon.text.textInverse,
                fontSize: 14,
                height: 1.43,
                letterSpacing: 0.16,
              ),
            ),
          ),
        ),
        if (_isTopAligned) _buildCaret(background, pointsUp: false),
      ],
    );
  }

  Widget _buildCaret(Color color, {required bool pointsUp}) {
    return CustomPaint(
      size: const Size(16, 8),
      painter: _TooltipCaretPainter(color: color, pointsUp: pointsUp),
    );
  }
}

class _TooltipCaretPainter extends CustomPainter {
  final Color color;
  final bool pointsUp;

  const _TooltipCaretPainter({required this.color, required this.pointsUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    if (pointsUp) {
      path
        ..moveTo(size.width / 2, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height);
    } else {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TooltipCaretPainter oldDelegate) =>
      color != oldDelegate.color || pointsUp != oldDelegate.pointsUp;
}
