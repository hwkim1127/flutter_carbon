import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Defines the localized labels and formatters for [CarbonPagination].
///
/// Use this class to translate the pagination text or customize the
/// formatting of item ranges.
class CarbonPaginationLabels {
  /// Label for the page size selector (e.g., "Items per page:").
  final String itemsPerPage;

  /// Function to format the items range text.
  ///
  /// [start] - Index of the first item on the page.
  /// [end] - Index of the last item on the page.
  /// [total] - Total number of items.
  ///
  /// Example return: "1–10 of 100"
  final String Function(int start, int end, int total) itemsRange;

  /// Function to format the page progress text.
  ///
  /// [current] - The current page number.
  /// [total] - The total number of pages.
  ///
  /// Example return: "1 of 10 pages"
  final String Function(int current, int total) pageRange;

  /// Tooltip label for the "Previous Page" button (for accessibility).
  final String? previousPageLabel;

  /// Tooltip label for the "Next Page" button (for accessibility).
  final String? nextPageLabel;

  const CarbonPaginationLabels({
    this.itemsPerPage = 'Items per page:',
    required this.itemsRange,
    required this.pageRange,
    this.previousPageLabel = 'Prev',
    this.nextPageLabel = 'Next',
  });

  /// Default English labels
  factory CarbonPaginationLabels.en() => CarbonPaginationLabels(
        itemsRange: (start, end, total) => '$start–$end of $total',
        pageRange: (current, total) => '$current of $total pages',
      );
}

/// Carbon Design System pagination.
///
/// Allows users to navigate through pages of data.
///
/// Example:
/// ```dart
/// CarbonPagination(
///   currentPage: 1,
///   totalPages: 10,
///   onPageChanged: (page) => setState(() => currentPage = page),
/// )
/// ```
/// ///
/// Localized Example:
/// ```dart
/// CarbonPagination(
///   currentPage: current,
///   totalPages: 10,
///   // Provide custom labels
///   labels: CarbonPaginationLabels(
///     itemsPerPage: '페이지당 항목:',
///     itemsRange: (start, end, total) => '전체 $total개 중 $start–$end',
///     pageRange: (current, total) => '$total페이지 중 $current페이지',
///     previousPageLabel: '이전',
///     nextPageLabel: '다음',
///   ),
///   onPageChanged: (page) { ... },
/// )
/// ```
class CarbonPagination extends StatelessWidget {
  /// The current page number (1-indexed).
  final int currentPage;

  /// The total number of pages.
  final int totalPages;

  /// Called when the page is changed.
  final ValueChanged<int>? onPageChanged;

  /// Number of items per page.
  final int itemsPerPage;

  /// Total number of items.
  final int totalItems;

  /// Whether to show page size selector.
  final bool showPageSizeSelector;

  /// Available page sizes.
  final List<int> pageSizes;

  /// Called when page size changes.
  final ValueChanged<int>? onPageSizeChanged;

  /// Localization labels.
  ///
  /// If null, defaults to [CarbonPaginationLabels.en].
  final CarbonPaginationLabels? labels;

  const CarbonPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPageChanged,
    this.itemsPerPage = 10,
    this.totalItems = 0,
    this.showPageSizeSelector = false,
    this.pageSizes = const [10, 20, 30, 40, 50],
    this.onPageSizeChanged,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    // Use provided labels or fallback to English defaults.
    final effectiveLabels = labels ?? CarbonPaginationLabels.en();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: carbon.layer.borderSubtle01, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Items info (e.g., "1-10 of 100")
          Flexible(
            child: Text(
              _getItemsText(effectiveLabels),
              style: TextStyle(color: carbon.text.textSecondary, fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // Navigation controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showPageSizeSelector) ...[
                _PageSizeSelector(
                  label: effectiveLabels.itemsPerPage,
                  currentSize: itemsPerPage,
                  sizes: pageSizes,
                  onChanged: onPageSizeChanged,
                ),
                const SizedBox(width: 16),
              ],
              Text(
                effectiveLabels.pageRange(currentPage, totalPages),
                style: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: effectiveLabels.previousPageLabel,
                onPressed: currentPage > 1
                    ? () => onPageChanged?.call(currentPage - 1)
                    : null,
                icon: Icon(
                  Icons.chevron_left,
                  color: currentPage > 1
                      ? carbon.text.iconPrimary
                      : carbon.text.iconDisabled,
                ),
                iconSize: 20,
              ),
              IconButton(
                tooltip: effectiveLabels.nextPageLabel,
                onPressed: currentPage < totalPages
                    ? () => onPageChanged?.call(currentPage + 1)
                    : null,
                icon: Icon(
                  Icons.chevron_right,
                  color: currentPage < totalPages
                      ? carbon.text.iconPrimary
                      : carbon.text.iconDisabled,
                ),
                iconSize: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getItemsText(CarbonPaginationLabels labels) {
    if (totalItems == 0) {
      return labels.itemsRange(0, 0, 0);
    }
    final start = (currentPage - 1) * itemsPerPage + 1;
    final end = (currentPage * itemsPerPage).clamp(0, totalItems);
    return labels.itemsRange(start, end, totalItems);
  }
}

/// Internal page size selector widget.
class _PageSizeSelector extends StatelessWidget {
  final String label;
  final int currentSize;
  final List<int> sizes;
  final ValueChanged<int>? onChanged;

  const _PageSizeSelector({
    required this.label,
    required this.currentSize,
    required this.sizes,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(color: carbon.text.textSecondary, fontSize: 14),
        ),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: currentSize,
          onChanged: onChanged == null
              ? null
              : (int? value) {
                  if (value != null) onChanged!(value);
                },
          underline: const SizedBox.shrink(),
          icon: Icon(Icons.arrow_drop_down, color: carbon.text.iconPrimary),
          style: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
          items: sizes.map((size) {
            return DropdownMenuItem<int>(
              value: size,
              child: Text(size.toString()),
            );
          }).toList(),
        ),
      ],
    );
  }
}
