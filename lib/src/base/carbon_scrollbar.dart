import 'package:flutter/widgets.dart';

import '../theme/carbon_theme.dart';

/// Matches flutter/foundation's `precisionErrorTolerance` (not re-exported
/// by flutter/widgets).
const double _kOverflowTolerance = 1e-10;

/// Builds the scrollable, wiring [controller] to it.
typedef CarbonScrollbarBuilder = Widget Function(
  BuildContext context,
  ScrollController controller,
);

/// Internal Carbon-styled scrollbar: sharp corners, thin
/// `$border-strong-01` thumb, **visible exactly while the content
/// overflows** and hidden entirely when it fits.
///
/// Carbon web relies on native browser scrollbars for this; Flutter draws
/// none, so library scrollables wrap themselves in this primitive.
///
/// Points that shape the implementation (verified against the SDK):
///
/// - `RawScrollbar.thumbVisibility: true` requires an attached
///   [ScrollController]; when the adopter has none to share, this widget
///   owns one and hands it to [builder].
/// - Older SDKs (< 3.32) paint a full-track thumb even when nothing
///   overflows — visibility is gated here via
///   [ScrollMetricsNotification] instead (the framework's own Scrollbar
///   convention; the notification is dispatched post-layout, so setState
///   in the handler is safe).
/// - The scrollbar painter is fed only by notifications bubbling through
///   the CHILD — for nested-2D layouts, wrap the pinned viewport and pass
///   an axis-based [notificationPredicate] (inner-axis notifications
///   cross the outer scrollable at depth 1).
/// - Flutter's base [ScrollBehavior] injects a default scrollbar around
///   every scrollable on desktop; it is suppressed here so there is
///   exactly one bar per axis.
///
/// Not exported — this is a building block for Carbon widgets, not public
/// API.
class CarbonScrollbar extends StatefulWidget {
  const CarbonScrollbar({
    super.key,
    this.controller,
    required this.builder,
    this.axis = Axis.vertical,
    this.notificationPredicate,
    this.padding = EdgeInsets.zero,
    this.thickness = 6,
    this.crossAxisMargin = 2,
  });

  /// The controller attached to the scrollable. When null, this widget
  /// creates and owns one (for stateless adopters).
  final ScrollController? controller;

  /// Builds the scrollable subtree; MUST attach the given controller to
  /// the scrollable this bar indicates.
  final CarbonScrollbarBuilder builder;

  /// Which axis this bar indicates. Only notifications for this axis (at
  /// depth 0) drive it unless [notificationPredicate] overrides.
  final Axis axis;

  /// Custom notification filter — needed when the indicated scrollable is
  /// not the nearest one below this widget (nested 2D scrolling).
  final bool Function(ScrollNotification notification)? notificationPredicate;

  /// Inset for the track. Never null — `RawScrollbar`'s own null default
  /// falls back to MediaQuery padding (notch insets), which is wrong
  /// inside components. Directional insets resolve with the ambient text
  /// direction.
  final EdgeInsetsGeometry padding;

  /// Thumb thickness.
  final double thickness;

  /// Gap between the thumb and the viewport edge.
  final double crossAxisMargin;

  @override
  State<CarbonScrollbar> createState() => _CarbonScrollbarState();
}

class _CarbonScrollbarState extends State<CarbonScrollbar> {
  ScrollController? _internal;
  ScrollController get _controller => widget.controller ?? _internal!;

  /// Whether the indicated scrollable currently overflows.
  bool _overflowing = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _internal = ScrollController();
  }

  @override
  void didUpdateWidget(CarbonScrollbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (widget.controller == null) {
        _internal ??= ScrollController();
      } else if (_internal != null) {
        // The outgoing child scrollable still holds the internal controller
        // until it rebuilds LATER this frame — disposing now would make its
        // detach hit a disposed ChangeNotifier. Retire it post-frame.
        final retired = _internal!;
        _internal = null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          retired.dispose();
        });
      }
    }
  }

  @override
  void dispose() {
    _internal?.dispose();
    super.dispose();
  }

  bool _accept(ScrollNotification notification) =>
      widget.notificationPredicate?.call(notification) ??
      (notification.depth == 0 && notification.metrics.axis == widget.axis);

  bool _onMetrics(ScrollMetricsNotification notification) {
    // asScrollUpdate() does not carry the bubble depth (always 0), which
    // would let a consumer's nested same-axis scrollable drive the gate —
    // check the ORIGINAL notification's depth on the default path. Custom
    // predicates receive the depth-0 conversion: filter by axis there.
    final accepted = widget.notificationPredicate != null
        ? widget.notificationPredicate!(notification.asScrollUpdate())
        : (notification.depth == 0 &&
            notification.metrics.axis == widget.axis);
    if (!accepted) return false;
    final overflowing = notification.metrics.maxScrollExtent -
            notification.metrics.minScrollExtent >
        _kOverflowTolerance;
    if (overflowing != _overflowing) {
      // Safe: ScrollMetricsNotification is dispatched post-layout.
      setState(() => _overflowing = overflowing);
    }
    return false; // keep bubbling — an outer bar of the other axis needs it
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: _onMetrics,
      child: RawScrollbar(
        controller: _controller,
        thumbVisibility: _overflowing,
        interactive: true,
        thickness: widget.thickness,
        // No radius: null paints a square-cornered thumb (Carbon corners).
        thumbColor: context.carbon.layer.borderStrong01,
        crossAxisMargin: widget.crossAxisMargin,
        mainAxisMargin: 2,
        padding: widget.padding,
        notificationPredicate: _accept,
        child: ScrollConfiguration(
          // Suppress the framework's default desktop scrollbar — exactly
          // one bar per axis.
          behavior:
              ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: widget.builder(context, _controller),
        ),
      ),
    );
  }
}
