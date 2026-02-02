import 'package:flutter/material.dart';

import '../../flutter_carbon.dart';

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
            ? KeyedSubtree(
                key: const ValueKey('batch'),
                child: batchActions!,
              )
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

  const CarbonToolbarContent({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      ),
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
                  TextButton(
                    onPressed: onSelectAll,
                    style: TextButton.styleFrom(
                      foregroundColor: carbon.text.textOnColor,
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      selectAllLabel?.call(totalRowsCount!) ??
                          'Select all ($totalRowsCount)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.29,
                        letterSpacing: 0.16,
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
              for (int i = 0; i < actions.length; i++) ...[
                actions[i],
              ],
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
          child: Container(
            width: 1,
            color: widget.textColor,
          ),
        ),
        // Button
        TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            foregroundColor: widget.textColor,
            // padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
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
      ],
    );
  }
}

/// Search field for toolbar.
///
/// A text field styled for Carbon toolbar usage with transparent background
/// and proper focus states.
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
  final FocusNode _inputFocusNode = FocusNode(); // For TextField input
  final FocusNode _iconFocusNode = FocusNode(); // For collapsed icon
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _isExpanded = widget.persistent;
    _inputFocusNode.addListener(_onInputFocusChange);
    _iconFocusNode.addListener(_onIconFocusChange);
  }

  void _onInputFocusChange() {
    // Handle focus out - collapse if no value and not persistent
    if (!_inputFocusNode.hasFocus) {
      _handleFocusOut();
    }
  }

  void _onIconFocusChange() {
    // When collapsed icon gains focus (keyboard navigation), expand
    if (_iconFocusNode.hasFocus && !_isExpanded) {
      _handleExpand();
    }
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
    _inputFocusNode.removeListener(_onInputFocusChange);
    _iconFocusNode.removeListener(_onIconFocusChange);
    _controller.dispose();
    _inputFocusNode.dispose();
    _iconFocusNode.dispose();
    super.dispose();
  }

  /// Handles user-initiated expand (click/focus).
  /// Matches Carbon's _handleUserInitiatedExpand implementation.
  Future<void> _handleExpand() async {
    if (_isExpanded) return;

    setState(() => _isExpanded = true);

    // Wait for widget to rebuild before focusing (matches Carbon's await this.updateComplete)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _inputFocusNode.requestFocus();
      }
    });
  }

  /// Handles focus out - collapse if no value and not persistent.
  void _handleFocusOut() {
    if (_controller.text.isEmpty && !widget.persistent) {
      setState(() => _isExpanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    Widget searchField = Container(
      constraints: const BoxConstraints(minHeight: 48),
      child: TextField(
        controller: _controller,
        focusNode: _inputFocusNode,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          isCollapsed: true,
          hintText: widget.placeholder,
          hintStyle: TextStyle(
            color: carbon.text.textPlaceholder,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            CarbonIcons.search,
            size: 16,
            color: carbon.text.iconPrimary,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    CarbonIcons.close,
                    size: 16,
                    color: carbon.text.iconPrimary,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                    _handleFocusOut();
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: carbon.layer.focus,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
          isDense: true,
        ),
        style: TextStyle(
          fontSize: 14,
          color: carbon.text.textPrimary,
        ),
      ),
    );

    // First check if collapsed (regardless of expanded property)
    if (!widget.persistent && !_isExpanded) {
      // Collapsed state - show only icon
      // Supports both click and keyboard focus (tab navigation)
      return Focus(
        focusNode: _iconFocusNode,
        child: InkWell(
          onTap: _handleExpand,
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: Icon(
              CarbonIcons.search,
              size: 16,
              color: carbon.text.iconPrimary,
            ),
          ),
        ),
      );
    }

    // Expanded state - decide layout based on expanded property
    if (widget.expanded) {
      return Expanded(child: searchField);
    }

    return SizedBox(
      width: 300,
      child: searchField,
    );
  }
}
