import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../icons/carbon_icons.dart';
import '../text/carbon_editable_core.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// The values reported by [CarbonSlider.onChanged] / [CarbonSlider.onRelease]
/// (mirrors React's `onChange({value, valueUpper})`).
class CarbonSliderChange {
  const CarbonSliderChange({required this.value, this.valueUpper});

  /// The (lower, in range mode) handle value.
  final double value;

  /// The upper handle value; non-null only in range mode.
  final double? valueUpper;

  @override
  String toString() => 'CarbonSliderChange(value: $value'
      '${valueUpper != null ? ', valueUpper: $valueUpper' : ''})';
}

enum _SliderThumb { lower, upper }

/// Carbon Design System slider.
///
/// Fully controlled: the widget never stores the value — it snaps, clamps,
/// and reports through [onChanged] (during drags and per keystroke) and
/// [onRelease] (pointer-up / input commit).
///
/// Passing [valueUpper] enables the two-handle range mode: the filled track
/// runs between the handles, track taps move the nearest handle, and the
/// handles cannot cross.
///
/// Keyboard (per focused handle): arrows move by [step], Shift+arrows by
/// `step × stepMultiplier`, Home/End jump to the handle's bounds.
///
/// Deliberate spec deviations (follow-ups): the focused thumb is a solid
/// `$interactive` circle instead of the double inset ring; range handles are
/// circles rather than the 24×16 directional handles; out-of-range typed
/// values clamp on commit instead of flagging a transient invalid state.
class CarbonSlider extends StatefulWidget {
  const CarbonSlider({
    super.key,
    this.labelText,
    this.hideLabel = false,
    required this.min,
    required this.max,
    required this.value,
    this.valueUpper,
    this.step = 1,
    this.stepMultiplier = 4,
    this.minLabel,
    this.maxLabel,
    this.formatLabel,
    this.hideTextInput = false,
    this.disabled = false,
    this.readOnly = false,
    this.invalid = false,
    this.invalidText,
    this.warn = false,
    this.warnText,
    this.onChanged,
    this.onRelease,
  }) : assert(min < max, 'min must be less than max'),
       assert(step > 0, 'step must be positive'),
       assert(stepMultiplier > 0, 'stepMultiplier must be positive'),
       assert(
         value >= min && value <= max,
         'value must be within [min, max]',
       ),
       assert(
         valueUpper == null || (valueUpper >= value && valueUpper <= max),
         'valueUpper must be within [value, max]',
       );

  /// The label above the slider.
  final String? labelText;

  /// Visually hides [labelText] (still announced by assistive tech).
  final bool hideLabel;

  final double min;
  final double max;

  /// The (lower) handle value.
  final double value;

  /// Enables range mode when non-null: the upper handle value.
  final double? valueUpper;

  /// Keyboard/snap increment.
  final double step;

  /// Shift+arrow multiplier.
  final double stepMultiplier;

  /// Range label at the start; defaults to the formatted [min].
  final String? minLabel;

  /// Range label at the end; defaults to the formatted [max].
  final String? maxLabel;

  /// Formats the range labels and the handle's semantic value.
  final String Function(double value, String? label)? formatLabel;

  /// Hides the embedded number input.
  final bool hideTextInput;

  final bool disabled;

  /// Read-only: handles stay focusable, but nothing changes the value.
  final bool readOnly;

  /// Error state on the number input; [invalidText] below the slider.
  final bool invalid;
  final String? invalidText;

  /// Warning state; [warnText] below. Overridden by [invalid].
  final bool warn;
  final String? warnText;

  /// Fired while dragging, per keystroke, and on input commit.
  final ValueChanged<CarbonSliderChange>? onChanged;

  /// Fired on pointer-up, arrow-key release, and input commit.
  final ValueChanged<CarbonSliderChange>? onRelease;

  /// Snaps [raw] to the nearest [step] from [min] and clamps to
  /// `[min, max]`. Exposed for tests.
  @visibleForTesting
  static double snapValue(double raw, double min, double max, double step) {
    final stepped = min + ((raw - min) / step).round() * step;
    return stepped.clamp(min, max);
  }

  /// Maps a track-relative ratio (0..1, start-relative) to a snapped value.
  /// Exposed for tests.
  @visibleForTesting
  static double valueForRatio(
    double ratio,
    double min,
    double max,
    double step,
  ) {
    return snapValue(min + ratio.clamp(0.0, 1.0) * (max - min), min, max, step);
  }

  @override
  State<CarbonSlider> createState() => _CarbonSliderState();
}

class _CarbonSliderState extends State<CarbonSlider> {
  static const double _thumbRest = 14;
  static const double _thumbActive = 20;
  static const double _hitSize = 28;

  final FocusNode _lowerFocus = FocusNode(debugLabel: 'CarbonSlider.lower');
  final FocusNode _upperFocus = FocusNode(debugLabel: 'CarbonSlider.upper');

  _SliderThumb? _dragging;
  _SliderThumb? _hovered;

  /// Thumb picked at pointer-down (drag acceptance happens after touch
  /// slop, by which point the pointer may sit closer to the other handle).
  _SliderThumb? _pendingThumb;

  /// The last values emitted through [CarbonSlider.onChanged] during the
  /// current interaction. The widget is controlled, so `widget.value` lags
  /// one frame behind — releases and follow-up updates read these instead.
  CarbonSliderChange? _pendingChange;

  /// Set when an arrow keydown changed the value; the matching keyup fires
  /// [CarbonSlider.onRelease].
  bool _keyboardDirty = false;

  /// Track width captured from the last layout pass, for gesture math.
  double _trackWidth = 0;

  bool get _isRange => widget.valueUpper != null;
  bool get _interactive => !widget.disabled && !widget.readOnly;

  /// Latest lower value: emitted-but-not-yet-applied, or the widget's.
  double get _currentLower => _pendingChange?.value ?? widget.value;

  /// Latest upper value (null outside range mode).
  double? get _currentUpper =>
      _pendingChange != null ? _pendingChange!.valueUpper : widget.valueUpper;

  @override
  void initState() {
    super.initState();
    _lowerFocus.addListener(_repaint);
    _upperFocus.addListener(_repaint);
  }

  @override
  void didUpdateWidget(CarbonSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The parent applied (or overrode) the emitted values — the widget's
    // are authoritative again.
    if (widget.value != oldWidget.value ||
        widget.valueUpper != oldWidget.valueUpper) {
      _pendingChange = null;
    }
  }

  @override
  void dispose() {
    _lowerFocus.dispose();
    _upperFocus.dispose();
    super.dispose();
  }

  void _repaint() {
    if (mounted) setState(() {});
  }

  String _format(double value, [String? label]) {
    final formatter = widget.formatLabel;
    if (formatter != null) return formatter(value, label);
    if (label != null) return label;
    return value == value.roundToDouble()
        ? value.round().toString()
        : value.toString();
  }

  double _ratioOf(double value) =>
      (value - widget.min) / (widget.max - widget.min);

  /// Converts a gesture x position to a start-relative (RTL-aware) ratio.
  double _ratioForDx(double dx, TextDirection direction) {
    if (_trackWidth <= 0) return 0;
    final logical = direction == TextDirection.rtl ? _trackWidth - dx : dx;
    return logical / _trackWidth;
  }

  (double, double) _boundsOf(_SliderThumb thumb) {
    // No-crossing rule: each handle is bounded by the other.
    if (!_isRange) return (widget.min, widget.max);
    return thumb == _SliderThumb.lower
        ? (widget.min, _currentUpper!)
        : (_currentLower, widget.max);
  }

  double _valueOf(_SliderThumb thumb) =>
      thumb == _SliderThumb.upper ? _currentUpper! : _currentLower;

  void _setThumbValue(_SliderThumb thumb, double raw) {
    final (lower, upper) = _boundsOf(thumb);
    final snapped = CarbonSlider.snapValue(
      raw,
      widget.min,
      widget.max,
      widget.step,
    ).clamp(lower, upper);
    if (snapped == _valueOf(thumb)) return;
    final change = thumb == _SliderThumb.upper
        ? CarbonSliderChange(value: _currentLower, valueUpper: snapped)
        : CarbonSliderChange(value: snapped, valueUpper: _currentUpper);
    _pendingChange = change;
    widget.onChanged?.call(change);
  }

  void _release() {
    final change =
        _pendingChange ??
        CarbonSliderChange(value: widget.value, valueUpper: widget.valueUpper);
    _pendingChange = null;
    widget.onRelease?.call(change);
  }

  _SliderThumb _thumbForRatio(double ratio) {
    if (!_isRange) return _SliderThumb.lower;
    final target = widget.min + ratio * (widget.max - widget.min);
    final lowerDistance = (target - _currentLower).abs();
    final upperDistance = (target - _currentUpper!).abs();
    if (lowerDistance == upperDistance) {
      // Tie (overlapping handles): past them moves the upper one.
      return target > _currentLower ? _SliderThumb.upper : _SliderThumb.lower;
    }
    return lowerDistance < upperDistance
        ? _SliderThumb.lower
        : _SliderThumb.upper;
  }

  /// Pointer-down: remember which thumb this interaction targets before
  /// drag acceptance moves the position by the touch slop.
  void _prepareGesture(Offset local, TextDirection direction) {
    _pendingThumb = _thumbForRatio(_ratioForDx(local.dx, direction));
  }

  void _startGesture(Offset local, TextDirection direction) {
    final ratio = _ratioForDx(local.dx, direction);
    final thumb = _pendingThumb ?? _thumbForRatio(ratio);
    (thumb == _SliderThumb.upper ? _upperFocus : _lowerFocus).requestFocus();
    setState(() => _dragging = thumb);
    _setThumbValue(
      thumb,
      widget.min + ratio.clamp(0.0, 1.0) * (widget.max - widget.min),
    );
  }

  void _updateGesture(Offset local, TextDirection direction) {
    final thumb = _dragging;
    if (thumb == null) return;
    final ratio = _ratioForDx(local.dx, direction).clamp(0.0, 1.0);
    _setThumbValue(
      thumb,
      widget.min + ratio * (widget.max - widget.min),
    );
  }

  void _endGesture() {
    _pendingThumb = null;
    if (_dragging == null) return;
    setState(() => _dragging = null);
    _release();
  }

  static final Set<LogicalKeyboardKey> _arrowKeys = {
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
  };

  static final Set<LogicalKeyboardKey> _valueKeys = {
    ..._arrowKeys,
    LogicalKeyboardKey.home,
    LogicalKeyboardKey.end,
  };

  KeyEventResult _handleThumbKey(
    _SliderThumb thumb,
    FocusNode node,
    KeyEvent event,
  ) {
    final key = event.logicalKey;
    final arrows = _arrowKeys;

    // Read-only: the handle is focusable but the value keys are inert —
    // swallow them so arrows don't fall through to directional focus
    // traversal and yank focus elsewhere.
    if (widget.readOnly && !widget.disabled) {
      return _valueKeys.contains(key)
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
    }
    if (!_interactive) return KeyEventResult.ignored;

    if (event is KeyUpEvent) {
      if (arrows.contains(key) && _keyboardDirty) {
        _keyboardDirty = false;
        _release();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final direction = Directionality.of(context);
    final rtl = direction == TextDirection.rtl;
    final increment =
        widget.step *
        (HardwareKeyboard.instance.isShiftPressed ? widget.stepMultiplier : 1);
    final current = _valueOf(thumb);
    final (lowerBound, upperBound) = _boundsOf(thumb);

    double? target;
    if (key == LogicalKeyboardKey.arrowUp) {
      target = current + increment;
    } else if (key == LogicalKeyboardKey.arrowDown) {
      target = current - increment;
    } else if (key == LogicalKeyboardKey.arrowRight) {
      target = rtl ? current - increment : current + increment;
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      target = rtl ? current + increment : current - increment;
    } else if (key == LogicalKeyboardKey.home) {
      target = lowerBound;
    } else if (key == LogicalKeyboardKey.end) {
      target = upperBound;
    }
    if (target == null) return KeyEventResult.ignored;

    _setThumbValue(thumb, target);
    if (arrows.contains(key)) {
      _keyboardDirty = true;
    } else {
      // Home/End have no repeat semantics — release immediately.
      _release();
    }
    return KeyEventResult.handled;
  }

  void _commitInput(_SliderThumb thumb, double raw) {
    _setThumbValue(thumb, raw);
    _release();
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final disabled = widget.disabled;
    final invalid = !disabled && widget.invalid;
    final warn = !disabled && !invalid && widget.warn;

    final labelColor = disabled
        ? carbon.text.textDisabled
        : carbon.text.textSecondary;
    final rangeLabelColor = disabled
        ? carbon.text.textDisabled
        : carbon.text.textPrimary;

    final String? statusText;
    final Color statusColor;
    if (invalid) {
      statusText = widget.invalidText;
      statusColor = carbon.text.textError;
    } else if (warn) {
      statusText = widget.warnText;
      statusColor = carbon.text.textHelper;
    } else {
      statusText = null;
      statusColor = carbon.text.textHelper;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null && !widget.hideLabel) ...[
          Text(
            widget.labelText!,
            style: CarbonTypography.label01.copyWith(color: labelColor),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Text(
              _format(widget.min, widget.minLabel),
              style: CarbonTypography.bodyCompact01.copyWith(
                color: rangeLabelColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              // Align loosens Expanded's tight constraints — otherwise the
              // spec's 640px max-width could never take effect.
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 200,
                    maxWidth: 640,
                  ),
                  child: _buildBody(context),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              _format(widget.max, widget.maxLabel),
              style: CarbonTypography.bodyCompact01.copyWith(
                color: rangeLabelColor,
              ),
            ),
            if (!widget.hideTextInput) ...[
              const SizedBox(width: 16),
              _SliderInput(
                value: widget.value,
                widened: invalid || warn,
                invalid: invalid,
                warn: warn,
                disabled: disabled,
                readOnly: widget.readOnly,
                onCommit: (raw) => _commitInput(_SliderThumb.lower, raw),
              ),
              if (_isRange) ...[
                const SizedBox(width: 16),
                _SliderInput(
                  value: widget.valueUpper!,
                  widened: invalid || warn,
                  invalid: invalid,
                  warn: warn,
                  disabled: disabled,
                  readOnly: widget.readOnly,
                  onCommit: (raw) => _commitInput(_SliderThumb.upper, raw),
                ),
              ],
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
  }

  Widget _buildBody(BuildContext context) {
    final direction = Directionality.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragDown: _interactive
          ? (details) => _prepareGesture(details.localPosition, direction)
          : null,
      onTapDown: _interactive
          ? (details) => _startGesture(details.localPosition, direction)
          : null,
      onTapUp: _interactive ? (_) => _endGesture() : null,
      onTapCancel: _interactive ? _endGesture : null,
      onHorizontalDragStart: _interactive
          ? (details) => _startGesture(details.localPosition, direction)
          : null,
      onHorizontalDragUpdate: _interactive
          ? (details) => _updateGesture(details.localPosition, direction)
          : null,
      onHorizontalDragEnd: _interactive ? (_) => _endGesture() : null,
      onHorizontalDragCancel: _interactive ? _endGesture : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
          height: _thumbActive,
          child: LayoutBuilder(
            builder: (context, constraints) {
              _trackWidth = constraints.maxWidth;
              return _buildTrackStack(context, constraints.maxWidth);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTrackStack(BuildContext context, double width) {
    final carbon = context.carbon;
    final disabled = widget.disabled;

    final lowerX = _ratioOf(widget.value) * width;
    final upperX = _isRange ? _ratioOf(widget.valueUpper!) * width : lowerX;
    final fillStart = _isRange ? lowerX : 0.0;
    final fillEnd = _isRange ? upperX : lowerX;

    final thumbEngaged =
        _dragging != null || _lowerFocus.hasFocus || _upperFocus.hasFocus;
    final Color fillColor = disabled
        ? carbon.layer.borderDisabled
        : thumbEngaged
        ? carbon.layer.borderInteractive
        : carbon.layer.layerSelectedInverse;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Full track.
        Positioned.fill(
          top: (_thumbActive - 2) / 2,
          bottom: (_thumbActive - 2) / 2,
          child: ColoredBox(color: carbon.layer.borderSubtle01),
        ),
        // Filled segment: geometry immediate (drags must not lag), only the
        // color animates.
        PositionedDirectional(
          start: fillStart,
          width: (fillEnd - fillStart).clamp(0.0, width),
          top: (_thumbActive - 2) / 2,
          height: 2,
          child: AnimatedContainer(
            duration: CarbonMotion.fast02,
            curve: CarbonMotion.standardProductive,
            color: fillColor,
          ),
        ),
        _buildThumb(carbon, _SliderThumb.lower, lowerX, _lowerFocus),
        if (_isRange)
          _buildThumb(carbon, _SliderThumb.upper, upperX, _upperFocus),
      ],
    );
  }

  Widget _buildThumb(
    CarbonThemeData carbon,
    _SliderThumb thumb,
    double x,
    FocusNode focusNode,
  ) {
    final disabled = widget.disabled;
    final focused = focusNode.hasFocus;
    final engaged =
        !disabled && (focused || _hovered == thumb || _dragging == thumb);
    final diameter = engaged ? _thumbActive : _thumbRest;
    final Color color = disabled
        ? carbon.layer.borderDisabled
        : focused
        ? carbon.layer.interactive
        : carbon.layer.layerSelectedInverse;

    final formatted = _format(_valueOf(thumb));
    final (lowerBound, upperBound) = _boundsOf(thumb);
    final increased = (_valueOf(thumb) + widget.step).clamp(
      lowerBound,
      upperBound,
    );
    final decreased = (_valueOf(thumb) - widget.step).clamp(
      lowerBound,
      upperBound,
    );

    return PositionedDirectional(
      start: x - _hitSize / 2,
      top: (_thumbActive - _hitSize) / 2,
      width: _hitSize,
      height: _hitSize,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = thumb),
        onExit: (_) {
          if (_hovered == thumb) setState(() => _hovered = null);
        },
        cursor: _interactive
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: Focus(
          focusNode: focusNode,
          canRequestFocus: !disabled,
          onKeyEvent: (node, event) => _handleThumbKey(thumb, node, event),
          child: Semantics(
            slider: true,
            label: widget.labelText,
            value: formatted,
            increasedValue: _format(increased),
            decreasedValue: _format(decreased),
            enabled: _interactive,
            onIncrease: _interactive
                ? () {
                    _setThumbValue(thumb, increased);
                    _release();
                  }
                : null,
            onDecrease: _interactive
                ? () {
                    _setThumbValue(thumb, decreased);
                    _release();
                  }
                : null,
            child: Center(
              child: AnimatedContainer(
                duration: CarbonMotion.fast01,
                curve: CarbonMotion.standardProductive,
                width: diameter,
                height: diameter,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The slider's embedded number field: 40×64 (96 wide with a status icon),
/// centered text, commit on submit or focus loss.
class _SliderInput extends StatefulWidget {
  const _SliderInput({
    required this.value,
    required this.widened,
    required this.invalid,
    required this.warn,
    required this.disabled,
    required this.readOnly,
    required this.onCommit,
  });

  final double value;
  final bool widened;
  final bool invalid;
  final bool warn;
  final bool disabled;
  final bool readOnly;

  /// Called with the parsed raw value; the parent snaps/clamps and reports.
  final ValueChanged<double> onCommit;

  @override
  State<_SliderInput> createState() => _SliderInputState();
}

class _SliderInputState extends State<_SliderInput> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode(debugLabel: 'CarbonSliderInput');

  /// Text of the last commit of this focus session — submitting with Enter
  /// also blurs, and the blur commit must not re-fire the callbacks.
  String? _lastCommittedText;

  static String _formatValue(double value) => value == value.roundToDouble()
      ? value.round().toString()
      : value.toString();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.value));
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(_SliderInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Never fight the user's typing: sync only while unfocused.
    if (!_focusNode.hasFocus && widget.value != oldWidget.value) {
      _controller.text = _formatValue(widget.value);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) setState(() {});
    if (_focusNode.hasFocus) {
      _lastCommittedText = null;
    } else {
      _commit();
    }
  }

  void _commit() {
    final text = _controller.text.trim();
    if (text == _lastCommittedText) return;
    _lastCommittedText = text;
    final parsed = double.tryParse(text);
    if (parsed == null) {
      // Unparsable: restore the current value.
      _controller.text = _formatValue(widget.value);
      return;
    }
    widget.onCommit(parsed);
    // The parent clamps; reflect the committed value even while focused
    // (didUpdateWidget skips focused syncs).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.text = _formatValue(widget.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final disabled = widget.disabled;
    final showsIcon = widget.widened && (widget.invalid || widget.warn);

    final Color outline = _focusNode.hasFocus && !disabled
        ? carbon.layer.focus
        : widget.invalid
        ? carbon.layer.supportError
        : CarbonPalette.transparent;

    return AnimatedContainer(
      duration: CarbonMotion.fast01,
      curve: CarbonMotion.standardProductive,
      width: widget.widened ? 96 : 64,
      height: 40,
      decoration: BoxDecoration(
        color: carbon.layer.field01,
        border: Border(
          bottom: BorderSide(
            color: disabled
                ? CarbonPalette.transparent
                : carbon.layer.borderStrong01,
          ),
        ),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: outline, width: 2),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: 8,
              end: showsIcon ? 32 : 8,
            ),
            child: Align(
              child: CarbonEditableCore(
                controller: _controller,
                focusNode: _focusNode,
                style: CarbonTypography.bodyCompact01.copyWith(
                  color: disabled
                      ? carbon.text.textDisabled
                      : carbon.text.textPrimary,
                ),
                enabled: !disabled,
                readOnly: widget.readOnly,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
                ],
                onSubmitted: (_) => _commit(),
              ),
            ),
          ),
          if (showsIcon)
            PositionedDirectional(
              end: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  widget.invalid
                      ? CarbonIcons.warningFilled
                      : CarbonIcons.warningAltFilled,
                  size: 16,
                  color: widget.invalid
                      ? carbon.layer.supportError
                      : carbon.layer.supportWarning,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
