import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Breadcrumb size variants.
enum CarbonBreadcrumbSize {
  small,
  medium,
}

/// Carbon Design System breadcrumb item.
class CarbonBreadcrumbItem {
  /// The text label of the breadcrumb.
  final String label;

  /// Called when this breadcrumb is tapped (null for current page).
  final VoidCallback? onTap;

  /// Whether this is the current page.
  final bool isCurrent;

  const CarbonBreadcrumbItem({
    required this.label,
    this.onTap,
    this.isCurrent = false,
  });
}

/// Carbon Design System breadcrumb.
///
/// Breadcrumb shows users their current location in a multi-level website or app.
///
/// Example:
/// ```dart
/// CarbonBreadcrumb(
///   items: [
///     CarbonBreadcrumbItem(
///       label: 'Home',
///       onTap: () => navigateToHome(),
///     ),
///     CarbonBreadcrumbItem(
///       label: 'Products',
///       onTap: () => navigateToProducts(),
///     ),
///     CarbonBreadcrumbItem(
///       label: 'Details',
///       isCurrent: true,
///     ),
///   ],
/// )
/// ```
class CarbonBreadcrumb extends StatelessWidget {
  /// The list of breadcrumb items.
  final List<CarbonBreadcrumbItem> items;

  /// The size of the breadcrumb.
  final CarbonBreadcrumbSize size;

  /// Whether to omit the trailing slash.
  final bool noTrailingSlash;

  const CarbonBreadcrumb({
    super.key,
    required this.items,
    this.size = CarbonBreadcrumbSize.medium,
    this.noTrailingSlash = false,
  }) : assert(items.length >= 1, 'Breadcrumb must have at least 1 item');

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          _BreadcrumbLink(
            item: items[i],
            size: size,
          ),
          if (i < items.length - 1 || !noTrailingSlash)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size == CarbonBreadcrumbSize.small ? 4 : 8),
              child: Text(
                '/',
                style: TextStyle(
                  color: carbon.breadcrumb.separatorColor,
                  fontSize: _getFontSize(),
                ),
              ),
            ),
        ],
      ],
    );
  }

  double _getFontSize() {
    switch (size) {
      case CarbonBreadcrumbSize.small:
        return 12;
      case CarbonBreadcrumbSize.medium:
        return 14;
    }
  }
}

/// Internal widget for breadcrumb links.
class _BreadcrumbLink extends StatefulWidget {
  final CarbonBreadcrumbItem item;
  final CarbonBreadcrumbSize size;

  const _BreadcrumbLink({
    required this.item,
    required this.size,
  });

  @override
  State<_BreadcrumbLink> createState() => _BreadcrumbLinkState();
}

class _BreadcrumbLinkState extends State<_BreadcrumbLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final isClickable = widget.item.onTap != null && !widget.item.isCurrent;

    final textColor = widget.item.isCurrent
        ? carbon.breadcrumb.currentColor
        : _isHovered && isClickable
            ? carbon.breadcrumb.linkHoverColor
            : carbon.breadcrumb.linkColor;

    final textWidget = Text(
      widget.item.label,
      style: TextStyle(
        color: textColor,
        fontSize: _getFontSize(),
        fontWeight: widget.item.isCurrent ? FontWeight.w600 : FontWeight.w400,
        decoration: isClickable && _isHovered ? TextDecoration.underline : null,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (!isClickable) {
      return textWidget;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: textWidget,
      ),
    );
  }

  double _getFontSize() {
    switch (widget.size) {
      case CarbonBreadcrumbSize.small:
        return 12;
      case CarbonBreadcrumbSize.medium:
        return 14;
    }
  }
}
