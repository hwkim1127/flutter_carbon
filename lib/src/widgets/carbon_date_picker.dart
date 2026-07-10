import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../base/carbon_anchored_overlay.dart';
import '../base/carbon_overlay_surface.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../icons/carbon_icons.dart';
import '../text/carbon_editable_core.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';
import 'carbon_calendar_panel.dart';
import 'carbon_date_utils.dart';

/// English strings for [CarbonDatePicker]'s calendar; override for other
/// locales (the package carries no localization dependency).
///
/// Follows the `CarbonTextSelectionLabels` shape: const class, defaulted
/// English fields, an `.en()` factory.
class CarbonDatePickerLabels {
  const CarbonDatePickerLabels({
    this.monthNames = const [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ],
    this.weekdayLabels = const ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
    this.previousMonth = 'Previous month',
    this.nextMonth = 'Next month',
    this.openCalendar = 'Open calendar',
    this.year = 'Year',
  });
  // List lengths can't be asserted in a const constructor — the calendar
  // panel asserts monthNames.length == 12 && weekdayLabels.length == 7 in
  // debug builds when it consumes the labels.

  /// The English defaults.
  factory CarbonDatePickerLabels.en() => const CarbonDatePickerLabels();

  /// Month names, January first (must have exactly 12 entries). Used in
  /// the calendar header and day-cell semantics.
  final List<String> monthNames;

  /// Weekday column labels (must have exactly 7 entries), **Sunday-first**
  /// regardless of the picker's `firstDayOfWeek` — the calendar rotates
  /// them itself; do not pre-rotate.
  final List<String> weekdayLabels;

  /// Semantic label for the previous-month button.
  final String previousMonth;

  /// Semantic label for the next-month button.
  final String nextMonth;

  /// Semantic label for the calendar icon / open action.
  final String openCalendar;

  /// Semantic label for the year input in the calendar header.
  final String year;
}

/// The three Carbon date-picker layouts.
enum CarbonDatePickerVariant {
  /// A plain masked input — no calendar popup.
  simple,

  /// One input with the calendar popup (default).
  single,

  /// Two inputs (start/end) sharing one calendar.
  range,
}

/// Field heights for [CarbonDatePicker].
enum CarbonDatePickerSize {
  /// Small: 32px.
  sm(32),

  /// Medium: 40px (default).
  md(40),

  /// Large: 48px.
  lg(48);

  const CarbonDatePickerSize(this.height);

  /// Field height in logical pixels.
  final double height;
}

/// Carbon Design System date picker.
///
/// Three variants: [CarbonDatePickerVariant.simple] is a plain masked
/// `m/d/Y` input, [CarbonDatePickerVariant.single] adds the calendar popup,
/// and [CarbonDatePickerVariant.range] renders two inputs sharing one
/// calendar (in-range days highlighted; picking a day before the current
/// start restarts the range).
///
/// Fully controlled: pass [value] (and [endValue] in range mode) and apply
/// changes from [onChanged] / [onRangeChanged]. Typed input commits on
/// Enter or blur; unparsable text is left as typed and fires nothing (drive
/// the [invalid] flag yourself, like React). Selectable dates are capped to
/// years 1–9999 and further bounded by [minDate]/[maxDate].
///
/// Keyboard: any tap on the field opens the calendar; ArrowDown moves focus
/// into the day grid (arrows/PageUp/PageDown/Home/End navigate, Enter
/// selects); Escape closes and returns focus to the input.
class CarbonDatePicker extends StatefulWidget {
  CarbonDatePicker({
    super.key,
    this.variant = CarbonDatePickerVariant.single,
    required this.labelText,
    this.endLabelText,
    this.hideLabel = false,
    this.value,
    this.endValue,
    this.onChanged,
    this.onRangeChanged,
    this.placeholder = 'mm/dd/yyyy',
    this.helperText,
    this.invalid = false,
    this.invalidText,
    this.warn = false,
    this.warnText,
    this.disabled = false,
    this.readOnly = false,
    this.size = CarbonDatePickerSize.md,
    this.minDate,
    this.maxDate,
    this.closeOnSelect = true,
    this.allowInput = true,
    this.firstDayOfWeek = 0,
    this.labels,
    this.formatDate,
    this.parseDate,
    this.width,
  }) : assert(
         variant != CarbonDatePickerVariant.range || endLabelText != null,
         'range mode needs endLabelText',
       ),
       assert(
         variant != CarbonDatePickerVariant.range || onChanged == null,
         'range mode reports through onRangeChanged',
       ),
       assert(
         variant == CarbonDatePickerVariant.range ||
             (endValue == null && onRangeChanged == null),
         'endValue/onRangeChanged are range-mode only',
       ),
       assert(
         minDate == null || maxDate == null || !maxDate.isBefore(minDate),
         'minDate must not be after maxDate',
       ),
       assert(
         value == null || (value.year >= 1 && value.year <= 9999),
         'value must be within years 1-9999',
       ),
       assert(
         endValue == null || (endValue.year >= 1 && endValue.year <= 9999),
         'endValue must be within years 1-9999',
       ),
       assert(
         value == null || endValue == null || !endValue.isBefore(value),
         'endValue must not be before value',
       ),
       assert(firstDayOfWeek >= 0 && firstDayOfWeek <= 6);

  final CarbonDatePickerVariant variant;

  /// Label above the (start) input. Required per Carbon accessibility
  /// guidance; [hideLabel] hides it visually.
  final String labelText;

  /// Label above the end input (range mode; required there).
  final String? endLabelText;

  /// Visually hides the labels (still announced by assistive tech).
  final bool hideLabel;

  /// The selected date (range mode: the range start).
  final DateTime? value;

  /// The range end (range mode only).
  final DateTime? endValue;

  /// Simple/single: fires with the picked/typed date, or null when the
  /// input is cleared.
  final ValueChanged<DateTime?>? onChanged;

  /// Range: fires with the current (start, end) pair; end is null while
  /// the second pick is pending.
  final void Function(DateTime? start, DateTime? end)? onRangeChanged;

  /// Hint shown while an input is empty.
  final String placeholder;

  /// Guidance below the field; replaced by [invalidText]/[warnText].
  final String? helperText;

  /// Error state: 2px `$support-error` outline + icon (replacing the
  /// calendar icon); [invalidText] below.
  final bool invalid;
  final String? invalidText;

  /// Warning state; overridden by [invalid].
  final bool warn;
  final String? warnText;

  final bool disabled;

  /// Read-only: focusable, but the calendar never opens and typing is
  /// rejected.
  final bool readOnly;

  final CarbonDatePickerSize size;

  /// Selection bounds (date-only compared), intersected with the hard
  /// year 1–9999 cap.
  final DateTime? minDate;
  final DateTime? maxDate;

  /// Whether completing a selection closes the calendar (range: after the
  /// end pick).
  final bool closeOnSelect;

  /// Whether the date can be typed. When false the input is read-only but
  /// the field still opens the calendar (which takes keyboard focus).
  final bool allowInput;

  /// First day of the week: 0 = Sunday (default) … 6 = Saturday.
  final int firstDayOfWeek;

  /// Calendar strings; defaults to English.
  final CarbonDatePickerLabels? labels;

  /// Overrides the default `m/d/Y` formatting.
  final String Function(DateTime date)? formatDate;

  /// Overrides the default `m/d/Y` parsing (return null to reject).
  final DateTime? Function(String text)? parseDate;

  /// Overrides the spec default field width (per input in range mode:
  /// simple 120/152, single 288, range 143.5).
  final double? width;

  @override
  State<CarbonDatePicker> createState() => _CarbonDatePickerState();
}

/// Visual state in Carbon's precedence order.
enum _FieldState { readOnly, disabled, invalid, warn, normal }

class _CarbonDatePickerState extends State<CarbonDatePicker> {
  final GlobalKey _startFieldKey = GlobalKey();
  final GlobalKey<CarbonCalendarPanelState> _panelKey =
      GlobalKey<CarbonCalendarPanelState>();

  late final TextEditingController _startController;
  late final TextEditingController _endController;
  final FocusNode _startFocus = FocusNode(debugLabel: 'CarbonDatePicker');
  final FocusNode _endFocus = FocusNode(debugLabel: 'CarbonDatePicker.end');

  OverlayEntry? _entry;
  bool _isOpen = false;
  bool _startHovered = false;
  bool _endHovered = false;

  /// Which input the open calendar belongs to visually (outline holder).
  bool _activeEnd = false;

  /// The latest values fired through the callbacks. The widget is
  /// controlled, so `widget.value` lags one frame behind — same-event
  /// sequences (blur-commit followed by a day tap) must read these.
  DateTime? _latestStart;
  DateTime? _latestEnd;

  bool get _isRange => widget.variant == CarbonDatePickerVariant.range;
  bool get _hasCalendar => widget.variant != CarbonDatePickerVariant.simple;
  bool get _interactive => !widget.disabled && !widget.readOnly;
  CarbonDatePickerLabels get _labels =>
      widget.labels ?? CarbonDatePickerLabels.en();

  String _format(DateTime date) =>
      widget.formatDate?.call(date) ?? formatMDY(date);
  DateTime? _parse(String text) =>
      widget.parseDate != null ? widget.parseDate!(text) : parseMDY(text);

  @override
  void initState() {
    super.initState();
    _latestStart = widget.value;
    _latestEnd = widget.endValue;
    _startController = TextEditingController(
      text: widget.value == null ? '' : _format(widget.value!),
    );
    _endController = TextEditingController(
      text: widget.endValue == null ? '' : _format(widget.endValue!),
    );
    _startFocus.addListener(() => _handleFocusChanged(isEnd: false));
    _endFocus.addListener(() => _handleFocusChanged(isEnd: true));
    _startFocus.onKeyEvent = (node, event) =>
        _handleInputKey(event, isEnd: false);
    _endFocus.onKeyEvent = (node, event) => _handleInputKey(event, isEnd: true);
  }

  @override
  void didUpdateWidget(CarbonDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _latestStart = widget.value;
      _startController.text = widget.value == null
          ? ''
          : _format(widget.value!);
    }
    if (widget.endValue != oldWidget.endValue) {
      _latestEnd = widget.endValue;
      _endController.text = widget.endValue == null
          ? ''
          : _format(widget.endValue!);
    }
    if (_isOpen && !_interactive) {
      _close();
    } else if (_isOpen &&
        (widget.value != oldWidget.value ||
            widget.endValue != oldWidget.endValue ||
            widget.minDate != oldWidget.minDate ||
            widget.maxDate != oldWidget.maxDate)) {
      // didUpdateWidget runs during the build phase and the overlay entry
      // is not our descendant — marking it now asserts. Defer a frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isOpen) _entry?.markNeedsBuild();
      });
    }
  }

  @override
  void dispose() {
    // Remove the entry directly — never setState from dispose.
    _entry?.remove();
    _entry = null;
    _startController.dispose();
    _endController.dispose();
    _startFocus.dispose();
    _endFocus.dispose();
    super.dispose();
  }

  // --- Overlay lifecycle ----------------------------------------------

  void _open({required bool grabFocus, required bool fromEnd}) {
    if (_isOpen || !_hasCalendar || !_interactive) return;
    _activeEnd = fromEnd;

    final anchorRect = CarbonAnchoredOverlay.anchorRectGetterFor(
      _startFieldKey.currentContext ?? context,
    );
    _entry = OverlayEntry(
      builder: (context) => CarbonAnchoredOverlay(
        anchorRect: anchorRect,
        alignment: CarbonPopoverAlignment.bottomStart,
        spacing: 1,
        maxWidth: 288,
        onDismiss: _close,
        contentBuilder: (context, _) => CarbonOverlaySurface(
          child: CarbonCalendarPanel(
            key: _panelKey,
            selectedStart: widget.value,
            selectedEnd: widget.endValue,
            isRange: _isRange,
            onSelectDay: _handleSelectDay,
            onClose: _close,
            minDate: widget.minDate,
            maxDate: widget.maxDate,
            firstDayOfWeek: widget.firstDayOfWeek,
            labels: _labels,
            initialFocusedDay:
                (fromEnd ? widget.endValue : widget.value) ?? widget.value,
            grabFocusOnOpen: grabFocus,
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_entry!);
    if (mounted) setState(() => _isOpen = true);
  }

  void _close() {
    if (!_isOpen) return;
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  // --- Selection & typing ----------------------------------------------

  void _fireSingle(DateTime? day) {
    _latestStart = day;
    widget.onChanged?.call(day);
  }

  void _fireRange(DateTime? start, DateTime? end) {
    _latestStart = start;
    _latestEnd = end;
    widget.onRangeChanged?.call(start, end);
  }

  void _handleSelectDay(DateTime day) {
    // Commit any uncommitted typed text first — whether tapping the
    // calendar blurs the input (and thus commits) is platform-dependent,
    // so a typed-but-uncommitted start must not be silently discarded.
    if (_startFocus.hasFocus) _commitText(isEnd: false);
    if (_endFocus.hasFocus) _commitText(isEnd: true);

    if (!_isRange) {
      _fireSingle(day);
      _startController.text = _format(day);
      if (widget.closeOnSelect) _close();
      return;
    }

    final start = _latestStart;
    final end = _latestEnd;
    if (start == null || end != null || isBeforeDay(day, start)) {
      // No start yet, a completed range, or a pick before the start:
      // (re)start the range.
      _fireRange(day, null);
      _startController.text = _format(day);
      _endController.text = '';
    } else {
      _fireRange(start, day);
      _endController.text = _format(day);
      if (widget.closeOnSelect) _close();
    }
  }

  void _commitText({required bool isEnd}) {
    final controller = isEnd ? _endController : _startController;
    final text = controller.text.trim();

    if (text.isEmpty) {
      // Clearing the input clears the value.
      if (_isRange) {
        if (isEnd) {
          if (_latestEnd != null) _fireRange(_latestStart, null);
        } else if (_latestStart != null) {
          _fireRange(null, _latestEnd);
        }
      } else if (_latestStart != null) {
        _fireSingle(null);
      }
      return;
    }

    final parsed = _parse(text);
    if (parsed == null) return; // leave as typed; consumer drives `invalid`
    final day = dateOnly(parsed);
    if (isBeforeDay(day, effectiveMinDate(widget.minDate)) ||
        isBeforeDay(effectiveMaxDate(widget.maxDate), day)) {
      return; // outside bounds: no change
    }

    // Already committed (e.g. a day-select committed this text and the
    // later blur re-parses it): reformat only, no duplicate event.
    if (isSameDay(day, isEnd ? _latestEnd : _latestStart)) {
      controller.text = _format(day);
      return;
    }

    if (!_isRange) {
      _fireSingle(day);
    } else if (isEnd) {
      final start = _latestStart;
      if (start != null && isBeforeDay(day, start)) {
        // An end before the start restarts the range from it.
        _fireRange(day, null);
        _startController.text = _format(day);
        _endController.text = '';
        return;
      }
      _fireRange(start, day);
    } else {
      final end = _latestEnd;
      if (end != null && isBeforeDay(end, day)) {
        _fireRange(day, null);
        _endController.text = '';
      } else {
        _fireRange(day, end);
      }
    }
    controller.text = _format(day);
  }

  // --- Focus & keys ------------------------------------------------------

  void _handleFocusChanged({required bool isEnd}) {
    if (mounted) setState(() {});
    final node = isEnd ? _endFocus : _startFocus;
    if (!node.hasFocus) _commitText(isEnd: isEnd);
  }

  KeyEventResult _handleInputKey(KeyEvent event, {required bool isEnd}) {
    final key = event.logicalKey;

    // Read-only: swallow the value keys (repeats included — app-level
    // arrow shortcuts act on those too) so arrows don't fall through to
    // directional focus traversal.
    if (widget.readOnly && !widget.disabled) {
      if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
        return KeyEventResult.ignored;
      }
      final swallowed =
          key == LogicalKeyboardKey.arrowUp ||
          key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.numpadEnter ||
          key == LogicalKeyboardKey.space;
      return swallowed ? KeyEventResult.handled : KeyEventResult.ignored;
    }
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (key == LogicalKeyboardKey.escape) {
      if (_isOpen) {
        _close();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.arrowDown && _hasCalendar && _interactive) {
      if (_isOpen) {
        _panelKey.currentState?.focusGrid();
      } else {
        _open(grabFocus: true, fromEnd: isEnd);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _commitText(isEnd: isEnd);
      if (_isOpen) _close();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _handleFieldTap({required bool isEnd}) {
    if (widget.disabled) return;
    (isEnd ? _endFocus : _startFocus).requestFocus();
    if (widget.readOnly || !_hasCalendar) return;
    if (!_isOpen) {
      // Typing users keep input focus; with allowInput off the calendar
      // takes it (there is nothing to type).
      _open(grabFocus: !widget.allowInput, fromEnd: isEnd);
    } else if (_activeEnd != isEnd) {
      // The outline moves to the tapped input.
      setState(() => _activeEnd = isEnd);
    }
  }

  // --- Build -------------------------------------------------------------

  _FieldState get _state {
    if (widget.readOnly) return _FieldState.readOnly;
    if (widget.disabled) return _FieldState.disabled;
    if (widget.invalid) return _FieldState.invalid;
    if (widget.warn) return _FieldState.warn;
    return _FieldState.normal;
  }

  double _fieldWidth() {
    if (widget.width != null) return widget.width!;
    switch (widget.variant) {
      case CarbonDatePickerVariant.simple:
        return _state == _FieldState.invalid || _state == _FieldState.warn
            ? 152
            : 120;
      case CarbonDatePickerVariant.single:
        return 288;
      case CarbonDatePickerVariant.range:
        return 143.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final state = _state;

    final String? statusText;
    switch (state) {
      case _FieldState.invalid:
        statusText = widget.invalidText ?? widget.helperText;
      case _FieldState.warn:
        statusText = widget.warnText ?? widget.helperText;
      case _FieldState.readOnly:
      case _FieldState.disabled:
      case _FieldState.normal:
        statusText = widget.helperText;
    }
    final statusColor = switch (state) {
      _FieldState.invalid => carbon.text.textError,
      _FieldState.disabled => carbon.text.textDisabled,
      _ => carbon.text.textHelper,
    };

    if (!_isRange) {
      return _buildColumn(
        carbon,
        labelText: widget.labelText,
        statusText: statusText,
        statusColor: statusColor,
        field: _buildField(carbon, isEnd: false),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildColumn(
              carbon,
              labelText: widget.labelText,
              statusText: null,
              statusColor: statusColor,
              field: _buildField(carbon, isEnd: false),
            ),
            const SizedBox(width: 1),
            _buildColumn(
              carbon,
              labelText: widget.endLabelText!,
              statusText: null,
              statusColor: statusColor,
              field: _buildField(carbon, isEnd: true),
            ),
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

  Widget _buildColumn(
    CarbonThemeData carbon, {
    required String labelText,
    required String? statusText,
    required Color statusColor,
    required Widget field,
  }) {
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.hideLabel) ...[
          Text(
            labelText,
            style: CarbonTypography.label01.copyWith(
              color: widget.disabled
                  ? carbon.text.textDisabled
                  : carbon.text.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        field,
        if (statusText != null) ...[
          const SizedBox(height: 4),
          Text(
            statusText,
            style: CarbonTypography.helperText01.copyWith(color: statusColor),
          ),
        ],
      ],
    );
    if (widget.hideLabel) return Semantics(label: labelText, child: column);
    return column;
  }

  Widget _buildField(CarbonThemeData carbon, {required bool isEnd}) {
    final state = _state;
    final controller = isEnd ? _endController : _startController;
    final focusNode = isEnd ? _endFocus : _startFocus;
    final hovered = isEnd ? _endHovered : _startHovered;
    final focused = focusNode.hasFocus;
    final showsStatusIcon =
        state == _FieldState.invalid || state == _FieldState.warn;
    final showsIcon = _hasCalendar || showsStatusIcon;

    final Color background;
    final Color bottomBorder;
    switch (state) {
      case _FieldState.readOnly:
        background = CarbonPalette.transparent;
        bottomBorder = carbon.layer.borderSubtle01;
      case _FieldState.disabled:
        background = carbon.layer.field01;
        bottomBorder = CarbonPalette.transparent;
      case _FieldState.normal:
      case _FieldState.invalid:
      case _FieldState.warn:
        background = hovered && !focused
            ? carbon.layer.fieldHover01
            : carbon.layer.field01;
        bottomBorder = carbon.layer.borderStrong01;
    }

    // Focus (or the open calendar on this input) wins over invalid.
    final outlineActive = focused || (_isOpen && _activeEnd == isEnd);
    final Color outline = outlineActive && state != _FieldState.disabled
        ? carbon.layer.focus
        : state == _FieldState.invalid
        ? carbon.layer.supportError
        : CarbonPalette.transparent;

    final textColor = state == _FieldState.disabled
        ? carbon.text.textDisabled
        : carbon.text.textPrimary;

    final IconData? icon;
    final Color iconColor;
    if (showsStatusIcon) {
      icon = state == _FieldState.invalid
          ? CarbonIcons.warningFilled
          : CarbonIcons.warningAltFilled;
      iconColor = state == _FieldState.invalid
          ? carbon.layer.supportError
          : carbon.layer.supportWarning;
    } else if (_hasCalendar) {
      icon = CarbonIcons.calendar;
      iconColor = _interactive
          ? carbon.text.iconPrimary
          : carbon.text.iconDisabled;
    } else {
      icon = null;
      iconColor = CarbonPalette.transparent;
    }

    return MouseRegion(
      onEnter: (_) => setState(() {
        if (isEnd) {
          _endHovered = true;
        } else {
          _startHovered = true;
        }
      }),
      onExit: (_) => setState(() {
        if (isEnd) {
          _endHovered = false;
        } else {
          _startHovered = false;
        }
      }),
      cursor: state == _FieldState.disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.text,
      child: GestureDetector(
        onTap: widget.disabled ? null : () => _handleFieldTap(isEnd: isEnd),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          key: isEnd ? null : _startFieldKey,
          duration: CarbonMotion.fast01,
          curve: CarbonMotion.standardProductive,
          width: _fieldWidth(),
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
                  end: showsIcon ? 48 : 16,
                ),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CarbonEditableCore(
                    controller: controller,
                    focusNode: focusNode,
                    style: CarbonTypography.code02.copyWith(color: textColor),
                    placeholder: widget.placeholder,
                    placeholderStyle: CarbonTypography.code02.copyWith(
                      color: state == _FieldState.disabled
                          ? carbon.text.textDisabled
                          : carbon.text.textPlaceholder,
                    ),
                    enabled: state != _FieldState.disabled,
                    readOnly: widget.readOnly || !widget.allowInput,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d/]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onTap: () => _handleFieldTap(isEnd: isEnd),
                  ),
                ),
              ),
              if (icon != null)
                PositionedDirectional(
                  end: 16,
                  top: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Icon(
                        icon,
                        size: 16,
                        color: iconColor,
                        semanticLabel: !showsStatusIcon && _hasCalendar
                            ? _labels.openCalendar
                            : null,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
