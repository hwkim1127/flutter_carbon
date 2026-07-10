import 'package:flutter/gestures.dart' show kPrimaryButton, kTouchSlop;
import 'package:flutter/services.dart' show KeyDownEvent, LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../base/carbon_anchored_overlay.dart';
import '../base/carbon_overlay_surface.dart';
import '../theme/carbon_theme.dart';

export '../base/carbon_anchored_overlay.dart' show CarbonPopoverAlignment;

/// Carbon Design System Popover.
///
/// An interactive floating panel that displays additional content
/// relative to a trigger element.
///
/// Example:
/// ```dart
/// CarbonPopover(
///   content: Text('Popover content'),
///   child: ElevatedButton(
///     onPressed: () {},
///     child: Text('Show Popover'),
///   ),
/// )
/// ```
class CarbonPopover extends StatefulWidget {
  /// The trigger widget that shows the popover.
  final Widget child;

  /// The content to display in the popover.
  final Widget content;

  /// The alignment of the popover relative to the trigger.
  final CarbonPopoverAlignment alignment;

  /// Whether to show a caret (arrow pointer).
  final bool caret;

  /// Whether to show a drop shadow.
  final bool dropShadow;

  /// Whether to show a border.
  final bool border;

  /// Whether to use high contrast mode.
  final bool highContrast;

  /// Callback when the popover is opened.
  final VoidCallback? onOpen;

  /// Callback when the popover is closed.
  final VoidCallback? onClose;

  /// Maximum width of the popover content.
  final double? maxWidth;

  /// Whether the popover is initially open.
  final bool initiallyOpen;

  const CarbonPopover({
    super.key,
    required this.child,
    required this.content,
    this.alignment = CarbonPopoverAlignment.bottom,
    this.caret = true,
    this.dropShadow = true,
    this.border = false,
    this.highContrast = false,
    this.onOpen,
    this.onClose,
    this.maxWidth = 368,
    this.initiallyOpen = false,
  });

  @override
  State<CarbonPopover> createState() => _CarbonPopoverState();
}

class _CarbonPopoverState extends State<CarbonPopover> {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  /// Carries the Escape-to-close handler for the trigger side.
  final FocusNode _escapeNode = FocusNode(
    debugLabel: 'CarbonPopover',
    skipTraversal: true,
  );

  KeyEventResult _handleEscape(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape &&
        _isOpen) {
      _hidePopover();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initiallyOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Guard: the widget can be disposed within its first frame.
        if (mounted) _showPopover();
      });
    }
  }

  @override
  void dispose() {
    // Remove directly — _hidePopover() calls setState, which is not allowed
    // during dispose. Still deliver onClose so paired onOpen/onClose
    // consumers stay balanced.
    if (_isOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      widget.onClose?.call();
    }
    _escapeNode.dispose();
    super.dispose();
  }

  void _togglePopover() {
    if (_isOpen) {
      _hidePopover();
    } else {
      _showPopover();
    }
  }

  void _showPopover() {
    if (_isOpen) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    // Make Escape work for mouse users: focus the wrapper unless something
    // inside the trigger (e.g. a focused button) already holds focus —
    // `hasFocus` covers descendants.
    if (!_escapeNode.hasFocus) {
      _escapeNode.requestFocus();
    }
    setState(() => _isOpen = true);
    widget.onOpen?.call();
  }

  void _hidePopover() {
    if (!_isOpen) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
    widget.onClose?.call();
  }

  OverlayEntry _createOverlayEntry() {
    final anchorRect = CarbonAnchoredOverlay.anchorRectGetterFor(context);

    return OverlayEntry(
      builder: (context) => CarbonAnchoredOverlay(
        anchorRect: anchorRect,
        alignment: widget.alignment,
        maxWidth: widget.maxWidth ?? 368,
        onDismiss: _hidePopover,
        // Escape also closes when focus moved INTO the popover's
        // interactive content.
        contentBuilder: (context, effectiveAlignment) => Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onKeyEvent: _handleEscape,
          child: _PopoverContent(
            content: widget.content,
            alignment: effectiveAlignment,
            caret: widget.caret,
            dropShadow: widget.dropShadow,
            border: widget.border,
            highContrast: widget.highContrast,
          ),
        ),
      ),
    );
  }

  Offset? _pointerDownPosition;
  int? _pointerDownId;

  @override
  Widget build(BuildContext context) {
    // Raw pointer events instead of a tap gesture: interactive children
    // (buttons) win the gesture arena and would swallow a competing tap
    // recognizer entirely. A primary-button down/up pair within touch slop
    // counts as a tap on the trigger — drags (scrolls) move past slop and
    // are ignored, and no recognizer state is involved.
    return Focus(
      focusNode: _escapeNode,
      onKeyEvent: _handleEscape,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          if (event.buttons & kPrimaryButton == 0) return;
          _pointerDownId = event.pointer;
          _pointerDownPosition = event.position;
        },
        onPointerUp: (event) {
          if (event.pointer != _pointerDownId) return;
          final down = _pointerDownPosition;
          _pointerDownId = null;
          _pointerDownPosition = null;
          if (down != null && (event.position - down).distance <= kTouchSlop) {
            _togglePopover();
          }
        },
        onPointerCancel: (event) {
          if (event.pointer != _pointerDownId) return;
          _pointerDownId = null;
          _pointerDownPosition = null;
        },
        child: widget.child,
      ),
    );
  }
}

/// Internal popover content widget.
class _PopoverContent extends StatelessWidget {
  final Widget content;
  final CarbonPopoverAlignment alignment;
  final bool caret;
  final bool dropShadow;
  final bool border;
  final bool highContrast;

  const _PopoverContent({
    required this.content,
    required this.alignment,
    required this.caret,
    required this.dropShadow,
    required this.border,
    required this.highContrast,
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
    final backgroundColor = highContrast
        ? carbon.popover.backgroundHighContrast
        : carbon.popover.background;
    final borderColor = highContrast
        ? carbon.popover.borderHighContrast
        : carbon.popover.border;
    final caretColor = highContrast
        ? carbon.popover.caretBackgroundHighContrast
        : carbon.popover.caretBackground;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (caret && _isBottomAligned) _buildCaret(caretColor, isTop: true),
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: border ? Border.all(color: borderColor, width: 1) : null,
            borderRadius: BorderRadius.circular(2),
            boxShadow: dropShadow
                ? [
                    BoxShadow(
                      color: highContrast
                          ? carbon.popover.dropShadowHighContrast.withValues(
                              alpha: 0.3,
                            )
                          : carbon.popover.dropShadow.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: CarbonOverlaySurface(
            child: Padding(padding: const EdgeInsets.all(16), child: content),
          ),
        ),
        if (caret && _isTopAligned) _buildCaret(caretColor, isTop: false),
      ],
    );
  }

  Widget _buildCaret(Color color, {required bool isTop}) {
    return CustomPaint(
      size: const Size(16, 8),
      painter: _CaretPainter(color: color, pointsUp: isTop),
    );
  }
}

/// Custom painter for the popover caret (arrow).
class _CaretPainter extends CustomPainter {
  final Color color;
  final bool pointsUp;

  const _CaretPainter({required this.color, required this.pointsUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (pointsUp) {
      // Triangle pointing up
      path.moveTo(size.width / 2, 0); // Top center
      path.lineTo(0, size.height); // Bottom left
      path.lineTo(size.width, size.height); // Bottom right
    } else {
      // Triangle pointing down
      path.moveTo(0, 0); // Top left
      path.lineTo(size.width, 0); // Top right
      path.lineTo(size.width / 2, size.height); // Bottom center
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CaretPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.pointsUp != pointsUp;
  }
}
