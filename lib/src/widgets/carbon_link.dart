import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Link size variants.
enum CarbonLinkSize {
  small,
  medium,
  large,
}

/// Carbon Design System link widget.
///
/// Styled hyperlink that follows Carbon design patterns.
///
/// Example:
/// ```dart
/// CarbonLink(
///   text: 'Learn more',
///   onTap: () => launchUrl('https://carbondesignsystem.com'),
/// )
/// ```
class CarbonLink extends StatefulWidget {
  /// The link text.
  final String text;

  /// Called when the link is tapped.
  final VoidCallback? onTap;

  /// The size of the link.
  final CarbonLinkSize size;

  /// Whether the link is disabled.
  final bool disabled;

  /// Whether to show the visited state.
  final bool visited;

  /// Whether to show an inline icon.
  final Widget? icon;

  const CarbonLink({
    super.key,
    required this.text,
    this.onTap,
    this.size = CarbonLinkSize.medium,
    this.disabled = false,
    this.visited = false,
    this.icon,
  });

  @override
  State<CarbonLink> createState() => _CarbonLinkState();
}

class _CarbonLinkState extends State<CarbonLink> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    final textColor = widget.disabled
        ? carbon.text.textDisabled
        : widget.visited
            ? carbon.text.linkVisited
            : _isHovered || _isFocused
                ? carbon.text.linkPrimaryHover
                : carbon.text.linkPrimary;

    return MouseRegion(
      onEnter:
          widget.disabled ? null : (_) => setState(() => _isHovered = true),
      onExit:
          widget.disabled ? null : (_) => setState(() => _isHovered = false),
      cursor:
          widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: Focus(
        onFocusChange: widget.disabled
            ? null
            : (focused) => setState(() => _isFocused = focused),
        child: GestureDetector(
          onTap: widget.disabled ? null : widget.onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.text,
                style: TextStyle(
                  color: textColor,
                  fontSize: _getFontSize(),
                  fontWeight: FontWeight.w400,
                  decoration: _isHovered || _isFocused
                      ? TextDecoration.underline
                      : null,
                ),
              ),
              if (widget.icon != null) ...[
                const SizedBox(width: 4),
                IconTheme(
                  data: IconThemeData(
                    color: textColor,
                    size: 16,
                  ),
                  child: widget.icon!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  double _getFontSize() {
    switch (widget.size) {
      case CarbonLinkSize.small:
        return 12;
      case CarbonLinkSize.medium:
        return 14;
      case CarbonLinkSize.large:
        return 16;
    }
  }
}
