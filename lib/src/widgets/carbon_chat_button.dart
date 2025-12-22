import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// Chat Button size.
enum CarbonChatButtonSize {
  /// Small size.
  sm,

  /// Medium size.
  md,

  /// Large size.
  lg,
}

/// Chat Button kind.
enum CarbonChatButtonKind {
  /// Primary button.
  primary,

  /// Secondary button.
  secondary,

  /// Tertiary button.
  tertiary,

  /// Ghost button.
  ghost,

  /// Danger button.
  danger,
}

/// Carbon Design System Chat Button.
///
/// A specialized button component for chat interfaces.
/// Supports quick actions and selected states.
///
/// Example:
/// ```dart
/// CarbonChatButton(
///   onPressed: () {
///     // Handle chat action
///   },
///   child: Text('Send'),
///   icon: Icon(Icons.send),
/// )
/// ```
class CarbonChatButton extends StatefulWidget {
  /// The content of the button.
  final Widget child;

  /// Optional icon to display.
  final Widget? icon;

  /// Callback when button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is disabled.
  final bool disabled;

  /// The button kind.
  final CarbonChatButtonKind kind;

  /// The button size.
  final CarbonChatButtonSize size;

  /// Whether this is a quick action button.
  final bool isQuickAction;

  /// Whether the quick action button is selected.
  final bool isSelected;

  const CarbonChatButton({
    super.key,
    required this.child,
    this.icon,
    this.onPressed,
    this.disabled = false,
    this.kind = CarbonChatButtonKind.primary,
    this.size = CarbonChatButtonSize.lg,
    this.isQuickAction = false,
    this.isSelected = false,
  });

  @override
  State<CarbonChatButton> createState() => _CarbonChatButtonState();
}

class _CarbonChatButtonState extends State<CarbonChatButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CarbonChatButtonKind get _effectiveKind {
    if (widget.isQuickAction) {
      return CarbonChatButtonKind.ghost;
    }
    return widget.kind;
  }

  CarbonChatButtonSize get _effectiveSize {
    if (widget.isQuickAction) {
      return CarbonChatButtonSize.sm;
    }
    return widget.size;
  }

  double _getHeight() {
    switch (_effectiveSize) {
      case CarbonChatButtonSize.sm:
        return 32;
      case CarbonChatButtonSize.md:
        return 40;
      case CarbonChatButtonSize.lg:
        return 48;
    }
  }

  double _getFontSize() {
    switch (_effectiveSize) {
      case CarbonChatButtonSize.sm:
        return 12;
      case CarbonChatButtonSize.md:
        return 14;
      case CarbonChatButtonSize.lg:
        return 14;
    }
  }

  EdgeInsets _getPadding() {
    if (widget.icon != null) {
      switch (_effectiveSize) {
        case CarbonChatButtonSize.sm:
          return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
        case CarbonChatButtonSize.md:
          return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
        case CarbonChatButtonSize.lg:
          return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      }
    } else {
      switch (_effectiveSize) {
        case CarbonChatButtonSize.sm:
          return const EdgeInsets.symmetric(horizontal: 16, vertical: 6);
        case CarbonChatButtonSize.md:
          return const EdgeInsets.symmetric(horizontal: 20, vertical: 8);
        case CarbonChatButtonSize.lg:
          return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      }
    }
  }

  Color _getBackgroundColor(CarbonThemeData carbon) {
    if (widget.disabled) {
      return carbon.button.buttonDisabled;
    }

    if (widget.isQuickAction && widget.isSelected) {
      return carbon.chat.chatButtonSelected;
    }

    if (_isPressed) {
      // return carbon.chat.chatButtonActive;
      switch (_effectiveKind) {
        case CarbonChatButtonKind.primary:
          return carbon.button.buttonPrimaryActive;
        case CarbonChatButtonKind.secondary:
          return carbon.button.buttonSecondaryActive;
        case CarbonChatButtonKind.tertiary:
          return carbon.button.buttonTertiaryActive;
        case CarbonChatButtonKind.danger:
          return carbon.button.buttonDangerActive;
        case CarbonChatButtonKind.ghost:
          return carbon.chat.chatButtonActive; // Keep chat theme for ghost
      }
    }

    if (_isHovered) {
      // return carbon.chat.chatButtonHover;
      switch (_effectiveKind) {
        case CarbonChatButtonKind.primary:
          return carbon.button.buttonPrimaryHover;
        case CarbonChatButtonKind.secondary:
          return carbon.button.buttonSecondaryHover;
        case CarbonChatButtonKind.tertiary:
          return carbon.chat.chatButtonHover;
        case CarbonChatButtonKind.danger:
          return carbon.button.buttonDangerHover;
        case CarbonChatButtonKind.ghost:
          return carbon.chat.chatButtonHover; // Keep chat theme for ghost
      }
    }

    switch (_effectiveKind) {
      case CarbonChatButtonKind.primary:
        return carbon.button.buttonPrimary;
      case CarbonChatButtonKind.secondary:
        return carbon.button.buttonSecondary;
      case CarbonChatButtonKind.tertiary:
        // Tertiary buttons have transparent background
        // buttonTertiary token is used for border/text (see line 214)
        return Colors.transparent;
      case CarbonChatButtonKind.ghost:
        return widget.isQuickAction
            ? carbon.chat.chatButton
            : Colors.transparent;
      case CarbonChatButtonKind.danger:
        return carbon.button.buttonDangerPrimary;
    }
  }

  Color _getTextColor(CarbonThemeData carbon) {
    if (widget.disabled) {
      return carbon.text.textDisabled;
    }

    if (widget.isQuickAction && widget.isSelected) {
      return carbon.chat.chatButtonTextSelected;
    }

    if (_isHovered && widget.isQuickAction) {
      return carbon.chat.chatButtonTextHover;
    }

    // Quick actions have colored background, need light text
    if (widget.isQuickAction) {
      return carbon.text.textOnColor;
    }

    switch (_effectiveKind) {
      case CarbonChatButtonKind.primary:
      case CarbonChatButtonKind.secondary:
      case CarbonChatButtonKind.danger:
        return carbon.text.textOnColor;
      case CarbonChatButtonKind.tertiary:
      case CarbonChatButtonKind.ghost:
        return carbon.text.textPrimary;
    }
  }

  Border? _getBorder(CarbonThemeData carbon) {
    if (_effectiveKind == CarbonChatButtonKind.tertiary) {
      return Border.all(
        color: widget.disabled
            ? carbon.button.buttonDisabled
            : carbon.button.buttonTertiary,
        width: 1,
      );
    }
    return null;
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.disabled) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final height = _getHeight();
    final fontSize = _getFontSize();
    final padding = _getPadding();
    final backgroundColor = _getBackgroundColor(carbon);
    final textColor = _getTextColor(carbon);
    final border = _getBorder(carbon);

    return Semantics(
      button: true,
      enabled: !widget.disabled,
      child: MouseRegion(
        onEnter: (_) {
          if (!widget.disabled) {
            setState(() => _isHovered = true);
          }
        },
        onExit: (_) => setState(() => _isHovered = false),
        cursor: widget.disabled
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.disabled ? null : widget.onPressed,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: Container(
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: border,
              // borderRadius: BorderRadius.zero,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(color: textColor, size: fontSize + 4),
                    child: widget.icon!,
                  ),
                  const SizedBox(width: 8),
                ],
                DefaultTextStyle(
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
