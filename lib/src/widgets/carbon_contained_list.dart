import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';
import '../theme/component_themes/contained_list_theme_data.dart';

/// Carbon contained list component.
///
/// Organizes related content in smaller UI spaces like cards or sidebars.
/// Supports headers, actions, clickable rows, and inline elements.
class CarbonContainedList extends StatelessWidget {
  /// The title displayed in the header.
  final String? title;

  /// Optional action widget in the header (e.g., search icon, button).
  final Widget? headerAction;

  /// List of items to display.
  final List<CarbonContainedListItem> items;

  /// Whether to show dividers between items.
  final bool showDividers;

  /// Whether to use inset dividers (vs extended).
  final bool insetDividers;

  /// Whether this is a disclosed list (adds elevation/shadow).
  final bool disclosed;

  /// Custom height for list items.
  final double? itemHeight;

  const CarbonContainedList({
    super.key,
    this.title,
    this.headerAction,
    required this.items,
    this.showDividers = true,
    this.insetDividers = false,
    this.disclosed = false,
    this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final theme = CarbonContainedListThemeData(
      background: carbon.layer.layer01,
      border: carbon.layer.borderSubtle01,
      headerBackground: carbon.layer.layer01,
      itemBackground: carbon.layer.layer01,
      itemBackgroundHover: carbon.layer.layerHover01,
      divider: carbon.layer.borderSubtle01,
      text: carbon.text.textPrimary,
      textSecondary: carbon.text.textSecondary,
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.zero,
        boxShadow: disclosed
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          if (title != null || headerAction != null)
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.headerBackground,
                border: Border(bottom: BorderSide(color: theme.divider)),
              ),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.text,
                        ),
                      ),
                    ),
                  if (headerAction != null) headerAction!,
                ],
              ),
            ),

          // Items
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return _ContainedListItemWidget(
              item: item,
              theme: theme,
              showDivider: showDividers && !isLast,
              insetDivider: insetDividers,
              itemHeight: itemHeight,
            );
          }),
        ],
      ),
    );
  }
}

/// Item for Carbon contained list.
class CarbonContainedListItem {
  /// The main content of the list item.
  final Widget child;

  /// Optional leading icon.
  final Widget? leading;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Callback when item is tapped (makes row clickable).
  final VoidCallback? onTap;

  /// Optional subtitle/secondary text.
  final String? subtitle;

  /// Whether the item is enabled.
  final bool enabled;

  const CarbonContainedListItem({
    required this.child,
    this.leading,
    this.trailing,
    this.onTap,
    this.subtitle,
    this.enabled = true,
  });
}

class _ContainedListItemWidget extends StatefulWidget {
  final CarbonContainedListItem item;
  final CarbonContainedListThemeData theme;
  final bool showDivider;
  final bool insetDivider;
  final double? itemHeight;

  const _ContainedListItemWidget({
    required this.item,
    required this.theme,
    required this.showDivider,
    required this.insetDivider,
    this.itemHeight,
  });

  @override
  State<_ContainedListItemWidget> createState() =>
      _ContainedListItemWidgetState();
}

class _ContainedListItemWidgetState extends State<_ContainedListItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isClickable = widget.item.onTap != null && widget.item.enabled;

    Widget content = Container(
      constraints: BoxConstraints(minHeight: widget.itemHeight ?? 48),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isHovered && isClickable
            ? widget.theme.itemBackgroundHover
            : widget.theme.itemBackground,
      ),
      child: Row(
        children: [
          if (widget.item.leading != null) ...[
            widget.item.leading!,
            const SizedBox(width: 16),
          ],
          Expanded(
            child: widget.item.subtitle != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(
                          color: widget.item.enabled
                              ? widget.theme.text
                              : widget.theme.textSecondary,
                          fontSize: 14,
                        ),
                        child: widget.item.child,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.item.subtitle!,
                        style: TextStyle(
                          color: widget.theme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : DefaultTextStyle(
                    style: TextStyle(
                      color: widget.item.enabled
                          ? widget.theme.text
                          : widget.theme.textSecondary,
                      fontSize: 14,
                    ),
                    child: widget.item.child,
                  ),
          ),
          if (widget.item.trailing != null) ...[
            const SizedBox(width: 16),
            widget.item.trailing!,
          ],
        ],
      ),
    );

    if (isClickable) {
      content = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: widget.item.onTap, child: content),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content,
        if (widget.showDivider)
          Padding(
            padding: widget.insetDivider
                ? const EdgeInsets.only(left: 16)
                : EdgeInsets.zero,
            child: Divider(
              color: widget.theme.divider,
              height: 1,
              thickness: 1,
            ),
          ),
      ],
    );
  }
}
