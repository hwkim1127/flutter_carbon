import 'package:flutter/widgets.dart';

import '../base/carbon_anchored_overlay.dart';
import '../base/carbon_overlay_surface.dart';
import '../foundation/motion.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';
import 'carbon_button.dart';
import 'carbon_menu.dart';
import 'carbon_tooltip.dart';

/// A Carbon Design System combo button (split button).
///
/// Combines a primary action button with a dropdown menu for additional
/// actions. The primary button executes the main action immediately; the
/// chevron button opens a Carbon menu with secondary actions.
///
/// Example:
/// ```dart
/// CarbonComboButton<String>(
///   label: 'Save',
///   onPressed: () => print('Save clicked'),
///   menuItems: const [
///     CarbonMenuItem(value: 'save-as', label: 'Save as...'),
///     CarbonMenuItem(value: 'save-copy', label: 'Save a copy'),
///   ],
///   onMenuItemSelected: (value) => print('Selected: $value'),
/// )
/// ```
class CarbonComboButton<T> extends StatefulWidget {
  /// Creates a Carbon combo button.
  const CarbonComboButton({
    super.key,
    required this.label,
    this.onPressed,
    this.menuItems = const [],
    this.onMenuItemSelected,
    this.size = CarbonComboButtonSize.large,
    this.disabled = false,
    this.tooltipContent = 'Additional actions',
  });

  /// Label text for the primary button.
  final String label;

  /// Callback when the primary button is pressed.
  final VoidCallback? onPressed;

  /// The dropdown menu content.
  final List<CarbonMenuEntry<T>> menuItems;

  /// Called with an activated item's [CarbonMenuItem.value] when non-null.
  /// Per-item [CarbonMenuItem.onTap] callbacks fire first.
  final ValueChanged<T>? onMenuItemSelected;

  /// Size of the combo button.
  final CarbonComboButtonSize size;

  /// Whether the button is disabled.
  final bool disabled;

  /// Tooltip text for the menu trigger button.
  final String tooltipContent;

  @override
  State<CarbonComboButton<T>> createState() => _CarbonComboButtonState<T>();
}

class _CarbonComboButtonState<T> extends State<CarbonComboButton<T>> {
  /// Anchors the menu to the FULL container (primary + separator + trigger),
  /// so `matchAnchorWidth` makes the menu exactly container-width (spec).
  final GlobalKey _containerKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  bool _menuOpen = false;

  CarbonButtonSize get _buttonSize {
    switch (widget.size) {
      case CarbonComboButtonSize.small:
        return CarbonButtonSize.sm;
      case CarbonComboButtonSize.medium:
        return CarbonButtonSize.md;
      case CarbonComboButtonSize.large:
        return CarbonButtonSize.lg;
    }
  }

  void _toggleMenu() {
    if (_menuOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    if (_menuOpen) return;

    final overlayState = Overlay.of(context);
    final anchorRect = CarbonAnchoredOverlay.anchorRectGetterFor(
      _containerKey.currentContext!,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => CarbonAnchoredOverlay(
        anchorRect: anchorRect,
        alignment: CarbonPopoverAlignment.bottomEnd,
        spacing: 0,
        matchAnchorWidth: true,
        onDismiss: _closeMenu,
        contentBuilder: (context, _) => CarbonOverlaySurface(
          child: CarbonMenuPanel<T>(
            entries: widget.menuItems,
            onSelected: widget.onMenuItemSelected,
            onClose: _closeMenu,
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
    setState(() => _menuOpen = true);
  }

  void _closeMenu() {
    if (!_menuOpen) return;

    if (mounted) {
      setState(() => _menuOpen = false);
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void didUpdateWidget(CarbonComboButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.disabled && _menuOpen) {
      _closeMenu();
    }
  }

  @override
  void dispose() {
    // Remove directly — _closeMenu() calls setState, not allowed in dispose.
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    final trigger = CarbonButton(
      onPressed: widget.disabled ? null : _toggleMenu,
      kind: CarbonButtonKind.primary,
      size: _buttonSize,
      icon: AnimatedRotation(
        turns: _menuOpen ? 0.5 : 0.0,
        duration: CarbonMotion.fast02,
        curve: CarbonMotion.standardProductive,
        child: const Icon(CarbonIcons.chevronDown),
      ),
    );

    return Row(
      key: _containerKey,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary action (spec: nowrap ellipsis, max width 239).
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 239),
          child: CarbonButton(
            onPressed: widget.disabled ? null : widget.onPressed,
            kind: CarbonButtonKind.primary,
            size: _buttonSize,
            child: Text(
              widget.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        // 1px separator between the halves.
        SizedBox(
          width: 1,
          height: widget.size.height,
          child: ColoredBox(
            color: widget.disabled
                ? carbon.layer.borderDisabled
                : carbon.button.buttonSeparator,
          ),
        ),

        // Menu trigger. The tooltip stays mounted (a conditional wrapper
        // would recreate the trigger subtree and kill the chevron rotation
        // animation) but is suppressed while the menu is open.
        CarbonTooltip(
          message: widget.tooltipContent,
          enabled: !_menuOpen,
          child: trigger,
        ),
      ],
    );
  }
}

/// Size variants for Carbon combo button.
enum CarbonComboButtonSize {
  /// Small - 32px height
  small(32, 14, 12),

  /// Medium - 40px height
  medium(40, 14, 16),

  /// Large - 48px height (default)
  large(48, 16, 16);

  const CarbonComboButtonSize(
    this.height,
    this.fontSize,
    this.horizontalPadding,
  );

  /// Height in pixels.
  final double height;

  /// Font size for button text.
  final double fontSize;

  /// Horizontal padding for button content.
  final double horizontalPadding;
}
