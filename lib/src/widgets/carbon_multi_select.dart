import 'package:flutter/material.dart';

import '../base/carbon_anchored_overlay.dart';
import '../base/carbon_overlay_surface.dart';
import '../foundation/colors.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';
import 'carbon_checkbox.dart';
import 'carbon_tag.dart';

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
/// displayed as chips above the dropdown field. The menu floats over the
/// content (like [CarbonDropdown]) and dismisses on tap-outside; selecting
/// an item keeps it open.
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
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  String _filterText = '';
  final TextEditingController _filterController = TextEditingController();

  @override
  void didUpdateWidget(CarbonMultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The menu lives in an OverlayEntry, which does not rebuild with this
    // widget — repaint it when the selection or items change from outside.
    // Deferred: didUpdateWidget runs during build, and the entry is not a
    // descendant, so marking it dirty here directly is not allowed.
    if (_overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    }
  }

  @override
  void dispose() {
    // Remove directly — _closeMenu() calls setState, which is not allowed
    // during dispose.
    _overlayEntry?.remove();
    _overlayEntry = null;
    _filterController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    if (!widget.enabled || _isOpen) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    if (!_isOpen) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    _filterController.clear();
    _filterText = '';
    if (mounted) {
      setState(() => _isOpen = false);
    }
  }

  void _toggleSelection(T value) {
    final newValues = List<T>.from(widget.values);
    if (newValues.contains(value)) {
      newValues.remove(value);
    } else {
      newValues.add(value);
    }
    widget.onChanged(newValues);
    // Repaint the menu's checkboxes even if the parent doesn't rebuild us.
    _overlayEntry?.markNeedsBuild();
  }

  void _removeItem(T value) {
    final newValues = List<T>.from(widget.values);
    newValues.remove(value);
    widget.onChanged(newValues);
    _overlayEntry?.markNeedsBuild();
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

  OverlayEntry _createOverlayEntry() {
    // Anchor to the field itself, not the whole widget with its label,
    // chips, and helper text — the menu must sit flush to the field.
    final anchorRect = CarbonAnchoredOverlay.anchorRectGetterFor(
      _fieldKey.currentContext ?? context,
    );

    return OverlayEntry(
      builder: (context) => CarbonAnchoredOverlay(
        anchorRect: anchorRect,
        alignment: CarbonPopoverAlignment.bottomStart,
        matchAnchorWidth: true,
        spacing: 4,
        onDismiss: _closeMenu,
        contentBuilder: (context, _) => CarbonOverlaySurface(
          // The filter TextField still needs the Material ancestor the
          // overlay doesn't provide.
          // TODO(v2 Phase 2): replace with CarbonTextInput when it exists.
          child: Material(
            type: MaterialType.transparency,
            child: _buildMenu(context.carbon),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(CarbonThemeData carbon) {
    final filteredItems = _getFilteredItems();

    return Container(
      constraints: BoxConstraints(maxHeight: widget.menuMaxHeight ?? 300),
      decoration: BoxDecoration(
        color: carbon.layer.layer01,
        border: Border.all(color: carbon.layer.borderSubtle01),
        borderRadius: BorderRadius.zero,
        boxShadow: [
          BoxShadow(
            color: CarbonPalette.black.withValues(alpha: 0.1),
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
                autofocus: true,
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
                style: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
                onChanged: (value) {
                  setState(() => _filterText = value);
                  _overlayEntry?.markNeedsBuild();
                },
              ),
            ),
          ],

          // Options list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                final isSelected = widget.values.contains(item.value);

                return MouseRegion(
                  cursor: item.enabled
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.forbidden,
                  child: GestureDetector(
                    onTap: item.enabled
                        ? () => _toggleSelection(item.value)
                        : null,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? carbon.layer.layerSelected01 : null,
                      ),
                      child: Row(
                        children: [
                          CarbonCheckbox(
                            value: isSelected,
                            onChanged: item.enabled
                                ? (value) => _toggleSelection(item.value)
                                : null,
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

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
              return CarbonTag(
                text: _getItemText(value),
                type: CarbonTagType.gray,
                size: CarbonTagSize.md,
                onDismiss: widget.enabled ? () => _removeItem(value) : null,
                disabled: !widget.enabled,
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],

        // Dropdown field
        GestureDetector(
          key: _fieldKey,
          onTap: widget.enabled ? _toggleMenu : null,
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
                    : _isOpen
                    ? carbon.button.buttonPrimary
                    : carbon.layer.borderStrong01,
                width: hasError || _isOpen ? 2 : 1,
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
                  _isOpen ? CarbonIcons.chevronUp : CarbonIcons.chevronDown,
                  color: widget.enabled
                      ? carbon.text.iconPrimary
                      : carbon.text.iconDisabled,
                ),
              ],
            ),
          ),
        ),

        // Helper or error text
        if (widget.helperText != null || widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText ?? widget.helperText!,
            style: TextStyle(
              color: hasError
                  ? carbon.layer.supportError
                  : carbon.text.textHelper,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
