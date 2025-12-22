import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Carbon Design System combo box with autocomplete and search.
///
/// A combo box that follows Carbon Design System specifications with:
/// - Autocomplete dropdown with search
/// - Sharp corners (zero border radius)
/// - Proper Carbon colors and states
/// - Filtering capabilities
///
/// Example:
/// ```dart
/// CarbonComboBox<String>(
///   value: selectedValue,
///   label: 'Select option',
///   items: ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry']
///       .map((value) => CarbonComboBoxItem(
///             value: value,
///             label: value,
///           ))
///       .toList(),
///   onChanged: (value) {
///     setState(() => selectedValue = value);
///   },
/// )
/// ```
class CarbonComboBox<T> extends StatefulWidget {
  /// The currently selected value.
  final T? value;

  /// Called when the user selects an item.
  final ValueChanged<T?>? onChanged;

  /// The list of items to display in the combo box.
  final List<CarbonComboBoxItem<T>> items;

  /// Optional label text displayed above the combo box.
  final String? label;

  /// Optional helper text displayed below the combo box.
  final String? helperText;

  /// Optional error text displayed below the combo box.
  final String? errorText;

  /// Whether the combo box is enabled.
  final bool enabled;

  /// Placeholder text when no value is selected.
  final String? placeholder;

  /// Whether to allow clearing the selection.
  final bool allowClear;

  const CarbonComboBox({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.placeholder,
    this.allowClear = true,
  });

  @override
  State<CarbonComboBox<T>> createState() => _CarbonComboBoxState<T>();
}

class _CarbonComboBoxState<T> extends State<CarbonComboBox<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<CarbonComboBoxItem<T>> _filteredItems = [];
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _updateSearchText();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(CarbonComboBox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateSearchText();
    }
    if (oldWidget.items != widget.items) {
      _filteredItems = widget.items;
      _filterItems(_searchController.text);
    }
  }

  @override
  void dispose() {
    _closeDropdown();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateSearchText() {
    if (widget.value != null) {
      final selectedItem = widget.items.firstWhere(
        (item) => item.value == widget.value,
        orElse: () => widget.items.first,
      );
      _searchController.text = selectedItem.label;
    } else {
      _searchController.clear();
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && !_isOpen) {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;

    _isOpen = true;
    _filterItems(_searchController.text);

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    if (!_isOpen) return;

    _isOpen = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _updateSearchText();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) =>
                item.label.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _selectItem(T value) {
    widget.onChanged?.call(value);
    _closeDropdown();
    _focusNode.unfocus();
  }

  void _clearSelection() {
    widget.onChanged?.call(null);
    _searchController.clear();
    _focusNode.requestFocus();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        final carbon = context.carbon;
        final theme = carbon.comboBox;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeDropdown,
          child: Stack(
            children: [
              Positioned(
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, size.height),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.zero,
                    color: theme.menuBackground,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: _filteredItems.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No results found',
                                style: TextStyle(
                                  color: theme.menuItemText,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final isSelected = item.value == widget.value;

                                return InkWell(
                                  onTap: item.enabled
                                      ? () => _selectItem(item.value)
                                      : null,
                                  hoverColor: theme.menuItemHover,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    color: isSelected
                                        ? theme.menuItemSelected
                                        : null,
                                    child: Text(
                                      item.label,
                                      style: TextStyle(
                                        color: item.enabled
                                            ? theme.menuItemText
                                            : theme.menuItemTextDisabled,
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final theme = carbon.comboBox;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
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
                    : theme.textColorDisabled,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Input field with search
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: widget.enabled
                  ? theme.fieldBackground
                  : carbon.layer.layerSelectedDisabled,
              border: Border.all(
                color: hasError
                    ? theme.fieldBorderError
                    : (_focusNode.hasFocus
                        ? theme.fieldBorderFocus
                        : theme.fieldBorder),
                width: hasError || _focusNode.hasFocus ? 2 : 1,
              ),
              borderRadius: BorderRadius.zero,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    style: TextStyle(
                      color: widget.enabled
                          ? theme.textColor
                          : theme.textColorDisabled,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: TextStyle(
                        color: theme.placeholderColor,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (value) {
                      if (!_isOpen) {
                        _openDropdown();
                      }
                      _filterItems(value);
                    },
                    onTap: () {
                      if (!_isOpen) {
                        _openDropdown();
                      }
                    },
                  ),
                ),
                // Clear button
                if (widget.allowClear &&
                    widget.value != null &&
                    widget.enabled) ...[
                  InkWell(
                    onTap: _clearSelection,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: theme.iconColor,
                      ),
                    ),
                  ),
                ],
                // Dropdown icon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: widget.enabled
                        ? theme.iconColor
                        : theme.iconColorDisabled,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Helper or error text
          if (widget.helperText != null || widget.errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.errorText ?? widget.helperText!,
              style: TextStyle(
                color:
                    hasError ? theme.fieldBorderError : carbon.text.textHelper,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A menu item for use in a [CarbonComboBox].
class CarbonComboBoxItem<T> {
  /// The value this item represents.
  final T value;

  /// The display label for this item.
  final String label;

  /// Whether this item is enabled.
  final bool enabled;

  const CarbonComboBoxItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });
}
