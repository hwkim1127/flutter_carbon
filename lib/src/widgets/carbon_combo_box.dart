import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/carbon_theme.dart';

/// Carbon Design System combo box with autocomplete and search.
///
/// A combo box that follows Carbon Design System specifications with:
/// - Autocomplete dropdown with search
/// - Sharp corners (zero border radius)
/// - Proper Carbon colors and states
/// - Filtering capabilities
/// - Keyboard navigation (↑ ↓ Enter Escape)
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

  /// Called when the user types in the search field.
  ///
  /// When provided, client-side filtering is disabled — the parent is
  /// responsible for updating [items] in response to the query (e.g. by
  /// querying a database).
  final ValueChanged<String>? onSearch;

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
    this.onSearch,
  });

  @override
  State<CarbonComboBox<T>> createState() => _CarbonComboBoxState<T>();
}

class _CarbonComboBoxState<T> extends State<CarbonComboBox<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();
  OverlayEntry? _overlayEntry;
  List<CarbonComboBoxItem<T>> _filteredItems = [];
  bool _isOpen = false;
  int _highlightedIndex = -1;

  static const double _itemHeight = 44.0;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _updateSearchText();
    _focusNode.addListener(_onFocusChange);
    _focusNode.onKeyEvent = _handleKeyEvent;
  }

  @override
  void didUpdateWidget(CarbonComboBox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateSearchText();
    }
    if (oldWidget.items != widget.items) {
      _filteredItems = widget.items;
      _highlightedIndex = -1;
      if (widget.onSearch == null) {
        _filterItems(_searchController.text);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {});
            _overlayEntry?.markNeedsBuild();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _closeDropdown();
    _searchController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateSearchText() {
    if (widget.value != null) {
      final selectedItem = widget.items.firstWhere(
        (item) => item.value == widget.value,
        orElse: () => widget.items.first,
      );
      _searchController.text = selectedItem.filterText;
    } else {
      _searchController.clear();
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && !_isOpen) {
      _openDropdown();
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (!_isOpen) _openDropdown();
      if (_filteredItems.isEmpty) return KeyEventResult.handled;
      setState(() {
        _highlightedIndex =
            (_highlightedIndex + 1).clamp(0, _filteredItems.length - 1);
      });
      _overlayEntry?.markNeedsBuild();
      _scrollToHighlighted();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (!_isOpen || _filteredItems.isEmpty) return KeyEventResult.ignored;
      setState(() {
        _highlightedIndex =
            (_highlightedIndex - 1).clamp(0, _filteredItems.length - 1);
      });
      _overlayEntry?.markNeedsBuild();
      _scrollToHighlighted();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      if (_isOpen &&
          _highlightedIndex >= 0 &&
          _highlightedIndex < _filteredItems.length) {
        final item = _filteredItems[_highlightedIndex];
        if (item.enabled) _selectItem(item.value);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_isOpen) {
        _closeDropdown();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  void _scrollToHighlighted() {
    if (!_scrollController.hasClients || _highlightedIndex < 0) return;
    final offset = _highlightedIndex * _itemHeight;
    final maxOffset = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(offset.clamp(0.0, maxOffset));
  }

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;

    _isOpen = true;
    _highlightedIndex = -1;
    _filterItems(_searchController.text);

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    if (!_isOpen) return;

    _isOpen = false;
    _highlightedIndex = -1;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _updateSearchText();
  }

  void _filterItems(String query) {
    if (widget.onSearch != null) {
      setState(() => _filteredItems = widget.items);
      widget.onSearch!(query);
    } else {
      setState(() {
        _filteredItems = query.isEmpty
            ? widget.items
            : widget.items
                .where((item) =>
                    item.filterText.toLowerCase().contains(query.toLowerCase()))
                .toList();
      });
    }
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
                              controller: _scrollController,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: _filteredItems.length,
                              itemExtent: _itemHeight,
                              itemBuilder: (context, index) {
                                final item = _filteredItems[index];
                                final isSelected = item.value == widget.value;
                                final isHighlighted =
                                    index == _highlightedIndex;

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
                                    color: isHighlighted
                                        ? theme.menuItemHover
                                        : isSelected
                                            ? theme.menuItemSelected
                                            : null,
                                    child: item.child ??
                                        Text(
                                          item.label!,
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
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
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
///
/// Exactly one of [label] or [child] must be provided.
/// - [label]: displays as text and is used for filtering.
/// - [child]: displays as a custom widget; filtering falls back to
///   `value.toString()`.
class CarbonComboBoxItem<T> {
  /// The value this item represents.
  final T value;

  /// Text to display and filter by. Mutually exclusive with [child].
  final String? label;

  /// Custom widget to display. Mutually exclusive with [label].
  final Widget? child;

  /// Whether this item is enabled.
  final bool enabled;

  const CarbonComboBoxItem({
    required this.value,
    this.label,
    this.child,
    this.enabled = true,
  }) : assert(
          (label != null) ^ (child != null),
          'Exactly one of label or child must be provided.',
        );

  /// The string used for filtering, regardless of display mode.
  String get filterText => label ?? value.toString();
}
