# Migration Guide: CarbonDataTable v1.1.0

This guide helps migrate existing CarbonDataTable implementations to v1.1.0, which includes significant architectural improvements and new features.

## Breaking Changes

### 1. Headers Now Require `key` Property

**Before v1.1.0:**
```dart
CarbonDataTable(
  headers: [
    CarbonDataTableHeader(label: 'Name'),
    CarbonDataTableHeader(label: 'Status'),
  ],
  rows: [...],
)
```

**v1.1.0 and later:**
```dart
CarbonDataTable(
  headers: [
    CarbonDataTableHeader(key: 'name', label: 'Name'),
    CarbonDataTableHeader(key: 'status', label: 'Status'),
  ],
  rows: [...],
)
```

**Migration Steps:**
1. Add unique `key` property to each `CarbonDataTableHeader`
2. Keys should be lowercase, descriptive identifiers (e.g., 'name', 'email', 'created_at')
3. Keys are used for sorting and column identification

### 2. Table-Level Feature Configuration

The architecture now uses table-level configuration instead of computing features from row data.

**Before v1.1.0 (conceptual):**
```dart
// Features were computed from rows
CarbonDataTable(
  rows: [
    CarbonDataTableRow(
      expandedContent: someWidget, // This made table expandable
      cells: [...],
    ),
  ],
)
```

**v1.1.0 and later:**
```dart
CarbonDataTable(
  hasExpandableRows: true, // Explicit table-level config
  rows: [
    CarbonDataTableRow(
      expandedContent: someWidget,
      cells: [...],
    ),
  ],
)
```

**Migration Steps:**
1. Add `hasExpandableRows: true` if any rows have `expandedContent`
2. Add `hasSelectableRows: true` if you want row selection
3. These flags enable the feature for the entire table

### 3. Assertions for Feature Consistency

v1.1.0 adds strict assertions to catch API misuse:

```dart
// This will throw an assertion error:
CarbonDataTable(
  hasExpandableRows: false,
  rows: [
    CarbonDataTableRow(
      expandedContent: someWidget, // Error! Can't have expandedContent when hasExpandableRows is false
      cells: [...],
    ),
  ],
)
```

**Migration Steps:**
1. Ensure `hasExpandableRows: true` if ANY row has `expandedContent`
2. Ensure `hasSelectableRows: true` if you provide `onSelectChanged` callbacks
3. Set `radio: true` if you want single-selection mode (disables `batchSelection`)

## New Features and How to Adopt Them

### 1. Size Variants

Control table density with four size options:

```dart
CarbonDataTable(
  size: CarbonDataTableSize.compact, // tall, medium, short, compact
  headers: [...],
  rows: [...],
)
```

**Default:** `CarbonDataTableSize.tall`

**Migration:** Add `size` parameter to make tables more compact if needed.

### 2. Row Selection (Checkbox Mode)

```dart
CarbonDataTable(
  hasSelectableRows: true,
  headers: [...],
  rows: [
    CarbonDataTableRow(
      id: '1',
      selected: selectedIds.contains('1'),
      onSelectChanged: (selected) {
        setState(() {
          if (selected) {
            selectedIds.add('1');
          } else {
            selectedIds.remove('1');
          }
        });
      },
      cells: [...],
    ),
  ],
)
```

**Migration Steps:**
1. Set `hasSelectableRows: true` at table level
2. Add unique `id` to each row
3. Add `selected` boolean based on your state
4. Add `onSelectChanged` callback to handle selection changes
5. Manage selected IDs in your state (typically a `Set<String>`)

### 3. Radio Mode (Single Selection)

```dart
CarbonDataTable(
  hasSelectableRows: true,
  radio: true,
  headers: [...],
  rows: [
    CarbonDataTableRow(
      id: '1',
      selected: selectedId == '1',
      onSelectChanged: (selected) {
        if (selected) setState(() => selectedId = '1');
      },
      cells: [...],
    ),
  ],
)
```

**Migration:** Change multi-select tables to single-select by adding `radio: true`.

### 4. Batch Selection (Select All)

```dart
CarbonDataTable(
  hasSelectableRows: true,
  batchSelection: true,
  allRowsSelected: selectedIds.length == totalRows && selectedIds.isNotEmpty,
  onSelectAllChanged: (selected) {
    setState(() {
      if (selected) {
        selectedIds.addAll(allRowIds);
      } else {
        selectedIds.clear();
      }
    });
  },
  headers: [...],
  rows: [...],
)
```

**Migration Steps:**
1. Set `batchSelection: true`
2. Implement `allRowsSelected` logic (check if all rows are selected)
3. Implement `onSelectAllChanged` callback
4. The header checkbox will automatically show indeterminate state when some (but not all) rows are selected

### 5. Sortable Columns

**Add sorting to specific columns:**
```dart
CarbonDataTable(
  sortable: true,
  sortKey: currentSortKey,
  sortDirection: currentSortDirection,
  onSortChanged: (key, direction) {
    setState(() {
      currentSortKey = key;
      currentSortDirection = direction;
      // Sort your data here
      rows.sort((a, b) {
        // Your sort logic
      });
    });
  },
  headers: [
    CarbonDataTableHeader(
      key: 'name',
      label: 'Name',
      sortable: true,
    ),
    CarbonDataTableHeader(
      key: 'status',
      label: 'Status',
      sortable: false, // Disable sorting for this column
    ),
  ],
  rows: [...],
)
```

**Migration Steps:**
1. Set `sortable: true` at table level to enable sorting
2. Add `sortKey` and `sortDirection` state variables
3. Implement `onSortChanged` callback with your sort logic
4. Mark individual headers as `sortable: true/false`
5. Sort direction cycles: none → ascending → descending → none

### 6. Zebra Stripes

```dart
CarbonDataTable(
  zebra: true,
  headers: [...],
  rows: [...],
)
```

**Migration:** Simply add `zebra: true` for alternating row colors.

### 7. Title and Description

```dart
CarbonDataTable(
  title: 'Load Balancers',
  description: 'Manage your load balancer instances',
  headers: [...],
  rows: [...],
)
```

**Migration:** Add `title` and/or `description` for table headers.

### 8. Custom Toolbar

```dart
CarbonDataTable(
  toolbar: CarbonToolbar(
    content: CarbonToolbarContent(
      children: [
        CarbonToolbarSearch(
          value: searchQuery,
          onChanged: (value) {
            setState(() => searchQuery = value);
            // Filter your data
          },
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: () {},
          icon: Icon(CarbonIcons.add, size: 16),
          label: const Text('Add'),
        ),
      ],
    ),
    batchActions: CarbonToolbarBatchActions(
      selectedCount: selectedIds.length,
      onCancel: () => setState(() => selectedIds.clear()),
      actions: [
        TextButton.icon(
          onPressed: () {
            // Bulk delete action
          },
          icon: Icon(CarbonIcons.trash_can, size: 16),
          label: const Text('Delete'),
        ),
      ],
    ),
    selectedCount: selectedIds.length,
  ),
  headers: [...],
  rows: [...],
)
```

**Migration Steps:**
1. Wrap search and action buttons in `CarbonToolbarContent`
2. Create `CarbonToolbarBatchActions` for bulk operations
3. Use `CarbonToolbar` to combine both and auto-switch based on `selectedCount`
4. Use `CarbonToolbarSearch` for styled search fields

### 9. Skeleton Loading State

```dart
CarbonDataTable(
  skeleton: isLoading,
  skeletonRowCount: 5, // Optional, defaults to 5
  headers: [...],
  rows: isLoading ? [] : actualRows,
)
```

**Migration:** Add `skeleton` boolean flag to show loading state.

## Complete Migration Example

**Before v1.1.0:**
```dart
CarbonDataTable(
  headers: [
    CarbonDataTableHeader(label: 'Name'),
    CarbonDataTableHeader(label: 'Status'),
  ],
  rows: [
    CarbonDataTableRow(
      cells: [
        CarbonDataTableCell(child: Text('Server 1')),
        CarbonDataTableCell(child: Text('Active')),
      ],
    ),
  ],
)
```

**After v1.1.0 (with new features):**
```dart
class MyTable extends StatefulWidget {
  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {
  Set<String> selectedIds = {};
  String? sortKey;
  CarbonDataTableSortDirection sortDirection = CarbonDataTableSortDirection.none;
  String searchQuery = '';
  bool isLoading = false;

  List<ServerData> servers = [...]; // Your data

  @override
  Widget build(BuildContext context) {
    final filteredServers = servers.where((s) =>
      s.name.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();

    return CarbonDataTable(
      // Table configuration
      size: CarbonDataTableSize.medium,
      zebra: true,
      skeleton: isLoading,

      // Title section
      title: 'Servers',
      description: 'Manage your server instances',

      // Toolbar with search and batch actions
      toolbar: CarbonToolbar(
        content: CarbonToolbarContent(
          children: [
            CarbonToolbarSearch(
              value: searchQuery,
              onChanged: (value) => setState(() => searchQuery = value),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _addServer,
              icon: Icon(CarbonIcons.add, size: 16),
              label: const Text('Add'),
            ),
          ],
        ),
        batchActions: CarbonToolbarBatchActions(
          selectedCount: selectedIds.length,
          onCancel: () => setState(() => selectedIds.clear()),
          actions: [
            TextButton.icon(
              onPressed: _deleteSelected,
              icon: Icon(CarbonIcons.trash_can, size: 16),
              label: const Text('Delete'),
            ),
          ],
        ),
        selectedCount: selectedIds.length,
      ),

      // Selection configuration
      hasSelectableRows: true,
      batchSelection: true,
      allRowsSelected: selectedIds.length == filteredServers.length && selectedIds.isNotEmpty,
      onSelectAllChanged: (selected) {
        setState(() {
          if (selected) {
            selectedIds.addAll(filteredServers.map((s) => s.id));
          } else {
            selectedIds.clear();
          }
        });
      },

      // Sorting configuration
      sortable: true,
      sortKey: sortKey,
      sortDirection: sortDirection,
      onSortChanged: (key, direction) {
        setState(() {
          sortKey = key;
          sortDirection = direction;
          if (direction != CarbonDataTableSortDirection.none) {
            filteredServers.sort((a, b) {
              final aValue = key == 'name' ? a.name : a.status;
              final bValue = key == 'name' ? b.name : b.status;
              final result = aValue.compareTo(bValue);
              return direction == CarbonDataTableSortDirection.ascending ? result : -result;
            });
          }
        });
      },

      // Headers with keys
      headers: [
        CarbonDataTableHeader(
          key: 'name',
          label: 'Name',
          sortable: true,
        ),
        CarbonDataTableHeader(
          key: 'status',
          label: 'Status',
          sortable: true,
        ),
      ],

      // Rows with selection
      rows: filteredServers.map((server) {
        return CarbonDataTableRow(
          id: server.id,
          selected: selectedIds.contains(server.id),
          onSelectChanged: (selected) {
            setState(() {
              if (selected) {
                selectedIds.add(server.id);
              } else {
                selectedIds.remove(server.id);
              }
            });
          },
          cells: [
            CarbonDataTableCell(child: Text(server.name)),
            CarbonDataTableCell(child: Text(server.status)),
          ],
        );
      }).toList(),
    );
  }
}
```

## Quick Reference Checklist

When migrating to v1.1.0, ensure:

- [ ] All headers have unique `key` properties
- [ ] `hasExpandableRows: true` if any row has `expandedContent`
- [ ] `hasSelectableRows: true` if using row selection
- [ ] Each selectable row has unique `id`, `selected`, and `onSelectChanged`
- [ ] Use `Set<String>` to manage selected IDs in state
- [ ] Implement `onSelectAllChanged` if using `batchSelection: true`
- [ ] Set `sortable: true` on table and individual headers for sorting
- [ ] Implement `onSortChanged` callback with sort logic
- [ ] Use `CarbonToolbar`, `CarbonToolbarContent`, `CarbonToolbarBatchActions` for toolbar
- [ ] Add `skeleton: isLoading` for loading states
- [ ] Consider using `zebra: true` for better visual separation
- [ ] Choose appropriate `size` for table density

## Need Help?

Check the comprehensive example in `example/lib/pages/data_table_demo_page.dart` for working code samples of all features.
