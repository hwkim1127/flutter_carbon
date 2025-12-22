import 'package:flutter/material.dart';

import '../foundation/motion.dart';
import '../theme/carbon_theme.dart';
import '../theme/component_themes/ui_shell_theme_data.dart';

/// Collapse mode for the side navigation.
enum CarbonSideNavCollapseMode {
  /// Side nav is always visible at full width.
  fixed,

  /// Side nav can collapse to a narrow rail with icons only.
  rail,

  /// Side nav is fully collapsible and responsive to screen size.
  responsive,
}

/// Navigation item for the header or side nav.
class CarbonNavItem {
  /// The label text for this nav item.
  final String label;

  /// Optional icon to display.
  final IconData? icon;

  /// Whether this item is currently selected/active.
  final bool isSelected;

  /// Called when this item is tapped.
  final VoidCallback? onTap;

  /// Optional submenu items.
  final List<CarbonNavItem>? children;

  const CarbonNavItem({
    required this.label,
    this.icon,
    this.isSelected = false,
    this.onTap,
    this.children,
  });
}

/// Carbon Design System UI Shell.
///
/// Complete navigation scaffold with header, side navigation, and content area.
/// Provides the global navigation framework for Carbon applications.
class CarbonUIShell extends StatefulWidget {
  /// The application name displayed in the header.
  final String appName;

  /// Optional prefix text before the app name (e.g., "IBM").
  final String? appNamePrefix;

  /// Navigation items for the header (horizontal navigation).
  final List<CarbonNavItem>? headerNavItems;

  /// Navigation items for the side nav (vertical navigation).
  final List<CarbonNavItem>? sideNavItems;

  /// The main content to display.
  final Widget child;

  /// Collapse mode for the side navigation.
  final CarbonSideNavCollapseMode collapseMode;

  /// Whether the side nav is initially expanded.
  final bool initialSideNavExpanded;

  /// Optional actions to display in the header (right side).
  final List<Widget>? headerActions;

  /// Optional right panel widget.
  final Widget? rightPanel;

  /// Whether the right panel is initially open.
  final bool initialRightPanelOpen;

  /// Callback when side nav expand state changes.
  final ValueChanged<bool>? onSideNavExpandedChanged;

  /// Called when a header nav item is tapped.
  final ValueChanged<int>? onHeaderNavItemTap;

  /// Called when a side nav item is tapped.
  final ValueChanged<int>? onSideNavItemTap;

  const CarbonUIShell({
    super.key,
    required this.appName,
    required this.child,
    this.appNamePrefix,
    this.headerNavItems,
    this.sideNavItems,
    this.collapseMode = CarbonSideNavCollapseMode.responsive,
    this.initialSideNavExpanded = false,
    this.headerActions,
    this.rightPanel,
    this.initialRightPanelOpen = false,
    this.onSideNavExpandedChanged,
    this.onHeaderNavItemTap,
    this.onSideNavItemTap,
  });

  @override
  State<CarbonUIShell> createState() => _CarbonUIShellState();
}

class _CarbonUIShellState extends State<CarbonUIShell> {
  late bool _sideNavExpanded;
  late bool _rightPanelOpen;
  int? _expandedSideNavMenuIndex;

  @override
  void initState() {
    super.initState();
    _sideNavExpanded = widget.initialSideNavExpanded;
    _rightPanelOpen = widget.initialRightPanelOpen;
  }

  void _toggleSideNav() {
    setState(() {
      _sideNavExpanded = !_sideNavExpanded;
    });
    widget.onSideNavExpandedChanged?.call(_sideNavExpanded);
  }

  void _toggleRightPanel() {
    setState(() {
      _rightPanelOpen = !_rightPanelOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Scaffold(
      body: Column(
        children: [
          _Header(
            appName: widget.appName,
            appNamePrefix: widget.appNamePrefix,
            navItems: widget.headerNavItems,
            actions: widget.headerActions,
            showMenuButton:
                widget.collapseMode != CarbonSideNavCollapseMode.fixed,
            onMenuButtonPressed: _toggleSideNav,
            onNavItemTap: widget.onHeaderNavItemTap,
            theme: carbon.uiShell,
          ),
          Expanded(
            child: Row(
              children: [
                if (widget.sideNavItems != null)
                  _SideNav(
                    items: widget.sideNavItems!,
                    expanded: _sideNavExpanded,
                    collapseMode: widget.collapseMode,
                    expandedMenuIndex: _expandedSideNavMenuIndex,
                    onExpandedMenuChanged: (index) {
                      setState(() => _expandedSideNavMenuIndex = index);
                    },
                    theme: carbon.uiShell,
                    onItemTap: widget.onSideNavItemTap,
                  ),
                Expanded(child: widget.child),
                if (widget.rightPanel != null && _rightPanelOpen)
                  _RightPanel(
                    onClose: _toggleRightPanel,
                    theme: carbon.uiShell,
                    child: widget.rightPanel!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String appName;
  final String? appNamePrefix;
  final List<CarbonNavItem>? navItems;
  final List<Widget>? actions;
  final bool showMenuButton;
  final VoidCallback onMenuButtonPressed;
  final ValueChanged<int>? onNavItemTap;
  final CarbonUIShellThemeData theme;

  const _Header({
    required this.appName,
    required this.showMenuButton,
    required this.onMenuButtonPressed,
    required this.theme,
    this.appNamePrefix,
    this.navItems,
    this.actions,
    this.onNavItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.headerBackground,
        border: Border(bottom: BorderSide(color: theme.headerBorder, width: 1)),
      ),
      child: Row(
        children: [
          if (showMenuButton)
            _MenuButton(
              onPressed: onMenuButtonPressed,
              icon: theme.headerIconPrimary,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (appNamePrefix != null) ...[
                  Text(
                    appNamePrefix!,
                    style: TextStyle(
                      color: theme.headerText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  appName,
                  style: TextStyle(
                    color: theme.headerText,
                    fontSize: 14,
                    fontWeight: appNamePrefix != null
                        ? FontWeight.w400
                        : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (navItems != null) ...[
            const SizedBox(width: 8),
            ...navItems!.asMap().entries.map((entry) {
              return _HeaderNavItem(
                item: entry.value,
                onTap: () => onNavItemTap?.call(entry.key),
                theme: theme,
              );
            }),
          ],
          const Spacer(),
          if (actions != null)
            ...actions!.map(
              (action) => Padding(
                padding: const EdgeInsets.only(right: 1),
                child: action,
              ),
            ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color icon;

  const _MenuButton({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.menu, color: icon, size: 20),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _HeaderNavItem extends StatefulWidget {
  final CarbonNavItem item;
  final VoidCallback onTap;
  final CarbonUIShellThemeData theme;

  const _HeaderNavItem({
    required this.item,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_HeaderNavItem> createState() => _HeaderNavItemState();
}

class _HeaderNavItemState extends State<_HeaderNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.item.isSelected
        ? widget.theme.headerNavItemBackgroundSelected
        : _isHovered
            ? widget.theme.headerNavItemBackgroundHover
            : widget.theme.headerNavItemBackground;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: widget.item.isSelected
                ? Border(
                    bottom: BorderSide(
                      color: widget.theme.headerNavItemBorderActive,
                      width: 3,
                    ),
                  )
                : null,
          ),
          child: Center(
            child: Text(
              widget.item.label,
              style: TextStyle(
                color: widget.theme.headerNavItemText,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SideNav extends StatelessWidget {
  final List<CarbonNavItem> items;
  final bool expanded;
  final CarbonSideNavCollapseMode collapseMode;
  final int? expandedMenuIndex;
  final ValueChanged<int?> onExpandedMenuChanged;
  final CarbonUIShellThemeData theme;
  final ValueChanged<int>? onItemTap;

  const _SideNav({
    required this.items,
    required this.expanded,
    required this.collapseMode,
    required this.expandedMenuIndex,
    required this.onExpandedMenuChanged,
    required this.theme,
    this.onItemTap,
  });

  double get _width {
    if (collapseMode == CarbonSideNavCollapseMode.fixed) {
      return 256;
    }
    return expanded ? 256 : 48;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: CarbonMotion.durationModerate02,
      width: _width,
      decoration: BoxDecoration(
        color: theme.sideNavBackground,
        border: Border(
          right: BorderSide(color: theme.sideNavDivider, width: 1),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                if (item.children != null && item.children!.isNotEmpty) {
                  return _SideNavMenu(
                    item: item,
                    expanded: expandedMenuIndex == index,
                    showLabel: expanded ||
                        collapseMode == CarbonSideNavCollapseMode.fixed,
                    onToggle: () {
                      onExpandedMenuChanged(
                        expandedMenuIndex == index ? null : index,
                      );
                    },
                    theme: theme,
                  );
                }
                return _SideNavItem(
                  item: item,
                  showLabel: expanded ||
                      collapseMode == CarbonSideNavCollapseMode.fixed,
                  onTap: () => onItemTap?.call(index),
                  theme: theme,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SideNavItem extends StatefulWidget {
  final CarbonNavItem item;
  final bool showLabel;
  final VoidCallback onTap;
  final CarbonUIShellThemeData theme;

  const _SideNavItem({
    required this.item,
    required this.showLabel,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_SideNavItem> createState() => _SideNavItemState();
}

class _SideNavItemState extends State<_SideNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isHovered
        ? widget.theme.sideNavItemBackgroundHover
        : widget.theme.sideNavItemBackground;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: widget.showLabel ? 12 : 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: widget.item.isSelected
                ? Border(
                    left: BorderSide(
                      color: widget.theme.sideNavItemBorderActive,
                      width: 4,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              if (widget.item.icon != null)
                Icon(
                  widget.item.icon,
                  color: widget.theme.sideNavItemIcon,
                  size: 20,
                ),
              if (widget.showLabel && widget.item.icon != null)
                const SizedBox(width: 16),
              if (widget.showLabel)
                Expanded(
                  child: Text(
                    widget.item.label,
                    style: TextStyle(
                      color: widget.theme.sideNavItemText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideNavMenu extends StatelessWidget {
  final CarbonNavItem item;
  final bool expanded;
  final bool showLabel;
  final VoidCallback onToggle;
  final CarbonUIShellThemeData theme;

  const _SideNavMenu({
    required this.item,
    required this.expanded,
    required this.showLabel,
    required this.onToggle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SideNavItem(
          item: CarbonNavItem(
            label: item.label,
            icon: item.icon,
            onTap: onToggle,
          ),
          showLabel: showLabel,
          onTap: onToggle,
          theme: theme,
        ),
        if (expanded && showLabel)
          ...item.children!.map(
            (child) => Padding(
              padding: const EdgeInsets.only(left: 16),
              child: _SideNavItem(
                item: child,
                showLabel: true,
                onTap: child.onTap ?? () {},
                theme: theme,
              ),
            ),
          ),
      ],
    );
  }
}

class _RightPanel extends StatelessWidget {
  final VoidCallback onClose;
  final CarbonUIShellThemeData theme;
  final Widget child;

  const _RightPanel({
    required this.onClose,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: theme.panelBackground,
        border: Border(left: BorderSide(color: theme.panelBorder, width: 1)),
      ),
      child: child,
    );
  }
}
