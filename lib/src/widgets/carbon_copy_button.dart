import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundation/motion.dart';
import '../theme/carbon_theme.dart';

/// Carbon Design System copy button with feedback.
///
/// A button that copies text to clipboard and shows visual feedback.
///
/// Example:
/// ```dart
/// CarbonCopyButton(
///   textToCopy: 'npm install carbon-design-system',
///   onCopied: () => print('Copied!'),
/// )
/// ```
class CarbonCopyButton extends StatefulWidget {
  /// The text to copy to clipboard.
  final String textToCopy;

  /// Called when text is copied.
  final VoidCallback? onCopied;

  /// Custom button label (defaults to 'Copy').
  final String? label;

  /// Custom success label (defaults to 'Copied!').
  final String? successLabel;

  /// Duration to show success state.
  final Duration successDuration;

  /// Whether the button is enabled.
  final bool enabled;

  const CarbonCopyButton({
    super.key,
    required this.textToCopy,
    this.onCopied,
    this.label,
    this.successLabel,
    this.successDuration = CarbonMotion.durationSlow02,
    this.enabled = true,
  });

  @override
  State<CarbonCopyButton> createState() => _CarbonCopyButtonState();
}

class _CarbonCopyButtonState extends State<CarbonCopyButton> {
  bool _copied = false;

  Future<void> _handleCopy() async {
    if (!widget.enabled) return;

    Clipboard.setData(ClipboardData(text: widget.textToCopy));
    setState(() => _copied = true);
    widget.onCopied?.call();

    Future.delayed(widget.successDuration, () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final theme = carbon.codeSnippet;

    return InkWell(
      onTap: widget.enabled ? _handleCopy : null,
      borderRadius: BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: widget.enabled
              ? theme.copyButtonBackground
              : carbon.layer.layerSelectedDisabled,
          border: Border.all(color: carbon.layer.borderStrong01, width: 1),
          borderRadius: BorderRadius.zero,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _copied ? Icons.check : Icons.content_copy,
              size: 16,
              color: widget.enabled
                  ? theme.copyButtonIcon
                  : carbon.text.iconDisabled,
            ),
            const SizedBox(width: 8),
            Text(
              _copied
                  ? (widget.successLabel ?? 'Copied!')
                  : (widget.label ?? 'Copy'),
              style: TextStyle(
                color: widget.enabled
                    ? carbon.text.textPrimary
                    : carbon.text.textDisabled,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
