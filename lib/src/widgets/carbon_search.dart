import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../base/carbon_pressable.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../icons/carbon_icons.dart';
import '../text/carbon_editable_core.dart';
import '../text/carbon_text_selection_labels.dart';
import '../theme/carbon_theme.dart';

/// Field heights for [CarbonSearch].
enum CarbonSearchSize {
  /// Extra small: 24px.
  xs(24),

  /// Small: 32px.
  sm(32),

  /// Medium: 40px (default).
  md(40),

  /// Large: 48px.
  lg(48);

  const CarbonSearchSize(this.height);

  /// Field height in logical pixels. Also the side length of the leading
  /// magnifier square and the trailing clear button.
  final double height;
}

/// Carbon Design System search input.
///
/// A search field drawn to the Carbon spec on the widgets layer: leading
/// magnifier, `$field` background with a 1px `$border-strong` bottom border,
/// 2px `$focus` outline, and a trailing clear button that is hidden (with
/// layout retained) while the field is empty.
///
/// Escape follows the Carbon behavior: with text it clears the field (firing
/// [onClear] and [onChanged]); when empty and [expandable] it collapses the
/// field. Other Escape presses pass through to ancestors (modals still
/// dismiss).
///
/// The [expandable] variant renders as a square icon button that expands on
/// tap or keyboard focus and collapses again when it loses focus while
/// empty. The expand width animation requires a bounded width from the
/// parent (e.g. an [Expanded] or a fixed-width [SizedBox]); under unbounded
/// constraints the switch is instant.
///
/// Per the Carbon spec the label is never rendered visually; [labelText] is
/// exposed to assistive technology only.
class CarbonSearch extends StatefulWidget {
  const CarbonSearch({
    super.key,
    this.labelText = 'Search',
    this.placeholder = 'Search',
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.size = CarbonSearchSize.md,
    this.disabled = false,
    this.autofocus = false,
    this.expandable = false,
    this.initiallyExpanded = false,
    this.onExpandedChanged,
    this.clearButtonLabel = 'Clear search input',
    this.selectionLabels,
  });

  /// Accessible name for the field (visually hidden per the Carbon spec).
  final String labelText;

  /// Hint shown while the field is empty.
  final String placeholder;

  /// Text controller. Owned internally when null.
  final TextEditingController? controller;

  /// Focus node for the input. Owned internally when null. Any `onKeyEvent`
  /// handler already installed on a provided node keeps working — this
  /// widget chains it before its own Escape handling.
  final FocusNode? focusNode;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Called when the field is cleared via the clear button or Escape.
  final VoidCallback? onClear;

  final CarbonSearchSize size;
  final bool disabled;
  final bool autofocus;

  /// Renders the collapsed square-button variant that expands on tap/focus
  /// and collapses on blur or Escape while empty.
  final bool expandable;

  /// Initial expansion state; only meaningful when [expandable].
  final bool initiallyExpanded;

  /// Reports expansion changes of the [expandable] variant.
  final ValueChanged<bool>? onExpandedChanged;

  /// Accessible label for the clear button.
  final String clearButtonLabel;

  /// Context-menu labels; defaults to English.
  final CarbonTextSelectionLabels? selectionLabels;

  @override
  State<CarbonSearch> createState() => _CarbonSearchState();
}

class _CarbonSearchState extends State<CarbonSearch> {
  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController!;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode!;

  /// Pre-existing handler on an externally-provided focus node, chained
  /// before this widget's Escape handling and restored on dispose.
  FocusOnKeyEventCallback? _chainedOnKeyEvent;

  /// Traversal target for the collapsed square button (kept outside
  /// [CarbonPressable] so tabbing onto the button expands the field —
  /// same pattern the toolbar search used).
  final FocusNode _collapsedFocusNode = FocusNode(
    debugLabel: 'CarbonSearch.collapsed',
  );

  bool _expanded = true;
  bool _empty = true;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: 'CarbonSearch');
    }
    _expanded = !widget.expandable || widget.initiallyExpanded;
    _empty = _effectiveController.text.isEmpty;
    _effectiveController.addListener(_handleTextChanged);
    _effectiveFocusNode.addListener(_handleFocusChanged);
    _installKeyHandler();
    _collapsedFocusNode.addListener(_handleCollapsedFocusChanged);
  }

  @override
  void didUpdateWidget(CarbonSearch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(
        _handleTextChanged,
      );
      if (widget.controller != null) {
        _internalController?.dispose();
        _internalController = null;
      } else {
        _internalController = TextEditingController.fromValue(
          oldWidget.controller!.value,
        );
      }
      _effectiveController.addListener(_handleTextChanged);
      _empty = _effectiveController.text.isEmpty;
    }

    if (widget.focusNode != oldWidget.focusNode) {
      final oldNode = oldWidget.focusNode ?? _internalFocusNode;
      oldNode?.removeListener(_handleFocusChanged);
      _uninstallKeyHandler(oldNode);
      if (widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      } else {
        _internalFocusNode ??= FocusNode(debugLabel: 'CarbonSearch');
      }
      _effectiveFocusNode.addListener(_handleFocusChanged);
      _installKeyHandler();
    }

    if (widget.expandable != oldWidget.expandable && !widget.expandable) {
      _expanded = true;
    }
  }

  @override
  void dispose() {
    (widget.controller ?? _internalController)?.removeListener(
      _handleTextChanged,
    );
    final node = widget.focusNode ?? _internalFocusNode;
    node?.removeListener(_handleFocusChanged);
    _uninstallKeyHandler(node);
    _internalController?.dispose();
    _internalFocusNode?.dispose();
    _collapsedFocusNode.dispose();
    super.dispose();
  }

  void _installKeyHandler() {
    _chainedOnKeyEvent = _effectiveFocusNode.onKeyEvent;
    _effectiveFocusNode.onKeyEvent = _handleKeyEvent;
  }

  void _uninstallKeyHandler(FocusNode? node) {
    if (node != null && node.onKeyEvent == _handleKeyEvent) {
      node.onKeyEvent = _chainedOnKeyEvent;
    }
    _chainedOnKeyEvent = null;
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    final chained = _chainedOnKeyEvent?.call(node, event);
    if (chained != null && chained != KeyEventResult.ignored) {
      return chained;
    }
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    if (_effectiveController.text.isNotEmpty) {
      _clear(refocus: false);
      return KeyEventResult.handled;
    }
    if (widget.expandable && _expanded) {
      _setExpanded(false);
      _effectiveFocusNode.unfocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _handleTextChanged() {
    final empty = _effectiveController.text.isEmpty;
    if (empty != _empty && mounted) {
      setState(() => _empty = empty);
    }
  }

  void _handleFocusChanged() {
    if (!mounted) return;
    setState(() {});
    if (!_effectiveFocusNode.hasFocus &&
        widget.expandable &&
        _expanded &&
        _effectiveController.text.isEmpty) {
      _setExpanded(false);
    }
  }

  void _handleCollapsedFocusChanged() {
    if (_collapsedFocusNode.hasFocus && !_expanded) {
      _expand();
    }
  }

  void _expand() {
    if (_expanded || widget.disabled) return;
    _setExpanded(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _effectiveFocusNode.requestFocus();
    });
  }

  void _setExpanded(bool value) {
    if (_expanded == value) return;
    setState(() => _expanded = value);
    widget.onExpandedChanged?.call(value);
  }

  void _clear({bool refocus = true}) {
    _effectiveController.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
    if (refocus) _effectiveFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.expandable) {
      return _buildField(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final side = widget.size.height;
        if (!constraints.hasBoundedWidth) {
          // No expand target to animate towards — instant switch.
          return _expanded
              ? _buildField(context)
              : _buildCollapsedButton(context);
        }
        final target = constraints.maxWidth;
        return ClipRect(
          child: AnimatedContainer(
            duration: CarbonMotion.fast01,
            curve: CarbonMotion.standardProductive,
            width: _expanded ? target : side,
            // Fixed height: the OverflowBox below sizes itself to the
            // BIGGEST incoming constraints — without this it demands
            // infinite height inside scrollables (unbounded height).
            height: side,
            alignment: AlignmentDirectional.centerStart,
            // While the width animates, the field stays laid out at the
            // target width (clipped) so its Row never overflows.
            child: _expanded
                ? OverflowBox(
                    alignment: AlignmentDirectional.centerStart,
                    minWidth: target,
                    maxWidth: target,
                    child: _buildField(context),
                  )
                : _buildCollapsedButton(context),
          ),
        );
      },
    );
  }

  Widget _buildCollapsedButton(BuildContext context) {
    final carbon = context.carbon;
    final side = widget.size.height;

    return Focus(
      focusNode: _collapsedFocusNode,
      canRequestFocus: !widget.disabled,
      child: Semantics(
        button: true,
        label: widget.labelText,
        child: CarbonPressable(
          onTap: widget.disabled ? null : _expand,
          builder: (context, state) => Container(
            width: side,
            height: side,
            alignment: Alignment.center,
            color: state.hovered
                ? carbon.layer.fieldHover01
                : CarbonPalette.transparent,
            child: Icon(
              CarbonIcons.search,
              size: 16,
              color: widget.disabled
                  ? carbon.text.iconDisabled
                  : carbon.text.iconPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context) {
    final carbon = context.carbon;
    final side = widget.size.height;
    final disabled = widget.disabled;
    final focused = _effectiveFocusNode.hasFocus;
    final showClear = !_empty && !disabled;

    final background = disabled
        ? carbon.layer.field01
        : _hovered && !focused
        ? carbon.layer.fieldHover01
        : carbon.layer.field01;
    final bottomBorder = disabled
        ? CarbonPalette.transparent
        : carbon.layer.borderStrong01;
    // Always-present outline (transparent when unfocused): toggling the
    // foreground decoration would change the tree depth and remount the
    // editable, killing the input connection.
    final outline = focused && !disabled
        ? carbon.layer.focus
        : CarbonPalette.transparent;

    final field = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.text,
      child: GestureDetector(
        // Catches taps on the magnifier square (the editable handles its
        // own; the clear button consumes its taps first).
        onTap: disabled ? null : () => _effectiveFocusNode.requestFocus(),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: CarbonMotion.fast02,
          curve: CarbonMotion.standardProductive,
          height: side,
          decoration: BoxDecoration(
            color: background,
            border: Border(bottom: BorderSide(color: bottomBorder)),
          ),
          foregroundDecoration: BoxDecoration(
            border: Border.all(color: outline, width: 2),
          ),
          child: Row(
            children: [
              SizedBox(
                width: side,
                height: side,
                child: IgnorePointer(
                  child: Icon(
                    CarbonIcons.search,
                    size: 16,
                    color: disabled
                        ? carbon.text.iconDisabled
                        : carbon.text.iconSecondary,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CarbonEditableCore(
                    controller: _effectiveController,
                    focusNode: _effectiveFocusNode,
                    style: CarbonTypography.bodyCompact01.copyWith(
                      color: disabled
                          ? carbon.text.textDisabled
                          : carbon.text.textPrimary,
                    ),
                    placeholder: widget.placeholder,
                    placeholderStyle: CarbonTypography.bodyCompact01.copyWith(
                      color: disabled
                          ? carbon.text.textDisabled
                          : carbon.text.textPlaceholder,
                    ),
                    enabled: !disabled,
                    autofocus: widget.autofocus,
                    textInputAction: TextInputAction.search,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    selectionLabels: widget.selectionLabels,
                  ),
                ),
              ),
              // Always mounted with layout retained (web Carbon hides it
              // with `visibility: hidden`) — constant tree shape, no width
              // jump when text appears.
              IgnorePointer(
                ignoring: !showClear,
                child: Opacity(
                  opacity: showClear ? 1 : 0,
                  child: ExcludeSemantics(
                    excluding: !showClear,
                    child: Semantics(
                      button: true,
                      label: widget.clearButtonLabel,
                      child: CarbonPressable(
                        onTap: showClear ? _clear : null,
                        focusable: true,
                        builder: (context, state) => Container(
                          width: side,
                          height: side,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: state.hovered
                                ? carbon.layer.fieldHover01
                                : CarbonPalette.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: state.hovered
                                    ? carbon.layer.borderStrong01
                                    : CarbonPalette.transparent,
                              ),
                            ),
                          ),
                          child: Icon(
                            CarbonIcons.close,
                            size: 16,
                            color: carbon.text.iconPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // The editable emits the text-field semantics node; the label is only
    // attached for assistive tech (never rendered, per spec).
    return Semantics(label: widget.labelText, child: field);
  }
}
