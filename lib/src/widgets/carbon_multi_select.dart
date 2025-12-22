import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Item for Carbon multi-select dropdown.
class CarbonMultiSelectItem<T> {
  /// The value represented by this item.
  final T value;

  /// The widget to display for this item.
  final Widget child;

  /// Whether this item is enabled for selection.
  final bool enabled;

  const CarbonMultiSelectItem({
    required this.value,
    required this.child,
    this.enabled = true,
  });
}

/// Carbon multi-select dropdown component.
///
/// Allows users to select multiple options from a list. Selected items are
/// displayed as chips above the dropdown field.
class CarbonMultiSelect<T> extends StatefulWidget {
  /// The currently selected values.
  final List<T> values;

  /// Called when the selection changes.
  final ValueChanged<List<T>> onChanged;

  /// The list of items to display in the dropdown.
  final List<CarbonMultiSelectItem<T>> items;

  /// Optional label text displayed above the dropdown.
  final String? label;

  /// Optional helper text displayed below the dropdown.
  final String? helperText;

  /// Optional error text displayed below the dropdown.
  final String? errorText;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// Hint text when no values are selected.
  final String? hint;

  /// Whether to show a search/filter field.
  final bool filterable;

  /// Maximum height for the dropdown menu.
  final double? menuMaxHeight;

  /// Function to convert a value to display text (for chips).
  final String Function(T)? itemToString;

  const CarbonMultiSelect({
    super.key,
    required this.values,
    required this.items,
    required this.onChanged,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.hint,
    this.filterable = false,
    this.menuMaxHeight,
    this.itemToString,
  });

  @override
  State<CarbonMultiSelect<T>> createState() => _CarbonMultiSelectState<T>();
}

class _CarbonMultiSelectState<T> extends State<CarbonMultiSelect<T>> {
  bool _isOpen = false;
  String _filterText = '';
  final TextEditingController _filterController = TextEditingController();

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  void _toggleSelection(T value) {
    final newValues = List<T>.from(widget.values);
    if (newValues.contains(value)) {
      newValues.remove(value);
    } else {
      newValues.add(value);
    }
    widget.onChanged(newValues);
  }

  void _removeItem(T value) {
    final newValues = List<T>.from(widget.values);
    newValues.remove(value);
    widget.onChanged(newValues);
  }

  String _getItemText(T value) {
    if (widget.itemToString != null) {
      return widget.itemToString!(value);
    }
    return value.toString();
  }

  List<CarbonMultiSelectItem<T>> _getFilteredItems() {
    if (!widget.filterable || _filterText.isEmpty) {
      return widget.items;
    }
    return widget.items.where((item) {
      final text = _getItemText(item.value).toLowerCase();
      return text.contains(_filterText.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final filteredItems = _getFilteredItems();

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

        // Selected items as chips
        if (widget.values.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.values.map((value) {
              return Chip(
                label: Text(_getItemText(value)),
                onDeleted: widget.enabled ? () => _removeItem(value) : null,
                deleteIcon: Icon(
                  Icons.close,
                  size: 16,
                  color: carbon.text.iconPrimary,
                ),
                backgroundColor: carbon.layer.layer01,
                side: BorderSide(color: carbon.layer.borderSubtle01),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                labelStyle: TextStyle(
                  color: carbon.text.textPrimary,
                  fontSize: 12,
                ),
                deleteIconColor: carbon.text.iconPrimary,
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],

        // Dropdown field
        GestureDetector(
          onTap:
              widget.enabled ? () => setState(() => _isOpen = !_isOpen) : null,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.enabled
                  ? carbon.layer.field01
                  : carbon.layer.layerSelectedDisabled,
              border: Border.all(
                color: hasError
                    ? carbon.layer.supportError
                    : carbon.layer.borderStrong01,
                width: hasError ? 2 : 1,
              ),
              borderRadius: BorderRadius.zero,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.values.isEmpty
                        ? (widget.hint ?? 'Select options')
                        : '${widget.values.length} selected',
                    style: TextStyle(
                      color: widget.values.isEmpty
                          ? carbon.text.textPlaceholder
                          : carbon.text.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: widget.enabled
                      ? carbon.text.iconPrimary
                      : carbon.text.iconDisabled,
                ),
              ],
            ),
          ),
        ),

        // Dropdown menu
        if (_isOpen) ...[
          const SizedBox(height: 4),
          Container(
            constraints: BoxConstraints(maxHeight: widget.menuMaxHeight ?? 300),
            decoration: BoxDecoration(
              color: carbon.layer.layer01,
              border: Border.all(color: carbon.layer.borderSubtle01),
              borderRadius: BorderRadius.zero,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Filter field
                if (widget.filterable) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: carbon.layer.borderSubtle01),
                      ),
                    ),
                    child: TextField(
                      controller: _filterController,
                      decoration: InputDecoration(
                        hintText: 'Filter options',
                        hintStyle: TextStyle(
                          color: carbon.text.textPlaceholder,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                      style: TextStyle(
                        color: carbon.text.textPrimary,
                        fontSize: 14,
                      ),
                      onChanged: (value) {
                        setState(() => _filterText = value);
                      },
                    ),
                  ),
                ],

                // Options list
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = widget.values.contains(item.value);

                      return InkWell(
                        onTap: item.enabled
                            ? () => _toggleSelection(item.value)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? carbon.layer.layerSelected01
                                : null,
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: item.enabled
                                    ? (value) => _toggleSelection(item.value)
                                    : null,
                                activeColor: carbon.button.buttonPrimary,
                                checkColor: carbon.text.textOnColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                    color: item.enabled
                                        ? carbon.text.textPrimary
                                        : carbon.text.textDisabled,
                                    fontSize: 14,
                                  ),
                                  child: item.child,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],

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
