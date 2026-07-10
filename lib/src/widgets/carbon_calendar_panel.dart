import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../base/carbon_pressable.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../icons/carbon_icons.dart';
import '../text/carbon_editable_core.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';
import 'carbon_date_picker.dart' show CarbonDatePickerLabels;
import 'carbon_date_utils.dart';

/// The Carbon date-picker calendar (flatpickr equivalent): month/year
/// header with chevrons and an editable year, weekday row, and a fixed
/// 7×6 day grid with full keyboard navigation.
///
/// The panel owns the *displayed* month and the keyboard-focused day; the
/// hosting picker owns the selected values (fully controlled) and the
/// selection semantics ([onSelectDay] fires with the tapped/entered day —
/// what that means for single vs range is the picker's business).
///
/// Keyboard (single focus node on the grid): arrows move the focused day
/// (crossing month boundaries follows the month), PageUp/PageDown ±month,
/// Shift+PageUp/PageDown ±year, Home/End first/last day of the focused
/// week row, Enter/Space select, Escape closes. Tab traverses the panel's
/// own scope (chevrons → year → grid).
///
/// Not exported — a building block like `CarbonMenuPanel`.
class CarbonCalendarPanel extends StatefulWidget {
  const CarbonCalendarPanel({
    super.key,
    required this.selectedStart,
    this.selectedEnd,
    this.isRange = false,
    required this.onSelectDay,
    required this.onClose,
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = 0,
    required this.labels,
    this.initialFocusedDay,
    this.grabFocusOnOpen = true,
  });

  /// The selected day (range mode: the range start).
  final DateTime? selectedStart;

  /// The range end (range mode only).
  final DateTime? selectedEnd;

  /// Paints the in-range band and treats both ends as selected.
  final bool isRange;

  /// Fired with the chosen day; the picker owns what selection means.
  final ValueChanged<DateTime> onSelectDay;

  /// Called to dismiss the calendar (Escape).
  final VoidCallback onClose;

  /// Selection bounds; intersected with the hard year 1–9999 cap.
  final DateTime? minDate;
  final DateTime? maxDate;

  /// 0 = Sunday … 6 = Saturday.
  final int firstDayOfWeek;

  final CarbonDatePickerLabels labels;

  /// Seeds the displayed month and keyboard focus
  /// (default: selectedStart ?? today).
  final DateTime? initialFocusedDay;

  /// Whether the panel takes keyboard focus on mount. The picker passes
  /// false when the calendar opened from a tap on the text input, so
  /// typing continues uninterrupted.
  final bool grabFocusOnOpen;

  @override
  State<CarbonCalendarPanel> createState() => CarbonCalendarPanelState();
}

/// Public-in-src so the picker can move focus into the grid (ArrowDown
/// from the input).
class CarbonCalendarPanelState extends State<CarbonCalendarPanel> {
  final FocusScopeNode _scopeNode = FocusScopeNode(
    debugLabel: 'CarbonCalendarPanel',
  );
  final FocusNode _gridFocusNode = FocusNode(
    debugLabel: 'CarbonCalendarPanel.grid',
  );
  final FocusNode _yearFocusNode = FocusNode(
    debugLabel: 'CarbonCalendarPanel.year',
  );
  late final TextEditingController _yearController;

  /// Whatever held focus before the calendar opened; restored on close.
  FocusNode? _previousFocus;

  late DateTime _displayedMonth; // always the first of the month
  late DateTime _focusedDay;
  DateTime? _hoveredDay;
  bool _yearHovered = false;

  DateTime get _effectiveMin => effectiveMinDate(widget.minDate);
  DateTime get _effectiveMax => effectiveMaxDate(widget.maxDate);
  DateTime get _today => dateOnly(DateTime.now());

  @override
  void initState() {
    super.initState();
    assert(
      widget.labels.monthNames.length == 12 &&
          widget.labels.weekdayLabels.length == 7,
      'CarbonDatePickerLabels needs 12 monthNames and 7 weekdayLabels',
    );
    _focusedDay = clampDate(
      widget.initialFocusedDay ?? widget.selectedStart ?? _today,
      _effectiveMin,
      _effectiveMax,
    );
    _displayedMonth = DateTime(_focusedDay.year, _focusedDay.month);
    _yearController = TextEditingController(
      text: _displayedMonth.year.toString(),
    );
    _gridFocusNode.addListener(_repaint);
    _yearFocusNode.addListener(_handleYearFocusChanged);

    _previousFocus = FocusManager.instance.primaryFocus;
    if (widget.grabFocusOnOpen) {
      // `autofocus` is ignored when the scope already has a focused node —
      // take focus explicitly (menu-panel convention).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _gridFocusNode.requestFocus();
      });
    }
  }

  @override
  void didUpdateWidget(CarbonCalendarPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.minDate != oldWidget.minDate ||
        widget.maxDate != oldWidget.maxDate) {
      _moveFocusedDay(_focusedDay); // re-clamp into the new bounds
    }
  }

  @override
  void dispose() {
    // Restore focus to the pre-calendar node — but only when focus is
    // still ours (or fell back to a scope); never steal from a dialog an
    // action opened. Same guard as the menu panel, widened to any node
    // inside the panel's scope (year input, chevrons).
    final current = FocusManager.instance.primaryFocus;
    final previous = _previousFocus;
    if (previous != null &&
        previous.context != null &&
        (current == null ||
            current is FocusScopeNode ||
            current.ancestors.contains(_scopeNode))) {
      previous.requestFocus();
    }
    _gridFocusNode.removeListener(_repaint);
    _yearFocusNode.removeListener(_handleYearFocusChanged);
    _gridFocusNode.dispose();
    _yearFocusNode.dispose();
    _scopeNode.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _repaint() {
    if (mounted) setState(() {});
  }

  /// Moves keyboard focus into the day grid (used by the picker for
  /// ArrowDown from the text input).
  void focusGrid() => _gridFocusNode.requestFocus();

  bool _isDayEnabled(DateTime day) =>
      !isBeforeDay(day, _effectiveMin) && !isBeforeDay(_effectiveMax, day);

  /// Clamps [target], updates the focused day, and lets the displayed
  /// month follow it.
  void _moveFocusedDay(DateTime target) {
    final clamped = clampDate(target, _effectiveMin, _effectiveMax);
    setState(() {
      _focusedDay = clamped;
      _displayedMonth = DateTime(clamped.year, clamped.month);
      _syncYearText();
    });
  }

  void _syncYearText() {
    if (_yearFocusNode.hasFocus) return; // never fight the user's typing
    final text = _displayedMonth.year.toString();
    if (_yearController.text != text) _yearController.text = text;
  }

  void _shiftMonths(int months) =>
      _moveFocusedDay(addMonthsClamped(_focusedDay, months));

  void _handleDayTap(DateTime day) {
    if (!_isDayEnabled(day)) return;
    _moveFocusedDay(day);
    widget.onSelectDay(day);
  }

  KeyEventResult _handleGridKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final day = _focusedDay;

    if (key == LogicalKeyboardKey.escape) {
      widget.onClose();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space) {
      if (_isDayEnabled(day)) widget.onSelectDay(day);
      return KeyEventResult.handled;
    }

    DateTime? target;
    if (key == LogicalKeyboardKey.arrowRight) {
      target = DateTime(day.year, day.month, day.day + (rtl ? -1 : 1));
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      target = DateTime(day.year, day.month, day.day + (rtl ? 1 : -1));
    } else if (key == LogicalKeyboardKey.arrowDown) {
      target = DateTime(day.year, day.month, day.day + 7);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      target = DateTime(day.year, day.month, day.day - 7);
    } else if (key == LogicalKeyboardKey.pageUp) {
      target = addMonthsClamped(
        day,
        HardwareKeyboard.instance.isShiftPressed ? -12 : -1,
      );
    } else if (key == LogicalKeyboardKey.pageDown) {
      target = addMonthsClamped(
        day,
        HardwareKeyboard.instance.isShiftPressed ? 12 : 1,
      );
    } else if (key == LogicalKeyboardKey.home ||
        key == LogicalKeyboardKey.end) {
      // First/last day of the focused week row (W3C APG grid pattern).
      final column =
          (day.weekday % 7 - widget.firstDayOfWeek + 7) % 7;
      final delta = key == LogicalKeyboardKey.home ? -column : 6 - column;
      target = DateTime(day.year, day.month, day.day + delta);
    }
    if (target == null) return KeyEventResult.ignored;

    _moveFocusedDay(target);
    return KeyEventResult.handled;
  }

  /// Escape anywhere inside the panel (year input, chevrons) closes.
  KeyEventResult _handlePanelKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      widget.onClose();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // --- Year input -----------------------------------------------------

  void _handleYearFocusChanged() {
    if (mounted) setState(() {});
    if (!_yearFocusNode.hasFocus) _commitYear();
  }

  void _commitYear() {
    final parsed = int.tryParse(_yearController.text.trim());
    if (parsed == null) {
      _yearController.text = _displayedMonth.year.toString();
      return;
    }
    final year = parsed.clamp(_effectiveMin.year, _effectiveMax.year);
    final dayInMonth = _focusedDay.day <= daysInMonth(year, _focusedDay.month)
        ? _focusedDay.day
        : daysInMonth(year, _focusedDay.month);
    _moveFocusedDay(DateTime(year, _focusedDay.month, dayInMonth));
    // _syncYearText skips while focused (Enter keeps focus) — force it.
    _yearController.text = _displayedMonth.year.toString();
  }

  void _stepYear(int delta) {
    final parsed =
        int.tryParse(_yearController.text.trim()) ?? _displayedMonth.year;
    final year = (parsed + delta).clamp(_effectiveMin.year, _effectiveMax.year);
    final dayInMonth = _focusedDay.day <= daysInMonth(year, _focusedDay.month)
        ? _focusedDay.day
        : daysInMonth(year, _focusedDay.month);
    _moveFocusedDay(DateTime(year, _focusedDay.month, dayInMonth));
    _yearController.text = _displayedMonth.year.toString();
  }

  // --- Build ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Focus(
      onKeyEvent: _handlePanelKey,
      // Escape-catcher only — never a tab stop (bubbled key events reach
      // ancestor nodes regardless of focusability).
      canRequestFocus: false,
      child: FocusScope(
        node: _scopeNode,
        child: Container(
          width: 288,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
          decoration: BoxDecoration(
            color: carbon.layer.layer01,
            boxShadow: [
              BoxShadow(
                // $shadow already encodes its alpha.
                color: carbon.layer.shadow,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(carbon),
              _buildWeekdayRow(carbon),
              Focus(
                focusNode: _gridFocusNode,
                onKeyEvent: _handleGridKey,
                child: _buildGrid(carbon),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(CarbonThemeData carbon) {
    final monthName = widget.labels.monthNames[_displayedMonth.month - 1];
    final firstOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final canGoPrev = firstOfMonth.isAfter(
      DateTime(_effectiveMin.year, _effectiveMin.month),
    );
    final canGoNext = firstOfMonth.isBefore(
      DateTime(_effectiveMax.year, _effectiveMax.month),
    );

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          _buildNavButton(
            carbon,
            icon: CarbonIcons.chevronLeft,
            label: widget.labels.previousMonth,
            onTap: canGoPrev ? () => _shiftMonths(-1) : null,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    monthName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CarbonTypography.headingCompact01.copyWith(
                      color: carbon.text.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _buildYearInput(carbon),
              ],
            ),
          ),
          _buildNavButton(
            carbon,
            icon: CarbonIcons.chevronRight,
            label: widget.labels.nextMonth,
            onTap: canGoNext ? () => _shiftMonths(1) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    CarbonThemeData carbon, {
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: CarbonPressable(
        onTap: onTap,
        focusable: true,
        builder: (context, state) => Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          color: state.hovered && onTap != null
              ? carbon.layer.layerHover01
              : CarbonPalette.transparent,
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              color: state.focused ? carbon.layer.focus : CarbonPalette.transparent,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: onTap != null
                ? carbon.text.iconPrimary
                : carbon.text.iconDisabled,
          ),
        ),
      ),
    );
  }

  Widget _buildYearInput(CarbonThemeData carbon) {
    return MouseRegion(
      onEnter: (_) => setState(() => _yearHovered = true),
      onExit: (_) => setState(() => _yearHovered = false),
      child: Semantics(
        label: widget.labels.year,
        child: Container(
          width: 60,
          height: 28,
          decoration: BoxDecoration(color: carbon.layer.field01),
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              color: _yearFocusNode.hasFocus
                  ? carbon.layer.focus
                  : CarbonPalette.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  child: CarbonEditableCore(
                    controller: _yearController,
                    focusNode: _yearFocusNode,
                    style: CarbonTypography.headingCompact01.copyWith(
                      fontWeight: FontWeight.w600,
                      color: carbon.text.textPrimary,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    textAlign: TextAlign.center,
                    onSubmitted: (_) => _commitYear(),
                  ),
                ),
              ),
              // The spinner slot is always laid out so the hover reveal
              // never reflows the header.
              SizedBox(
                width: 12,
                child: Visibility(
                  visible: _yearHovered,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildYearSpinner(carbon, up: true),
                      _buildYearSpinner(carbon, up: false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearSpinner(CarbonThemeData carbon, {required bool up}) {
    return _HoverIcon(
      icon: up ? CarbonIcons.caretUp : CarbonIcons.caretDown,
      restColor: carbon.text.iconPrimary,
      hoverColor: carbon.button.buttonPrimary,
      onTap: () => _stepYear(up ? 1 : -1),
    );
  }

  Widget _buildWeekdayRow(CarbonThemeData carbon) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          for (var i = 0; i < 7; i++)
            Expanded(
              child: Center(
                child: ExcludeSemantics(
                  child: Text(
                    widget.labels.weekdayLabels[(widget.firstDayOfWeek + i) %
                        7],
                    style: CarbonTypography.bodyCompact01.copyWith(
                      color: carbon.text.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGrid(CarbonThemeData carbon) {
    final offset = firstDayOffset(
      _displayedMonth.year,
      _displayedMonth.month,
      widget.firstDayOfWeek,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < 6; row++)
          Row(
            children: [
              for (var column = 0; column < 7; column++)
                Expanded(
                  child: _buildDayCell(
                    carbon,
                    DateTime(
                      _displayedMonth.year,
                      _displayedMonth.month,
                      1 - offset + row * 7 + column,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildDayCell(CarbonThemeData carbon, DateTime day) {
    final outsideMonth = day.month != _displayedMonth.month ||
        day.year != _displayedMonth.year;
    final enabled = _isDayEnabled(day);
    final start = widget.selectedStart;
    final end = widget.selectedEnd;
    final selected = isSameDay(day, start) ||
        (widget.isRange && isSameDay(day, end));
    final inRange = widget.isRange &&
        start != null &&
        end != null &&
        isBeforeDay(start, day) &&
        isBeforeDay(day, end);
    final today = isSameDay(day, _today);
    final hovered = isSameDay(day, _hoveredDay) && enabled;
    final keyboardFocused =
        _gridFocusNode.hasFocus && isSameDay(day, _focusedDay);

    final Color background;
    final Color foreground;
    FontWeight? weight;
    if (!enabled) {
      background = CarbonPalette.transparent;
      foreground = carbon.text.textDisabled;
    } else if (selected) {
      background = carbon.button.buttonPrimary;
      foreground = carbon.text.textOnColor;
    } else {
      background = inRange
          ? carbon.layer.highlight
          : hovered
          ? carbon.layer.layerHover01
          : CarbonPalette.transparent;
      if (today) {
        foreground = carbon.text.linkPrimary;
        weight = FontWeight.w600;
      } else if (outsideMonth) {
        foreground = carbon.text.textHelper;
      } else {
        foreground = carbon.text.textPrimary;
      }
    }
    final showDot = today && !selected && enabled;

    final semanticLabel =
        '${widget.labels.monthNames[day.month - 1]} ${day.day}, ${day.year}';

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredDay = day),
      onExit: (_) {
        if (isSameDay(_hoveredDay, day)) setState(() => _hoveredDay = null);
      },
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? () => _handleDayTap(day) : null,
        behavior: HitTestBehavior.opaque,
        child: Semantics(
          button: true,
          enabled: enabled,
          selected: selected,
          label: semanticLabel,
          child: Container(
            height: 40,
            color: background,
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                color: keyboardFocused
                    ? carbon.button.buttonPrimary
                    : CarbonPalette.transparent,
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ExcludeSemantics(
                  child: Text(
                    day.day.toString(),
                    style: CarbonTypography.bodyCompact01.copyWith(
                      color: foreground,
                      fontWeight: weight,
                    ),
                  ),
                ),
                if (showDot)
                  Positioned(
                    bottom: 7,
                    child: Container(
                      width: 4,
                      height: 4,
                      color: carbon.text.linkPrimary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A 12px spinner triangle with its own hover color (the flatpickr year
/// arrows highlight independently).
class _HoverIcon extends StatefulWidget {
  const _HoverIcon({
    required this.icon,
    required this.restColor,
    required this.hoverColor,
    required this.onTap,
  });

  final IconData icon;
  final Color restColor;
  final Color hoverColor;
  final VoidCallback onTap;

  @override
  State<_HoverIcon> createState() => _HoverIconState();
}

class _HoverIconState extends State<_HoverIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Icon(
          widget.icon,
          size: 12,
          color: _hovered ? widget.hoverColor : widget.restColor,
        ),
      ),
    );
  }
}
