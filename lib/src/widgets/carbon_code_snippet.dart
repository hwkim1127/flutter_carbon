import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../base/carbon_copy_feedback.dart';
import '../base/carbon_pressable.dart';
import '../base/carbon_scrollbar.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../icons/carbon_icons.dart';
import '../text/carbon_editable_core.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';
import 'carbon_button.dart';
import 'carbon_copy_button.dart';
import 'carbon_skeleton.dart';
import 'carbon_syntax.dart';

/// Type of code snippet.
enum CarbonCodeSnippetType {
  /// Inline code snippet for short snippets within text.
  inline,

  /// Single line code snippet in a container.
  single,

  /// Multi-line code snippet with expand/collapse functionality.
  multi,
}

/// Overridable labels for [CarbonCodeSnippet] (English defaults).
class CarbonCodeSnippetLabels {
  const CarbonCodeSnippetLabels({
    this.copyToClipboard = 'Copy to clipboard',
    this.copied = 'Copied!',
    this.showMore = 'Show more',
    this.showLess = 'Show less',
    this.codeSnippet = 'code-snippet',
  });

  /// English labels (the defaults).
  factory CarbonCodeSnippetLabels.en() => const CarbonCodeSnippetLabels();

  /// Accessible label for the copy trigger.
  final String copyToClipboard;

  /// Feedback tooltip text shown after copying.
  final String copied;

  /// Expand button label (multi-line, collapsed).
  final String showMore;

  /// Collapse button label (multi-line, expanded).
  final String showLess;

  /// Accessible label for the snippet container.
  final String codeSnippet;
}

/// One spec row of `code-01` text: 12px / 16px line height. All multi-line
/// row math is rows × this (scaled by the ambient text scaler).
const double _kRowHeight = 16.0;

/// Carbon Design System code snippet.
///
/// Displays code in the three Carbon variants:
///
/// - [CarbonCodeSnippetType.inline] — a 20px chip for snippets within text;
///   the whole chip is the copy trigger (per spec) unless [hideCopyButton].
/// - [CarbonCodeSnippetType.single] — a 40px single-line field with
///   horizontal scrolling, an overflow fade, and a copy button.
/// - [CarbonCodeSnippetType.multi] — a multi-line block with selectable
///   text, Show more/less row-based collapsing, overflow fades, optional
///   [wrapText], and a copy button.
///
/// Optionally syntax-highlighted via [highlighter]; colors come from the
/// theme's `carbon.syntax` tokens.
///
/// Example:
/// ```dart
/// CarbonCodeSnippet(
///   code: 'print("Hello World")',
///   type: CarbonCodeSnippetType.single,
/// )
/// ```
class CarbonCodeSnippet extends StatefulWidget {
  /// The code to display.
  final String code;

  /// The type of code snippet.
  final CarbonCodeSnippetType type;

  /// Hides the copy affordance (button, or the inline chip's interactivity).
  final bool hideCopyButton;

  /// Overrides what is written to the clipboard (defaults to [code]).
  final String? copyText;

  /// How long the copy feedback tooltip stays before fading out.
  final Duration feedbackTimeout;

  /// Called after the code is copied.
  final VoidCallback? onCopy;

  /// Soft-wrap long lines instead of scrolling horizontally (multi only).
  final bool wrapText;

  /// Show a non-selectable line-number gutter (multi only; ignored by the
  /// inline and single variants). The numbers live outside the selectable
  /// text, so selection and copy never include them.
  final bool showLineNumbers;

  /// Disables interaction and renders disabled colors (single/multi only —
  /// Carbon's inline snippet has no disabled state).
  final bool disabled;

  /// Collapsed height cap in 16px rows (multi only).
  final int maxCollapsedNumberOfRows;

  /// Collapsed minimum height in 16px rows (multi only).
  final int minCollapsedNumberOfRows;

  /// Expanded height cap in 16px rows; 0 means unbounded (multi only).
  final int maxExpandedNumberOfRows;

  /// Expanded minimum height in 16px rows (multi only).
  final int minExpandedNumberOfRows;

  /// Optional syntax highlighter (e.g. [CarbonDartHighlighter]). When null
  /// the code renders in the single `codeText` color.
  final CarbonSyntaxHighlighter? highlighter;

  /// Overridable UI labels.
  final CarbonCodeSnippetLabels labels;

  const CarbonCodeSnippet({
    super.key,
    required this.code,
    this.type = CarbonCodeSnippetType.single,
    this.hideCopyButton = false,
    this.copyText,
    this.feedbackTimeout = const Duration(milliseconds: 2000),
    this.onCopy,
    this.wrapText = false,
    this.showLineNumbers = false,
    this.disabled = false,
    this.maxCollapsedNumberOfRows = 15,
    this.minCollapsedNumberOfRows = 3,
    this.maxExpandedNumberOfRows = 0,
    this.minExpandedNumberOfRows = 16,
    this.highlighter,
    this.labels = const CarbonCodeSnippetLabels(),
  })  : assert(maxCollapsedNumberOfRows >= 0),
        assert(minCollapsedNumberOfRows >= 0),
        assert(maxExpandedNumberOfRows >= 0),
        assert(minExpandedNumberOfRows >= 0);

  @override
  State<CarbonCodeSnippet> createState() => _CarbonCodeSnippetState();
}

class _CarbonCodeSnippetState extends State<CarbonCodeSnippet> {
  bool _expanded = false;

  /// Whether focus is anywhere inside the snippet (removes the overflow
  /// fades, per spec `:focus-within`).
  bool _focusWithin = false;

  /// Inline-variant feedback state (single/multi delegate to
  /// [CarbonCopyButton], which owns its own).
  bool _showInlineFeedback = false;
  Timer? _inlineFeedbackTimer;

  /// Backs the read-only editable in the multi-line variant. Always holds
  /// the FULL code — collapsing clips the viewport height, never the text,
  /// so selection survives expand/collapse and copy gets everything.
  late final _HighlightingController _codeController =
      _HighlightingController(text: widget.code);

  /// Drive the [CarbonScrollbar] indicators (Carbon web relies on native
  /// browser scrollbars; Flutter has none, so the snippet draws its own).
  /// Only one variant is mounted at a time, so the horizontal controller is
  /// shared between single and no-wrap multi.
  final ScrollController _verticalScroll = ScrollController();
  final ScrollController _horizontalScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _refreshHighlight();
  }

  /// Recomputes highlight spans for the controller's current text. Called
  /// wherever the text or highlighter changes — never in build.
  void _refreshHighlight() {
    final highlighter = widget.highlighter;
    _codeController
      ..highlightSpans =
          highlighter?.highlight(_codeController.text) ?? const []
      ..highlightEnabled = highlighter != null;
  }

  int get _lineCount => widget.code.split('\n').length;

  @override
  void didUpdateWidget(CarbonCodeSnippet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.code != oldWidget.code) {
      _codeController.text = widget.code;
      _refreshHighlight();
    } else if (widget.highlighter != oldWidget.highlighter) {
      _refreshHighlight();
    }
    // Auto-collapse when the content shrinks to the expanded minimum
    // (React parity). Line-count based — in wrapText mode this
    // underestimates visual rows; accepted best effort.
    if (_expanded &&
        (widget.code != oldWidget.code ||
            widget.minExpandedNumberOfRows !=
                oldWidget.minExpandedNumberOfRows) &&
        _lineCount <= widget.minExpandedNumberOfRows) {
      _expanded = false;
    }
  }

  @override
  void dispose() {
    _inlineFeedbackTimer?.cancel();
    _verticalScroll.dispose();
    _horizontalScroll.dispose();
    _codeController.dispose();
    super.dispose();
  }


  String get _textToCopy => widget.copyText ?? widget.code;

  void _copyInline() {
    Clipboard.setData(ClipboardData(text: _textToCopy));
    widget.onCopy?.call();
    setState(() => _showInlineFeedback = true);
    _inlineFeedbackTimer?.cancel();
    _inlineFeedbackTimer = Timer(widget.feedbackTimeout, () {
      if (mounted) setState(() => _showInlineFeedback = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    switch (widget.type) {
      case CarbonCodeSnippetType.inline:
        return _buildInline(carbon);
      case CarbonCodeSnippetType.single:
        return _buildSingle(carbon);
      case CarbonCodeSnippetType.multi:
        return _buildMulti(carbon);
    }
  }

  TextStyle _codeStyle(CarbonThemeData carbon) => CarbonTypography.code01
      .copyWith(
        color: widget.disabled &&
                widget.type != CarbonCodeSnippetType.inline
            ? carbon.text.textDisabled
            : carbon.codeSnippet.codeText,
      );

  /// Plain or syntax-highlighted code text for the non-editable variants.
  Widget _codeText(String code, TextStyle style, CarbonThemeData carbon) {
    final highlighter = widget.highlighter;
    if (highlighter == null) {
      return Text(code, style: style, softWrap: false);
    }
    return Text.rich(
      TextSpan(
        style: style,
        children: carbonSyntaxTextSpans(
          code: code,
          spans: highlighter.highlight(code),
          baseStyle: style,
          syntax: carbon.syntax,
        ),
      ),
      softWrap: false,
    );
  }

  // ---------------------------------------------------------------- inline

  Widget _buildInline(CarbonThemeData carbon) {
    final style = _codeStyle(carbon);

    if (widget.hideCopyButton) {
      return Container(
        height: 20,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: carbon.codeSnippet.background,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: CarbonPalette.transparent),
        ),
        child: Center(
          widthFactor: 1,
          child: _codeText(widget.code, style, carbon),
        ),
      );
    }

    // Per spec the whole inline chip is the copy trigger.
    return CarbonCopyFeedback(
      visible: _showInlineFeedback,
      message: widget.labels.copied,
      child: Semantics(
        container: true,
        button: true,
        label: widget.labels.copyToClipboard,
        child: CarbonPressable(
          onTap: _copyInline,
          focusable: true,
          builder: (context, state) => Container(
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: state.pressed
                  ? carbon.layer.layerActive01
                  : state.hovered
                      ? carbon.layer.layerHover01
                      : carbon.codeSnippet.background,
              // The one border radius in Carbon.
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: state.focused
                    ? carbon.layer.focus
                    : CarbonPalette.transparent,
              ),
            ),
            child: Center(
              widthFactor: 1,
              child: _codeText(widget.code, style, carbon),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- single

  Widget _buildSingle(CarbonThemeData carbon) {
    final style = _codeStyle(carbon);
    final background = carbon.codeSnippet.background;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 768),
      child: Focus(
        canRequestFocus: !widget.disabled,
        onFocusChange: (v) => setState(() => _focusWithin = v),
        child: Semantics(
          container: true,
          // Keep the copy button (and any focused descendants) as their own
          // semantics nodes instead of fusing into the textbox node.
          explicitChildNodes: true,
          label: widget.labels.codeSnippet,
          readOnly: true,
          textField: true,
          child: Container(
            height: 40,
            color: background,
            // Always-present (transparent) outline keeps the tree shape
            // stable when focus toggles.
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: _focusWithin
                    ? carbon.layer.focus
                    : CarbonPalette.transparent,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  // The scrollbar wraps the Stack so its thumb paints above
                  // the edge fade.
                  child: CarbonScrollbar(
                    controller: _horizontalScroll,
                    axis: Axis.horizontal,
                    builder: (context, scrollController) => Stack(
                      children: [
                        SingleChildScrollView(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsetsDirectional.only(
                            start: 16,
                            end: 32,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            widthFactor: 1,
                            child: _codeText(widget.code, style, carbon),
                          ),
                        ),
                        if (!_focusWithin)
                          PositionedDirectional(
                            end: 0,
                            top: 0,
                            bottom: 0,
                            width: 32,
                            child: _EdgeFade(
                              background: background,
                              horizontal: true,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (!widget.hideCopyButton)
                  CarbonCopyButton(
                    textToCopy: _textToCopy,
                    size: CarbonCopyButtonSize.md,
                    feedback: widget.labels.copied,
                    feedbackTimeout: widget.feedbackTimeout,
                    iconDescription: widget.labels.copyToClipboard,
                    onCopied: widget.onCopy,
                    enabled: !widget.disabled,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------- multi

  Widget _buildMulti(CarbonThemeData carbon) {
    final style = _codeStyle(carbon);
    final background = carbon.codeSnippet.background;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 768),
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: (v) => setState(() => _focusWithin = v),
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          label: widget.labels.codeSnippet,
          readOnly: true,
          textField: true,
          multiline: true,
          child: ColoredBox(
            color: background,
            child: LayoutBuilder(
              builder: (context, constraints) =>
                  _buildMultiContent(carbon, style, background, constraints),
            ),
          ),
        ),
      ),
    );
  }

  /// Wraps the code area with the optional line-number gutter: a
  /// pointer-transparent, semantics-excluded column sharing the code's row
  /// metrics, OUTSIDE the selectable text (and outside the horizontal
  /// scroll, so it stays pinned).
  Widget _withGutter(
    CarbonThemeData carbon,
    TextStyle codeStyle, {
    required double rowHeight,
    required double gutterWidth,
    required int lineCount,
    required List<int>? rowsPerLine,
    required Widget child,
  }) {
    if (!widget.showLineNumbers) return child;

    final gutterStyle = codeStyle.copyWith(
      color: widget.disabled
          ? carbon.text.textDisabled
          : carbon.text.textSecondary,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IgnorePointer(
          child: ExcludeSemantics(
            child: SizedBox(
              width: gutterWidth,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: Column(
                  children: [
                    for (var i = 0; i < lineCount; i++)
                      SizedBox(
                        // In wrap mode a logical line can span several
                        // visual rows; the number sits on the first.
                        height: (rowsPerLine?[i] ?? 1) * rowHeight,
                        child: Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Text('${i + 1}', style: gutterStyle),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildMultiContent(
    CarbonThemeData carbon,
    TextStyle style,
    Color background,
    BoxConstraints constraints,
  ) {
    final textScaler = MediaQuery.textScalerOf(context);
    final rowHeight = textScaler.scale(_kRowHeight);

    // A multiline EditableText needs bounded width inside the horizontal
    // scroll view — measure the widest laid-out line. Match the render
    // conditions (text scaler, accessibility bold), and pad by the caret
    // margin RenderEditable reserves inside its width (cursor 1px + 1px
    // gap) or the longest line wraps.
    final measureStyle = MediaQuery.boldTextOf(context)
        ? style.copyWith(fontWeight: FontWeight.bold)
        : style;

    final lines = widget.code.split('\n');

    // Gutter width: the digit count of the last line number, measured in
    // the same style as the code (plus a 16px gap to the code).
    var gutterWidth = 0.0;
    if (widget.showLineNumbers) {
      final digitPainter = TextPainter(
        text: TextSpan(
          text: '9' * '${lines.length}'.length,
          style: measureStyle,
        ),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      )..layout();
      gutterWidth = digitPainter.width + 16;
      digitPainter.dispose();
    }

    final int contentRows;
    double? measuredWidth;

    /// Visual rows per logical line — only computed when the wrap-mode
    /// gutter needs to place one number per logical line.
    List<int>? rowsPerLine;
    if (widget.wrapText) {
      // Wrapped rows at the width the editable will actually get:
      // container width minus the 16px side paddings and the gutter.
      final wrapWidth = (constraints.maxWidth - 32 - gutterWidth)
          .clamp(1.0, double.infinity);
      if (widget.showLineNumbers) {
        rowsPerLine = <int>[];
        var total = 0;
        for (final line in lines) {
          final painter = TextPainter(
            text: TextSpan(text: line.isEmpty ? ' ' : line,
                style: measureStyle),
            textDirection: TextDirection.ltr,
            textScaler: textScaler,
          )..layout(maxWidth: wrapWidth);
          final rows = (painter.height / rowHeight).round().clamp(1, 1 << 31);
          painter.dispose();
          rowsPerLine.add(rows);
          total += rows;
        }
        contentRows = total;
      } else {
        final painter = TextPainter(
          text: TextSpan(text: widget.code, style: measureStyle),
          textDirection: TextDirection.ltr,
          textScaler: textScaler,
        )..layout(maxWidth: wrapWidth);
        contentRows =
            (painter.height / rowHeight).round().clamp(1, 1 << 31);
        painter.dispose();
      }
    } else {
      contentRows = lines.length;
      final painter = TextPainter(
        text: TextSpan(text: widget.code, style: measureStyle),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      )..layout();
      measuredWidth = painter.width + 4;
      painter.dispose();
    }

    // Spec row model (React CodeSnippet parity).
    final maxCollapsed = widget.maxCollapsedNumberOfRows;
    final minCollapsed = widget.minCollapsedNumberOfRows;
    final maxExpanded = widget.maxExpandedNumberOfRows;
    final minExpanded = widget.minExpandedNumberOfRows;

    final canExpand = contentRows > maxCollapsed &&
        (maxExpanded == 0 || maxExpanded > maxCollapsed);
    final expanded = _expanded && canExpand;

    // React's box is CONTENT-sized between the row limits (min/max-height
    // CSS) — and the content includes the 24px scroll padding below the
    // last row. A pure rows×16 height would leave a spurious 24px scroll
    // (and a scrollbar thumb) on snippets that visually fit.
    final contentExtent = contentRows * rowHeight + 24;
    final double viewportHeight;
    if (expanded) {
      final minH = minExpanded * rowHeight;
      viewportHeight = maxExpanded == 0
          ? (contentExtent > minH ? contentExtent : minH)
          : contentExtent.clamp(
              minH < maxExpanded * rowHeight ? minH : maxExpanded * rowHeight,
              maxExpanded * rowHeight,
            );
    } else {
      final minH = minCollapsed * rowHeight;
      viewportHeight = contentExtent.clamp(
        minH < maxCollapsed * rowHeight ? minH : maxCollapsed * rowHeight,
        maxCollapsed * rowHeight,
      );
    }

    final editable = CarbonEditableCore(
      controller: _codeController,
      readOnly: true,
      enabled: !widget.disabled,
      maxLines: null,
      style: style,
    );

    // The clipped viewport: scroll views at the bottom, edge fades above
    // them. The scrollbar wrappers below paint their thumbs via
    // foregroundPainter — ABOVE everything here, so the fades never wash
    // the thumbs out.
    Widget viewport = ClipRect(
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _verticalScroll,
            padding: const EdgeInsets.only(bottom: 24),
            child: _withGutter(
              carbon,
              style,
              rowHeight: rowHeight,
              gutterWidth: gutterWidth,
              lineCount: lines.length,
              rowsPerLine: rowsPerLine,
              // The code area scrolls horizontally in no-wrap mode;
              // the gutter sits beside it, pinned.
              child: widget.wrapText
                  ? editable
                  : SingleChildScrollView(
                      controller: _horizontalScroll,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsetsDirectional.only(end: 24),
                      child: SizedBox(
                        width: measuredWidth,
                        child: editable,
                      ),
                    ),
            ),
          ),
          // Overflow fades — pointer-transparent, removed on focus-within.
          if (!widget.wrapText && !_focusWithin)
            PositionedDirectional(
              end: 0,
              top: 0,
              bottom: 0,
              width: 32,
              child: _EdgeFade(background: background, horizontal: true),
            ),
          if (canExpand && !expanded && !_focusWithin)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 16,
              child: _EdgeFade(background: background, horizontal: false),
            ),
        ],
      ),
    );

    if (!widget.wrapText) {
      final inner = viewport;
      viewport = CarbonScrollbar(
        controller: _horizontalScroll,
        axis: Axis.horizontal,
        // The horizontal scrollable is nested inside the vertical one, so
        // its notifications arrive at depth 1 — filter by axis only.
        notificationPredicate: (n) => n.metrics.axis == Axis.horizontal,
        // Keep the track off the line-number gutter (cosmetic limit: the
        // track ends gutterWidth short of the trailing edge).
        padding: EdgeInsetsDirectional.only(start: gutterWidth),
        builder: (context, _) => inner,
      );
    }
    {
      final inner = viewport;
      viewport = CarbonScrollbar(
        controller: _verticalScroll,
        builder: (context, _) => inner,
      );
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          // Fill the container (spec inline-size 100%) — the scroll views
          // would otherwise shrink-wrap the Stack to the code width.
          child: SizedBox(
            width: (constraints.maxWidth - 32).clamp(0.0, double.infinity),
            child: AnimatedContainer(
              duration: CarbonMotion.durationModerate01,
              curve: CarbonMotion.standardProductive,
              height: viewportHeight,
              child: viewport,
            ),
          ),
        ),
        if (!widget.hideCopyButton)
          PositionedDirectional(
            top: 8,
            end: 8,
            child: CarbonCopyButton(
              textToCopy: _textToCopy,
              size: CarbonCopyButtonSize.sm,
              feedback: widget.labels.copied,
              feedbackTimeout: widget.feedbackTimeout,
              iconDescription: widget.labels.copyToClipboard,
              onCopied: widget.onCopy,
              enabled: !widget.disabled,
            ),
          ),
        if (canExpand)
          PositionedDirectional(
            bottom: 0,
            end: 0,
            // Ghost buttons are transparent; the spec gives the expand
            // button a $layer background so it reads over the code.
            child: ColoredBox(
              color: background,
              child: CarbonButton(
                kind: CarbonButtonKind.ghost,
                size: CarbonButtonSize.sm,
                onPressed: widget.disabled
                    ? null
                    : () => setState(() => _expanded = !_expanded),
                icon: AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: CarbonMotion.durationModerate01,
                  curve: CarbonMotion.standardProductive,
                  child: const Icon(CarbonIcons.chevronDown, size: 16),
                ),
                child: Text(
                  expanded ? widget.labels.showLess : widget.labels.showMore,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Loading placeholder matching [CarbonCodeSnippet] geometry (Carbon's
/// `CodeSnippetSkeleton`): single = 56px with one shimmer bar, multi = 98px
/// with three bars (100% / 85% / 95% width). Inline renders like single.
class CarbonCodeSnippetSkeleton extends StatelessWidget {
  /// Which snippet variant to mimic.
  final CarbonCodeSnippetType type;

  const CarbonCodeSnippetSkeleton({
    super.key,
    this.type = CarbonCodeSnippetType.single,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final background = carbon.codeSnippet.background;

    if (type == CarbonCodeSnippetType.multi) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 768),
        child: Container(
          height: 98,
          color: background,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              CarbonSkeleton(height: 16),
              SizedBox(height: 8),
              FractionallySizedBox(
                widthFactor: 0.85,
                alignment: AlignmentDirectional.centerStart,
                child: CarbonSkeleton(height: 16),
              ),
              SizedBox(height: 8),
              FractionallySizedBox(
                widthFactor: 0.95,
                alignment: AlignmentDirectional.centerStart,
                child: CarbonSkeleton(height: 16),
              ),
            ],
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 768),
      child: Container(
        height: 56,
        color: background,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: AlignmentDirectional.centerStart,
        child: const CarbonSkeleton(height: 16),
      ),
    );
  }
}

/// A pointer-transparent gradient overlay standing in for Carbon's CSS
/// `mask-image` overflow fades — visually equivalent over the snippet's
/// opaque `$layer` background.
class _EdgeFade extends StatelessWidget {
  final Color background;

  /// True fades toward the reading end (start→end), false fades downward.
  final bool horizontal;

  const _EdgeFade({required this.background, required this.horizontal});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: horizontal
                ? AlignmentDirectional.centerStart
                : Alignment.topCenter,
            end: horizontal
                ? AlignmentDirectional.centerEnd
                : Alignment.bottomCenter,
            colors: [background.withValues(alpha: 0), background],
          ),
        ),
      ),
    );
  }
}

/// Controller whose [buildTextSpan] paints cached highlight spans — the
/// standard rich-code pattern for [EditableText]: the text itself is
/// unchanged, so selection and copy keep working.
class _HighlightingController extends TextEditingController {
  _HighlightingController({super.text});

  /// Spans matching the CURRENT [text]; owner updates both together.
  List<CarbonSyntaxSpan> highlightSpans = const [];
  bool highlightEnabled = false;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // withComposing is irrelevant: the snippet's editable is read-only.
    if (!highlightEnabled || highlightSpans.isEmpty) {
      return TextSpan(style: style, text: text);
    }
    return TextSpan(
      style: style,
      children: carbonSyntaxTextSpans(
        code: text,
        spans: highlightSpans,
        baseStyle: style,
        syntax: context.carbon.syntax,
      ),
    );
  }
}
