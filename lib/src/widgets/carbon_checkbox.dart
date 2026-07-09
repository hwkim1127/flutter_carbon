import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show KeyDownEvent, LogicalKeyboardKey;

import '../foundation/colors.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// A Carbon Design System checkbox.
///
/// Drawn to the Carbon spec on the widgets layer (no Material dependency):
/// 16×16 box with 2px radius, `$icon-primary` border/fill, `$icon-inverse`
/// checkmark, 2px `$focus` ring at 1px offset.
///
/// Example:
/// ```dart
/// CarbonCheckbox(
///   value: _agreed,
///   onChanged: (value) => setState(() => _agreed = value ?? false),
///   label: 'I agree',
/// )
/// ```
class CarbonCheckbox extends StatefulWidget {
  /// Whether the checkbox is checked. `null` renders the indeterminate dash
  /// (only meaningful with [tristate]).
  final bool? value;

  /// Called with the next value when toggled. With [tristate] the cycle is
  /// false → true → null → false. `null` disables the checkbox.
  final ValueChanged<bool?>? onChanged;

  /// Optional label displayed to the right of the box.
  final String? label;

  /// Whether [value] may be `null` (indeterminate).
  final bool tristate;

  /// Whether to render the error state (border `$support-error`).
  final bool invalid;

  /// Error text shown below the control when [invalid].
  final String? invalidText;

  const CarbonCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.tristate = false,
    this.invalid = false,
    this.invalidText,
  }) : assert(
         tristate || value != null,
         'value can only be null when tristate is true',
       );

  bool get enabled => onChanged != null;

  @override
  State<CarbonCheckbox> createState() => _CarbonCheckboxState();
}

class _CarbonCheckboxState extends State<CarbonCheckbox> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggle() {
    if (!widget.enabled) return;
    switch (widget.value) {
      case false:
        widget.onChanged!(true);
      case true:
        widget.onChanged!(widget.tristate ? null : false);
      case null:
        widget.onChanged!(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    final labelColor = widget.enabled
        ? carbon.text.textPrimary
        : carbon.text.textDisabled;

    // MergeSemantics folds the checked state and the label Text into one
    // node, so screen readers announce the label once, with the state.
    return MergeSemantics(
      child: Semantics(
        checked: widget.value ?? false,
        mixed: widget.tristate && widget.value == null,
        enabled: widget.enabled,
        child: MouseRegion(
          cursor: widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          child: GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Focus(
              focusNode: _focusNode,
              canRequestFocus: widget.enabled,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.space) {
                  _toggle();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildBox(carbon),
                      if (widget.label != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          widget.label!,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.43,
                            letterSpacing: 0.16,
                            color: labelColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (widget.invalid && widget.invalidText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.invalidText!,
                      style: TextStyle(
                        fontSize: 12,
                        color: carbon.layer.supportError,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBox(CarbonThemeData carbon) {
    final checked = widget.value != false; // true or indeterminate

    final Color fillColor;
    final Color borderColor;
    if (!widget.enabled) {
      fillColor = checked
          ? carbon.text.iconDisabled
          : CarbonPalette.transparent;
      borderColor = carbon.text.iconDisabled;
    } else if (widget.invalid) {
      fillColor = checked ? carbon.text.iconPrimary : CarbonPalette.transparent;
      borderColor = carbon.layer.supportError;
    } else {
      fillColor = checked ? carbon.text.iconPrimary : CarbonPalette.transparent;
      borderColor = carbon.text.iconPrimary;
    }

    // 2px focus ring with a 1px gap around the 16px box (total 22px).
    return Container(
      width: 22,
      height: 22,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(
          color: _isFocused && widget.enabled
              ? carbon.layer.focus
              : CarbonPalette.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: fillColor,
          border: checked && !widget.invalid
              ? null
              : Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: switch (widget.value) {
          true => CustomPaint(
            painter: _CheckmarkPainter(color: carbon.text.iconInverse),
          ),
          null => Center(
            child: Container(
              width: 8,
              height: 2,
              color: carbon.text.iconInverse,
            ),
          ),
          false => null,
        },
      ),
    );
  }
}

/// Paints the 9×5 Carbon checkmark, stroked at 1.8px in the box's center.
class _CheckmarkPainter extends CustomPainter {
  final Color color;

  const _CheckmarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.butt;

    // 9×5 check centered in the box.
    final left = (size.width - 9) / 2;
    final top = (size.height - 5) / 2;
    final path = Path()
      ..moveTo(left + 0.5, top + 2.4)
      ..lineTo(left + 3.4, top + 5)
      ..lineTo(left + 8.6, top + 0.4);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) =>
      color != oldDelegate.color;
}
