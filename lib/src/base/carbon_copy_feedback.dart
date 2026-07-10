import 'package:flutter/widgets.dart';

import '../foundation/motion.dart';
import 'carbon_anchored_overlay.dart';
import 'carbon_tooltip_bubble.dart';

/// Click-triggered "Copied!" feedback bubble shared by [CarbonCopyButton]
/// and [CarbonCodeSnippet].
///
/// Unlike [CarbonTooltip] (hover/focus lifecycle), visibility is driven
/// entirely by [visible]: the parent flips it on after a copy and back off
/// when its feedback timer elapses. The bubble fades in/out with
/// `duration-fast-02` productive motion and is announced as a live region.
///
/// Rendered in the app [Overlay] so ancestor clipping (the code snippet's
/// `ClipRect`, a 40px single-line row) cannot cut it off. It never
/// intercepts pointers.
///
/// Not exported — this is a building block for Carbon widgets, not public API.
class CarbonCopyFeedback extends StatefulWidget {
  /// Whether the bubble is (fading) visible. The parent owns the timer.
  final bool visible;

  /// The feedback text, e.g. 'Copied!'.
  final String message;

  /// Preferred placement relative to [child] (auto-flips at screen edges).
  final CarbonPopoverAlignment alignment;

  /// The trigger the bubble is anchored to.
  final Widget child;

  const CarbonCopyFeedback({
    super.key,
    required this.visible,
    required this.message,
    this.alignment = CarbonPopoverAlignment.bottom,
    required this.child,
  });

  @override
  State<CarbonCopyFeedback> createState() => _CarbonCopyFeedbackState();
}

class _CarbonCopyFeedbackState extends State<CarbonCopyFeedback>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;

  // Created in initState — a lazy `late final` would first initialize in
  // dispose() when feedback never showed, and createTicker's ancestor
  // lookup is illegal there.
  late final AnimationController _fadeController;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: CarbonMotion.durationFast02,
      vsync: this,
    );
    _fade = CurvedAnimation(
      parent: _fadeController,
      curve: CarbonMotion.standardProductive,
    );
    if (widget.visible) {
      // Overlay insertion is not allowed during build — defer.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.visible) _show();
      });
    }
  }

  @override
  void didUpdateWidget(CarbonCopyFeedback oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      // didUpdateWidget runs during build: inserting/removing overlay
      // entries and starting animations that rebuild them must be deferred.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.visible) {
          _show();
        } else {
          _hide();
        }
      });
    } else if (_overlayEntry != null &&
        (oldWidget.message != widget.message ||
            oldWidget.alignment != widget.alignment)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
  }

  @override
  void dispose() {
    // Remove directly — no setState/animation during dispose.
    _overlayEntry?.remove();
    _overlayEntry = null;
    _fadeController.dispose();
    super.dispose();
  }

  void _show() {
    if (!widget.visible) return; // flipped back off before the frame ended
    if (_overlayEntry == null) {
      final anchorRect = CarbonAnchoredOverlay.anchorRectGetterFor(context);
      _overlayEntry = OverlayEntry(
        builder: (context) => IgnorePointer(
          child: CarbonAnchoredOverlay(
            anchorRect: anchorRect,
            alignment: widget.alignment,
            onDismiss: () {}, // never reachable — pointers are ignored
            contentBuilder: (context, effectiveAlignment) => FadeTransition(
              opacity: _fade,
              // The announcement must not wait for paint alpha — screen
              // readers should hear the feedback the moment it shows.
              alwaysIncludeSemantics: true,
              // One merged live-region node: the bubble text is the label
              // and the flag makes assistive tech announce it on show.
              child: MergeSemantics(
                child: Semantics(
                  liveRegion: true,
                  child: CarbonTooltipBubble(
                    message: widget.message,
                    alignment: effectiveAlignment,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    }
    _fadeController.forward();
  }

  void _hide() {
    if (_overlayEntry == null) return;
    _fadeController.reverse().whenComplete(() {
      // Reentry guard: a new copy may have re-shown the bubble while the
      // fade-out was running.
      if (!mounted || widget.visible) return;
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
