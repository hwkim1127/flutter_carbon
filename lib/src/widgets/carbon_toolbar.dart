import 'package:flutter/widgets.dart';

import '../../flutter_carbon.dart';
import '../base/carbon_pressable.dart';

/// Carbon Design System Toolbar.
///
/// A toolbar component for data tables following Carbon Design System specifications.
/// Supports regular actions and batch actions with automatic switching and animations.
///
/// The toolbar uses `$layer` background color and has a minimum height of 48px (3rem).
/// When items are selected, it automatically switches to batch actions mode with
/// `$background-brand` color and animated transition.
///
/// Typically used with [CarbonDataTable] to provide search, filters, and actions.
class CarbonToolbar extends StatelessWidget {
  /// Regular toolbar content (search, filters, actions).
  ///
  /// Use [CarbonToolbarContent] to wrap toolbar widgets.
  final Widget? content;

  /// Batch actions shown when items are selected.
  ///
  /// Use [CarbonToolbarBatchActions] to wrap batch action buttons.
  /// This is shown instead of [content] when [selectedCount] > 0.
  final Widget? batchActions;

  /// Number of selected items.
  ///
  /// When > 0, [batchActions] is shown instead of [content].
  final int selectedCount;

  const CarbonToolbar({
    super.key,
    this.content,
    this.batchActions,
    this.selectedCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final showBatchActions = selectedCount > 0 && batchActions != null;

    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      color: carbon.layer.layer01,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 110),
        child: showBatchActions
            ? KeyedSubtree(key: const ValueKey('batch'), child: batchActions!)
            : KeyedSubtree(
                key: const ValueKey('content'),
                child: content ?? const SizedBox.shrink(),
              ),
      ),
    );
  }
}

/// Regular toolbar content container.
///
/// Use this to wrap search fields, filters, and action buttons.
/// Items are right-aligned by default following Carbon specifications.
class CarbonToolbarContent extends StatelessWidget {
  /// Child widgets (search, filters, actions).
  final List<Widget> children;

  const CarbonToolbarContent({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: children),
    );
  }
}

/// Batch actions toolbar shown when items are selected.
///
/// Displays the selected count, optional "Select all" button, and action buttons
/// for bulk operations. Uses `$background-brand` color with white text.
///
/// Structure:
/// - Batch summary (selected count + select all button)
/// - Spacer
/// - Action buttons
/// - Cancel button with divider
class CarbonToolbarBatchActions extends StatelessWidget {
  /// Number of selected items.
  final int selectedCount;

  /// Action buttons (delete, export, etc.).
  final List<Widget> actions;

  /// Callback when the cancel button is pressed.
  ///
  /// Typically used to clear selection.
  final VoidCallback? onCancel;

  /// Total number of items in the table.
  ///
  /// If provided, shows "Select all (N)" button in the batch summary.
  final int? totalRowsCount;

  /// Callback when "Select all" button is pressed.
  final VoidCallback? onSelectAll;

  /// Label generator for "Select all" button.
  ///
  /// Defaults to "Select all (N)".
  final String Function(int total)? selectAllLabel;

  /// Label for the cancel button.
  ///
  /// Defaults to "Cancel".
  final String? cancelLabel;

  /// Formatter for selected items count.
  ///
  /// Defaults to "X item" or "X items" depending on count.
  final String Function(int count)? formatSelectedItemsCount;

  const CarbonToolbarBatchActions({
    super.key,
    required this.selectedCount,
    required this.actions,
    this.onCancel,
    this.totalRowsCount,
    this.onSelectAll,
    this.selectAllLabel,
    this.cancelLabel,
    this.formatSelectedItemsCount,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final String formattedCount =
        formatSelectedItemsCount?.call(selectedCount) ??
        '$selectedCount item${selectedCount <= 1 ? '' : 's'} selected';

    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      color: carbon.layer.backgroundBrand,
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          // Batch summary
          Expanded(
            child: Row(
              children: [
                // Selected count text
                Text(
                  formattedCount,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: carbon.text.textOnColor,
                    height: 1.29,
                    letterSpacing: 0.16,
                  ),
                ),

                // Divider + Select all button
                if (totalRowsCount != null && totalRowsCount! > 0) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '|',
                      style: TextStyle(
                        color: carbon.text.textOnColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CarbonPressable(
                    onTap: onSelectAll,
                    focusable: true,
                    builder: (context, state) => Opacity(
                      opacity: state.hovered || state.pressed ? 0.8 : 1.0,
                      child: Text(
                        selectAllLabel?.call(totalRowsCount!) ??
                            'Select all ($totalRowsCount)',
                        style: TextStyle(
                          color: carbon.text.textOnColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.29,
                          letterSpacing: 0.16,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Action buttons
          Row(
            children: [
              for (int i = 0; i < actions.length; i++) ...[actions[i]],
              // Cancel button with divider
              if (onCancel != null) ...[
                const SizedBox(width: 1),
                _CancelButton(
                  onPressed: onCancel!,
                  textColor: carbon.text.textOnColor,
                  label: cancelLabel,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Cancel button with left divider for batch actions.
class _CancelButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color textColor;
  final String? label;

  const _CancelButton({
    required this.onPressed,
    required this.textColor,
    this.label,
  });

  @override
  State<_CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<_CancelButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Divider (always visible)
        Positioned(
          left: 0,
          top: 15,
          bottom: 15,
          child: Container(width: 1, color: widget.textColor),
        ),
        // Button
        CarbonPressable(
          onTap: widget.onPressed,
          focusable: true,
          builder: (context, state) => Opacity(
            opacity: state.hovered || state.pressed ? 0.8 : 1.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Text(
                widget.label ?? 'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor,
                  height: 1.29,
                  letterSpacing: 0.16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Search field for toolbar.
///
/// A thin wrapper over [CarbonSearch] at toolbar size (48px): expandable by
/// default (persistent renders the field permanently), 300px wide expanded —
/// or filling the toolbar with [expanded].
class CarbonToolbarSearch extends StatefulWidget {
  /// Current search value.
  final String? value;

  /// Callback when search value changes.
  final ValueChanged<String>? onChanged;

  /// Callback when search is submitted (Enter key).
  final ValueChanged<String>? onSubmitted;

  /// Placeholder text.
  final String placeholder;

  /// Whether the search field should be persistent (always visible).
  ///
  /// If false, the search field is expandable on click/focus.
  final bool persistent;

  /// Whether the search field should expand to fill available space.
  final bool expanded;

  const CarbonToolbarSearch({
    super.key,
    this.value,
    this.onChanged,
    this.onSubmitted,
    this.placeholder = 'Search',
    this.persistent = false,
    this.expanded = false,
  });

  @override
  State<CarbonToolbarSearch> createState() => _CarbonToolbarSearchState();
}

class _CarbonToolbarSearchState extends State<CarbonToolbarSearch> {
  late final TextEditingController _controller;

  /// Keeps the search's state (focus, expansion, animation) alive while
  /// this wrapper reparents it between the collapsed bare widget and the
  /// expanded SizedBox/Expanded shells.
  final GlobalKey _searchKey = GlobalKey();

  bool _searchExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _searchExpanded = widget.persistent;
  }

  @override
  void didUpdateWidget(CarbonToolbarSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = CarbonSearch(
      key: _searchKey,
      controller: _controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      placeholder: widget.placeholder,
      size: CarbonSearchSize.lg,
      expandable: !widget.persistent,
      initiallyExpanded: widget.persistent,
      onExpandedChanged: (value) => setState(() => _searchExpanded = value),
    );

    // Collapsed: the bare 48px square (unbounded in the toolbar Row).
    if (!widget.persistent && !_searchExpanded) {
      return search;
    }
    if (widget.expanded) {
      return Expanded(child: search);
    }
    return SizedBox(width: 300, child: search);
  }
}
