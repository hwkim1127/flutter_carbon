import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/carbon_theme.dart';

/// Carbon Design System number input.
///
/// A numeric input field with increment/decrement buttons.
///
/// Example:
/// ```dart
/// CarbonNumberInput(
///   value: 10,
///   min: 0,
///   max: 100,
///   step: 5,
///   onChanged: (value) => print('New value: $value'),
///   label: 'Quantity',
/// )
/// ```
class CarbonNumberInput extends StatefulWidget {
  /// The current value of the input.
  final double? value;

  /// Called when the value changes.
  final ValueChanged<double>? onChanged;

  /// The minimum allowed value.
  final double? min;

  /// The maximum allowed value.
  final double? max;

  /// The step value for increment/decrement.
  final double step;

  /// The label text for the input.
  final String? label;

  /// The helper text displayed below the input.
  final String? helperText;

  /// Whether the input is disabled.
  final bool disabled;

  /// Whether to hide the increment/decrement buttons.
  final bool hideSteppers;

  /// Whether the input is invalid.
  final bool invalid;

  /// The invalid text to show when invalid is true.
  final String? invalidText;

  /// Whether the input is read-only.
  final bool readOnly;

  /// Number of decimal places to show.
  final int? decimalPlaces;

  const CarbonNumberInput({
    super.key,
    this.value,
    this.onChanged,
    this.min,
    this.max,
    this.step = 1,
    this.label,
    this.helperText,
    this.disabled = false,
    this.hideSteppers = false,
    this.invalid = false,
    this.invalidText,
    this.readOnly = false,
    this.decimalPlaces,
  });

  @override
  State<CarbonNumberInput> createState() => _CarbonNumberInputState();
}

class _CarbonNumberInputState extends State<CarbonNumberInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value != null ? _formatValue(widget.value!) : '',
    );
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(CarbonNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text =
          widget.value != null ? _formatValue(widget.value!) : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatValue(double value) {
    if (widget.decimalPlaces != null) {
      return value.toStringAsFixed(widget.decimalPlaces!);
    }
    return value.toString();
  }

  void _increment() {
    if (widget.disabled || widget.readOnly) return;

    final currentValue = widget.value ?? 0;
    final newValue = currentValue + widget.step;

    if (widget.max != null && newValue > widget.max!) return;

    widget.onChanged?.call(newValue);
  }

  void _decrement() {
    if (widget.disabled || widget.readOnly) return;

    final currentValue = widget.value ?? 0;
    final newValue = currentValue - widget.step;

    if (widget.min != null && newValue < widget.min!) return;

    widget.onChanged?.call(newValue);
  }

  void _handleTextChanged(String text) {
    if (text.isEmpty) {
      widget.onChanged?.call(0);
      return;
    }

    final value = double.tryParse(text);
    if (value != null) {
      var clampedValue = value;
      if (widget.min != null && clampedValue < widget.min!) {
        clampedValue = widget.min!;
      }
      if (widget.max != null && clampedValue > widget.max!) {
        clampedValue = widget.max!;
      }
      widget.onChanged?.call(clampedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label!,
              style: TextStyle(
                color: widget.disabled
                    ? carbon.text.textDisabled
                    : carbon.text.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.invalid
                    ? carbon.layer.supportError
                    : (widget.disabled
                        ? carbon.text.textDisabled
                        : carbon.layer.borderStrong01),
                width: _focusNode.hasFocus && !widget.disabled ? 2 : 1,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !widget.disabled,
                  readOnly: widget.readOnly,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
                  ],
                  style: TextStyle(
                    color: widget.disabled
                        ? carbon.text.textDisabled
                        : carbon.text.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    isDense: true,
                  ),
                  onChanged: _handleTextChanged,
                ),
              ),
              if (!widget.hideSteppers)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: carbon.numberInput.controlButtonDivider,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StepperButton(
                        icon: Icons.add,
                        onPressed: widget.disabled || widget.readOnly
                            ? null
                            : _increment,
                      ),
                      Container(
                        height: 1,
                        color: carbon.numberInput.controlButtonDivider,
                      ),
                      _StepperButton(
                        icon: Icons.remove,
                        onPressed: widget.disabled || widget.readOnly
                            ? null
                            : _decrement,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (widget.helperText != null && !widget.invalid)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.helperText!,
              style: TextStyle(
                color: widget.disabled
                    ? carbon.text.textDisabled
                    : carbon.text.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        if (widget.invalid && widget.invalidText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.invalidText!,
              style: TextStyle(color: carbon.layer.supportError, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

/// Internal stepper button widget.
class _StepperButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _StepperButton({required this.icon, this.onPressed});

  @override
  State<_StepperButton> createState() => _StepperButtonState();
}

class _StepperButtonState extends State<_StepperButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final isDisabled = widget.onPressed == null;

    Color backgroundColor;
    if (isDisabled) {
      backgroundColor = carbon.numberInput.controlButtonBackground;
    } else if (_isPressed) {
      backgroundColor = carbon.numberInput.controlButtonBackgroundActive;
    } else if (_isHovered) {
      backgroundColor = carbon.numberInput.controlButtonBackgroundHover;
    } else {
      backgroundColor = carbon.numberInput.controlButtonBackground;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: Container(
          width: 40,
          height: 32,
          color: backgroundColor,
          child: Icon(
            widget.icon,
            size: 16,
            color: isDisabled
                ? carbon.text.iconDisabled
                : carbon.numberInput.controlButtonIcon,
          ),
        ),
      ),
    );
  }
}
