import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Carbon Design System dropdown/select widget.
///
/// A dropdown that follows Carbon Design System specifications with:
/// - Sharp corners (zero border radius)
/// - 1px border that changes on focus
/// - Chevron down icon
/// - Proper Carbon colors and states
///
/// Example:
/// ```dart
/// CarbonDropdown<String>(
///   value: selectedValue,
///   label: 'Select option',
///   items: ['Option 1', 'Option 2', 'Option 3']
///       .map((value) => CarbonDropdownItem(
///             value: value,
///             child: Text(value),
///           ))
///       .toList(),
///   onChanged: (value) {
///     setState(() => selectedValue = value);
///   },
/// )
/// ```
class CarbonDropdown<T> extends StatelessWidget {
  /// The currently selected value.
  final T? value;

  /// Called when the user selects an item.
  final ValueChanged<T?>? onChanged;

  /// The list of items to display in the dropdown.
  final List<CarbonDropdownItem<T>> items;

  /// Optional label text displayed above the dropdown.
  final String? label;

  /// Optional helper text displayed below the dropdown.
  final String? helperText;

  /// Optional error text displayed below the dropdown.
  final String? errorText;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// Hint text when no value is selected.
  final String? hint;

  /// Custom icon for the dropdown (defaults to chevron down).
  final Widget? icon;

  /// Whether to show border around the dropdown.
  final bool showBorder;

  const CarbonDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.hint,
    this.icon,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: enabled
                  ? carbon.text.textSecondary
                  : carbon.text.textDisabled,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Dropdown
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: enabled
                ? carbon.layer.field01
                : carbon.layer.layerSelectedDisabled,
            border: showBorder
                ? Border.all(
                    color: hasError
                        ? carbon.layer.supportError
                        : carbon.layer.borderStrong01,
                    width: hasError ? 2 : 1,
                  )
                : null,
            borderRadius: BorderRadius.zero,
          ),
          child: DropdownButtonHideUnderline(
            child: Theme(
              data: Theme.of(context).copyWith(
                // Highlight color for selected/hovered menu items
                highlightColor: carbon.layer.layerSelected01,
                // Focus color for keyboard navigation
                focusColor: carbon.layer.layerSelected01,
                // Hover color for mouse hover
                hoverColor: carbon.layer.layerHover01,
              ),
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<T>(
                  value: value,
                  hint: hint != null
                      ? Text(
                          hint!,
                          style: TextStyle(
                            color: carbon.text.textPlaceholder,
                            fontSize: 14,
                          ),
                        )
                      : null,
                  items: items
                      .map(
                        (item) => DropdownMenuItem<T>(
                          value: item.value,
                          enabled: item.enabled,
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: carbon.text.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            child: item.child,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: enabled ? onChanged : null,
                  icon: icon ??
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: enabled
                            ? carbon.text.iconPrimary
                            : carbon.text.iconDisabled,
                      ),
                  isExpanded: true,
                  style: TextStyle(
                    color: enabled
                        ? carbon.text.textPrimary
                        : carbon.text.textDisabled,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  dropdownColor: carbon.layer.layer01,
                  elevation: 2,
                  menuMaxHeight: 300,
                  borderRadius: BorderRadius.zero,
                  itemHeight: kMinInteractiveDimension,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),
        ),

        // Helper or error text
        if (helperText != null || errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText ?? helperText!,
            style: TextStyle(
              color:
                  hasError ? carbon.layer.supportError : carbon.text.textHelper,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

/// A menu item for use in a [CarbonDropdown].
class CarbonDropdownItem<T> {
  /// The value this item represents.
  final T value;

  /// The widget to display for this item.
  final Widget child;

  /// Whether this item is enabled.
  final bool enabled;

  const CarbonDropdownItem({
    required this.value,
    required this.child,
    this.enabled = true,
  });
}
