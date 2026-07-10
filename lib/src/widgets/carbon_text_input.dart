import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../base/carbon_scrollbar.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../icons/carbon_icons.dart';
import '../text/carbon_editable_core.dart';
import '../text/carbon_text_selection_labels.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// Field heights for [CarbonTextInput].
enum CarbonTextInputSize {
  /// Extra small: 24px.
  xs(24),

  /// Small: 32px.
  sm(32),

  /// Medium: 40px (default).
  md(40),

  /// Large: 48px.
  lg(48);

  const CarbonTextInputSize(this.height);

  /// Field height in logical pixels.
  final double height;
}

/// Visual state of a Carbon field, in Carbon's precedence order.
enum _FieldState { readOnly, disabled, invalid, warn, normal }

_FieldState _resolveFieldState({
  required bool readOnly,
  required bool disabled,
  required bool invalid,
  required bool warn,
}) {
  if (readOnly) return _FieldState.readOnly;
  if (disabled) return _FieldState.disabled;
  if (invalid) return _FieldState.invalid;
  if (warn) return _FieldState.warn;
  return _FieldState.normal;
}

/// Carbon Design System text input.
///
/// A single-line text field drawn to the Carbon spec on the widgets layer —
/// no Material dependency. Works under both [CarbonApp] and a Material app
/// with the Carbon bridge. Bottom-border-only field, 2px inset focus ring,
/// invalid/warn states with icons, label and helper/status text.
///
/// State precedence follows Carbon: `readOnly` > `disabled` > `invalid` >
/// `warn`.
///
/// Deferred Carbon features (planned): password visibility toggle, character
/// counter UI ([maxLength] still enforces the limit), inline layout, fluid
/// variant, skeleton state.
///
/// Example:
/// ```dart
/// CarbonTextInput(
///   labelText: 'User name',
///   placeholder: 'jane.doe',
///   helperText: 'Lowercase letters only',
///   onChanged: (value) => setState(() => _name = value),
/// )
/// ```
class CarbonTextInput extends StatefulWidget {
  const CarbonTextInput({
    super.key,
    required this.labelText,
    this.hideLabel = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.helperText,
    this.size = CarbonTextInputSize.md,
    this.disabled = false,
    this.readOnly = false,
    this.invalid = false,
    this.invalidText,
    this.warn = false,
    this.warnText,
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.selectionLabels,
  });

  /// The label above the field. Required per Carbon accessibility guidance;
  /// use [hideLabel] to hide it visually while keeping it for screen
  /// readers.
  final String labelText;

  /// Visually hides [labelText] (still announced by assistive tech).
  final bool hideLabel;

  /// Text controller. Owned internally when null.
  final TextEditingController? controller;

  /// Focus node. Owned internally when null.
  final FocusNode? focusNode;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Hint shown while the field is empty.
  final String? placeholder;

  /// Guidance below the field; replaced by [invalidText]/[warnText] when the
  /// corresponding state is active.
  final String? helperText;

  final CarbonTextInputSize size;
  final bool disabled;
  final bool readOnly;

  /// Error state: 2px `$support-error` outline + icon; [invalidText] below.
  final bool invalid;
  final String? invalidText;

  /// Warning state: warning icon; [warnText] below. Overridden by [invalid].
  final bool warn;
  final String? warnText;

  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  /// Maximum character count, enforced with a
  /// [LengthLimitingTextInputFormatter]. The Carbon counter UI
  /// (`enableCounter`) is deferred.
  final int? maxLength;

  /// Context-menu labels (Cut/Copy/Paste/…); English by default.
  final CarbonTextSelectionLabels? selectionLabels;

  @override
  State<CarbonTextInput> createState() => _CarbonTextInputState();
}

class _CarbonTextInputState extends State<CarbonTextInput> {
  FocusNode? _internalFocusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(CarbonTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(
        _handleFocusChanged,
      );
      if (widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      _effectiveFocusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    (widget.focusNode ?? _internalFocusNode)?.removeListener(
      _handleFocusChanged,
    );
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final state = _resolveFieldState(
      readOnly: widget.readOnly,
      disabled: widget.disabled,
      invalid: widget.invalid,
      warn: widget.warn,
    );
    final focused = _effectiveFocusNode.hasFocus;

    final formatters = <TextInputFormatter>[
      ...?widget.inputFormatters,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(widget.maxLength),
    ];

    final field = _FieldChrome(
      state: state,
      focused: focused,
      hovered: _hovered,
      height: widget.size.height,
      onHoverChanged: (value) => setState(() => _hovered = value),
      onTap: state == _FieldState.disabled
          ? null
          : () => _effectiveFocusNode.requestFocus(),
      iconTopAligned: false,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: CarbonEditableCore(
          controller: widget.controller,
          focusNode: _effectiveFocusNode,
          style: CarbonTypography.bodyCompact01.copyWith(
            color: state == _FieldState.disabled
                ? carbon.text.textDisabled
                : carbon.text.textPrimary,
          ),
          placeholder: widget.placeholder,
          placeholderStyle: CarbonTypography.bodyCompact01.copyWith(
            color: state == _FieldState.disabled
                ? carbon.text.textDisabled
                : carbon.text.textPlaceholder,
          ),
          enabled: state != _FieldState.disabled,
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          inputFormatters: formatters.isEmpty ? null : formatters,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          selectionLabels: widget.selectionLabels,
        ),
      ),
    );

    return _FieldColumn(
      labelText: widget.labelText,
      hideLabel: widget.hideLabel,
      state: state,
      statusText: _statusTextFor(
        state,
        invalidText: widget.invalidText,
        warnText: widget.warnText,
        helperText: widget.helperText,
      ),
      carbon: carbon,
      field: field,
    );
  }
}

/// Carbon Design System text area (multi-line input).
///
/// Same state model and chrome as [CarbonTextInput]; per the Carbon spec it
/// uses `body-01` type (taller line height), 11px vertical padding, grows
/// with content from a 40px minimum, and anchors the validation icon to the
/// top-right instead of centering it.
class CarbonTextArea extends StatefulWidget {
  const CarbonTextArea({
    super.key,
    required this.labelText,
    this.hideLabel = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.placeholder,
    this.helperText,
    this.disabled = false,
    this.readOnly = false,
    this.invalid = false,
    this.invalidText,
    this.warn = false,
    this.warnText,
    this.autofocus = false,
    this.minLines = 4,
    this.maxLines,
    this.maxLength,
    this.inputFormatters,
    this.selectionLabels,
  });

  final String labelText;
  final bool hideLabel;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final String? helperText;
  final bool disabled;
  final bool readOnly;
  final bool invalid;
  final String? invalidText;
  final bool warn;
  final String? warnText;
  final bool autofocus;

  /// Initial visible height in lines (mirrors Carbon's `rows`).
  final int minLines;

  /// Cap on growth; null grows unbounded with content.
  final int? maxLines;

  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final CarbonTextSelectionLabels? selectionLabels;

  @override
  State<CarbonTextArea> createState() => _CarbonTextAreaState();
}

class _CarbonTextAreaState extends State<CarbonTextArea> {
  FocusNode? _internalFocusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  bool _hovered = false;

  /// Drives the scrollbar shown when the content exceeds [CarbonTextArea.maxLines].
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(CarbonTextArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(
        _handleFocusChanged,
      );
      if (widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      _effectiveFocusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    (widget.focusNode ?? _internalFocusNode)?.removeListener(
      _handleFocusChanged,
    );
    _internalFocusNode?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final state = _resolveFieldState(
      readOnly: widget.readOnly,
      disabled: widget.disabled,
      invalid: widget.invalid,
      warn: widget.warn,
    );
    final focused = _effectiveFocusNode.hasFocus;

    final formatters = <TextInputFormatter>[
      ...?widget.inputFormatters,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(widget.maxLength),
    ];

    final field = _FieldChrome(
      state: state,
      focused: focused,
      hovered: _hovered,
      height: null,
      minHeight: 40,
      verticalPadding: 11,
      onHoverChanged: (value) => setState(() => _hovered = value),
      onTap: state == _FieldState.disabled
          ? null
          : () => _effectiveFocusNode.requestFocus(),
      iconTopAligned: true,
      // Like a native <textarea>: indicate overflow when the content
      // exceeds maxLines (with maxLines null the editable grows unbounded
      // and never overflows — the gate keeps the bar hidden).
      child: CarbonScrollbar(
        controller: _scrollController,
        builder: (context, scrollController) => CarbonEditableCore(
          controller: widget.controller,
          focusNode: _effectiveFocusNode,
          scrollController: scrollController,
          style: CarbonTypography.body01.copyWith(
            color: state == _FieldState.disabled
                ? carbon.text.textDisabled
                : carbon.text.textPrimary,
          ),
          placeholder: widget.placeholder,
          placeholderStyle: CarbonTypography.body01.copyWith(
            color: state == _FieldState.disabled
                ? carbon.text.textDisabled
                : carbon.text.textPlaceholder,
          ),
          enabled: state != _FieldState.disabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          keyboardType: TextInputType.multiline,
          inputFormatters: formatters.isEmpty ? null : formatters,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          selectionLabels: widget.selectionLabels,
        ),
      ),
    );

    return _FieldColumn(
      labelText: widget.labelText,
      hideLabel: widget.hideLabel,
      state: state,
      statusText: _statusTextFor(
        state,
        invalidText: widget.invalidText,
        warnText: widget.warnText,
        helperText: widget.helperText,
      ),
      carbon: carbon,
      field: field,
    );
  }
}

String? _statusTextFor(
  _FieldState state, {
  required String? invalidText,
  required String? warnText,
  required String? helperText,
}) {
  switch (state) {
    case _FieldState.invalid:
      return invalidText ?? helperText;
    case _FieldState.warn:
      return warnText ?? helperText;
    case _FieldState.readOnly:
    case _FieldState.disabled:
    case _FieldState.normal:
      return helperText;
  }
}

/// Label + field + status text column shared by input and area.
class _FieldColumn extends StatelessWidget {
  const _FieldColumn({
    required this.labelText,
    required this.hideLabel,
    required this.state,
    required this.statusText,
    required this.carbon,
    required this.field,
  });

  final String labelText;
  final bool hideLabel;
  final _FieldState state;
  final String? statusText;
  final CarbonThemeData carbon;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    final Color statusColor;
    switch (state) {
      case _FieldState.invalid:
        statusColor = carbon.text.textError;
      case _FieldState.disabled:
        statusColor = carbon.text.textDisabled;
      case _FieldState.warn:
      case _FieldState.readOnly:
      case _FieldState.normal:
        statusColor = carbon.text.textHelper;
    }

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!hideLabel) ...[
          Text(
            labelText,
            style: CarbonTypography.label01.copyWith(
              color: state == _FieldState.disabled
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
            statusText!,
            style: CarbonTypography.helperText01.copyWith(color: statusColor),
          ),
        ],
      ],
    );

    // The editable itself already emits a text-field semantics node — no
    // `textField: true` wrapper (it would nest two text fields). A hidden
    // label is attached here so assistive tech still announces it.
    if (hideLabel) {
      return Semantics(label: labelText, child: column);
    }
    return column;
  }
}

/// The field box: background, bottom border, focus/invalid outline,
/// validation icon, hover tracking.
class _FieldChrome extends StatelessWidget {
  const _FieldChrome({
    required this.state,
    required this.focused,
    required this.hovered,
    required this.height,
    this.minHeight,
    this.verticalPadding = 0,
    required this.onHoverChanged,
    required this.onTap,
    required this.iconTopAligned,
    required this.child,
  });

  final _FieldState state;
  final bool focused;
  final bool hovered;

  /// Fixed height (text input) or null to grow (text area).
  final double? height;
  final double? minHeight;
  final double verticalPadding;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback? onTap;

  /// Text area anchors the validation icon top-right instead of centering.
  final bool iconTopAligned;
  final Widget child;

  bool get _showsIcon =>
      state == _FieldState.invalid || state == _FieldState.warn;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    final Color background;
    switch (state) {
      case _FieldState.readOnly:
        background = CarbonPalette.transparent;
      case _FieldState.normal:
      case _FieldState.warn:
        background = hovered && !focused
            ? carbon.layer.fieldHover01
            : carbon.layer.field01;
      case _FieldState.disabled:
      case _FieldState.invalid:
        background = carbon.layer.field01;
    }

    final Color bottomBorder;
    switch (state) {
      case _FieldState.readOnly:
        bottomBorder = carbon.layer.borderSubtle01;
      case _FieldState.disabled:
        bottomBorder = CarbonPalette.transparent;
      case _FieldState.normal:
      case _FieldState.invalid:
      case _FieldState.warn:
        bottomBorder = carbon.layer.borderStrong01;
    }

    // 2px inset outline: focus wins over invalid while focused (Carbon CSS
    // cascade); read-only stays focusable and shows the focus ring.
    // Transparent (never null) when absent: Container only mounts its
    // foreground DecoratedBox when the decoration is non-null, and toggling
    // it would change the tree depth and remount the editable — killing the
    // just-opened input connection on focus.
    final Color outline = focused && state != _FieldState.disabled
        ? carbon.layer.focus
        : state == _FieldState.invalid
        ? carbon.layer.supportError
        : CarbonPalette.transparent;

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      cursor: state == _FieldState.disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.text,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: CarbonMotion.fast01,
          curve: CarbonMotion.standardProductive,
          height: height,
          constraints: minHeight != null
              ? BoxConstraints(minHeight: minHeight!)
              : null,
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
                  end: _showsIcon ? 40 : 16,
                  top: verticalPadding,
                  bottom: verticalPadding,
                ),
                child: child,
              ),
              if (_showsIcon)
                PositionedDirectional(
                  end: 16,
                  top: iconTopAligned ? 12 : 0,
                  bottom: iconTopAligned ? null : 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      state == _FieldState.invalid
                          ? CarbonIcons.warningFilled
                          : CarbonIcons.warningAltFilled,
                      size: 16,
                      color: state == _FieldState.invalid
                          ? carbon.layer.supportError
                          : carbon.layer.supportWarning,
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
