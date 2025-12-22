import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';
import '../theme/component_themes/tile_theme_data.dart';

/// Carbon tile kinds.
enum CarbonTileKind {
  /// Base, non-interactive tile.
  base,

  /// Clickable tile - navigational.
  clickable,

  /// Selectable tile - for choices.
  selectable,

  /// Expandable tile - progressive disclosure.
  expandable,
}

/// Carbon tile for displaying content in a card-like container.
///
/// Tiles are containers that organize content. They come in four variants:
/// - Base: Non-interactive display
/// - Clickable: For navigation
/// - Selectable: For single or multiple selection
/// - Expandable: For progressive disclosure
class CarbonTile extends StatefulWidget {
  /// The main content of the tile.
  final Widget child;

  /// The kind of tile.
  final CarbonTileKind kind;

  /// Callback when tile is tapped (for clickable tiles).
  final VoidCallback? onTap;

  /// Whether the tile is selected (for selectable tiles).
  final bool selected;

  /// Callback when selection changes (for selectable tiles).
  final ValueChanged<bool>? onSelectedChanged;

  /// Whether the tile is expanded (for expandable tiles).
  final bool expanded;

  /// Callback when expansion changes (for expandable tiles).
  final ValueChanged<bool>? onExpansionChanged;

  /// Content to show when expanded (for expandable tiles).
  final Widget? expandedContent;

  /// Optional leading widget (icon, image, etc).
  final Widget? leading;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Title text (optional, can use child instead).
  final String? title;

  /// Subtitle text.
  final String? subtitle;

  /// Whether the tile is disabled.
  final bool disabled;

  /// Padding inside the tile.
  final EdgeInsetsGeometry? padding;

  const CarbonTile({
    super.key,
    required this.child,
    this.kind = CarbonTileKind.base,
    this.onTap,
    this.selected = false,
    this.onSelectedChanged,
    this.expanded = false,
    this.onExpansionChanged,
    this.expandedContent,
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.disabled = false,
    this.padding,
  });

  /// Creates a clickable tile.
  factory CarbonTile.clickable({
    Key? key,
    required Widget child,
    required VoidCallback onTap,
    Widget? leading,
    Widget? trailing,
    String? title,
    String? subtitle,
    bool disabled = false,
    EdgeInsetsGeometry? padding,
  }) {
    return CarbonTile(
      key: key,
      kind: CarbonTileKind.clickable,
      onTap: onTap,
      leading: leading,
      trailing: trailing,
      title: title,
      subtitle: subtitle,
      disabled: disabled,
      padding: padding,
      child: child,
    );
  }

  /// Creates a selectable tile.
  factory CarbonTile.selectable({
    Key? key,
    required Widget child,
    required bool selected,
    required ValueChanged<bool> onSelectedChanged,
    Widget? leading,
    String? title,
    String? subtitle,
    bool disabled = false,
    EdgeInsetsGeometry? padding,
  }) {
    return CarbonTile(
      key: key,
      kind: CarbonTileKind.selectable,
      selected: selected,
      onSelectedChanged: onSelectedChanged,
      leading: leading,
      title: title,
      subtitle: subtitle,
      disabled: disabled,
      padding: padding,
      child: child,
    );
  }

  /// Creates an expandable tile.
  factory CarbonTile.expandable({
    Key? key,
    required Widget child,
    required Widget expandedContent,
    required bool expanded,
    required ValueChanged<bool> onExpansionChanged,
    Widget? leading,
    String? title,
    String? subtitle,
    bool disabled = false,
    EdgeInsetsGeometry? padding,
  }) {
    return CarbonTile(
      key: key,
      kind: CarbonTileKind.expandable,
      expanded: expanded,
      onExpansionChanged: onExpansionChanged,
      expandedContent: expandedContent,
      leading: leading,
      title: title,
      subtitle: subtitle,
      disabled: disabled,
      padding: padding,
      child: child,
    );
  }

  @override
  State<CarbonTile> createState() => _CarbonTileState();
}

class _CarbonTileState extends State<CarbonTile> {
  bool _isHovered = false;

  bool get _isInteractive =>
      widget.kind != CarbonTileKind.base && !widget.disabled;

  Color _getBackgroundColor(CarbonThemeData carbon) {
    final theme = CarbonTileThemeData(
      background: carbon.layer.layer01,
      backgroundHover: carbon.layer.layerHover01,
      backgroundSelected: carbon.layer.layerSelected01,
      border: carbon.layer.borderSubtle01,
      borderHover: carbon.layer.borderSubtle01,
      text: carbon.text.textPrimary,
      textSecondary: carbon.text.textSecondary,
    );

    if (widget.disabled) return theme.background;
    if (widget.selected) return theme.backgroundSelected;
    if (_isHovered && _isInteractive) return theme.backgroundHover;
    return theme.background;
  }

  Color _getBorderColor(CarbonThemeData carbon) {
    final theme = CarbonTileThemeData(
      background: carbon.layer.layer01,
      backgroundHover: carbon.layer.layerHover01,
      backgroundSelected: carbon.layer.layerSelected01,
      border: carbon.layer.borderSubtle01,
      borderHover: carbon.layer.borderSubtle01,
      text: carbon.text.textPrimary,
      textSecondary: carbon.text.textSecondary,
    );

    if (_isInteractive) return theme.borderHover;
    return theme.border;
  }

  void _handleTap() {
    if (widget.disabled) return;

    switch (widget.kind) {
      case CarbonTileKind.clickable:
        widget.onTap?.call();
        break;
      case CarbonTileKind.selectable:
        widget.onSelectedChanged?.call(!widget.selected);
        break;
      case CarbonTileKind.expandable:
        widget.onExpansionChanged?.call(!widget.expanded);
        break;
      case CarbonTileKind.base:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final backgroundColor = _getBackgroundColor(carbon);
    final borderColor = _getBorderColor(carbon);

    Widget content = widget.child;

    // Build title/subtitle layout if provided
    if (widget.title != null || widget.subtitle != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            Text(
              widget.title!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: carbon.text.textPrimary,
              ),
            ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.subtitle!,
              style: TextStyle(fontSize: 14, color: carbon.text.textSecondary),
            ),
          ],
          if (widget.title != null || widget.subtitle != null)
            const SizedBox(height: 8),
          content,
        ],
      );
    }

    // Add leading/trailing
    if (widget.leading != null ||
        widget.trailing != null ||
        widget.kind == CarbonTileKind.selectable) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.kind == CarbonTileKind.selectable)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                widget.selected ? Icons.check_circle : Icons.circle_outlined,
                color: widget.selected
                    ? carbon.button.buttonPrimary
                    : carbon.text.iconSecondary,
                size: 20,
              ),
            ),
          if (widget.leading != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: widget.leading!,
            ),
          Expanded(child: content),
          if (widget.trailing != null)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: widget.trailing!,
            ),
          if (widget.kind == CarbonTileKind.expandable)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Icon(
                widget.expanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: carbon.text.iconPrimary,
              ),
            ),
        ],
      );
    }

    // Wrap in gesture detector for interactivity
    Widget tile = MouseRegion(
      onEnter: _isInteractive ? (_) => setState(() => _isHovered = true) : null,
      onExit: _isInteractive ? (_) => setState(() => _isHovered = false) : null,
      cursor: _isInteractive && !widget.disabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: _isInteractive ? _handleTap : null,
        child: Container(
          padding: widget.padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.zero,
          ),
          child: content,
        ),
      ),
    );

    // Add expanded content for expandable tiles
    if (widget.kind == CarbonTileKind.expandable &&
        widget.expanded &&
        widget.expandedContent != null) {
      tile = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tile,
          Container(
            padding: widget.padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: carbon.layer.layer01,
              border: Border(
                left: BorderSide(color: borderColor),
                right: BorderSide(color: borderColor),
                bottom: BorderSide(color: borderColor),
              ),
            ),
            child: widget.expandedContent!,
          ),
        ],
      );
    }

    return tile;
  }
}
