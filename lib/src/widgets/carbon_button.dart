import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyDownEvent;

import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// Carbon Design System button kind variants.
enum CarbonButtonKind {
  /// Filled button for primary actions.
  primary,

  /// Filled button for secondary actions.
  secondary,

  /// Outlined button for tertiary/less-prominent actions.
  tertiary,

  /// Transparent button for low-emphasis actions.
  ghost,

  /// Filled red button for destructive primary actions.
  danger,

  /// Outlined red button for destructive secondary actions.
  dangerTertiary,

  /// Transparent red button for destructive ghost actions.
  dangerGhost,
}

/// Carbon Design System button size variants.
enum CarbonButtonSize {
  /// Small — 32 px height.
  sm,

  /// Medium — 40 px height.
  md,

  /// Large — 48 px height (default).
  lg,

  /// Extra-large — 64 px height.
  xl,

  /// 2×-large — 80 px height.
  twoXl,
}

/// A Carbon Design System button component.
///
/// Supports all seven Carbon button kinds and five size variants.
/// Provide [icon] for a trailing icon or as the sole content for an
/// icon-only square button.
///
/// Example:
/// ```dart
/// // Primary text button
/// CarbonButton(
///   child: Text('Save'),
///   onPressed: _handleSave,
/// )
///
/// // Text + trailing icon
/// CarbonButton(
///   child: Text('Add item'),
///   icon: Icon(CarbonIcons.add),
///   onPressed: _handleAdd,
///   kind: CarbonButtonKind.primary,
/// )
///
/// // Icon-only ghost button
/// CarbonButton(
///   icon: Icon(CarbonIcons.close),
///   onPressed: _handleClose,
///   kind: CarbonButtonKind.ghost,
///   size: CarbonButtonSize.sm,
/// )
/// ```
class CarbonButton extends StatefulWidget {
  /// Creates a Carbon button.
  ///
  /// At least one of [child] or [icon] must be provided.
  const CarbonButton({
    super.key,
    this.child,
    this.icon,
    this.onPressed,
    this.kind = CarbonButtonKind.primary,
    this.size = CarbonButtonSize.lg,
  }) : assert(
          child != null || icon != null,
          'At least one of child or icon must be provided.',
        );

  /// Optional label widget, typically a [Text]. When null and [icon] is set,
  /// the button renders as an icon-only square.
  final Widget? child;

  /// Optional trailing icon widget. When [child] is null, this is the sole
  /// button content and the button renders as a square.
  final Widget? icon;

  /// Called on tap. Passing null disables the button.
  final VoidCallback? onPressed;

  /// Visual style variant.
  final CarbonButtonKind kind;

  /// Size variant controlling height and typography scale.
  final CarbonButtonSize size;

  bool get _enabled => onPressed != null;
  bool get _iconOnly => child == null && icon != null;

  @override
  State<CarbonButton> createState() => _CarbonButtonState();
}

class _CarbonButtonState extends State<CarbonButton> {
  final FocusNode _focusNode = FocusNode();
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(
      () => setState(() => _isFocused = _focusNode.hasFocus),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget._enabled) return;
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    final height = _height();
    final iconSize = _iconSize();
    final hPad = _horizontalPadding();

    // Resolve colors based on kind and interaction state.
    final bg = _backgroundColor(carbon);
    final borderColor = _borderColor(carbon);
    final contentColor = _contentColor(carbon);
    final focusColor = carbon.layer.borderInteractive;

    return Semantics(
      button: true,
      enabled: widget._enabled,
      child: MouseRegion(
        onEnter: widget._enabled
            ? (_) => setState(() => _isHovered = true)
            : null,
        onExit: widget._enabled
            ? (_) => setState(() => _isHovered = false)
            : null,
        cursor: widget._enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: (_, event) {
            if (event is KeyDownEvent &&
                (event.logicalKey.keyLabel == ' ' ||
                    event.logicalKey.keyLabel == 'Enter')) {
              _handleTap();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            onTap: _handleTap,
            onTapDown: widget._enabled
                ? (_) => setState(() => _isPressed = true)
                : null,
            onTapUp: widget._enabled
                ? (_) => setState(() => _isPressed = false)
                : null,
            onTapCancel: widget._enabled
                ? () => setState(() => _isPressed = false)
                : null,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Button surface — non-positioned so it sizes the Stack.
                AnimatedContainer(
                  duration: CarbonMotion.durationFast01,
                  height: widget._iconOnly ? height : null,
                  constraints: BoxConstraints(
                    minHeight: height,
                    minWidth: widget._iconOnly ? height : 0,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    border: Border.all(
                      color: borderColor ?? Colors.transparent,
                      width: 1,
                    ),
                  ),
                  alignment: widget._iconOnly
                      ? Alignment.center
                      : Alignment.centerLeft,
                  padding: widget._iconOnly
                      ? EdgeInsets.zero
                      : EdgeInsets.symmetric(horizontal: hPad),
                  child: _buildContent(contentColor, iconSize),
                ),

                // Focus ring — extends 2 px outside the button bounds.
                if (_isFocused && widget._enabled)
                  Positioned(
                    top: -2,
                    left: -2,
                    right: -2,
                    bottom: -2,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: focusColor, width: 2),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color contentColor, double iconSize) {
    if (widget._iconOnly) {
      return IconTheme(
        data: IconThemeData(color: contentColor, size: iconSize),
        child: widget.icon!,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DefaultTextStyle.merge(
          style: _textStyle().copyWith(color: contentColor),
          child: widget.child!,
        ),
        if (widget.icon != null) ...[
          const SizedBox(width: 8),
          IconTheme(
            data: IconThemeData(color: contentColor, size: iconSize),
            child: widget.icon!,
          ),
        ],
      ],
    );
  }

  // ─── Sizing helpers ───────────────────────────────────────────────────────

  double _height() {
    switch (widget.size) {
      case CarbonButtonSize.sm:
        return 32;
      case CarbonButtonSize.md:
        return 40;
      case CarbonButtonSize.lg:
        return 48;
      case CarbonButtonSize.xl:
        return 64;
      case CarbonButtonSize.twoXl:
        return 80;
    }
  }

  double _iconSize() => widget.size == CarbonButtonSize.twoXl ? 20 : 16;

  double _horizontalPadding() =>
      widget.size == CarbonButtonSize.twoXl ? 24 : 16;

  TextStyle _textStyle() {
    switch (widget.size) {
      case CarbonButtonSize.xl:
      case CarbonButtonSize.twoXl:
        return CarbonTypography.bodyCompact02;
      default:
        return CarbonTypography.bodyCompact01;
    }
  }

  // ─── Color helpers ────────────────────────────────────────────────────────

  Color? _borderColor(CarbonThemeData c) {
    final t = c.button;
    if (!widget._enabled) {
      switch (widget.kind) {
        case CarbonButtonKind.tertiary:
        case CarbonButtonKind.dangerTertiary:
          return t.buttonDisabled;
        default:
          return null;
      }
    }
    switch (widget.kind) {
      case CarbonButtonKind.tertiary:
        return _isHovered || _isPressed ? Colors.transparent : t.buttonTertiary;
      case CarbonButtonKind.dangerTertiary:
        return _isHovered || _isPressed
            ? Colors.transparent
            : t.buttonDangerSecondary;
      default:
        return null;
    }
  }

  Color _backgroundColor(CarbonThemeData c) {
    final t = c.button;
    final l = c.layer;
    if (!widget._enabled) {
      switch (widget.kind) {
        case CarbonButtonKind.ghost:
        case CarbonButtonKind.dangerGhost:
        case CarbonButtonKind.tertiary:
        case CarbonButtonKind.dangerTertiary:
          return Colors.transparent;
        default:
          return t.buttonDisabled;
      }
    }
    switch (widget.kind) {
      case CarbonButtonKind.primary:
        return _isPressed
            ? t.buttonPrimaryActive
            : _isHovered
                ? t.buttonPrimaryHover
                : t.buttonPrimary;
      case CarbonButtonKind.secondary:
        return _isPressed
            ? t.buttonSecondaryActive
            : _isHovered
                ? t.buttonSecondaryHover
                : t.buttonSecondary;
      case CarbonButtonKind.tertiary:
        return _isPressed
            ? t.buttonTertiaryActive
            : _isHovered
                ? t.buttonTertiaryHover
                : Colors.transparent;
      case CarbonButtonKind.ghost:
        return _isPressed
            ? l.layerActive01
            : _isHovered
                ? l.backgroundHover
                : Colors.transparent;
      case CarbonButtonKind.danger:
        return _isPressed
            ? t.buttonDangerActive
            : _isHovered
                ? t.buttonDangerHover
                : t.buttonDangerPrimary;
      case CarbonButtonKind.dangerTertiary:
        return _isPressed
            ? t.buttonDangerActive
            : _isHovered
                ? t.buttonDangerPrimary
                : Colors.transparent;
      case CarbonButtonKind.dangerGhost:
        return _isPressed
            ? t.buttonDangerActive
            : _isHovered
                ? t.buttonDangerHover
                : Colors.transparent;
    }
  }

  Color _contentColor(CarbonThemeData c) {
    final t = c.button;
    final tt = c.text;
    if (!widget._enabled) {
      switch (widget.kind) {
        case CarbonButtonKind.ghost:
        case CarbonButtonKind.dangerGhost:
        case CarbonButtonKind.tertiary:
        case CarbonButtonKind.dangerTertiary:
          return tt.textDisabled;
        default:
          return tt.textOnColorDisabled;
      }
    }
    switch (widget.kind) {
      case CarbonButtonKind.primary:
      case CarbonButtonKind.secondary:
      case CarbonButtonKind.danger:
        return tt.textOnColor;
      case CarbonButtonKind.tertiary:
        return _isHovered || _isPressed ? tt.textOnColor : t.buttonTertiary;
      case CarbonButtonKind.ghost:
        return tt.linkPrimary;
      case CarbonButtonKind.dangerTertiary:
      case CarbonButtonKind.dangerGhost:
        return _isHovered || _isPressed
            ? tt.textOnColor
            : t.buttonDangerSecondary;
    }
  }
}
