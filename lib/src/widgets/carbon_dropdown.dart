import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Size variants for [CarbonDropdown].
enum CarbonDropdownSize {
  /// Small size (32px / 2rem) - Use when space is constricted.
  small,

  /// Medium size (40px / 2.5rem) - Default size, most commonly used.
  medium,

  /// Large size (48px / 3rem) - Use when there is a lot of space.
  large,
}

/// Extension to get height from size.
extension CarbonDropdownSizeExtension on CarbonDropdownSize {
  double get height {
    switch (this) {
      case CarbonDropdownSize.small:
        return 32;
      case CarbonDropdownSize.medium:
        return 40;
      case CarbonDropdownSize.large:
        return 48;
    }
  }
}

/// Carbon Design System dropdown/select widget.
///
/// A custom dropdown implementation that follows Carbon Design System specifications:
/// - Sharp corners (zero border radius)
/// - 1px border that changes on focus
/// - Chevron down icon
/// - Proper Carbon colors and states
/// - No forced padding (precise control)
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
class CarbonDropdown<T> extends StatefulWidget {
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

  /// Size of the dropdown (default: medium).
  final CarbonDropdownSize size;

  /// Optional fixed width for the dropdown.
  final double? width;

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
    this.size = CarbonDropdownSize.medium,
    this.width,
  });

  @override
  State<CarbonDropdown<T>> createState() => _CarbonDropdownState<T>();
}

class _CarbonDropdownState<T> extends State<CarbonDropdown<T>> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;
  T? _highlightedValue;

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
      _highlightedValue = widget.value;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isOpen = false;
      _highlightedValue = null;
    });
  }

  void _selectItem(T value) {
    widget.onChanged?.call(value);
    _closeDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final menuWidth = widget.width ?? size.width;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Calculate available space below and above
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - offset.dy - size.height;
    const maxMenuHeight = 300.0;

    // Show menu above if there's not enough space below
    final showAbove = spaceBelow < maxMenuHeight && offset.dy > spaceBelow;
    final menuOffset = showAbove
        ? Offset(0, -(size.height * widget.items.length))
        : Offset(0, size.height + 1);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            // Full-screen invisible layer to detect clicks outside
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),
            // The actual dropdown menu
            Positioned(
              width: menuWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: menuOffset,
                child: Material(
                  elevation: 2,
                  color: Colors.transparent,
                  child: _buildDropdownMenu(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownMenu() {
    final carbon = context.carbon;

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: carbon.layer.layer01,
        border: Border.all(color: carbon.layer.borderSubtle01, width: 1),
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: widget.items.map((item) {
          final isSelected = item.value == widget.value;
          final isHighlighted = item.value == _highlightedValue;

          return _buildMenuItem(
            item: item,
            isSelected: isSelected,
            isHighlighted: isHighlighted,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem({
    required CarbonDropdownItem<T> item,
    required bool isSelected,
    required bool isHighlighted,
  }) {
    final carbon = context.carbon;

    return MouseRegion(
      onEnter: (_) {
        if (item.enabled) {
          setState(() {
            _highlightedValue = item.value;
          });
        }
      },
      child: GestureDetector(
        onTap: item.enabled
            ? () {
                _selectItem(item.value);
              }
            : null,
        child: Container(
          height: widget.size == CarbonDropdownSize.small
              ? 32
              : widget.size == CarbonDropdownSize.large
                  ? 48
                  : 40,
          decoration: BoxDecoration(
            color: isHighlighted
                ? carbon.layer.layerHover01
                : isSelected
                    ? carbon.layer.layerSelected01
                    : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              if (widget.width != null)
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: item.enabled
                          ? carbon.text.textPrimary
                          : carbon.text.textDisabled,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    child: item.child,
                  ),
                )
              else
                DefaultTextStyle(
                  style: TextStyle(
                    color: item.enabled
                        ? carbon.text.textPrimary
                        : carbon.text.textDisabled,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  child: item.child,
                ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.check,
                    size: 16,
                    color: carbon.text.iconPrimary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    // Find the selected item to display
    final selectedItem =
        widget.items.where((item) => item.value == widget.value).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              color: widget.enabled
                  ? carbon.text.textSecondary
                  : carbon.text.textDisabled,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Dropdown trigger
        CompositedTransformTarget(
          link: _layerLink,
          child: SizedBox(
            width: widget.width,
            child: GestureDetector(
              onTap: _toggleDropdown,
              child: Container(
                height: widget.size.height,
                decoration: BoxDecoration(
                  color: widget.enabled
                      ? carbon.layer.field01
                      : carbon.layer.layerSelectedDisabled,
                  border: widget.showBorder
                      ? Border.all(
                          color: hasError
                              ? carbon.layer.supportError
                              : _isOpen
                                  ? carbon.button.buttonPrimary
                                  : carbon.layer.borderStrong01,
                          width: hasError || _isOpen ? 2 : 1,
                        )
                      : null,
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    if (widget.width != null)
                      Expanded(
                        child: selectedItem != null
                            ? DefaultTextStyle(
                                style: TextStyle(
                                  color: widget.enabled
                                      ? carbon.text.textPrimary
                                      : carbon.text.textDisabled,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                child: selectedItem.child,
                              )
                            : widget.hint != null
                                ? Text(
                                    widget.hint!,
                                    style: TextStyle(
                                      color: carbon.text.textPlaceholder,
                                      fontSize: 14,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      )
                    else
                      selectedItem != null
                          ? DefaultTextStyle(
                              style: TextStyle(
                                color: widget.enabled
                                    ? carbon.text.textPrimary
                                    : carbon.text.textDisabled,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              child: selectedItem.child,
                            )
                          : widget.hint != null
                              ? Text(
                                  widget.hint!,
                                  style: TextStyle(
                                    color: carbon.text.textPlaceholder,
                                    fontSize: 14,
                                  ),
                                )
                              : const SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: widget.icon ??
                          Icon(
                            _isOpen
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: widget.enabled
                                ? carbon.text.iconPrimary
                                : carbon.text.iconDisabled,
                            size: 16,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Helper or error text
        if (widget.helperText != null || widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText ?? widget.helperText!,
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
