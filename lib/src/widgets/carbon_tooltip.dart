import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show KeyDownEvent, LogicalKeyboardKey;

import '../base/carbon_anchored_overlay.dart';
import '../theme/carbon_theme.dart';

/// A Carbon Design System tooltip.
///
/// Shows a short text message anchored to [child] on hover (after
/// [enterDelay]) or keyboard focus, drawn to the Carbon spec: high-contrast
/// surface (`$background-inverse` / `$text-inverse`), max width 288, caret
/// pointing at the trigger. The tooltip itself is never interactive — it
/// ignores pointers entirely.
///
/// Example:
/// ```dart
/// CarbonTooltip(
///   message: 'Previous page',
///   child: CarbonPressable(...),
/// )
/// ```
class CarbonTooltip extends StatefulWidget {
  /// The trigger the tooltip is anchored to.
  final Widget child;

  /// The text shown in the tooltip.
  final String message;

  /// Preferred placement relative to [child] (auto-flips at screen edges).
  final CarbonPopoverAlignment alignment;

  /// Hover delay before showing (Carbon default: 100ms).
  final Duration enterDelay;

  /// Delay before hiding after the pointer leaves (Carbon default: 300ms).
  final Duration leaveDelay;

  const CarbonTooltip({
    super.key,
    required this.child,
    required this.message,
    this.alignment = CarbonPopoverAlignment.top,
    this.enterDelay = const Duration(milliseconds: 100),
    this.leaveDelay = const Duration(milliseconds: 300),
  });

  @override
  State<CarbonTooltip> createState() => _CarbonTooltipState();
}

class _CarbonTooltipState extends State<CarbonTooltip> {
  OverlayEntry? _overlayEntry;
  Timer? _enterTimer;
  Timer? _leaveTimer;

  @override
  void didUpdateWidget(CarbonTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The overlay entry doesn't rebuild with this widget — repaint it when
    // the message/alignment change while visible. Deferred: didUpdateWidget
    // runs during build and the entry is not a descendant.
    if (_overlayEntry != null &&
        (oldWidget.message != widget.message ||
            oldWidget.alignment != widget.alignment)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
  }

  @override
  void dispose() {
    _enterTimer?.cancel();
    _leaveTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _scheduleShow() {
    _leaveTimer?.cancel();
    _leaveTimer = null;
    if (_overlayEntry != null || _enterTimer != null) return;
    _enterTimer = Timer(widget.enterDelay, () {
      _enterTimer = null;
      if (mounted) _show();
    });
  }

  void _scheduleHide() {
    _enterTimer?.cancel();
    _enterTimer = null;
    if (_overlayEntry == null || _leaveTimer != null) return;
    _leaveTimer = Timer(widget.leaveDelay, () {
      _leaveTimer = null;
      if (mounted) _hide();
    });
  }

  void _show() {
    if (_overlayEntry != null) return;

    final anchorRect = CarbonAnchoredOverlay.anchorRectGetterFor(context);
    _overlayEntry = OverlayEntry(
      // The tooltip must never intercept input — no barrier dismissal, no
      // content taps. Visibility is driven by hover/focus on the trigger.
      builder: (context) => IgnorePointer(
        child: CarbonAnchoredOverlay(
          anchorRect: anchorRect,
          alignment: widget.alignment,
          onDismiss: _hide,
          contentBuilder: (context, effectiveAlignment) => _TooltipContent(
            message: widget.message,
            alignment: effectiveAlignment,
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hide() {
    _enterTimer?.cancel();
    _enterTimer = null;
    _leaveTimer?.cancel();
    _leaveTimer = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      tooltip: widget.message,
      child: MouseRegion(
        onEnter: (_) => _scheduleShow(),
        onExit: (_) => _scheduleHide(),
        child: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onFocusChange: (focused) {
            // Show immediately on keyboard focus of the child, hide on blur.
            if (focused) {
              _leaveTimer?.cancel();
              _leaveTimer = null;
              _show();
            } else {
              _scheduleHide();
            }
          },
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.escape &&
                _overlayEntry != null) {
              _hide();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: widget.child,
        ),
      ),
    );
  }
}

class _TooltipContent extends StatelessWidget {
  final String message;
  final CarbonPopoverAlignment alignment;

  const _TooltipContent({required this.message, required this.alignment});

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
