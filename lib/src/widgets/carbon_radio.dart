import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show KeyDownEvent, LogicalKeyboardKey;

import '../foundation/colors.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// A Carbon Design System radio button.
///
/// Drawn to the Carbon spec on the widgets layer (no Material dependency):
/// 18×18 circle with 1px `$icon-primary` border and an 8px inner dot when
/// selected.
///
/// The API mirrors Material's `Radio` for easy migration: the button is
/// selected when [value] equals [groupValue], and reports [value] through
/// [onChanged] when activated.
///
/// Example:
/// ```dart
/// CarbonRadio<int>(
///   value: 1,
///   groupValue: _selected,
///   onChanged: (value) => setState(() => _selected = value),
///   label: 'Option one',
/// )
/// ```
class CarbonRadio<T> extends StatefulWidget {
  /// The value this radio button represents.
  final T value;

  /// The currently selected value of the group.
  final T? groupValue;

  /// Called with [value] when this button is selected. `null` disables it.
  final ValueChanged<T?>? onChanged;

  /// Optional label displayed to the right of the button.
  final String? label;

  /// Whether to render the error state (border `$support-error`).
  final bool invalid;

  const CarbonRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.invalid = false,
  });

  bool get enabled => onChanged != null;

  bool get selected => value == groupValue;

  @override
  State<CarbonRadio<T>> createState() => _CarbonRadioState<T>();
}

class _CarbonRadioState<T> extends State<CarbonRadio<T>> {
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

  void _select() {
    if (!widget.enabled) return;
    widget.onChanged!(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    // MergeSemantics folds the checked state and the label Text into one
    // node, so screen readers announce the label once, with the state.
    return MergeSemantics(
      child: Semantics(
        checked: widget.selected,
        inMutuallyExclusiveGroup: true,
        enabled: widget.enabled,
        child: MouseRegion(
          cursor: widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          child: GestureDetector(
            onTap: _select,
            behavior: HitTestBehavior.opaque,
            child: Focus(
              focusNode: _focusNode,
              canRequestFocus: widget.enabled,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.space) {
                  _select();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCircle(carbon),
                  if (widget.label != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      widget.label!,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.43,
                        letterSpacing: 0.16,
                        color: widget.enabled
                            ? carbon.text.textPrimary
                            : carbon.text.textDisabled,
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

  Widget _buildCircle(CarbonThemeData carbon) {
    final Color borderColor;
    final Color dotColor;
    if (!widget.enabled) {
      borderColor = carbon.text.iconDisabled;
      dotColor = carbon.text.textDisabled;
    } else if (widget.invalid) {
      borderColor = carbon.layer.supportError;
      dotColor = carbon.text.iconPrimary;
    } else {
      borderColor = carbon.text.iconPrimary;
      dotColor = carbon.text.iconPrimary;
    }

    // 2px focus ring with a 1px gap around the 18px circle (total 24px).
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _isFocused && widget.enabled
              ? carbon.layer.focus
              : CarbonPalette.transparent,
          width: 2,
        ),
      ),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: widget.selected
            ? Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
