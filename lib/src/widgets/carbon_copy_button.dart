import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import '../base/carbon_anchored_overlay.dart';
import '../base/carbon_copy_feedback.dart';
import '../base/carbon_pressable.dart';
import '../foundation/colors.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';

/// Size variants for [CarbonCopyButton].
enum CarbonCopyButtonSize {
  /// Small — 32×32 (the code snippet multi-line variant).
  sm(32),

  /// Medium — 40×40 (default; the code snippet single-line variant).
  md(40),

  /// Large — 48×48.
  lg(48);

  const CarbonCopyButtonSize(this.dimension);

  /// Button side length in pixels.
  final double dimension;
}

/// Carbon Design System copy button.
///
/// An icon-only square button that copies [textToCopy] to the clipboard and
/// confirms with a "Copied!" feedback tooltip that fades out after
/// [feedbackTimeout].
///
/// Example:
/// ```dart
/// CarbonCopyButton(
///   textToCopy: 'npm install carbon-components',
///   onCopied: () => print('Copied!'),
/// )
/// ```
class CarbonCopyButton extends StatefulWidget {
  /// The text to copy to clipboard.
  final String textToCopy;

  /// Called after the text is copied.
  final VoidCallback? onCopied;

  /// Button size (icon stays 16px).
  final CarbonCopyButtonSize size;

  /// The feedback tooltip text shown after copying.
  final String feedback;

  /// How long the feedback tooltip stays before fading out.
  final Duration feedbackTimeout;

  /// Accessible label for the button (Carbon's `iconDescription`).
  final String iconDescription;

  /// Whether the button is enabled.
  final bool enabled;

  const CarbonCopyButton({
    super.key,
    required this.textToCopy,
    this.onCopied,
    this.size = CarbonCopyButtonSize.md,
    this.feedback = 'Copied!',
    this.feedbackTimeout = const Duration(milliseconds: 2000),
    this.iconDescription = 'Copy to clipboard',
    this.enabled = true,
  });

  @override
  State<CarbonCopyButton> createState() => _CarbonCopyButtonState();
}

class _CarbonCopyButtonState extends State<CarbonCopyButton> {
  bool _showFeedback = false;
  Timer? _feedbackTimer;

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    super.dispose();
  }

  void _handleCopy() {
    Clipboard.setData(ClipboardData(text: widget.textToCopy));
    widget.onCopied?.call();
    setState(() => _showFeedback = true);
    // Restart the countdown on every copy.
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(widget.feedbackTimeout, () {
      if (mounted) setState(() => _showFeedback = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final theme = carbon.codeSnippet;
    final side = widget.size.dimension;

    return CarbonCopyFeedback(
      visible: _showFeedback,
      message: widget.feedback,
      alignment: CarbonPopoverAlignment.bottom,
      child: Semantics(
        container: true,
        button: true,
        enabled: widget.enabled,
        label: widget.iconDescription,
        child: CarbonPressable(
          onTap: widget.enabled ? _handleCopy : null,
          focusable: true,
          builder: (context, state) => Container(
            width: side,
            height: side,
            decoration: BoxDecoration(
              color: state.pressed
                  ? theme.copyButtonBackgroundActive
                  : state.hovered
                      ? theme.copyButtonBackgroundHover
                      : theme.copyButtonBackground,
              // Always-present border keeps the tree shape (and the icon
              // centering) stable when focus toggles.
              border: Border.all(
                width: 2,
                color: state.focused
                    ? carbon.layer.focus
                    : CarbonPalette.transparent,
              ),
            ),
            child: Icon(
              CarbonIcons.copy,
              size: 16,
              color: widget.enabled
                  ? theme.copyButtonIcon
                  : carbon.text.iconDisabled,
            ),
          ),
        ),
      ),
    );
  }
}
