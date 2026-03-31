import 'package:flutter/material.dart';

/// Tag size variants from Carbon Design System.
enum CarbonTagSize {
  /// Small — 18px height
  sm,

  /// Medium — 24px height (default)
  md,

  /// Large — 32px height
  lg,
}

/// Tag color/type variants from Carbon Design System.
enum CarbonTagType {
  red,
  magenta,
  purple,
  blue,
  cyan,
  teal,
  green,
  gray,
  coolGray,
  warmGray,
  highContrast,
  outline,
}

/// Color set for a single tag type.
class _TagColors {
  final Color background;
  final Color text;
  final Color hover;
  final Color? border;

  const _TagColors({
    required this.background,
    required this.text,
    required this.hover,
    this.border,
  });
}

const _tagColorMap = <CarbonTagType, _TagColors>{
  CarbonTagType.red: _TagColors(
    background: Color(0xFFFFD7D9),
    text: Color(0xFFA2191F),
    hover: Color(0xFFFFC2C5),
  ),
  CarbonTagType.magenta: _TagColors(
    background: Color(0xFFFFD6E8),
    text: Color(0xFF9F1853),
    hover: Color(0xFFFFAFD2),
  ),
  CarbonTagType.purple: _TagColors(
    background: Color(0xFFE8DAFF),
    text: Color(0xFF6929C4),
    hover: Color(0xFFD4BBFF),
  ),
  CarbonTagType.blue: _TagColors(
    background: Color(0xFFD0E2FF),
    text: Color(0xFF0043CE),
    hover: Color(0xFFA6C8FF),
  ),
  CarbonTagType.cyan: _TagColors(
    background: Color(0xFFBAE6FF),
    text: Color(0xFF00539A),
    hover: Color(0xFF82CFFF),
  ),
  CarbonTagType.teal: _TagColors(
    background: Color(0xFF9EF0F0),
    text: Color(0xFF005D5D),
    hover: Color(0xFF3DDBD9),
  ),
  CarbonTagType.green: _TagColors(
    background: Color(0xFFA7F0BA),
    text: Color(0xFF0E6027),
    hover: Color(0xFF6FDC8C),
  ),
  CarbonTagType.gray: _TagColors(
    background: Color(0xFFE0E0E0),
    text: Color(0xFF393939),
    hover: Color(0xFFC6C6C6),
  ),
  CarbonTagType.coolGray: _TagColors(
    background: Color(0xFFDDE1E6),
    text: Color(0xFF343A3F),
    hover: Color(0xFFC1C7CD),
  ),
  CarbonTagType.warmGray: _TagColors(
    background: Color(0xFFE5E0DF),
    text: Color(0xFF3C3535),
    hover: Color(0xFFCAC5C4),
  ),
  CarbonTagType.highContrast: _TagColors(
    background: Color(0xFF393939),
    text: Color(0xFFFFFFFF),
    hover: Color(0xFF474747),
  ),
  CarbonTagType.outline: _TagColors(
    background: Colors.transparent,
    text: Color(0xFF393939),
    hover: Color(0xFFE8E8E8),
    border: Color(0xFF8D8D8D),
  ),
};

/// A Carbon Design System tag component.
///
/// Tags are used to label, categorize, or organize items using keywords.
/// Provide an [onDismiss] callback to show a close button (dismissible tag).
///
/// ```dart
/// CarbonTag(text: 'Design', type: CarbonTagType.blue)
///
/// CarbonTag(
///   text: 'Removable',
///   type: CarbonTagType.gray,
///   onDismiss: () => removeTag(),
/// )
/// ```
class CarbonTag extends StatefulWidget {
  const CarbonTag({
    super.key,
    required this.text,
    this.type = CarbonTagType.gray,
    this.size = CarbonTagSize.md,
    this.onDismiss,
    this.disabled = false,
  });

  /// Text label displayed inside the tag.
  final String text;

  /// Color/style variant.
  final CarbonTagType type;

  /// Size variant.
  final CarbonTagSize size;

  /// When provided, a close/dismiss button is shown.
  final VoidCallback? onDismiss;

  /// Whether the tag is disabled (close button becomes inert).
  final bool disabled;

  @override
  State<CarbonTag> createState() => _CarbonTagState();
}

class _CarbonTagState extends State<CarbonTag> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = _tagColorMap[widget.type]!;
    final isDismissible = widget.onDismiss != null;

    final double height = switch (widget.size) {
      CarbonTagSize.sm => 18.0,
      CarbonTagSize.md => 24.0,
      CarbonTagSize.lg => 32.0,
    };

    final double fontSize = widget.size == CarbonTagSize.lg ? 14.0 : 12.0;

    final EdgeInsets padding = switch (widget.size) {
      CarbonTagSize.sm => const EdgeInsets.symmetric(horizontal: 6),
      CarbonTagSize.md => const EdgeInsets.symmetric(horizontal: 8),
      CarbonTagSize.lg => const EdgeInsets.symmetric(horizontal: 8),
    };

    final bg = _hovered && !widget.disabled ? colors.hover : colors.background;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100),
          border: widget.type == CarbonTagType.outline
              ? Border.all(color: colors.border!, width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: widget.disabled
                    ? colors.text.withValues(alpha: 0.5)
                    : colors.text,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                height: 1.0,
                letterSpacing: 0.16,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (isDismissible) ...[
              SizedBox(width: widget.size == CarbonTagSize.sm ? 2 : 4),
              GestureDetector(
                onTap: widget.disabled ? null : widget.onDismiss,
                child: Icon(
                  Icons.close,
                  size: widget.size == CarbonTagSize.lg ? 16 : 14,
                  color: widget.disabled
                      ? colors.text.withValues(alpha: 0.5)
                      : colors.text,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
