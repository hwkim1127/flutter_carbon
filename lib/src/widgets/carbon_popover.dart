import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Popover alignment options.
enum CarbonPopoverAlignment {
  top,
  topStart,
  topEnd,
  bottom,
  bottomStart,
  bottomEnd,
  left,
  leftStart,
  leftEnd,
  right,
  rightStart,
  rightEnd,
}

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
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.initiallyOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPopover();
      });
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
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
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hidePopover,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Transparent overlay to capture outside taps
            Positioned.fill(child: Container(color: Colors.transparent)),
            // Popover content
            Positioned(
              width: widget.maxWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: _getOffset(),
                child: GestureDetector(
                  onTap:
                      () {}, // Prevent tap from propagating to outer GestureDetector
                  child: _PopoverContent(
                    content: widget.content,
                    alignment: widget.alignment,
                    caret: widget.caret,
                    dropShadow: widget.dropShadow,
                    border: widget.border,
                    highContrast: widget.highContrast,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Offset _getOffset() {
    const caretSize = 8.0;
    const spacing = 4.0;

    switch (widget.alignment) {
      case CarbonPopoverAlignment.top:
      case CarbonPopoverAlignment.topStart:
      case CarbonPopoverAlignment.topEnd:
        return Offset(
          _getHorizontalOffset(),
          -(widget.caret ? caretSize + spacing : spacing),
        );

      case CarbonPopoverAlignment.bottom:
      case CarbonPopoverAlignment.bottomStart:
      case CarbonPopoverAlignment.bottomEnd:
        return Offset(
          _getHorizontalOffset(),
          widget.caret ? caretSize + spacing : spacing,
        );

      case CarbonPopoverAlignment.left:
      case CarbonPopoverAlignment.leftStart:
      case CarbonPopoverAlignment.leftEnd:
        return Offset(
          -(widget.maxWidth ?? 368) -
              (widget.caret ? caretSize + spacing : spacing),
          _getVerticalOffset(),
        );

      case CarbonPopoverAlignment.right:
      case CarbonPopoverAlignment.rightStart:
      case CarbonPopoverAlignment.rightEnd:
        return Offset(
          widget.caret ? caretSize + spacing : spacing,
          _getVerticalOffset(),
        );
    }
  }

  double _getHorizontalOffset() {
    switch (widget.alignment) {
      case CarbonPopoverAlignment.topStart:
      case CarbonPopoverAlignment.bottomStart:
        return 0;
      case CarbonPopoverAlignment.topEnd:
      case CarbonPopoverAlignment.bottomEnd:
        return -(widget.maxWidth ?? 368);
      default:
        return -(widget.maxWidth ?? 368) / 2;
    }
  }

  double _getVerticalOffset() {
    switch (widget.alignment) {
      case CarbonPopoverAlignment.leftStart:
      case CarbonPopoverAlignment.rightStart:
        return 0;
      case CarbonPopoverAlignment.leftEnd:
      case CarbonPopoverAlignment.rightEnd:
        return -100; // Approximate offset for end alignment
      default:
        return -50; // Approximate offset for center alignment
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(onTap: _togglePopover, child: widget.child),
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
          child: Material(
            color: Colors.transparent,
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
