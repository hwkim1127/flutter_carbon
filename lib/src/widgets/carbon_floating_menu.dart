import 'package:flutter/widgets.dart';

import '../base/carbon_pressable.dart';
import '../foundation/colors.dart';
import '../icons/carbon_icons.dart';
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

  const CarbonFloatingMenu({
    super.key,
    this.icon = CarbonIcons.add,
    this.openIcon,
    required this.items,
    this.label,
    this.initiallyOpen = false,
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

        // Main trigger button (Carbon has no FAB spec — native square with
        // hover/pressed feedback the Material FAB variant never had).
        Semantics(
          button: true,
          label: widget.label,
          child: CarbonPressable(
            onTap: _toggle,
            focusable: true,
            builder: (context, state) => Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: state.pressed
                    ? carbon.button.buttonPrimaryActive
                    : state.hovered
                        ? carbon.button.buttonPrimaryHover
                        : theme.fabBackground,
                boxShadow: [
                  BoxShadow(
                    color: CarbonPalette.black.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedRotation(
                  turns: _isOpen ? 0.125 : 0.0, // 45° rotation when open
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _isOpen
                        ? (widget.openIcon ?? CarbonIcons.close)
                        : widget.icon,
                    color: theme.fabForeground,
                    size: 24,
                  ),
                ),
              ),
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
                    color: CarbonPalette.black.withValues(alpha: 0.1),
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
                    color: CarbonPalette.black.withValues(alpha: 0.1),
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
