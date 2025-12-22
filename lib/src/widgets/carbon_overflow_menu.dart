import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/carbon_theme.dart';

/// Size options for the overflow menu.
enum CarbonOverflowMenuSize { xs, sm, md, lg }

/// A menu item for the CarbonOverflowMenu.
class CarbonOverflowMenuItem {
  /// The text label for this menu item.
  final String label;

  /// Whether this is a danger/destructive action (styled differently).
  final bool isDanger;

  /// Whether this item is disabled.
  final bool disabled;

  /// Called when this item is tapped.
  final VoidCallback? onTap;

  /// Optional leading icon for this item.
  final Widget? icon;

  const CarbonOverflowMenuItem({
    required this.label,
    this.isDanger = false,
    this.disabled = false,
    this.onTap,
    this.icon,
  });
}

/// A divider for the CarbonOverflowMenu.
class CarbonOverflowMenuDivider {
  const CarbonOverflowMenuDivider();
}

/// Carbon Design System Overflow Menu (kebab menu).
///
/// A vertical three-dot menu that reveals additional options when clicked.
/// Commonly used for actions like Edit, Delete, Share, etc.
class CarbonOverflowMenu extends StatefulWidget {
  /// The items to display in the menu.
  final List<dynamic> items;

  /// The size of the menu.
  final CarbonOverflowMenuSize size;

  /// Whether the menu should appear above the trigger button instead of below.
  final bool flipped;

  /// Optional custom icon for the trigger button.
  final IconData? icon;

  /// Optional accessibility label for the trigger button.
  final String? ariaLabel;

  const CarbonOverflowMenu({
    super.key,
    required this.items,
    this.size = CarbonOverflowMenuSize.md,
    this.flipped = false,
    this.icon,
    this.ariaLabel,
  });

  @override
  State<CarbonOverflowMenu> createState() => _CarbonOverflowMenuState();
}

class _CarbonOverflowMenuState extends State<CarbonOverflowMenu> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  double get _triggerSize {
    switch (widget.size) {
      case CarbonOverflowMenuSize.xs:
        return 24;
      case CarbonOverflowMenuSize.sm:
        return 32;
      case CarbonOverflowMenuSize.md:
        return 40;
      case CarbonOverflowMenuSize.lg:
        return 48;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case CarbonOverflowMenuSize.xs:
        return 16;
      case CarbonOverflowMenuSize.sm:
      case CarbonOverflowMenuSize.md:
        return 16;
      case CarbonOverflowMenuSize.lg:
        return 20;
    }
  }

  void _toggleMenu() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    final carbon = context.carbon;
    final overlayState = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _close,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor:
                  widget.flipped ? Alignment.topLeft : Alignment.bottomLeft,
              followerAnchor:
                  widget.flipped ? Alignment.bottomLeft : Alignment.topLeft,
              offset: Offset(0, widget.flipped ? -8 : 8),
              child: Material(
                color: Colors.transparent,
                child: _MenuContent(
                  items: widget.items,
                  size: widget.size,
                  onItemTapped: _close,
                  theme: carbon.overflowMenu,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _close() {
    if (mounted) {
      setState(() => _isOpen = false);
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Semantics(
      button: true,
      label: widget.ariaLabel ?? 'Options',
      child: CompositedTransformTarget(
        link: _layerLink,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              width: _triggerSize,
              height: _triggerSize,
              decoration: BoxDecoration(
                color: _isOpen
                    ? carbon.overflowMenu.triggerBackgroundHover
                    : carbon.overflowMenu.triggerBackground,
              ),
              child: Icon(
                widget.icon ?? Icons.more_vert,
                size: _iconSize,
                color: carbon.overflowMenu.triggerIcon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuContent extends StatefulWidget {
  final List<dynamic> items;
  final CarbonOverflowMenuSize size;
  final VoidCallback onItemTapped;
  final dynamic theme;

  const _MenuContent({
    required this.items,
    required this.size,
    required this.onItemTapped,
    required this.theme,
  });

  @override
  State<_MenuContent> createState() => _MenuContentState();
}

class _MenuContentState extends State<_MenuContent> {
  int? _hoveredIndex;

  double get _minWidth {
    switch (widget.size) {
      case CarbonOverflowMenuSize.xs:
        return 120;
      case CarbonOverflowMenuSize.sm:
        return 160;
      case CarbonOverflowMenuSize.md:
        return 200;
      case CarbonOverflowMenuSize.lg:
        return 240;
    }
  }

  double get _itemHeight {
    switch (widget.size) {
      case CarbonOverflowMenuSize.xs:
        return 32;
      case CarbonOverflowMenuSize.sm:
        return 40;
      case CarbonOverflowMenuSize.md:
        return 48;
      case CarbonOverflowMenuSize.lg:
        return 56;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          widget.onItemTapped();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        constraints: BoxConstraints(minWidth: _minWidth),
        decoration: BoxDecoration(
          color: widget.theme.menuBackground,
          border: Border.all(color: widget.theme.menuBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: widget.theme.menuShadow.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildItems(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems() {
    final List<Widget> widgets = [];

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];

      if (item is CarbonOverflowMenuDivider) {
        widgets.add(
          Divider(height: 1, thickness: 1, color: widget.theme.divider),
        );
      } else if (item is CarbonOverflowMenuItem) {
        widgets.add(_buildMenuItem(item, i));
      }
    }

    return widgets;
  }

  Widget _buildMenuItem(CarbonOverflowMenuItem item, int index) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      cursor: item.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: item.disabled
            ? null
            : () {
                item.onTap?.call();
                widget.onItemTapped();
              },
        child: Container(
          height: _itemHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: isHovered && !item.disabled
              ? widget.theme.itemBackgroundHover
              : widget.theme.itemBackground,
          child: Row(
            children: [
              if (item.icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: item.isDanger
                        ? (isHovered
                            ? widget.theme.itemDangerTextHover
                            : widget.theme.itemDangerText)
                        : (isHovered
                            ? widget.theme.itemTextHover
                            : widget.theme.itemText),
                    size: 16,
                  ),
                  child: item.icon!,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Opacity(
                  opacity: item.disabled ? 0.5 : 1.0,
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: item.isDanger
                          ? (isHovered
                              ? widget.theme.itemDangerTextHover
                              : widget.theme.itemDangerText)
                          : (isHovered
                              ? widget.theme.itemTextHover
                              : widget.theme.itemText),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
