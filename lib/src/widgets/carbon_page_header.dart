import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';
import '../theme/component_themes/page_header_theme_data.dart';

/// Carbon Design System Page Header.
///
/// Provides a consistent header area for pages with title, breadcrumbs,
/// description, and actions.
class CarbonPageHeader extends StatelessWidget {
  /// The page title (required).
  final String title;

  /// Optional subtitle displayed below the title.
  final String? subtitle;

  /// Optional description text.
  final String? description;

  /// Optional breadcrumb widget to display above the title.
  final Widget? breadcrumb;

  /// Whether to show a border below the breadcrumb area.
  final bool showBreadcrumbBorder;

  /// Optional icon to display next to the title.
  final IconData? icon;

  /// Optional action buttons (displayed on the right side).
  final List<Widget>? actions;

  /// Optional tabs widget to display below the header.
  final Widget? tabs;

  /// Optional tags to display with the tabs.
  final List<Widget>? tags;

  /// Background color override (uses theme default if null).
  final Color? backgroundColor;

  /// Padding around the header content.
  final EdgeInsetsGeometry? padding;

  const CarbonPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.breadcrumb,
    this.showBreadcrumbBorder = false,
    this.icon,
    this.actions,
    this.tabs,
    this.tags,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final theme = carbon.pageHeader;

    return Container(
      color: backgroundColor ?? theme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (breadcrumb != null)
            _BreadcrumbBar(
              showBorder: showBreadcrumbBorder,
              theme: theme,
              child: breadcrumb!,
            ),
          _ContentArea(
            title: title,
            subtitle: subtitle,
            description: description,
            icon: icon,
            actions: actions,
            padding: padding,
            theme: theme,
          ),
          if (tabs != null) _TabBar(tabs: tabs!, tags: tags, theme: theme),
        ],
      ),
    );
  }
}

class _BreadcrumbBar extends StatelessWidget {
  final bool showBorder;
  final CarbonPageHeaderThemeData theme;
  final Widget child;

  const _BreadcrumbBar({
    required this.showBorder,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.breadcrumbBackground,
        border: showBorder
            ? Border(bottom: BorderSide(color: theme.border, width: 1))
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: child,
    );
  }
}

class _ContentArea extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final IconData? icon;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;
  final CarbonPageHeaderThemeData theme;

  const _ContentArea({
    required this.title,
    required this.theme,
    this.subtitle,
    this.description,
    this.icon,
    this.actions,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: theme.icon, size: 32),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: theme.titleText,
                              fontSize: 28,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: theme.subtitleText,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                    if (description != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        description!,
                        style: TextStyle(
                          color: theme.descriptionText,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(width: 16),
                Row(
                  children: actions!.map((action) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: action,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final Widget tabs;
  final List<Widget>? tags;
  final CarbonPageHeaderThemeData theme;

  const _TabBar({required this.tabs, required this.theme, this.tags});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.border, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: tabs),
              if (tags != null && tags!.isNotEmpty) ...[
                const SizedBox(width: 16),
                Wrap(spacing: 8, children: tags!),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
