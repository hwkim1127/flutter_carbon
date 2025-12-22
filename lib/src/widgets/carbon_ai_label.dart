import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// AI Label size.
enum CarbonAILabelSize {
  /// Mini size.
  mini,

  /// Extra extra small size.
  xs2,

  /// Extra small size.
  xs,

  /// Small size.
  sm,

  /// Medium size.
  md,

  /// Large size.
  lg,

  /// Extra large size.
  xl,
}

/// AI Label kind.
enum CarbonAILabelKind {
  /// Default kind - icon badge.
  defaultKind,

  /// Inline kind - with text label.
  inline,
}

/// Carbon Design System AI Label.
///
/// An AI indicator badge that shows content is AI-generated.
/// Can display as an icon badge or inline with additional text.
///
/// Example:
/// ```dart
/// CarbonAILabel(
///   aiText: 'AI',
///   onTap: () {
///     // Show AI information popover
///   },
/// )
/// ```
class CarbonAILabel extends StatefulWidget {
  /// The AI text to display (typically "AI").
  final String aiText;

  /// Additional text to display in inline variant.
  final String? aiTextLabel;

  /// The type of AI Label.
  final CarbonAILabelKind kind;

  /// The size of the AI Label.
  final CarbonAILabelSize size;

  /// Callback when the label is tapped.
  final VoidCallback? onTap;

  /// Whether the revert button should be visible.
  final bool revertActive;

  /// Callback when the revert button is tapped.
  final VoidCallback? onRevert;

  /// Label for the revert button tooltip.
  final String revertLabel;

  /// Accessible label for the button.
  final String buttonLabel;

  const CarbonAILabel({
    super.key,
    this.aiText = 'AI',
    this.aiTextLabel,
    this.kind = CarbonAILabelKind.defaultKind,
    this.size = CarbonAILabelSize.xs,
    this.onTap,
    this.revertActive = false,
    this.onRevert,
    this.revertLabel = 'Revert to AI input',
    this.buttonLabel = 'Show information',
  });

  @override
  State<CarbonAILabel> createState() => _CarbonAILabelState();
}

class _CarbonAILabelState extends State<CarbonAILabel> {
  bool _isHovered = false;

  double _getSizeValue() {
    switch (widget.size) {
      case CarbonAILabelSize.mini:
        return 16;
      case CarbonAILabelSize.xs2:
        return 20;
      case CarbonAILabelSize.xs:
        return 24;
      case CarbonAILabelSize.sm:
        return 28;
      case CarbonAILabelSize.md:
        return 32;
      case CarbonAILabelSize.lg:
        return 36;
      case CarbonAILabelSize.xl:
        return 40;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case CarbonAILabelSize.mini:
        return 10;
      case CarbonAILabelSize.xs2:
      case CarbonAILabelSize.xs:
        return 11;
      case CarbonAILabelSize.sm:
        return 12;
      case CarbonAILabelSize.md:
      case CarbonAILabelSize.lg:
        return 14;
      case CarbonAILabelSize.xl:
        return 16;
    }
  }

  void _handleTap() {
    if (widget.revertActive) {
      widget.onRevert?.call();
    } else {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    if (widget.revertActive) {
      return _buildRevertButton(carbon);
    }

    return _buildAILabel(carbon);
  }

  Widget _buildRevertButton(CarbonThemeData carbon) {
    final sizeValue = _getSizeValue();

    return Semantics(
      button: true,
      label: widget.revertLabel,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _handleTap,
          child: Container(
            width: sizeValue,
            height: sizeValue,
            decoration: BoxDecoration(
              color: _isHovered
                  ? carbon.ai.aiAuraHoverBackground
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(sizeValue / 2),
            ),
            child: Icon(
              Icons.undo,
              size: sizeValue * 0.6,
              color: carbon.text.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAILabel(CarbonThemeData carbon) {
    final sizeValue = _getSizeValue();
    final fontSize = _getFontSize();
    final hasAdditionalText =
        widget.kind == CarbonAILabelKind.inline && widget.aiTextLabel != null;

    return Semantics(
      button: true,
      label: '${widget.aiText} - ${widget.buttonLabel}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor:
            widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: widget.onTap != null ? _handleTap : null,
          child: Container(
            height: sizeValue,
            padding: EdgeInsets.symmetric(
              horizontal: hasAdditionalText ? 8 : 0,
            ),
            decoration: BoxDecoration(
              gradient: _isHovered
                  ? LinearGradient(
                      colors: [
                        carbon.ai.aiAuraHoverStart,
                        carbon.ai.aiAuraHoverEnd,
                      ],
                    )
                  : LinearGradient(
                      colors: [carbon.ai.aiAuraStart, carbon.ai.aiAuraEnd],
                    ),
              borderRadius: BorderRadius.circular(sizeValue / 2),
              boxShadow: [
                // Layer 1: Ambient shadow (soft, diffuse)
                BoxShadow(
                  color: carbon.ai.aiDropShadow.withValues(alpha: 0.12),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
                // Layer 2: Penumbra (medium shadow)
                BoxShadow(
                  color: carbon.ai.aiDropShadow.withValues(alpha: 0.16),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
                // Layer 3: Key shadow (darker, more defined)
                BoxShadow(
                  color: carbon.ai.aiDropShadow.withValues(alpha: 0.20),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: hasAdditionalText ? 10 : 6,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                gradient: _isHovered
                    ? LinearGradient(
                        colors: [
                          carbon.ai.aiBorderStart,
                          carbon.ai.aiBorderEnd,
                        ],
                      )
                    : null,
                color: _isHovered ? null : carbon.layer.layer01,
                borderRadius: BorderRadius.circular(sizeValue / 2),
                border: Border.all(width: 1.5, color: Colors.transparent),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.aiText,
                    style: TextStyle(
                      color: carbon.text.textPrimary,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                  if (hasAdditionalText) ...[
                    const SizedBox(width: 4),
                    Text(
                      widget.aiTextLabel!,
                      style: TextStyle(
                        color: carbon.text.textSecondary,
                        fontSize: fontSize,
                        height: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
