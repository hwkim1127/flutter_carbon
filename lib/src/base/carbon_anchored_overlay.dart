import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';

/// Alignment of an anchored overlay (popover, toggle tip, …) relative to its
/// trigger.
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

/// Signature for building anchored-overlay content. [effectiveAlignment] is
/// the alignment after edge-flipping — use it to orient carets.
typedef CarbonAnchoredOverlayContentBuilder =
    Widget Function(
      BuildContext context,
      CarbonPopoverAlignment effectiveAlignment,
    );

/// Internal root for anchored overlay entries (popover, toggle tip, overflow
/// menu): a tap-outside barrier plus content positioned relative to the
/// trigger with edge awareness.
///
/// Positioning happens in a [SingleChildLayoutDelegate]: the child's real
/// size arrives during layout (no invisible measuring frame), the requested
/// alignment **flips** to the opposite side when the content doesn't fit
/// there but does on the other side, and the result is **clamped** to the
/// screen bounds. The software keyboard's inset is subtracted from the
/// usable height, so content flips above rather than opening under the
/// keyboard. Content size changes re-resolve automatically (the delegate
/// re-runs on relayout). Known limitation: the anchor rect is read at build
/// time, so a window resize while open repositions against the trigger's
/// pre-resize location until the entry rebuilds.
///
/// Not exported — this is a building block for Carbon widgets, not public API.
class CarbonAnchoredOverlay extends StatefulWidget {
  const CarbonAnchoredOverlay({
    super.key,
    required this.anchorRect,
    required this.alignment,
    required this.onDismiss,
    required this.contentBuilder,
    this.spacing = 4.0,
    this.maxWidth,
    this.matchAnchorWidth = false,
  });

  /// Returns the trigger's rect in overlay coordinates. Evaluated during the
  /// overlay's build (reading render-object geometry is not allowed during
  /// layout), so the anchor refreshes whenever the entry rebuilds. Build one
  /// with [anchorRectGetterFor].
  final ValueGetter<Rect> anchorRect;

  /// The requested alignment (may flip at screen edges).
  final CarbonPopoverAlignment alignment;

  /// Called when the barrier (outside the content) is tapped.
  final VoidCallback onDismiss;

  /// Builds the content; receives the post-flip alignment.
  final CarbonAnchoredOverlayContentBuilder contentBuilder;

  /// Gap between the anchor edge and the content.
  final double spacing;

  /// Optional max content width. Ignored when [matchAnchorWidth] is true.
  final double? maxWidth;

  /// Forces the content to exactly the anchor's width (dropdown-style menus
  /// that must sit flush with their trigger field).
  final bool matchAnchorWidth;

  /// Builds an anchor-rect getter for [triggerContext]'s render box, in the
  /// coordinate space of its enclosing [Overlay] (correct even when that
  /// overlay is not at the window origin, e.g. nested navigators).
  ///
  /// Capture at open time, while the trigger is mounted; the overlay entry
  /// must be removed before the trigger unmounts (all adopters remove their
  /// entry in `dispose`).
  static ValueGetter<Rect> anchorRectGetterFor(BuildContext triggerContext) {
    final triggerBox = triggerContext.findRenderObject()! as RenderBox;
    final overlayBox =
        Overlay.of(triggerContext).context.findRenderObject() as RenderBox?;
    return () =>
        triggerBox.localToGlobal(Offset.zero, ancestor: overlayBox) &
        triggerBox.size;
  }

  @override
  State<CarbonAnchoredOverlay> createState() => _CarbonAnchoredOverlayState();
}

class _CarbonAnchoredOverlayState extends State<CarbonAnchoredOverlay> {
  /// The post-flip alignment, reported by the layout delegate. Drives the
  /// caret side; updates one frame after a flip decision changes (content
  /// height is identical on either side, so this cannot oscillate).
  late final ValueNotifier<CarbonPopoverAlignment> _effectiveAlignment =
      ValueNotifier(widget.alignment);

  @override
  void dispose() {
    _effectiveAlignment.dispose();
    super.dispose();
  }

  void _reportEffectiveAlignment(CarbonPopoverAlignment value) {
    if (_effectiveAlignment.value == value) return;
    // Called during layout — defer the notification to after the frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _effectiveAlignment.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ValueListenableBuilder<CarbonPopoverAlignment>(
      valueListenable: _effectiveAlignment,
      builder: (context, effective, _) =>
          widget.contentBuilder(context, effective),
    );
    if (widget.maxWidth != null && !widget.matchAnchorWidth) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth!),
        child: content,
      );
    }

    // Resolve the anchor now — render-object sizes may be read during
    // build, but not from inside the delegate's layout pass.
    final anchor = widget.anchorRect();

    // The keyboard's inset does not shrink the overlay's size, so without
    // this the fit checks would place content under the keyboard on mobile.
    final bottomInset = MediaQuery.maybeViewInsetsOf(context)?.bottom ?? 0.0;

    return GestureDetector(
      onTap: widget.onDismiss,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          // Transparent overlay to capture outside taps
          Positioned.fill(child: Container(color: CarbonPalette.transparent)),
          Positioned.fill(
            child: CustomSingleChildLayout(
              delegate: _AnchoredOverlayDelegate(
                anchorRect: anchor,
                alignment: widget.alignment,
                spacing: widget.spacing,
                matchAnchorWidth: widget.matchAnchorWidth,
                bottomInset: bottomInset,
                onEffectiveAlignment: _reportEffectiveAlignment,
              ),
              child: GestureDetector(
                onTap: () {}, // Keep content taps off the barrier
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnchoredOverlayDelegate extends SingleChildLayoutDelegate {
  _AnchoredOverlayDelegate({
    required this.anchorRect,
    required this.alignment,
    required this.spacing,
    required this.matchAnchorWidth,
    required this.bottomInset,
    required this.onEffectiveAlignment,
  });

  static const double _screenMargin = 8.0;

  final Rect anchorRect;
  final CarbonPopoverAlignment alignment;
  final double spacing;
  final bool matchAnchorWidth;
  final double bottomInset;
  final ValueChanged<CarbonPopoverAlignment> onEffectiveAlignment;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final loosened = constraints.loosen();
    if (!matchAnchorWidth) return loosened;
    return loosened.tighten(width: anchorRect.width);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Treat the keyboard-covered strip as off-screen.
    final usable = Size(size.width, size.height - bottomInset);
    final effective = _resolveAlignment(anchorRect, childSize, usable);
    onEffectiveAlignment(effective);
    return _positionFor(effective, anchorRect, childSize, usable);
  }

  @override
  bool shouldRelayout(_AnchoredOverlayDelegate oldDelegate) =>
      anchorRect != oldDelegate.anchorRect ||
      alignment != oldDelegate.alignment ||
      spacing != oldDelegate.spacing ||
      matchAnchorWidth != oldDelegate.matchAnchorWidth ||
      bottomInset != oldDelegate.bottomInset;

  /// Flips the requested alignment to the opposite side when the content
  /// doesn't fit there but does fit on the other side.
  CarbonPopoverAlignment _resolveAlignment(
    Rect anchor,
    Size content,
    Size screen,
  ) {
    bool fitsBelow() =>
        anchor.bottom + spacing + content.height <= screen.height;
    bool fitsAbove() => anchor.top - spacing - content.height >= 0;
    bool fitsRight() => anchor.right + spacing + content.width <= screen.width;
    bool fitsLeft() => anchor.left - spacing - content.width >= 0;

    switch (alignment) {
      case CarbonPopoverAlignment.bottom:
        return !fitsBelow() && fitsAbove()
            ? CarbonPopoverAlignment.top
            : alignment;
      case CarbonPopoverAlignment.bottomStart:
        return !fitsBelow() && fitsAbove()
            ? CarbonPopoverAlignment.topStart
            : alignment;
      case CarbonPopoverAlignment.bottomEnd:
        return !fitsBelow() && fitsAbove()
            ? CarbonPopoverAlignment.topEnd
            : alignment;
      case CarbonPopoverAlignment.top:
        return !fitsAbove() && fitsBelow()
            ? CarbonPopoverAlignment.bottom
            : alignment;
      case CarbonPopoverAlignment.topStart:
        return !fitsAbove() && fitsBelow()
            ? CarbonPopoverAlignment.bottomStart
            : alignment;
      case CarbonPopoverAlignment.topEnd:
        return !fitsAbove() && fitsBelow()
            ? CarbonPopoverAlignment.bottomEnd
            : alignment;
      case CarbonPopoverAlignment.right:
        return !fitsRight() && fitsLeft()
            ? CarbonPopoverAlignment.left
            : alignment;
      case CarbonPopoverAlignment.rightStart:
        return !fitsRight() && fitsLeft()
            ? CarbonPopoverAlignment.leftStart
            : alignment;
      case CarbonPopoverAlignment.rightEnd:
        return !fitsRight() && fitsLeft()
            ? CarbonPopoverAlignment.leftEnd
            : alignment;
      case CarbonPopoverAlignment.left:
        return !fitsLeft() && fitsRight()
            ? CarbonPopoverAlignment.right
            : alignment;
      case CarbonPopoverAlignment.leftStart:
        return !fitsLeft() && fitsRight()
            ? CarbonPopoverAlignment.rightStart
            : alignment;
      case CarbonPopoverAlignment.leftEnd:
        return !fitsLeft() && fitsRight()
            ? CarbonPopoverAlignment.rightEnd
            : alignment;
    }
  }

  /// Top-left position for the content, clamped to the screen bounds.
  Offset _positionFor(
    CarbonPopoverAlignment effective,
    Rect anchor,
    Size content,
    Size screen,
  ) {
    double dx;
    double dy;

    switch (effective) {
      case CarbonPopoverAlignment.bottom:
        dx = anchor.center.dx - content.width / 2;
        dy = anchor.bottom + spacing;
      case CarbonPopoverAlignment.bottomStart:
        dx = anchor.left;
        dy = anchor.bottom + spacing;
      case CarbonPopoverAlignment.bottomEnd:
        dx = anchor.right - content.width;
        dy = anchor.bottom + spacing;
      case CarbonPopoverAlignment.top:
        dx = anchor.center.dx - content.width / 2;
        dy = anchor.top - spacing - content.height;
      case CarbonPopoverAlignment.topStart:
        dx = anchor.left;
        dy = anchor.top - spacing - content.height;
      case CarbonPopoverAlignment.topEnd:
        dx = anchor.right - content.width;
        dy = anchor.top - spacing - content.height;
      case CarbonPopoverAlignment.right:
        dx = anchor.right + spacing;
        dy = anchor.center.dy - content.height / 2;
      case CarbonPopoverAlignment.rightStart:
        dx = anchor.right + spacing;
        dy = anchor.top;
      case CarbonPopoverAlignment.rightEnd:
        dx = anchor.right + spacing;
        dy = anchor.bottom - content.height;
      case CarbonPopoverAlignment.left:
        dx = anchor.left - spacing - content.width;
        dy = anchor.center.dy - content.height / 2;
      case CarbonPopoverAlignment.leftStart:
        dx = anchor.left - spacing - content.width;
        dy = anchor.top;
      case CarbonPopoverAlignment.leftEnd:
        dx = anchor.left - spacing - content.width;
        dy = anchor.bottom - content.height;
    }

    // Clamp to screen; when the content is larger than the screen, pin to
    // the top/left margin (max() keeps clamp's min <= max).
    final maxDx = screen.width - content.width - _screenMargin;
    final maxDy = screen.height - content.height - _screenMargin;
    return Offset(
      dx.clamp(_screenMargin, maxDx > _screenMargin ? maxDx : _screenMargin),
      dy.clamp(_screenMargin, maxDy > _screenMargin ? maxDy : _screenMargin),
    );
  }
}
