import 'package:flutter/material.dart';

import '../../flutter_carbon.dart';

/// Sort direction for [CarbonDataTable] columns.
enum CarbonDataTableSortDirection {
  /// No sorting applied.
  none,

  /// Ascending order (A-Z, 0-9).
  ascending,

  /// Descending order (Z-A, 9-0).
  descending;

  /// Returns the next sort direction in the cycle: none → ascending → descending → ascending...
  CarbonDataTableSortDirection get next {
    switch (this) {
      case CarbonDataTableSortDirection.none:
        return CarbonDataTableSortDirection.ascending;
      case CarbonDataTableSortDirection.ascending:
        return CarbonDataTableSortDirection.descending;
      case CarbonDataTableSortDirection.descending:
        return CarbonDataTableSortDirection.ascending;
    }
  }
}

/// Size variants for [CarbonDataTable].
enum CarbonDataTableSize {
  /// Tall rows with 64px height.
  tall,

  /// Medium (default) rows with 48px height.
  medium,

  /// Short rows with 40px height.
  short,

  /// Compact rows with 32px height.
  compact;

  /// Returns the row height in pixels for this size.
  double get rowHeight {
    switch (this) {
      case CarbonDataTableSize.tall:
        return 64;
      case CarbonDataTableSize.medium:
        return 48;
      case CarbonDataTableSize.short:
        return 40;
      case CarbonDataTableSize.compact:
        return 32;
    }
  }

  /// Returns the header height in pixels for this size.
  double get headerHeight {
    switch (this) {
      case CarbonDataTableSize.tall:
        return 64;
      case CarbonDataTableSize.medium:
        return 48;
      case CarbonDataTableSize.short:
        return 48;
      case CarbonDataTableSize.compact:
        return 48;
    }
  }
}

/// Carbon Design System Data Table.
///
/// A comprehensive data table widget that follows Carbon Design System specifications.
/// Supports:
/// - Expandable rows
/// - Selectable rows
/// - Sortable headers
/// - Sticky headers
/// - Flexible column sizing
/// - Horizontal scrolling (via [minWidth])
///
/// Following Carbon Design System principles, table-level features (expandable,
/// selectable, sticky header) are configured at the table level and processed
/// efficiently without iterating through rows multiple times.
class CarbonDataTable extends StatefulWidget {
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

  /// Whether the table has expandable rows.
  ///
  /// When true, reserves space for expansion chevrons in the first column.
  /// This should be set at the table level rather than computed from row data.
  final bool hasExpandableRows;

  /// Whether the table has selectable rows.
  ///
  /// When true, reserves space for checkboxes (or radio buttons if [radio] is true)
  /// in the first column.
  final bool hasSelectableRows;

  /// Whether to use radio buttons for single-row selection.
  ///
  /// When true, only one row can be selected at a time using radio buttons.
  /// Requires [hasSelectableRows] to be true.
  /// When false (default), uses checkboxes for multi-row selection.
  ///
  /// In radio mode:
  /// - At most one row should have [CarbonDataTableRow.selected] = true
  /// - When a row's [CarbonDataTableRow.onSelectChanged] is called with true,
  ///   the parent must update all other rows to set their selected to false
  /// - Radio buttons are not shown in the header (no "select all" option)
  final bool radio;

  /// Whether to show a "select all" checkbox in the header.
  ///
  /// When true, adds a checkbox in the header that:
  /// - Selects all rows when checked
  /// - Deselects all rows when unchecked
  /// - Shows indeterminate state when some (but not all) rows are selected
  ///
  /// Requires [hasSelectableRows] to be true and [radio] to be false.
  /// Use [onSelectAll] callback to handle select all/deselect all actions.
  final bool batchSelection;

  /// Callback when the "select all" checkbox in the header is toggled.
  ///
  /// Called with `true` when selecting all rows, `false` when deselecting all.
  /// Only used when [batchSelection] is true.
  ///
  /// The parent is responsible for updating all rows' selected states.
  final ValueChanged<bool>? onSelectAll;

  /// Whether the header should stick to the top when scrolling.
  final bool stickyHeader;

  /// The size variant for row and header heights.
  ///
  /// Controls the density of the table:
  /// - [CarbonDataTableSize.tall]: 64px rows
  /// - [CarbonDataTableSize.medium]: 48px rows (default)
  /// - [CarbonDataTableSize.short]: 40px rows
  /// - [CarbonDataTableSize.compact]: 32px rows
  final CarbonDataTableSize size;

  /// Whether the table supports sortable columns.
  ///
  /// When true, headers with [CarbonDataTableHeader.sortable] = true will
  /// show sort indicators and respond to clicks.
  final bool sortable;

  /// The key of the currently sorted column.
  ///
  /// Must match a [CarbonDataTableHeader] key. Only used when [sortable] is true.
  /// Use with [sortDirection] to control programmatic sorting.
  final String? sortKey;

  /// The current sort direction.
  ///
  /// Only used when [sortable] is true and [sortKey] is set.
  final CarbonDataTableSortDirection sortDirection;

  /// Callback when a sortable header is clicked.
  ///
  /// Called with the header key and new sort direction.
  /// The parent is responsible for:
  /// 1. Updating [sortKey] and [sortDirection]
  /// 2. Sorting the [rows] data
  /// 3. Rebuilding the table with sorted data
  final void Function(String key, CarbonDataTableSortDirection direction)?
      onSort;

  /// Whether to apply zebra striping to rows.
  ///
  /// When true, alternates row background colors for better visual separation.
  /// Odd rows use the default background, even rows use a slightly darker shade.
  final bool zebra;

  /// Optional title displayed above the table.
  ///
  /// Typically used to identify what data the table contains.
  final String? title;

  /// Optional description displayed below the title.
  ///
  /// Provides additional context about the table data.
  final String? description;

  /// Optional toolbar widget displayed above the table.
  ///
  /// Use this to add search, filters, actions, or other controls.
  /// The toolbar appears below the title/description if they are provided.
  ///
  /// Common toolbar patterns:
  /// - Search field
  /// - Filter controls
  /// - Action buttons (Add, Export, etc.)
  /// - Batch action buttons (shown when rows are selected)
  final Widget? toolbar;

  /// Whether to show skeleton loading state.
  ///
  /// When true, displays animated skeleton placeholders instead of actual data.
  /// Use this while data is being fetched.
  final bool skeleton;

  /// Number of skeleton rows to show when [skeleton] is true.
  ///
  /// Defaults to 5 rows.
  final int skeletonRowCount;

  CarbonDataTable({
    super.key,
    required this.headers,
    required this.rows,
    this.minWidth,
    this.showBorders = true,
    this.hasExpandableRows = false,
    this.hasSelectableRows = false,
    this.radio = false,
    this.batchSelection = false,
    this.onSelectAll,
    this.stickyHeader = false,
    this.size = CarbonDataTableSize.medium,
    this.sortable = false,
    this.sortKey,
    this.sortDirection = CarbonDataTableSortDirection.none,
    this.onSort,
    this.zebra = false,
    this.title,
    this.description,
    this.toolbar,
    this.skeleton = false,
    this.skeletonRowCount = 5,
  })  : assert(
          hasExpandableRows || !rows.any((row) => row.expandedContent != null),
          'Cannot have rows with expandedContent when hasExpandableRows is false. '
          'Set hasExpandableRows: true on CarbonDataTable to enable expandable rows.',
        ),
        assert(
          hasSelectableRows ||
              !rows.any((row) => row.selected || row.onSelectChanged != null),
          'Cannot have rows with selected or onSelectChanged when hasSelectableRows is false. '
          'Set hasSelectableRows: true on CarbonDataTable to enable selectable rows.',
        ),
        assert(
          !radio || hasSelectableRows,
          'Cannot use radio mode when hasSelectableRows is false. '
          'Set hasSelectableRows: true on CarbonDataTable to enable radio selection.',
        ),
        assert(
          !radio || rows.where((row) => row.selected).length <= 1,
          'In radio mode, at most one row can be selected. '
          'Found ${rows.where((row) => row.selected).length} selected rows.',
        ),
        assert(
          !batchSelection || hasSelectableRows,
          'Cannot use batchSelection when hasSelectableRows is false. '
          'Set hasSelectableRows: true on CarbonDataTable to enable batch selection.',
        ),
        assert(
          !batchSelection || !radio,
          'Cannot use batchSelection in radio mode. '
          'Batch selection is only available for checkbox selection (radio: false).',
        );

  @override
  State<CarbonDataTable> createState() => _CarbonDataTableState();
}

class _CarbonDataTableState extends State<CarbonDataTable> {
  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    // Show skeleton state
    if (widget.skeleton) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Skeleton title and description
          if (widget.title != null || widget.description != null)
            _buildSkeletonTitleSection(context),

          // Skeleton toolbar (if toolbar is provided)
          if (widget.toolbar != null) _buildSkeletonToolbar(context),

          // Skeleton table
          _buildSkeletonTable(context),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title and description
        if (widget.title != null || widget.description != null)
          _buildTitleSection(context, carbon),

        // Toolbar
        if (widget.toolbar != null) widget.toolbar!,

        // Data table
        _buildTable(context),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context, CarbonThemeData carbon) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            Text(
              widget.title!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: carbon.text.textPrimary,
                height: 1.4,
              ),
            ),
          if (widget.description != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.description!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: carbon.text.textSecondary,
                height: 1.43,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double effectiveWidth =
            widget.minWidth != null && widget.minWidth! > constraints.maxWidth
                ? widget.minWidth!
                : constraints.maxWidth;

        final bool isScrollable = effectiveWidth > constraints.maxWidth;

        // Wrap in inherited widget to pass table configuration down efficiently
        Widget tableContent = _CarbonDataTableConfig(
          hasExpandableRows: widget.hasExpandableRows,
          hasSelectableRows: widget.hasSelectableRows,
          radio: widget.radio,
          batchSelection: widget.batchSelection,
          showBorders: widget.showBorders,
          size: widget.size,
          zebra: widget.zebra,
          headers: widget.headers,
          child: SizedBox(
            width: effectiveWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                // Build rows with zebra striping indices
                for (int i = 0; i < widget.rows.length; i++)
                  _ZebraRow(
                    index: i,
                    child: widget.rows[i],
                  ),
              ],
            ),
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

    // Calculate selection state for batch selection
    int selectedCount = 0;
    int selectableCount = 0;
    if (widget.batchSelection) {
      for (final row in widget.rows) {
        if (row.onSelectChanged != null) {
          selectableCount++;
          if (row.selected) {
            selectedCount++;
          }
        }
      }
    }

    final bool allSelected =
        selectableCount > 0 && selectedCount == selectableCount;
    final bool someSelected =
        selectedCount > 0 && selectedCount < selectableCount;

    return Container(
      height: widget.size.headerHeight,
      decoration: BoxDecoration(
        color: carbon.layer.layerAccent01,
        border: widget.showBorders
            ? Border(
                bottom: BorderSide(
                  color: carbon.layer.borderSubtle01,
                  width: 2,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          // Batch selection checkbox in header
          if (widget.hasSelectableRows &&
              widget.batchSelection &&
              !widget.radio)
            GestureDetector(
              onTap: widget.onSelectAll != null
                  ? () => widget.onSelectAll!(!allSelected)
                  : null,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 48,
                height: widget.size.headerHeight,
                child: Center(
                  child: Checkbox(
                    value: someSelected ? null : allSelected,
                    tristate: true,
                    onChanged: widget.onSelectAll != null
                        ? (value) {
                            // If fully selected, deselect all. Otherwise, select all.
                            widget.onSelectAll!(!allSelected);
                          }
                        : null,
                  ),
                ),
              ),
            )
          else if (widget.hasSelectableRows)
            // Reserved space for selection checkbox if not using batch selection
            const SizedBox(width: 48),

          // Reserved space for expand chevron
          if (widget.hasExpandableRows) const SizedBox(width: 48),

          // Build header cells efficiently
          for (final header in widget.headers) _buildHeaderCell(header, carbon),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
      CarbonDataTableHeader header, CarbonThemeData carbon) {
    final bool isSortable = widget.sortable && header.sortable;
    final bool isSorted = widget.sortKey == header.key;
    final sortDirection =
        isSorted ? widget.sortDirection : CarbonDataTableSortDirection.none;

    Widget headerContent = Row(
      mainAxisAlignment: header.mainAxisAlignment,
      crossAxisAlignment: header.crossAxisAlignment,
      children: [
        Flexible(
          child: DefaultTextStyle(
            style: TextStyle(
              color: carbon.text.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            child: header.child ?? Text(header.label ?? ''),
          ),
        ),
        // Sort indicator
        if (isSortable) ...[
          const SizedBox(width: 8),
          _SortIndicator(
            direction: sortDirection,
            color: carbon.text.textPrimary,
          ),
        ],
      ],
    );

    Widget cell = _buildCellContainer(
      flex: header.flex,
      width: header.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: headerContent,
    );

    // Make header clickable if sortable
    if (isSortable && widget.onSort != null) {
      cell = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            final newDirection = isSorted
                ? sortDirection.next
                : CarbonDataTableSortDirection.ascending;
            widget.onSort!(header.key, newDirection);
          },
          behavior: HitTestBehavior.opaque,
          child: cell,
        ),
      );
    }

    return cell;
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

  Widget _buildSkeletonTitleSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null)
            const CarbonSkeleton.rectangle(
              width: 200,
              height: 24,
            ),
          if (widget.description != null) ...[
            const SizedBox(height: 8),
            const CarbonSkeleton.rectangle(
              width: 300,
              height: 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkeletonToolbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Expanded(
            child: CarbonSkeleton.rectangle(
              height: 40,
            ),
          ),
          const SizedBox(width: 16),
          const CarbonSkeleton.rectangle(
            width: 100,
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonTable(BuildContext context) {
    final carbon = context.carbon;

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
              // Skeleton header
              Container(
                height: widget.size.headerHeight,
                decoration: BoxDecoration(
                  color: carbon.layer.layerAccent01,
                  border: widget.showBorders
                      ? Border(
                          bottom: BorderSide(
                            color: carbon.layer.borderSubtle01,
                            width: 2,
                          ),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    // Reserved space for selection/expansion
                    if (widget.hasSelectableRows) const SizedBox(width: 48),
                    if (widget.hasExpandableRows) const SizedBox(width: 48),

                    // Skeleton header cells
                    for (final header in widget.headers)
                      _buildCellContainer(
                        flex: header.flex,
                        width: header.width,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const CarbonSkeleton.rectangle(
                          width: 100,
                          height: 16,
                        ),
                      ),
                  ],
                ),
              ),

              // Skeleton rows
              for (int i = 0; i < widget.skeletonRowCount; i++)
                Container(
                  height: widget.size.rowHeight,
                  decoration: BoxDecoration(
                    color: widget.zebra && i.isEven
                        ? carbon.layer.layerAccent01
                        : carbon.layer.layer01,
                    border: Border(
                      bottom: BorderSide(
                        color: carbon.layer.borderSubtle01,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Reserved space for selection/expansion
                      if (widget.hasSelectableRows) const SizedBox(width: 48),
                      if (widget.hasExpandableRows) const SizedBox(width: 48),

                      // Skeleton cells
                      for (final header in widget.headers)
                        _buildCellContainer(
                          flex: header.flex,
                          width: header.width,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CarbonSkeleton.rectangle(
                            width: 80 + (i * 10).toDouble(),
                            height: 14,
                          ),
                        ),
                    ],
                  ),
                ),
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
}

/// Inherited widget to efficiently pass table configuration down to rows.
///
/// This avoids the need to copy rows or iterate through them multiple times
/// to determine table-level features.
class _CarbonDataTableConfig extends InheritedWidget {
  final bool hasExpandableRows;
  final bool hasSelectableRows;
  final bool radio;
  final bool batchSelection;
  final bool showBorders;
  final CarbonDataTableSize size;
  final bool zebra;
  final List<CarbonDataTableHeader> headers;

  const _CarbonDataTableConfig({
    required this.hasExpandableRows,
    required this.hasSelectableRows,
    required this.radio,
    required this.batchSelection,
    required this.showBorders,
    required this.size,
    required this.zebra,
    required this.headers,
    required super.child,
  });

  static _CarbonDataTableConfig? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CarbonDataTableConfig>();
  }

  static _CarbonDataTableConfig of(BuildContext context) {
    final config = maybeOf(context);
    assert(config != null, 'No _CarbonDataTableConfig found in context');
    return config!;
  }

  @override
  bool updateShouldNotify(_CarbonDataTableConfig oldWidget) {
    return hasExpandableRows != oldWidget.hasExpandableRows ||
        hasSelectableRows != oldWidget.hasSelectableRows ||
        radio != oldWidget.radio ||
        batchSelection != oldWidget.batchSelection ||
        showBorders != oldWidget.showBorders ||
        size != oldWidget.size ||
        zebra != oldWidget.zebra ||
        headers != oldWidget.headers;
  }
}

/// Wrapper widget that provides row index for zebra striping.
class _ZebraRow extends InheritedWidget {
  final int index;

  const _ZebraRow({
    required this.index,
    required super.child,
  });

  static _ZebraRow? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ZebraRow>();
  }

  @override
  bool updateShouldNotify(_ZebraRow oldWidget) {
    return index != oldWidget.index;
  }
}

/// Header definition for [CarbonDataTable].
class CarbonDataTableHeader {
  /// Unique key for this header column.
  ///
  /// Required for sorting and matching data to columns.
  final String key;

  /// Display label for the header.
  ///
  /// Use either [label] or [child], not both.
  final String? label;

  /// Custom widget for the header.
  ///
  /// Use either [label] or [child], not both.
  final Widget? child;

  /// Flex factor for column width when not using fixed [width].
  final int flex;

  /// Fixed width for the column in pixels.
  ///
  /// When set, the column will not flex and will use this exact width.
  final double? width;

  /// Whether this column is sortable.
  ///
  /// When true and the table has [CarbonDataTable.sortable] = true,
  /// the header will show a sort indicator and respond to clicks.
  /// Individual columns can disable sorting by setting this to false.
  final bool sortable;

  /// Horizontal alignment of header content.
  final MainAxisAlignment mainAxisAlignment;

  /// Vertical alignment of header content.
  final CrossAxisAlignment crossAxisAlignment;

  const CarbonDataTableHeader({
    required this.key,
    this.label,
    this.child,
    this.flex = 1,
    this.width,
    this.sortable = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  })  : assert(label != null || child != null,
            'Either label or child must be provided'),
        assert(label == null || child == null,
            'Cannot provide both label and child');
}

class CarbonDataTableRow extends StatefulWidget {
  final List<CarbonDataTableCell> cells;
  final Widget? expandedContent;
  final bool selected;

  /// Callback when the row selection state changes.
  ///
  /// In checkbox mode (default), this toggles the row's selection.
  /// In radio mode, this is called with `true` when the row is selected.
  /// The parent is responsible for deselecting other rows in radio mode.
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
    final config = _CarbonDataTableConfig.of(context);
    final zebraRow = _ZebraRow.maybeOf(context);
    final isExpandable = widget.expandedContent != null;

    // Determine background color with zebra striping support
    Color backgroundColor;
    if (_isHovered) {
      backgroundColor = carbon.layer.layerHover01;
    } else if (widget.selected) {
      backgroundColor = carbon.layer.layerSelected01;
    } else if (config.zebra && zebraRow != null && zebraRow.index.isEven) {
      // Even rows get accent background for zebra striping
      backgroundColor = carbon.layer.layerAccent01;
    } else {
      backgroundColor = carbon.layer.layer01;
    }

    // Build row children efficiently without using .map()
    final rowChildren = <Widget>[];

    // Selection checkbox or radio button
    if (config.hasSelectableRows) {
      if (config.radio) {
        // Radio button for single-row selection
        rowChildren.add(
          GestureDetector(
            onTap: widget.onSelectChanged != null && !widget.selected
                ? () => widget.onSelectChanged!(true)
                : null,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 48,
              height: config.size.rowHeight,
              child: Center(
                child: _CustomRadioButton(
                  selected: widget.selected,
                  enabled: widget.onSelectChanged != null,
                  color: carbon.text.textSecondary,
                ),
              ),
            ),
          ),
        );
      } else {
        // Checkbox for multi-row selection
        rowChildren.add(
          GestureDetector(
            onTap: widget.onSelectChanged != null
                ? () => widget.onSelectChanged!(!widget.selected)
                : null,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 48,
              height: config.size.rowHeight,
              child: Center(
                child: Checkbox(
                  value: widget.selected,
                  onChanged: widget.onSelectChanged != null
                      ? (value) => widget.onSelectChanged!(value ?? false)
                      : null,
                ),
              ),
            ),
          ),
        );
      }
    }

    // Expansion chevron or placeholder
    if (config.hasExpandableRows) {
      if (isExpandable) {
        rowChildren.add(
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 48,
              height: config.size.rowHeight,
              child: Center(
                child: Icon(
                  _expanded ? CarbonIcons.chevronUp : CarbonIcons.chevronDown,
                  color: carbon.text.iconPrimary,
                  size: 16,
                ),
              ),
            ),
          ),
        );
      } else {
        // Placeholder space if table has expandable rows but this row doesn't
        rowChildren.add(const SizedBox(width: 48));
      }
    }

    // Build cells efficiently with for loop instead of .map()
    for (final cell in widget.cells) {
      rowChildren.add(
        _buildCellContainer(
          flex: cell.flex,
          width: cell.width,
          padding: cell.padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: cell.mainAxisAlignment,
            crossAxisAlignment: cell.crossAxisAlignment,
            children: [
              DefaultTextStyle(
                style: TextStyle(
                  color: carbon.text.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                child: cell.child,
              ),
            ],
          ),
        ),
      );
    }

    Widget rowContent = Container(
      height: config.size.rowHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: carbon.layer.borderSubtle01,
            width: 1,
          ),
        ),
      ),
      child: Row(children: rowChildren),
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
              color: carbon.layer.layer01,
              border: Border(
                bottom: BorderSide(
                  color: carbon.layer.borderSubtle01,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: (config.hasSelectableRows ? 48.0 : 0.0) +
                    (config.hasExpandableRows ? 48.0 : 0.0),
              ),
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

/// Sort indicator widget showing ascending/descending arrows.
class _SortIndicator extends StatelessWidget {
  final CarbonDataTableSortDirection direction;
  final Color color;

  const _SortIndicator({
    required this.direction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == CarbonDataTableSortDirection.none) {
      // Show both arrows in inactive state
      return SizedBox(
        width: 16,
        height: 16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CarbonIcons.caretUp,
              size: 8,
              color: color.withValues(alpha: 0.3),
            ),
            Icon(
              CarbonIcons.caretDown,
              size: 8,
              color: color.withValues(alpha: 0.3),
            ),
          ],
        ),
      );
    }

    // Show active arrow
    return Icon(
      direction == CarbonDataTableSortDirection.ascending
          ? CarbonIcons.caretUp
          : CarbonIcons.caretDown,
      size: 16,
      color: color,
    );
  }
}

/// Custom radio button widget for single-row selection.
class _CustomRadioButton extends StatelessWidget {
  final bool selected;
  final bool enabled;
  final Color color;

  const _CustomRadioButton({
    required this.selected,
    required this.enabled,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = enabled ? color : color.withValues(alpha: 0.4);

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              selected ? effectiveColor : effectiveColor.withValues(alpha: 0.5),
          width: selected ? 2 : 1.5,
        ),
        color: selected ? Colors.transparent : Colors.transparent,
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: effectiveColor,
                ),
              ),
            )
          : null,
    );
  }
}

/// Cell definition for [CarbonDataTable].
class CarbonDataTableCell {
  final Widget child;
  final int flex;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const CarbonDataTableCell({
    required this.child,
    this.flex = 1,
    this.width,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });
}
