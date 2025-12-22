import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';
import '../theme/component_themes/floating_menu_theme_data.dart';

/// Item for Carbon floating menu.
class CarbonFloatingMenuItem {
  /// The icon to display.
  final IconData icon;

  /// The label for this action.
  final String label;

  /// Callback when  item is tapped.
  final VoidCallback onTap;

  const CarbonFloatingMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// Carbon floating action menu component.
///
/// A floating action button that expands to show multiple action items.
/// Based on Material's SpeedDial pattern with Carbon styling.
class CarbonFloatingMenu extends StatefulWidget {
  /// The main FAB icon when closed.
  final IconData icon;

  /// The icon to show when menu is open (defaults to close icon).
  final IconData? openIcon;

  /// List of menu items to display.
  final List<CarbonFloatingMenuItem> items;

  /// Optional label for the main FAB.
  final String? label;

  /// Whether the menu starts open.
  final bool initiallyOpen;

  /// The hero tag for the FAB.
  final Object? heroTag;

  const CarbonFloatingMenu({
    super.key,
    this.icon = Icons.add,
    this.openIcon,
    required this.items,
    this.label,
    this.initiallyOpen = false,
    this.heroTag,
  });

  @override
  State<CarbonFloatingMenu> createState() => _CarbonFloatingMenuState();
}

class _CarbonFloatingMenuState extends State<CarbonFloatingMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.initiallyOpen;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    if (_isOpen) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final theme = CarbonFloatingMenuThemeData(
      fabBackground: carbon.button.buttonPrimary,
      fabForeground: carbon.text.textOnColor,
      menuBackground: carbon.layer.layer02,
      menuItemBackground: carbon.layer.layer01,
      menuItemBackgroundHover: carbon.layer.layerHover01,
      text: carbon.text.textPrimary,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Menu items
        ...widget.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final delay = (widget.items.length - index - 1) * 0.05;

          return ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, 1.0, curve: Curves.easeOut),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _FloatingMenuItem(
                icon: item.icon,
                label: item.label,
                onTap: () {
                  item.onTap();
                  _toggle(); // Close menu after selection
                },
                theme: theme,
              ),
            ),
          );
        }),

        // Main FAB
        FloatingActionButton(
          heroTag: widget.heroTag ?? 'floating_menu_fab',
          backgroundColor: theme.fabBackground,
          foregroundColor: theme.fabForeground,
          onPressed: _toggle,
          elevation: 4,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: AnimatedRotation(
            turns: _isOpen ? 0.125 : 0.0, // 45 degree rotation when open
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _isOpen ? (widget.openIcon ?? Icons.close) : widget.icon,
            ),
          ),
        ),
      ],
    );
  }
}

class _FloatingMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final CarbonFloatingMenuThemeData theme;

  const _FloatingMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
  });

  @override
  State<_FloatingMenuItem> createState() => _FloatingMenuItemState();
}

class _FloatingMenuItemState extends State<_FloatingMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.theme.menuItemBackgroundHover
                    : widget.theme.menuItemBackground,
                border: Border.all(color: widget.theme.menuBackground),
                borderRadius: BorderRadius.zero,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: widget.theme.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Icon button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.theme.menuItemBackgroundHover
                    : widget.theme.menuItemBackground,
                border: Border.all(color: widget.theme.menuBackground),
                borderRadius: BorderRadius.zero,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(widget.icon, color: widget.theme.text, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
