import 'package:flutter/services.dart'
    show KeyDownEvent, KeyRepeatEvent, LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../base/carbon_anchored_overlay.dart';
import '../base/carbon_overlay_surface.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';
import 'carbon_menu.dart';

/// Field heights for [CarbonSelect].
enum CarbonSelectSize {
  /// Extra small: 24px.
  xs(24, CarbonMenuSize.xs),

  /// Small: 32px.
  sm(32, CarbonMenuSize.sm),

  /// Medium: 40px (default).
  md(40, CarbonMenuSize.md),

  /// Large: 48px.
  lg(48, CarbonMenuSize.lg);

  const CarbonSelectSize(this.height, this.menuSize);

  /// Field height in logical pixels.
  final double height;

  /// Matching option height in the opened menu.
  final CarbonMenuSize menuSize;
}

/// An option of a [CarbonSelect] (mirrors React's `SelectItem`).
class CarbonSelectItem<T> {
  const CarbonSelectItem({
    required this.value,
    required this.label,
    this.disabled = false,
  });

  /// The value reported through [CarbonSelect.onChanged].
  final T value;

  /// The text shown for this option.
  final String label;

  /// Whether this option can be chosen.
  final bool disabled;
}

/// Carbon Design System select.
///
/// The native-select form control: a text-input-like field (bottom border,
/// `$field` background, validation states, label and helper text) that opens
/// a Carbon menu of options. Distinct from `CarbonDropdown` in that it
/// carries the full Select form semantics — `invalid`/`warn` with status
/// icons and text, `readOnly`, and the xs–lg size scale.
///
/// Native `<select>` has no styled popup; the Flutter menu renders the
/// selected option dropdown-style (selected layer + checkmark) and keyboard
/// arrows continue from the selection.
///
/// State precedence follows Carbon: `readOnly` > `disabled` > `invalid` >
/// `warn`.
///
/// Deferred Carbon features (planned): `SelectItemGroup` option groups, the
/// `inline` variant, typeahead in the open menu.
class CarbonSelect<T> extends StatefulWidget {
  const CarbonSelect({
    super.key,
    required this.labelText,
    this.hideLabel = false,
    required this.items,
    required this.value,
    this.onChanged,
    this.placeholder,
    this.helperText,
    this.invalid = false,
    this.invalidText,
    this.warn = false,
    this.warnText,
    this.disabled = false,
    this.readOnly = false,
    this.size = CarbonSelectSize.md,
    this.width,
    this.menuMaxHeight = 300,
  });

  /// The label above the field. Required per Carbon accessibility guidance;
  /// use [hideLabel] to hide it visually while keeping it for screen
  /// readers.
  final String labelText;

  /// Visually hides [labelText] (still announced by assistive tech).
  final bool hideLabel;

  /// The options.
  final List<CarbonSelectItem<T>> items;

  /// The currently selected value; null shows [placeholder].
  final T? value;

  final ValueChanged<T?>? onChanged;

  /// Shown while [value] is null.
  final String? placeholder;

  /// Guidance below the field; replaced by [invalidText]/[warnText] when the
  /// corresponding state is active.
  final String? helperText;

  /// Error state: 2px `$support-error` outline + icon; [invalidText] below.
  final bool invalid;
  final String? invalidText;

  /// Warning state: warning icon; [warnText] below. Overridden by [invalid].
  final bool warn;
  final String? warnText;

  final bool disabled;

  /// Read-only: focusable, but the menu does not open.
  final bool readOnly;

  final CarbonSelectSize size;

  /// Optional fixed field width; defaults to filling the parent.
  final double? width;

  /// The opened menu scrolls beyond this height.
  final double menuMaxHeight;

  @override
  State<CarbonSelect<T>> createState() => _CarbonSelectState<T>();
}

class _CarbonSelectState<T> extends State<CarbonSelect<T>> {
  final GlobalKey _triggerKey = GlobalKey();
  final FocusNode _focusNode = FocusNode(debugLabel: 'CarbonSelect');

  OverlayEntry? _entry;
  bool _isOpen = false;
  bool _hovered = false;

  bool get _interactive => !widget.disabled && !widget.readOnly;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(CarbonSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isOpen && !_interactive) {
      _close();
    } else if (_isOpen &&
        (widget.value != oldWidget.value || widget.items != oldWidget.items)) {
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
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) setState(() {});
  }

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    if (_isOpen || !_interactive) return;
    // Focus the field first so the menu panel captures it as the previous
    // focus and restores it on close.
    _focusNode.requestFocus();

    final anchorRect = CarbonAnchoredOverlay.anchorRectGetterFor(
      _triggerKey.currentContext ?? context,
    );
    _entry = OverlayEntry(
      builder: (context) => CarbonAnchoredOverlay(
        anchorRect: anchorRect,
        alignment: CarbonPopoverAlignment.bottomStart,
        matchAnchorWidth: true,
        // Opt into growth beyond narrow fields (the panel sizes
        // intrinsically): the selected row's checkmark must never squeeze
        // the label out.
        maxWidth: 288,
        spacing: 1,
        onDismiss: _close,
        contentBuilder: (context, _) => CarbonOverlaySurface(
          child: CarbonMenuPanel<T>(
            entries: [
              for (final item in widget.items)
                CarbonMenuItem<T>(
                  label: item.label,
                  value: item.value,
                  disabled: item.disabled,
                ),
            ],
            selectedValue: widget.value,
            size: widget.size.menuSize,
            // The anchor (field) width is the real minimum — the menu
            // spec's 160px floor would balloon compact selects (AM/PM).
            minWidth: 0,
            maxHeight: widget.menuMaxHeight,
            onSelected: (value) => widget.onChanged?.call(value),
            onClose: _close,
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

  /// Enter/Space/Arrows open the closed menu (the open menu's panel owns
  /// its own keyboard handling).
  KeyEventResult _handleFieldKey(FocusNode node, KeyEvent event) {
    if (_isOpen) return KeyEventResult.ignored;
    // Repeats matter only for the read-only swallow below — the app-level
    // arrow shortcuts act on repeats too.
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final isValueKey =
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowUp;
    if (!isValueKey) return KeyEventResult.ignored;
    // Read-only: focusable but inert — swallow the keys so arrows don't
    // fall through to directional focus traversal and yank focus away.
    if (!_interactive) {
      return widget.readOnly && !widget.disabled
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
    }
    if (event is KeyRepeatEvent) return KeyEventResult.handled;
    _open();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final focused = _focusNode.hasFocus;
    // Carbon state precedence: readOnly > disabled > invalid > warn.
    final readOnly = widget.readOnly;
    final disabled = widget.disabled && !readOnly;
    final invalid = !readOnly && !disabled && widget.invalid;
    final warn = !readOnly && !disabled && !invalid && widget.warn;
    final showsStatusIcon = invalid || warn;

    final selected = widget.items
        .where((item) => item.value == widget.value)
        .firstOrNull;
    final displayText = selected?.label ?? widget.placeholder ?? '';

    final Color background;
    final Color bottomBorder;
    final Color chevronColor;
    final Color textColor;
    if (readOnly) {
      background = CarbonPalette.transparent;
      bottomBorder = carbon.layer.borderSubtle01;
      chevronColor = carbon.text.iconDisabled;
      textColor = carbon.text.textPrimary;
    } else if (disabled) {
      background = carbon.layer.field01;
      bottomBorder = CarbonPalette.transparent;
      chevronColor = carbon.text.iconDisabled;
      textColor = carbon.text.textDisabled;
    } else {
      background = _hovered && !focused && !_isOpen
          ? carbon.layer.fieldHover01
          : carbon.layer.field01;
      bottomBorder = carbon.layer.borderStrong01;
      chevronColor = carbon.text.iconPrimary;
      textColor = carbon.text.textPrimary;
    }

    // Focus (or open menu) wins over invalid, per the Carbon CSS cascade.
    // Always present, transparent when inactive (tree-shape stability).
    final Color outline = (focused || _isOpen) && !disabled
        ? carbon.layer.focus
        : invalid
        ? carbon.layer.supportError
        : CarbonPalette.transparent;

    Widget field = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: _interactive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: disabled
            ? null
            : readOnly
            ? () => _focusNode.requestFocus()
            : _toggle,
        behavior: HitTestBehavior.opaque,
        child: Focus(
          focusNode: _focusNode,
          canRequestFocus: !disabled,
          onKeyEvent: _handleFieldKey,
          child: AnimatedContainer(
            key: _triggerKey,
            // Spec: only the outline transitions (70ms).
            duration: CarbonMotion.fast01,
            curve: CarbonMotion.standardProductive,
            height: widget.size.height,
            width: widget.width,
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
                    end: showsStatusIcon ? 64 : 48,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      displayText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CarbonTypography.bodyCompact01.copyWith(
                        color: selected == null && !disabled
                            ? carbon.text.textPlaceholder
                            : textColor,
                      ),
                    ),
                  ),
                ),
                if (showsStatusIcon)
                  PositionedDirectional(
                    end: 40,
                    top: 0,
                    bottom: 0,
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
                PositionedDirectional(
                  end: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      _isOpen ? CarbonIcons.chevronUp : CarbonIcons.chevronDown,
                      size: 16,
                      color: chevronColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    field = Semantics(
      button: true,
      enabled: !disabled,
      label: widget.labelText,
      value: selected?.label,
      child: field,
    );

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

    return Column(
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
  }
}
