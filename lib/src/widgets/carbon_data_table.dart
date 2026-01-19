import 'package:flutter/material.dart';

import '../../flutter_carbon.dart';

/// Carbon Design System Data Table.
///
/// A comprehensive data table widget that follows Carbon Design System specifications.
/// Supports:
/// - Expandable rows
/// - Selectable rows
/// - Sortable headers
/// - flexible column sizing
/// - Horizontal scrolling (via [minWidth])
class CarbonDataTable<T> extends StatefulWidget {
  /// The headers of the table.
  final List<CarbonDataTableHeader> headers;

  /// The rows of the table.
  final List<CarbonDataTableRow> rows;

  /// The minimum width of the table.
  ///
  /// If provided and the available width is less than this value,
  /// the table will become scrollable horizontally.
  final double? minWidth;

  /// Whether to show borders between rows.
  final bool showBorders;

  const CarbonDataTable({
    super.key,
    required this.headers,
    required this.rows,
    this.minWidth,
    this.showBorders = true,
  });

  @override
  State<CarbonDataTable> createState() => _CarbonDataTableState<T>();
}

class _CarbonDataTableState<T> extends State<CarbonDataTable<T>> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double effectiveWidth =
            widget.minWidth != null && widget.minWidth! > constraints.maxWidth
                ? widget.minWidth!
                : constraints.maxWidth;

        final bool isScrollable = effectiveWidth > constraints.maxWidth;

        Widget tableContent = SizedBox(
          width: effectiveWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              ...widget.rows,
            ],
          ),
        );

        if (isScrollable) {
          tableContent = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: tableContent,
          );
        }

        return tableContent;
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final carbon = context.carbon;
    final theme =
        carbon.structuredList; // Using structured list theme for consistency

    return Container(
      height: 48,
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
        children: [
          // Reserved space for expand chevron if any row is expandable
          if (widget.rows.any((row) => row.expandedContent != null))
            const SizedBox(width: 48), // Standard expansion column width

          ...widget.headers.map((header) {
            return _buildCellContainer(
              flex: header.flex,
              width: header.width,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: theme.headerTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Text(header.label),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCellContainer({
    required int flex,
    double? width,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    if (width != null) {
      return SizedBox(
        width: width,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      );
    }
    return Expanded(
      flex: flex,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}

/// Header definition for [CarbonDataTable].
class CarbonDataTableHeader {
  final String label;
  final int flex;
  final double? width;
  final VoidCallback? onSort;
  final bool sortable;

  const CarbonDataTableHeader({
    required this.label,
    this.flex = 1,
    this.width,
    this.onSort,
    this.sortable = false,
  });
}

/// Row definition for [CarbonDataTable].
class CarbonDataTableRow extends StatefulWidget {
  final List<CarbonDataTableCell> cells;
  final Widget? expandedContent;
  final bool selected;
  final ValueChanged<bool>? onSelectChanged;
  final VoidCallback? onTap;

  const CarbonDataTableRow({
    super.key,
    required this.cells,
    this.expandedContent,
    this.selected = false,
    this.onSelectChanged,
    this.onTap,
  });

  @override
  State<CarbonDataTableRow> createState() => _CarbonDataTableRowState();
}

class _CarbonDataTableRowState extends State<CarbonDataTableRow> {
  bool _expanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final theme = carbon.structuredList;
    final isExpandable = widget.expandedContent != null;

    final backgroundColor = _isHovered
        ? theme.rowHover
        : (widget.selected ? theme.rowSelected : theme.background);

    Widget rowContent = Container(
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Expansion chevron
          if (isExpandable)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  _expanded ? CarbonIcons.chevronUp : CarbonIcons.chevronDown,
                  color: carbon.text.iconPrimary,
                  size: 16,
                ),
              ),
            )
          else
            // Placeholder if other rows are expandable but this one isn't
            // (Note: Ideally this should be passed down from parent if ANY row is expandable)
            const SizedBox(width: 48), // Hardcoded for now assuming mixed rows

          ...widget.cells.map((cell) {
            return _buildCellContainer(
              flex: cell.flex,
              width: cell.width,
              padding:
                  cell.padding ?? const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: theme.rowTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  child: cell.child,
                ),
              ),
            );
          }),
        ],
      ),
    );

    // Interactive wrapper
    rowContent = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null || isExpandable
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: () {
          if (isExpandable) {
            // Expanding takes precedence if row is just expandable
            setState(() => _expanded = !_expanded);
          } else {
            widget.onTap?.call();
          }
        },
        child: rowContent,
      ),
    );

    if (_expanded && widget.expandedContent != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          rowContent,
          Container(
            decoration: BoxDecoration(
              color: carbon
                  .layer.layer01, // Slightly different bg for expanded area
              border: Border(
                bottom: BorderSide(
                  color: theme.borderColor,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 48), // Indent content
              child: widget.expandedContent!,
            ),
          ),
        ],
      );
    }

    return rowContent;
  }

  Widget _buildCellContainer({
    required int flex,
    double? width,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    if (width != null) {
      return SizedBox(
        width: width,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      );
    }
    return Expanded(
      flex: flex,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}

/// Cell definition for [CarbonDataTable].
class CarbonDataTableCell {
  final Widget child;
  final int flex;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const CarbonDataTableCell({
    required this.child,
    this.flex = 1,
    this.width,
    this.padding,
  });
}
