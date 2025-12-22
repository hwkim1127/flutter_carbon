import 'package:flutter/material.dart';

import '../theme/carbon_theme_data.dart';

/// A Carbon Design System combo button (split button).
///
/// Combines a primary action button with a dropdown menu for additional actions.
/// The primary button executes the main action immediately, while the chevron
/// button opens a menu with secondary actions.
///
/// Example:
/// ```dart
/// CarbonComboButton(
///   label: 'Save',
///   onPressed: () => print('Save clicked'),
///   menuItems: [
///     PopupMenuItem(value: 'save-as', child: Text('Save as...')),
///     PopupMenuItem(value: 'save-copy', child: Text('Save a copy')),
///   ],
///   onMenuItemSelected: (value) => print('Selected: $value'),
/// )
/// ```
class CarbonComboButton extends StatelessWidget {
  /// Creates a Carbon combo button.
  const CarbonComboButton({
    super.key,
    required this.label,
    this.onPressed,
    required this.menuItems,
    this.onMenuItemSelected,
    this.size = CarbonComboButtonSize.large,
    this.disabled = false,
    this.tooltipContent = 'Additional actions',
  });

  /// Label text for the primary button.
  final String label;

  /// Callback when the primary button is pressed.
  final VoidCallback? onPressed;

  /// List of menu items for the dropdown.
  final List<PopupMenuEntry<dynamic>> menuItems;

  /// Callback when a menu item is selected.
  final void Function(dynamic value)? onMenuItemSelected;

  /// Size of the combo button.
  final CarbonComboButtonSize size;

  /// Whether the button is disabled.
  final bool disabled;

  /// Tooltip text for the menu trigger button.
  final String tooltipContent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final carbon = theme.extension<CarbonThemeData>()!;

    final height = size.height;
    final fontSize = size.fontSize;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary action button
        SizedBox(
          height: height,
          child: FilledButton(
            onPressed: disabled ? null : onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return carbon.button.buttonDisabled;
                }
                if (states.contains(WidgetState.hovered)) {
                  return carbon.button.buttonPrimaryHover;
                }
                if (states.contains(WidgetState.pressed)) {
                  return carbon.button.buttonPrimaryActive;
                }
                return carbon.button.buttonPrimary;
              }),
              foregroundColor: WidgetStateProperty.all(carbon.text.textOnColor),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(horizontal: size.horizontalPadding),
              ),
              shape: WidgetStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              textStyle: WidgetStateProperty.all(
                TextStyle(fontSize: fontSize, fontWeight: FontWeight.w400),
              ),
              // Remove right border radius to connect with icon button
              side: WidgetStateProperty.all(BorderSide.none),
            ),
            child: Text(label),
          ),
        ),

        // Divider between buttons
        Container(
          width: 1,
          height: height,
          color: disabled
              ? carbon.layer.borderDisabled
              : carbon.button.buttonPrimaryHover,
        ),

        // Menu trigger button
        SizedBox(
          width: height,
          height: height,
          child: PopupMenuButton<dynamic>(
            enabled: !disabled,
            itemBuilder: (context) => menuItems,
            onSelected: onMenuItemSelected,
            tooltip: tooltipContent,
            offset: Offset(0, height),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            color: carbon.layer.layer02,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return carbon.button.buttonDisabled;
                }
                if (states.contains(WidgetState.hovered)) {
                  return carbon.button.buttonPrimaryHover;
                }
                if (states.contains(WidgetState.pressed)) {
                  return carbon.button.buttonPrimaryActive;
                }
                return carbon.button.buttonPrimary;
              }),
              foregroundColor: WidgetStateProperty.all(carbon.text.textOnColor),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              shape: WidgetStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color:
                  disabled ? carbon.text.textDisabled : carbon.text.textOnColor,
            ),
          ),
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
      this.height, this.fontSize, this.horizontalPadding);

  /// Height in pixels.
  final double height;

  /// Font size for button text.
  final double fontSize;

  /// Horizontal padding for button content.
  final double horizontalPadding;
}
