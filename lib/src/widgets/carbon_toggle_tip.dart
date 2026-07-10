import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../base/carbon_anchored_overlay.dart';
import '../foundation/colors.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';

/// Carbon Design System Toggle Tip.
///
/// An interactive tooltip that stays open when clicked.
/// Unlike regular tooltips, toggle tips can contain actions and
/// remain open until explicitly closed.
///
/// Example:
/// ```dart
/// CarbonToggleTip(
///   label: 'Feature Name',
///   content: Text('This is a helpful description'),
///   actions: [
///     TextButton(
///       onPressed: () {},
///       child: Text('Learn More'),
///     ),
///   ],
/// )
/// ```
class CarbonToggleTip extends StatefulWidget {
  /// Optional label text displayed before the toggle button.
  final String? label;

  /// The content to display in the toggle tip.
  final Widget content;

  /// Optional action buttons to display below the content.
  final List<Widget>? actions;

  /// The alignment of the toggle tip relative to the button.
  final CarbonPopoverAlignment alignment;

  /// Callback when the toggle tip is opened.
  final VoidCallback? onOpen;

  /// Callback when the toggle tip is closed.
  final VoidCallback? onClose;

  /// Custom trigger icon. Defaults to information icon.
  final Widget? triggerIcon;

  /// Accessible label for the button.
  final String buttonLabel;

  /// Whether the toggle tip is initially open.
  final bool defaultOpen;

  /// Maximum width of the toggle tip content.
  final double? maxWidth;

  const CarbonToggleTip({
    super.key,
    this.label,
    required this.content,
    this.actions,
    this.alignment = CarbonPopoverAlignment.top,
    this.onOpen,
    this.onClose,
    this.triggerIcon,
    this.buttonLabel = 'Show information',
    this.defaultOpen = false,
    this.maxWidth = 288,
  });

  @override
  State<CarbonToggleTip> createState() => _CarbonToggleTipState();
}

class _CarbonToggleTipState extends State<CarbonToggleTip> {
  bool _isOpen = false;
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final GlobalKey _triggerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.defaultOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _open();
      });
    }
  }

  @override
  void dispose() {
    // Remove the overlay directly — _close() calls setState, which is not
    // allowed during dispose. Still deliver onClose so paired
    // onOpen/onClose consumers stay balanced.
    if (_isOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      widget.onClose?.call();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    if (_isOpen) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    // The Escape handler lives on this node — a mouse click on the trigger
    // doesn't focus it, so take focus explicitly while the tip is open.
    _focusNode.requestFocus();
    setState(() => _isOpen = true);
    widget.onOpen?.call();
  }

  void _close() {
    if (!_isOpen) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
    widget.onClose?.call();
  }

  OverlayEntry _createOverlayEntry() {
    final anchorRect = CarbonAnchoredOverlay.anchorRectGetterFor(
      _triggerKey.currentContext!,
    );

    return OverlayEntry(
      builder: (context) => CarbonAnchoredOverlay(
        anchorRect: anchorRect,
        alignment: widget.alignment,
        maxWidth: widget.maxWidth ?? 288,
        onDismiss: _close,
        contentBuilder: (context, effectiveAlignment) => _ToggleTipContent(
          content: widget.content,
          actions: widget.actions,
          alignment: effectiveAlignment,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _close();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
            ),
            const SizedBox(width: 8),
          ],
          KeyedSubtree(
            key: _triggerKey,
            child: _ToggleTipButton(
              isOpen: _isOpen,
              onPressed: _toggle,
              icon: widget.triggerIcon,
              buttonLabel: widget.buttonLabel,
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal toggle tip button widget.
class _ToggleTipButton extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onPressed;
  final Widget? icon;
  final String buttonLabel;

  const _ToggleTipButton({
    required this.isOpen,
    required this.onPressed,
    this.icon,
    required this.buttonLabel,
  });

  @override
  State<_ToggleTipButton> createState() => _ToggleTipButtonState();
}

class _ToggleTipButtonState extends State<_ToggleTipButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Semantics(
      button: true,
      label: widget.buttonLabel,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _isHovered
                  ? carbon.toggleTip.buttonBackgroundHover
                  : carbon.toggleTip.buttonBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                widget.icon ??
                Icon(
                  CarbonIcons.information,
                  size: 16,
                  color: carbon.toggleTip.buttonIcon,
                ),
          ),
        ),
      ),
    );
  }
}

/// Internal toggle tip content widget.
class _ToggleTipContent extends StatelessWidget {
  final Widget content;
  final List<Widget>? actions;
  final CarbonPopoverAlignment alignment;

  const _ToggleTipContent({
    required this.content,
    this.actions,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isBottomAligned) _buildCaret(carbon.toggleTip.caret, isTop: true),
        Container(
          decoration: BoxDecoration(
            color: carbon.toggleTip.contentBackground,
            border: Border.all(color: carbon.toggleTip.border, width: 1),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: CarbonPalette.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    color: carbon.toggleTip.contentText,
                    fontSize: 14,
                    height: 1.4,
                  ),
                  child: content,
                ),
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: actions!.map((action) {
                      return DefaultTextStyle(
                        style: TextStyle(
                          color: carbon.toggleTip.actionButtonText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        child: action,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (_isTopAligned) _buildCaret(carbon.toggleTip.caret, isTop: false),
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

/// Custom painter for the caret (arrow).
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
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CaretPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.pointsUp != pointsUp;
  }
}
