import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  const CarbonCodeSnippet({
    super.key,
    required this.code,
    this.type = CarbonCodeSnippetType.single,
    this.showCopyButton = true,
    this.feedbackMessage = 'Copied!',
    this.maxCollapsedLines = 10,
    this.useMonospace = true,
  });

  @override
  State<CarbonCodeSnippet> createState() => _CarbonCodeSnippetState();
}

class _CarbonCodeSnippetState extends State<CarbonCodeSnippet> {
  bool _isExpanded = false;
  bool _showFeedback = false;

  int get _lineCount => widget.code.split('\n').length;
  bool get _canExpand =>
      widget.type == CarbonCodeSnippetType.multi &&
      _lineCount > widget.maxCollapsedLines;

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

  Widget _buildInline(CarbonThemeData carbon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: carbon.codeSnippet.background,
        border: Border.all(color: carbon.codeSnippet.border),
      ),
      child: Text(
        widget.code,
        style: TextStyle(
          color: carbon.codeSnippet.codeText,
          fontFamily: widget.useMonospace ? 'monospace' : null,
          fontSize: 12,
        ),
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
              child: Text(
                widget.code,
                style: TextStyle(
                  color: carbon.codeSnippet.codeText,
                  fontFamily: widget.useMonospace ? 'monospace' : null,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (widget.showCopyButton) _buildCopyButton(carbon),
        ],
      ),
    );
  }

  Widget _buildMulti(CarbonThemeData carbon) {
    final lines = widget.code.split('\n');
    final displayedLines = _canExpand && !_isExpanded
        ? lines.take(widget.maxCollapsedLines).join('\n')
        : widget.code;

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
                  child: SelectableText(
                    displayedLines,
                    style: TextStyle(
                      color: carbon.codeSnippet.codeText,
                      fontFamily: widget.useMonospace ? 'monospace' : null,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              if (widget.showCopyButton) _buildCopyButton(carbon),
            ],
          ),
          if (_canExpand)
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Container(
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
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
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
              child: Icon(
                Icons.content_copy,
                color: widget.iconColor,
                size: 16,
              ),
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
                    color: Colors.black.withValues(alpha: 0.2),
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
