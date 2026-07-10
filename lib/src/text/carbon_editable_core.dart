import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/carbon_theme.dart';
import 'carbon_text_selection_controls.dart';
import 'carbon_text_selection_labels.dart';
import 'carbon_text_selection_toolbar.dart';

/// Internal Material-free editable text run: [EditableText] plus the Carbon
/// gesture handling, selection handles, and context menu. Draws no
/// decoration, label, or border — the public `CarbonTextInput` /
/// `CarbonTextArea` (and embedders like the combo box) build chrome around
/// it.
///
/// Not exported — a building block like `CarbonAnchoredOverlay`.
class CarbonEditableCore extends StatefulWidget {
  const CarbonEditableCore({
    super.key,
    this.controller,
    this.focusNode,
    required this.style,
    this.placeholder,
    this.placeholderStyle,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.cursorColor,
    this.selectionColor,
    this.enableInteractiveSelection,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.scrollController,
    this.scrollPhysics,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.autofillHints = const <String>[],
    this.restorationId,
    this.undoController,
    this.selectionLabels,
    this.keyboardAppearance,
    this.mouseCursor,
  });

  /// Owned internally when null.
  final TextEditingController? controller;

  /// Owned internally when null. When provided, any `onKeyEvent` handler the
  /// owner installed keeps working — this widget never overwrites it.
  final FocusNode? focusNode;

  /// Fully-resolved text style (color included) from the embedding widget.
  final TextStyle? style;

  /// Hint text painted behind the editable when the field is empty.
  final String? placeholder;

  /// Style for [placeholder]. Defaults to [style] with the theme's
  /// placeholder color.
  final TextStyle? placeholderStyle;

  /// When false: no gestures, no focus, no cursor, no selection UI.
  final bool enabled;

  final bool readOnly;
  final bool obscureText;
  final String obscuringCharacter;
  final bool autocorrect;
  final bool enableSuggestions;

  /// Inferred by [EditableText] from [maxLines]/[autofillHints] when null.
  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final TextAlign textAlign;
  final bool autofocus;

  /// Overrides the resolved cursor color
  /// ([DefaultSelectionStyle] → theme `buttonPrimary`).
  final Color? cursorColor;

  /// Overrides the resolved selection highlight color.
  final Color? selectionColor;

  final bool? enableInteractiveSelection;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;

  /// Called on a completed tap on the text (mirrors `TextField.onTap`).
  final GestureTapCallback? onTap;

  final TapRegionCallback? onTapOutside;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final EdgeInsets scrollPadding;
  final Iterable<String> autofillHints;
  final String? restorationId;
  final UndoHistoryController? undoController;

  /// Context-menu labels; defaults to English.
  final CarbonTextSelectionLabels? selectionLabels;

  /// Defaults to the theme background's luminance.
  final Brightness? keyboardAppearance;

  final MouseCursor? mouseCursor;

  @override
  State<CarbonEditableCore> createState() => _CarbonEditableCoreState();
}

class _CarbonEditableCoreState extends State<CarbonEditableCore>
    implements TextSelectionGestureDetectorBuilderDelegate {
  @override
  final GlobalKey<EditableTextState> editableTextKey =
      GlobalKey<EditableTextState>();

  @override
  bool get forcePressEnabled => defaultTargetPlatform == TargetPlatform.iOS;

  @override
  bool get selectionEnabled =>
      widget.enableInteractiveSelection ??
      (!widget.readOnly || !widget.obscureText);

  late final _CarbonEditableGestureBuilder _gestureBuilder =
      _CarbonEditableGestureBuilder(state: this);

  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController!;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode!;

  EditableTextState? get _editableText => editableTextKey.currentState;

  CarbonTextSelectionControls? _selectionControls;
  bool _showSelectionHandles = false;
  bool _wasEmpty = true;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
    }
    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    }
    _effectiveController.addListener(_handleTextChanged);
    _effectiveFocusNode.addListener(_handleFocusChanged);
    _effectiveFocusNode.canRequestFocus = widget.enabled;
    _wasEmpty = _effectiveController.text.isEmpty;
  }

  @override
  void didUpdateWidget(CarbonEditableCore oldWidget) {
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
      _wasEmpty = _effectiveController.text.isEmpty;
    }

    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(
        _handleFocusChanged,
      );
      if (widget.focusNode != null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      } else {
        _internalFocusNode = FocusNode();
      }
      _effectiveFocusNode.addListener(_handleFocusChanged);
    }

    _effectiveFocusNode.canRequestFocus = widget.enabled;

    // TextField parity: toggling readOnly while focused with a collapsed
    // selection shows/hides the collapsed handle.
    if (_effectiveFocusNode.hasFocus &&
        widget.readOnly != oldWidget.readOnly &&
        widget.enabled) {
      if (_effectiveController.selection.isCollapsed) {
        _showSelectionHandles = !widget.readOnly;
      }
    }
  }

  @override
  void dispose() {
    (widget.controller ?? _internalController)?.removeListener(
      _handleTextChanged,
    );
    (widget.focusNode ?? _internalFocusNode)?.removeListener(
      _handleFocusChanged,
    );
    _internalController?.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    // The selection highlight is only painted while focused.
    if (mounted) setState(() {});
  }

  void _handleTextChanged() {
    // Only the placeholder depends on the text here — repaint on the
    // empty/non-empty transition, not every keystroke.
    final isEmpty = _effectiveController.text.isEmpty;
    if (isEmpty != _wasEmpty && mounted) {
      setState(() => _wasEmpty = isEmpty);
    }
  }

  /// TextField's handle-visibility state machine, verbatim.
  bool _shouldShowSelectionHandles(SelectionChangedCause? cause) {
    if (!_gestureBuilder.shouldShowSelectionToolbar ||
        !_gestureBuilder.shouldShowSelectionHandles) {
      return false;
    }
    if (cause == SelectionChangedCause.keyboard) return false;
    if (widget.readOnly && _effectiveController.selection.isCollapsed) {
      return false;
    }
    if (!widget.enabled) return false;
    if (cause == SelectionChangedCause.longPress ||
        cause == SelectionChangedCause.stylusHandwriting) {
      return true;
    }
    return _effectiveController.text.isNotEmpty;
  }

  void _handleSelectionChanged(
    TextSelection selection,
    SelectionChangedCause? cause,
  ) {
    final willShow = _shouldShowSelectionHandles(cause);
    if (willShow != _showSelectionHandles) {
      setState(() => _showSelectionHandles = willShow);
    }

    if (cause == SelectionChangedCause.longPress) {
      _editableText?.bringIntoView(selection.extent);
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        // Mouse drag-selecting dismisses an open toolbar on desktop.
        if (cause == SelectionChangedCause.drag) {
          _editableText?.hideToolbar();
        }
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        break;
    }
  }

  void _handleSelectionHandleTapped() {
    if (_effectiveController.selection.isCollapsed) {
      _editableText?.toggleToolbar();
    }
  }

  /// Stable instance-method tear-off. An inline closure would change
  /// identity every build, and `EditableText.didUpdateWidget` responds to a
  /// changed `contextMenuBuilder` by disposing and recreating its entire
  /// SelectionOverlay — overlay-entry churn that can crash mid-frame.
  Widget _buildContextMenu(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return CarbonTextSelectionToolbar.editable(
      editableTextState: editableTextState,
      labels: widget.selectionLabels ?? CarbonTextSelectionLabels.en(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final selectionStyle = DefaultSelectionStyle.of(context);
    final cursorColor =
        widget.cursorColor ??
        selectionStyle.cursorColor ??
        carbon.button.buttonPrimary;
    final selectionColor =
        widget.selectionColor ??
        selectionStyle.selectionColor ??
        carbon.button.buttonPrimary.withValues(alpha: 0.3);
    final style =
        widget.style ??
        DefaultTextStyle.of(
          context,
        ).style.copyWith(color: carbon.text.textPrimary);

    _selectionControls ??= CarbonTextSelectionControls(
      fallbackHandleColor: cursorColor,
    );

    Widget editable = EditableText(
      key: editableTextKey,
      controller: _effectiveController,
      focusNode: _effectiveFocusNode,
      style: style,
      cursorColor: cursorColor,
      backgroundCursorColor: carbon.text.textSecondary,
      // Highlight only while focused (TextField parity).
      selectionColor: _effectiveFocusNode.hasFocus ? selectionColor : null,
      showSelectionHandles: _showSelectionHandles,
      selectionControls: widget.enabled && selectionEnabled
          ? _selectionControls
          : null,
      contextMenuBuilder: widget.enabled ? _buildContextMenu : null,
      onSelectionChanged: _handleSelectionChanged,
      onSelectionHandleTapped: _handleSelectionHandleTapped,
      readOnly: widget.readOnly || !widget.enabled,
      showCursor: widget.enabled && !widget.readOnly ? null : false,
      // Gestures are delivered by the detector below, not the render object.
      rendererIgnoresPointer: true,
      // Carbon caret: sharp 1px bar.
      cursorWidth: 1.0,
      cursorOpacityAnimates: defaultTargetPlatform == TargetPlatform.iOS,
      paintCursorAboveText: defaultTargetPlatform == TargetPlatform.iOS,
      keyboardAppearance:
          widget.keyboardAppearance ??
          (carbon.layer.background.computeLuminance() < 0.5
              ? Brightness.dark
              : Brightness.light),
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      textAlign: widget.textAlign,
      autofocus: widget.autofocus && widget.enabled,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      onTapOutside: widget.onTapOutside,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      scrollPadding: widget.scrollPadding,
      autofillHints: widget.autofillHints,
      restorationId: widget.restorationId,
      undoController: widget.undoController,
      enableInteractiveSelection: selectionEnabled,
      mouseCursor:
          widget.mouseCursor ??
          (widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.basic),
    );

    if (widget.placeholder != null) {
      final placeholderStyle =
          widget.placeholderStyle ??
          style.copyWith(color: carbon.text.textPlaceholder);
      // Constant tree shape: the placeholder slot is always present (its
      // visibility toggles) so the editable never changes position — a
      // remount would drop the active input connection.
      editable = Stack(
        children: [
          Positioned.fill(
            child: Visibility(
              visible: _effectiveController.text.isEmpty,
              maintainSize: false,
              child: IgnorePointer(
                child: Text(
                  widget.placeholder!,
                  style: placeholderStyle,
                  maxLines: widget.maxLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign: widget.textAlign,
                ),
              ),
            ),
          ),
          editable,
        ],
      );
    }

    if (!widget.enabled) return editable;

    return _gestureBuilder.buildGestureDetector(
      behavior: HitTestBehavior.translucent,
      child: editable,
    );
  }
}

/// Minimal subclass: the widgets-layer base class implements the complete
/// platform gesture matrix (tap caret placement, double-tap word select,
/// long-press with haptics, mouse drag, secondary-tap toolbar). Override
/// nothing but the user-tap callback — exactly what Material's TextField
/// does.
class _CarbonEditableGestureBuilder
    extends TextSelectionGestureDetectorBuilder {
  _CarbonEditableGestureBuilder({required _CarbonEditableCoreState state})
    : _state = state,
      super(delegate: state);

  final _CarbonEditableCoreState _state;

  @override
  void onUserTap() => _state.widget.onTap?.call();
}
