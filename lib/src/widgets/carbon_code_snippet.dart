import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../base/carbon_pressable.dart';
import '../text/carbon_editable_core.dart';
import 'carbon_syntax.dart';
import '../foundation/colors.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// Type of code snippet.
enum CarbonCodeSnippetType {
  /// Inline code snippet for short snippets within text.
  inline,

  /// Single line code snippet in a container.
  single,

  /// Multi-line code snippet with expand/collapse functionality.
  multi,
}

/// Carbon Design System code snippet.
///
/// Displays code with syntax highlighting and a copy button.
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

  /// Whether to show the copy button.
  final bool showCopyButton;

  /// Feedback message shown after copying.
  final String feedbackMessage;

  /// Maximum number of lines to show when collapsed (multi-line only).
  final int maxCollapsedLines;

  /// Whether to use monospace font.
  final bool useMonospace;

  /// Optional syntax highlighter (e.g. [CarbonDartHighlighter]). When null
  /// the code renders in the single `codeText` color. Colors come from the
  /// theme's `carbon.syntax` tokens.
  final CarbonSyntaxHighlighter? highlighter;

  const CarbonCodeSnippet({
    super.key,
    required this.code,
    this.type = CarbonCodeSnippetType.single,
    this.showCopyButton = true,
    this.feedbackMessage = 'Copied!',
    this.maxCollapsedLines = 10,
    this.useMonospace = true,
    this.highlighter,
  });

  @override
  State<CarbonCodeSnippet> createState() => _CarbonCodeSnippetState();
}

class _CarbonCodeSnippetState extends State<CarbonCodeSnippet> {
  bool _isExpanded = false;
  bool _showFeedback = false;

  /// Backs the read-only editable in the multi-line variant. Text is
  /// assigned only from state changes (never in build).
  late final _HighlightingController _codeController = _HighlightingController(
    text: _displayedLines,
  );

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
  bool get _canExpand =>
      widget.type == CarbonCodeSnippetType.multi &&
      _lineCount > widget.maxCollapsedLines;

  String get _displayedLines => _canExpand && !_isExpanded
      ? widget.code.split('\n').take(widget.maxCollapsedLines).join('\n')
      : widget.code;

  @override
  void didUpdateWidget(CarbonCodeSnippet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.code != oldWidget.code ||
        widget.maxCollapsedLines != oldWidget.maxCollapsedLines ||
        widget.type != oldWidget.type) {
      _codeController.text = _displayedLines;
      _refreshHighlight();
    } else if (widget.highlighter != oldWidget.highlighter) {
      _refreshHighlight();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      _codeController.text = _displayedLines;
      _refreshHighlight();
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _showFeedback = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showFeedback = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    if (widget.type == CarbonCodeSnippetType.inline) {
      return _buildInline(carbon);
    } else if (widget.type == CarbonCodeSnippetType.single) {
      return _buildSingle(carbon);
    } else {
      return _buildMulti(carbon);
    }
  }

  /// Plain or syntax-highlighted code text for the non-editable variants.
  Widget _codeText(String code, TextStyle style, CarbonThemeData carbon) {
    final highlighter = widget.highlighter;
    if (highlighter == null) {
      return Text(code, style: style);
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
    );
  }

  Widget _buildInline(CarbonThemeData carbon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: carbon.codeSnippet.background,
        border: Border.all(color: carbon.codeSnippet.border),
      ),
      child: _codeText(
        widget.code,
        TextStyle(
          color: carbon.codeSnippet.codeText,
          fontFamily: widget.useMonospace ? 'monospace' : null,
          fontSize: 12,
        ),
        carbon,
      ),
    );
  }

  Widget _buildSingle(CarbonThemeData carbon) {
    return Container(
      decoration: BoxDecoration(
        color: carbon.codeSnippet.background,
        border: Border.all(color: carbon.codeSnippet.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              child: _codeText(
                widget.code,
                TextStyle(
                  color: carbon.codeSnippet.codeText,
                  fontFamily: widget.useMonospace ? 'monospace' : null,
                  fontSize: 14,
                ),
                carbon,
              ),
            ),
          ),
          if (widget.showCopyButton) _buildCopyButton(carbon),
        ],
      ),
    );
  }

  Widget _buildMulti(CarbonThemeData carbon) {
    final codeStyle = TextStyle(
      color: carbon.codeSnippet.codeText,
      fontFamily: widget.useMonospace ? 'monospace' : null,
      fontSize: 14,
      height: 1.5,
    );

    // A multiline EditableText needs bounded width inside the horizontal
    // scroll view — measure the widest laid-out line. Match the render
    // conditions (text scaler, accessibility bold), and pad by the caret
    // margin RenderEditable reserves inside its width (cursor 1px + 1px
    // gap) or the longest line wraps.
    final measureStyle = MediaQuery.boldTextOf(context)
        ? codeStyle.copyWith(fontWeight: FontWeight.bold)
        : codeStyle;
    final painter = TextPainter(
      text: TextSpan(text: _codeController.text, style: measureStyle),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final textWidth = painter.width + 4;
    painter.dispose();

    return Container(
      decoration: BoxDecoration(
        color: carbon.codeSnippet.background,
        border: Border.all(color: carbon.codeSnippet.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: textWidth,
                    // Read-only selectable text with the Carbon-native
                    // selection UX (context menu, handles).
                    child: CarbonEditableCore(
                      controller: _codeController,
                      readOnly: true,
                      maxLines: null,
                      style: codeStyle,
                    ),
                  ),
                ),
              ),
              if (widget.showCopyButton) _buildCopyButton(carbon),
            ],
          ),
          if (_canExpand)
            CarbonPressable(
              onTap: _toggleExpanded,
              builder: (context, _) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: carbon.codeSnippet.border),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isExpanded ? 'Show less' : 'Show more',
                      style: TextStyle(
                        color: carbon.text.linkPrimary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _isExpanded
                          ? CarbonIcons.chevronUp
                          : CarbonIcons.chevronDown,
                      color: carbon.text.linkPrimary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCopyButton(CarbonThemeData carbon) {
    return _CopyButton(
      onPressed: _copyToClipboard,
      showFeedback: _showFeedback,
      feedbackMessage: widget.feedbackMessage,
      backgroundColor: carbon.codeSnippet.copyButtonBackground,
      backgroundHoverColor: carbon.codeSnippet.copyButtonBackgroundHover,
      iconColor: carbon.codeSnippet.copyButtonIcon,
      feedbackColor: carbon.text.textPrimary,
      feedbackBackground: carbon.layer.layer01,
    );
  }
}

/// Internal copy button widget.
class _CopyButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool showFeedback;
  final String feedbackMessage;
  final Color backgroundColor;
  final Color backgroundHoverColor;
  final Color iconColor;
  final Color feedbackColor;
  final Color feedbackBackground;

  const _CopyButton({
    required this.onPressed,
    required this.showFeedback,
    required this.feedbackMessage,
    required this.backgroundColor,
    required this.backgroundHoverColor,
    required this.iconColor,
    required this.feedbackColor,
    required this.feedbackBackground,
  });

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.backgroundHoverColor
                    : widget.backgroundColor,
                border: Border(
                  left: BorderSide(
                    color: widget.iconColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Icon(CarbonIcons.copy, color: widget.iconColor, size: 16),
            ),
          ),
        ),
        if (widget.showFeedback)
          Positioned(
            top: -36,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.feedbackBackground,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: CarbonPalette.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.feedbackMessage,
                style: TextStyle(color: widget.feedbackColor, fontSize: 12),
              ),
            ),
          ),
      ],
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
