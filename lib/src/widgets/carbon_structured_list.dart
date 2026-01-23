import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Size variants for [CarbonStructuredList].
enum CarbonStructuredListSize {
  /// Regular size (default).
  normal,

  /// Condensed size for compact layouts.
  condensed,
}

/// Carbon Design System structured list (table-like list with rows/columns).
///
/// A structured list that follows Carbon Design System specifications with:
/// - Table-like layout with rows and columns
/// - Optional header row
/// - Hover and selection states
/// - Sharp corners (zero border radius)
/// - Normal and condensed sizes
///
/// Example:
/// ```dart
/// CarbonStructuredList(
///   size: CarbonStructuredListSize.condensed,
///   headers: [
///     CarbonStructuredListHeader(label: 'Name'),
///     CarbonStructuredListHeader(label: 'Status'),
///     CarbonStructuredListHeader(label: 'Date'),
///   ],
///   rows: [
///     CarbonStructuredListRow(cells: [
///       CarbonStructuredListCell(child: Text('Item 1')),
///       CarbonStructuredListCell(child: Text('Active')),
///       CarbonStructuredListCell(child: Text('2024-01-01')),
///     ]),
///   ],
/// )
/// ```
class CarbonStructuredList extends StatefulWidget {
  /// Optional header row.
  final List<CarbonStructuredListHeader>? headers;

  /// The list rows.
  final List<CarbonStructuredListRow> rows;

  /// Whether to show borders between rows.
  final bool showBorders;

  /// Whether rows are selectable.
  final bool selectable;

  /// Index of currently selected row.
  final int? selectedIndex;

  /// Called when a row is selected.
  final ValueChanged<int>? onRowSelected;

  /// The size of the rows (normal or condensed).
  final CarbonStructuredListSize size;

  const CarbonStructuredList({
    super.key,
    this.headers,
    required this.rows,
    this.showBorders = true,
    this.selectable = false,
    this.selectedIndex,
    this.onRowSelected,
    this.size = CarbonStructuredListSize.normal,
  });

  @override
  State<CarbonStructuredList> createState() => _CarbonStructuredListState();
}

class _CarbonStructuredListState extends State<CarbonStructuredList> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final theme = carbon.structuredList;

    // Calculate padding based on size
    final verticalPadding =
        widget.size == CarbonStructuredListSize.normal ? 16.0 : 8.0;
    final padding =
        EdgeInsets.symmetric(horizontal: 16.0, vertical: verticalPadding);

    return Container(
      decoration: BoxDecoration(
        color: theme.background,
        border: widget.showBorders
            ? Border.all(color: theme.borderColor, width: 1)
            : null,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          if (widget.headers != null && widget.headers!.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: theme.headerBackground,
                border: widget.showBorders
                    ? Border(
                        bottom: BorderSide(
                          color: theme.headerBorderColor,
                          width: 2,
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: widget.headers!.map((header) {
                  return Expanded(
                    flex: header.flex,
                    child: Padding(
                      padding: padding,
                      child: Row(
                        mainAxisAlignment: header.mainAxisAlignment,
                        crossAxisAlignment: header.crossAxisAlignment,
                        children: [
                          DefaultTextStyle(
                            style: TextStyle(
                              color: theme.headerTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            child: header.child ?? Text(header.label ?? ''),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Data rows
          ...List.generate(widget.rows.length, (index) {
            final row = widget.rows[index];
            final isSelected = widget.selectedIndex == index;
            final isHovered = _hoveredIndex == index;

            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = index),
              onExit: (_) => setState(() => _hoveredIndex = null),
              child: InkWell(
                onTap: widget.selectable && widget.onRowSelected != null
                    ? () => widget.onRowSelected!(index)
                    : null,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.rowSelected
                        : (isHovered ? theme.rowHover : null),
                    border: widget.showBorders && index < widget.rows.length - 1
                        ? Border(
                            bottom: BorderSide(
                              color: theme.borderColor,
                              width: 1,
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    children: row.cells.map((cell) {
                      return Expanded(
                        flex: cell.flex,
                        child: Padding(
                          padding: padding,
                          child: Row(
                            mainAxisAlignment: cell.mainAxisAlignment,
                            crossAxisAlignment: cell.crossAxisAlignment,
                            children: [
                              DefaultTextStyle(
                                style: TextStyle(
                                  color: theme.rowTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                child: cell.child,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Header cell for a [CarbonStructuredList].
class CarbonStructuredListHeader {
  /// The label text for the header.
  final String? label;

  /// Custom widget for the header (overrides label).
  final Widget? child;

  /// Flex value for column width.
  /// Width flex factor.
  final int flex;

  /// Alignment of content along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Alignment of content along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  const CarbonStructuredListHeader({
    this.label,
    this.child,
    this.flex = 1,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : assert(label != null || child != null,
            'Either label or child must be provided');
}

/// A row in a [CarbonStructuredList].
class CarbonStructuredListRow {
  /// The cells in this row.
  final List<CarbonStructuredListCell> cells;

  /// Optional data associated with this row.
  final dynamic data;

  const CarbonStructuredListRow({
    required this.cells,
    this.data,
  });
}

/// A cell in a [CarbonStructuredListRow].
class CarbonStructuredListCell {
  /// The widget to display in the cell.
  final Widget child;

  /// Flex value for cell width.
  /// Flex value for cell width.
  final int flex;

  /// Alignment of content along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Alignment of content along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  const CarbonStructuredListCell({
    required this.child,
    this.flex = 1,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });
}
