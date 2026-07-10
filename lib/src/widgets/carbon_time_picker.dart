import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../icons/carbon_icons.dart';
import '../text/carbon_editable_core.dart';
import '../text/carbon_text_selection_labels.dart';
import '../theme/carbon_theme.dart';
import 'carbon_select.dart';

/// Field heights for [CarbonTimePicker].
enum CarbonTimePickerSize {
  /// Small: 32px.
  sm(32),

  /// Medium: 40px (default).
  md(40),

  /// Large: 48px.
  lg(48);

  const CarbonTimePickerSize(this.height);

  /// Field height in logical pixels.
  final double height;
}

/// Carbon Design System time picker.
///
/// Per the Carbon spec this is a masked `hh:mm` **text input** plus
/// optional compact selects (AM/PM, timezone) composed in a row — not a
/// clock dial:
///
/// ```dart
/// CarbonTimePicker(
///   labelText: 'Select a time',
///   value: _time,
///   onChanged: (value) => setState(() => _time = value),
///   selects: [
///     CarbonTimePickerSelect<String>(
///       labelText: 'AM/PM',
///       items: const [
///         CarbonSelectItem(value: 'AM', label: 'AM'),
///         CarbonSelectItem(value: 'PM', label: 'PM'),
///       ],
///       value: _period,
///       onChanged: (value) => setState(() => _period = value),
///     ),
///   ],
/// )
/// ```
///
/// The value is a plain string and validation is consumer-driven (drive
/// [invalid] yourself), mirroring React; [time12h] is the spec's 12-hour
/// pattern as a convenience matcher.
class CarbonTimePicker extends StatefulWidget {
  const CarbonTimePicker({
    super.key,
    required this.labelText,
    this.hideLabel = false,
    this.value,
    this.onChanged,
    this.onSubmitted,
    this.placeholder = 'hh:mm',
    this.helperText,
    this.invalid = false,
    this.invalidText,
    this.warn = false,
    this.warnText,
    this.disabled = false,
    this.readOnly = false,
    this.size = CarbonTimePickerSize.md,
    this.maxLength = 5,
    this.inputFormatters,
    this.selectionLabels,
    this.selects = const <Widget>[],
    this.width,
  });

  /// The spec's 12-hour pattern (`1:00`–`12:59`), e.g. for driving
  /// [invalid] on commit.
  static final RegExp time12h = RegExp(r'^(1[012]|[1-9]):[0-5][0-9]$');

  /// The label above the row. Required per Carbon accessibility guidance;
  /// [hideLabel] hides it visually.
  final String labelText;

  final bool hideLabel;

  /// The time string (consumer-owned; no parsing is imposed).
  final String? value;

  /// Fires per keystroke with the raw string.
  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  final String placeholder;

  /// Guidance below the row; replaced by [invalidText]/[warnText].
  final String? helperText;

  /// Error state: 2px `$support-error` outline + icon, widened field.
  final bool invalid;
  final String? invalidText;

  /// Warning state; overridden by [invalid].
  final bool warn;
  final String? warnText;

  final bool disabled;

  /// Read-only: focusable, but typing is rejected and value keys are
  /// swallowed.
  final bool readOnly;

  final CarbonTimePickerSize size;

  /// Enforced with a [LengthLimitingTextInputFormatter].
  final int maxLength;

  /// Defaults to allowing digits and `:` only.
  final List<TextInputFormatter>? inputFormatters;

  /// Context-menu labels; defaults to English.
  final CarbonTextSelectionLabels? selectionLabels;

  /// Trailing widgets ([CarbonTimePickerSelect]s), each separated by the
  /// spec's 2px gap and bottom-aligned with the input.
  final List<Widget> selects;

  /// Overrides the spec input width (78; 98.8 when invalid/warn).
  final double? width;

  @override
  State<CarbonTimePicker> createState() => _CarbonTimePickerState();
}

class _CarbonTimePickerState extends State<CarbonTimePicker> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode(debugLabel: 'CarbonTimePicker');
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
    _focusNode.addListener(_repaint);
    _focusNode.onKeyEvent = _handleKeyEvent;
  }

  @override
  void didUpdateWidget(CarbonTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value &&
        widget.value != _controller.text &&
        !_focusNode.hasFocus) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_repaint);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _repaint() {
    if (mounted) setState(() {});
  }

  /// Read-only fields swallow the value keys so arrows don't fall through
  /// to directional focus traversal — including auto-repeats, which the
  /// app-level arrow shortcuts also act on.
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!widget.readOnly || widget.disabled) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final swallowed =
        key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space;
    return swallowed ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    // Carbon precedence: readOnly > disabled > invalid > warn.
    final readOnly = widget.readOnly;
    final disabled = widget.disabled && !readOnly;
    final invalid = !readOnly && !disabled && widget.invalid;
    final warn = !readOnly && !disabled && !invalid && widget.warn;
    final focused = _focusNode.hasFocus;
    final showsIcon = invalid || warn;

    final Color background;
    final Color bottomBorder;
    if (readOnly) {
      background = CarbonPalette.transparent;
      bottomBorder = carbon.layer.borderSubtle01;
    } else if (disabled) {
      background = carbon.layer.field01;
      bottomBorder = CarbonPalette.transparent;
    } else {
      background = _hovered && !focused
          ? carbon.layer.fieldHover01
          : carbon.layer.field01;
      bottomBorder = carbon.layer.borderStrong01;
    }
    final Color outline = focused && !disabled
        ? carbon.layer.focus
        : invalid
        ? carbon.layer.supportError
        : CarbonPalette.transparent;
    final textColor = disabled
        ? carbon.text.textDisabled
        : carbon.text.textPrimary;

    final String? statusText;
    final Color statusColor;
    if (invalid) {
      statusText = widget.invalidText ?? widget.helperText;
      statusColor = carbon.text.textError;
    } else if (warn) {
      statusText = widget.warnText ?? widget.helperText;
      statusColor = carbon.text.textHelper;
    } else {
      statusText = widget.helperText;
      statusColor = disabled
          ? carbon.text.textDisabled
          : carbon.text.textHelper;
    }

    final input = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.text,
      child: GestureDetector(
        onTap: disabled ? null : () => _focusNode.requestFocus(),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: CarbonMotion.fast01,
          curve: CarbonMotion.standardProductive,
          width: widget.width ?? (showsIcon ? 98.8 : 78),
          height: widget.size.height,
          decoration: BoxDecoration(
            color: background,
            border: Border(bottom: BorderSide(color: bottomBorder)),
          ),
          foregroundDecoration: BoxDecoration(
            border: Border.all(color: outline, width: 2),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 16,
                  end: showsIcon ? 40 : 16,
                ),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CarbonEditableCore(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: CarbonTypography.code02.copyWith(color: textColor),
                    placeholder: widget.placeholder,
                    placeholderStyle: CarbonTypography.code02.copyWith(
                      color: disabled
                          ? carbon.text.textDisabled
                          : carbon.text.textPlaceholder,
                    ),
                    enabled: !disabled,
                    readOnly: readOnly,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      ...widget.inputFormatters ??
                          [FilteringTextInputFormatter.allow(RegExp(r'[\d:]'))],
                      LengthLimitingTextInputFormatter(widget.maxLength),
                    ],
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    selectionLabels: widget.selectionLabels,
                  ),
                ),
              ),
              if (showsIcon)
                PositionedDirectional(
                  end: 16,
                  top: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Icon(
                        invalid
                            ? CarbonIcons.warningFilled
                            : CarbonIcons.warningAltFilled,
                        size: 16,
                        color: invalid
                            ? carbon.layer.supportError
                            : carbon.layer.supportWarning,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.hideLabel) ...[
          Text(
            widget.labelText,
            style: CarbonTypography.label01.copyWith(
              color: disabled
                  ? carbon.text.textDisabled
                  : carbon.text.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            input,
            for (final select in widget.selects) ...[
              const SizedBox(width: 2),
              select,
            ],
          ],
        ),
        if (statusText != null) ...[
          const SizedBox(height: 4),
          Text(
            statusText,
            style: CarbonTypography.helperText01.copyWith(color: statusColor),
          ),
        ],
      ],
    );

    if (widget.hideLabel) {
      return Semantics(label: widget.labelText, child: column);
    }
    return column;
  }
}

/// The compact, label-less select that accompanies [CarbonTimePicker]
/// (AM/PM, timezone). A thin wrapper over [CarbonSelect] with the label
/// hidden — the consumer supplies the options, like React's
/// `TimePickerSelect`.
class CarbonTimePickerSelect<T> extends StatelessWidget {
  const CarbonTimePickerSelect({
    super.key,
    required this.labelText,
    required this.items,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.readOnly = false,
    this.size = CarbonSelectSize.md,
    this.width,
  });

  /// Accessible name only — never rendered (per spec).
  final String labelText;

  /// The options (e.g. AM/PM); not built in, matching React.
  final List<CarbonSelectItem<T>> items;

  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool disabled;
  final bool readOnly;

  /// Match the time input's size ([CarbonSelectSize] heights align).
  final CarbonSelectSize size;

  /// Fixed width; defaults to intrinsic (text + chevron).
  final double? width;

  @override
  Widget build(BuildContext context) {
    return CarbonSelect<T>(
      labelText: labelText,
      hideLabel: true,
      items: items,
      value: value,
      onChanged: onChanged,
      disabled: disabled,
      readOnly: readOnly,
      size: size,
      width: width,
    );
  }
}
