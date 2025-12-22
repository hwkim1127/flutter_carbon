import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyDownEvent;

import '../foundation/motion.dart';
import '../theme/carbon_theme_data.dart';

/// Carbon toggle size variants.
enum CarbonToggleSize {
  /// Regular size: 48px × 24px
  regular,

  /// Small size: 32px × 16px
  small,
}

/// A Carbon Design System toggle (switch) component.
///
/// Unlike Material Switch, this follows Carbon's exact specifications:
/// - Regular: 48px × 24px track with 18px thumb
/// - Small: 32px × 16px track with 10px thumb (includes checkmark when on)
///
/// Example:
/// ```dart
/// CarbonToggle(
///   value: _isEnabled,
///   onChanged: (value) => setState(() => _isEnabled = value),
///   labelText: 'Enable feature',
///   onText: 'On',
///   offText: 'Off',
/// )
/// ```
class CarbonToggle extends StatefulWidget {
  /// Creates a Carbon toggle.
  const CarbonToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.labelText,
    this.onText = 'On',
    this.offText = 'Off',
    this.size = CarbonToggleSize.regular,
    this.hideLabel = false,
    this.readOnly = false,
  });

  /// Whether the toggle is on (checked).
  final bool value;

  /// Called when the user toggles the switch.
  final ValueChanged<bool>? onChanged;

  /// Label text displayed above the toggle.
  final String? labelText;

  /// Text displayed when toggle is on.
  final String onText;

  /// Text displayed when toggle is off.
  final String offText;

  /// Size variant of the toggle.
  final CarbonToggleSize size;

  /// Whether to hide the label text visually (still accessible).
  final bool hideLabel;

  /// Whether the toggle is read-only (cannot be changed).
  final bool readOnly;

  bool get enabled => onChanged != null && !readOnly;

  @override
  State<CarbonToggle> createState() => _CarbonToggleState();
}

class _CarbonToggleState extends State<CarbonToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: CarbonMotion.durationFast02,
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );

    _updateAnimation();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(CarbonToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
    if (oldWidget.size != widget.size) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    final thumbTravel = widget.size == CarbonToggleSize.regular ? 24.0 : 16.0;
    _slideAnimation = Tween<double>(begin: 0.0, end: thumbTravel).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  void _handleTap() {
    if (!widget.enabled) return;
    widget.onChanged?.call(!widget.value);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carbon = Theme.of(context).extension<CarbonThemeData>()!;
    final toggleTheme = carbon.toggle;

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label text
          if (widget.labelText != null && !widget.hideLabel)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.labelText!,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.33,
                  letterSpacing: 0.32,
                  color: widget.enabled
                      ? toggleTheme.labelColor
                      : toggleTheme.textDisabled,
                ),
              ),
            ),

          // Toggle switch
          Focus(
            focusNode: _focusNode,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  (event.logicalKey.keyLabel == ' ' ||
                      event.logicalKey.keyLabel == 'Enter')) {
                _handleTap();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSwitch(toggleTheme),
                  const SizedBox(width: 8),
                  Text(
                    widget.value ? widget.onText : widget.offText,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.43,
                      letterSpacing: 0.16,
                      color: widget.enabled
                          ? toggleTheme.stateTextColor
                          : toggleTheme.textDisabled,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(CarbonToggleThemeData theme) {
    final isRegular = widget.size == CarbonToggleSize.regular;
    final trackWidth = isRegular ? 48.0 : 32.0;
    final trackHeight = isRegular ? 24.0 : 16.0;
    final thumbSize = isRegular ? 18.0 : 10.0;
    final thumbInset = 3.0;

    Color trackColor;
    Color thumbColor;
    Color? borderColor;

    if (!widget.enabled) {
      trackColor = theme.backgroundDisabled;
      thumbColor = theme.thumbColorDisabled;
    } else if (widget.readOnly) {
      trackColor = Colors.transparent;
      thumbColor = theme.thumbReadOnly;
      borderColor = theme.borderReadOnly;
    } else {
      trackColor = widget.value ? theme.toggleOn : theme.toggleOff;
      thumbColor = theme.thumbColor;
    }

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Container(
          width: trackWidth,
          height: trackHeight,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(trackHeight / 2),
            border: borderColor != null ? Border.all(color: borderColor) : null,
          ),
          child: Stack(
            children: [
              // Focus ring
              if (_isFocused && widget.enabled)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                      border: Border.all(color: theme.focusColor, width: 2),
                    ),
                    margin: const EdgeInsets.all(-2),
                  ),
                ),

              // Thumb
              Positioned(
                left: thumbInset + _slideAnimation.value,
                top: thumbInset,
                child: Container(
                  width: thumbSize,
                  height: thumbSize,
                  decoration: BoxDecoration(
                    color: thumbColor,
                    shape: BoxShape.circle,
                  ),
                  child: widget.value &&
                          !isRegular &&
                          widget.enabled &&
                          !widget.readOnly
                      ? Center(
                          child: CustomPaint(
                            size: const Size(6, 5),
                            painter: _CheckmarkPainter(theme.checkmarkColor),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Custom painter for the small toggle checkmark.
class _CheckmarkPainter extends CustomPainter {
  final Color color;

  _CheckmarkPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(2.2, 2.7)
      ..lineTo(5, 0)
      ..lineTo(6, 1)
      ..lineTo(2.2, 5)
      ..lineTo(0, 2.7)
      ..lineTo(1, 1.5)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) =>
      color != oldDelegate.color;
}
