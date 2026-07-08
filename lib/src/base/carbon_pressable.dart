import 'package:flutter/widgets.dart';

/// Interaction state passed to a [CarbonPressable.builder].
class CarbonPressState {
  const CarbonPressState({
    required this.hovered,
    required this.pressed,
    required this.focused,
  });

  final bool hovered;
  final bool pressed;
  final bool focused;
}

/// Signature for [CarbonPressable.builder].
typedef CarbonPressableBuilder = Widget Function(
  BuildContext context,
  CarbonPressState state,
);

/// Internal tap/hover/focus detector replacing Material's [InkWell].
///
/// Carbon has no ink ripple; interaction feedback is a plain color change
/// driven by the [builder]'s [CarbonPressState]. Keyboard activation (Space /
/// Enter) is handled through the activate action when [focusable] is true.
///
/// Not exported — this is a building block for Carbon widgets, not public API.
class CarbonPressable extends StatefulWidget {
  const CarbonPressable({
    super.key,
    required this.builder,
    this.onTap,
    this.cursor,
    this.focusable = false,
    this.behavior = HitTestBehavior.opaque,
  });

  /// Builds the child for the current interaction state.
  final CarbonPressableBuilder builder;

  /// Called on tap or keyboard activation. Null disables the detector.
  final VoidCallback? onTap;

  /// Cursor when enabled. Defaults to [SystemMouseCursors.click].
  final MouseCursor? cursor;

  /// Whether this is a traversable focus target with keyboard activation.
  final bool focusable;

  final HitTestBehavior behavior;

  bool get _enabled => onTap != null;

  @override
  State<CarbonPressable> createState() => _CarbonPressableState();
}

class _CarbonPressableState extends State<CarbonPressable> {
  final FocusNode _focusNode = FocusNode(debugLabel: 'CarbonPressable');
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget._enabled;
    _focusNode
      ..canRequestFocus = enabled && widget.focusable
      ..skipTraversal = !widget.focusable;

    return FocusableActionDetector(
      enabled: enabled,
      focusNode: _focusNode,
      mouseCursor: enabled
          ? (widget.cursor ?? SystemMouseCursors.click)
          : MouseCursor.defer,
      onShowHoverHighlight: (v) => setState(() => _hovered = v),
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: GestureDetector(
        behavior: widget.behavior,
        onTap: enabled ? widget.onTap : null,
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        child: widget.builder(
          context,
          CarbonPressState(
            hovered: _hovered,
            pressed: _pressed,
            focused: _focused,
          ),
        ),
      ),
    );
  }
}
