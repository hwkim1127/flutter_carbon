import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonDataTable functionality.
class DataTableDemoPage extends StatefulWidget {
  const DataTableDemoPage({super.key});

  @override
  State<DataTableDemoPage> createState() => _DataTableDemoPageState();
}

class _DataTableDemoPageState extends State<DataTableDemoPage> {
  // Basic table data
  final List<_LoadBalancer> _basicData = [
    _LoadBalancer('1', 'Load Balancer 1', 'HTTP', 443, 'Round robin', 'Active'),
    _LoadBalancer('2', 'Load Balancer 2', 'HTTPS', 80, 'DNS delegation', 'Inactive'),
    _LoadBalancer('3', 'Load Balancer 3', 'HTTP', 3000, 'Round robin', 'Active'),
    _LoadBalancer('4', 'Load Balancer 4', 'HTTP', 8080, 'Round robin', 'Active'),
  ];

  // Selection state
  final Set<String> _selectedIds = {};
  String? _selectedRadioId;

  // Sort state
  String? _sortKey;
  CarbonDataTableSortDirection _sortDirection = CarbonDataTableSortDirection.none;
  List<_LoadBalancer> _sortedData = [];

  // Search state
  String _searchQuery = '';

  // Loading state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sortedData = List.from(_basicData);
  }

  void _sort(String key, CarbonDataTableSortDirection direction) {
    setState(() {
      _sortKey = key;
      _sortDirection = direction;

      if (direction == CarbonDataTableSortDirection.none) {
        _sortedData = List.from(_basicData);
        return;
      }

      _sortedData.sort((a, b) {
        dynamic aValue, bValue;
        switch (key) {
          case 'name':
            aValue = a.name;
            bValue = b.name;
            break;
          case 'port':
            aValue = a.port;
            bValue = b.port;
            break;
          case 'protocol':
            aValue = a.protocol;
            bValue = b.protocol;
            break;
          case 'rule':
            aValue = a.rule;
            bValue = b.rule;
            break;
          case 'status':
            aValue = a.status;
            bValue = b.status;
            break;
          default:
            return 0;
        }

        final comparison = Comparable.compare(aValue as Comparable, bValue);
        return direction == CarbonDataTableSortDirection.ascending
            ? comparison
            : -comparison;
      });
    });
  }

  List<_LoadBalancer> get _filteredData {
    if (_searchQuery.isEmpty) return _sortedData;
    return _sortedData.where((item) =>
      item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      item.protocol.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return DemoPageTemplate(
      title: 'Carbon Data Table',
      description: 'Data tables display structured data with features like sorting, '
          'selection, expandable rows, and more. Following Carbon Design System specifications.',
      sections: [
        DemoSection(
          title: 'Basic Data Table',
          description: 'Simple table with headers and rows.',
          builder: (context) => CarbonDataTable(
            headers: [
              CarbonDataTableHeader(key: 'name', label: 'Name'),
              CarbonDataTableHeader(key: 'protocol', label: 'Protocol'),
              CarbonDataTableHeader(key: 'port', label: 'Port'),
              CarbonDataTableHeader(key: 'rule', label: 'Rule'),
            ],
            rows: _basicData.map((item) => CarbonDataTableRow(
              cells: [
                CarbonDataTableCell(child: Text(item.name)),
                CarbonDataTableCell(child: Text(item.protocol)),
                CarbonDataTableCell(child: Text(item.port.toString())),
                CarbonDataTableCell(child: Text(item.rule)),
              ],
            )).toList(),
          ),
        ),
        DemoSection(
          title: 'With Title and Description',
          description: 'Table with title and description text.',
          builder: (context) => CarbonDataTable(
            title: 'Load Balancers',
            description: 'Your organization\'s active load balancers.',
            headers: [
              CarbonDataTableHeader(key: 'name', label: 'Name'),
              CarbonDataTableHeader(key: 'status', label: 'Status'),
              CarbonDataTableHeader(key: 'port', label: 'Port'),
            ],
            rows: _basicData.map((item) => CarbonDataTableRow(
              cells: [
                CarbonDataTableCell(child: Text(item.name)),
                CarbonDataTableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.status == 'Active'
                          ? carbon.layer.supportSuccess.withValues(alpha: 0.1)
                          : carbon.layer.layer02,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item.status,
                      style: TextStyle(
                        fontSize: 12,
                        color: item.status == 'Active'
                            ? carbon.layer.supportSuccess
                            : carbon.text.textSecondary,
                      ),
                    ),
                  ),
                ),
                CarbonDataTableCell(child: Text(item.port.toString())),
              ],
            )).toList(),
          ),
        ),
        DemoSection(
          title: 'Expandable Rows',
          description: 'Rows can be expanded to show additional content.',
          builder: (context) => CarbonDataTable(
            hasExpandableRows: true,
            headers: [
              CarbonDataTableHeader(key: 'name', label: 'Name'),
              CarbonDataTableHeader(key: 'protocol', label: 'Protocol'),
              CarbonDataTableHeader(key: 'port', label: 'Port'),
            ],
            rows: _basicData.map((item) => CarbonDataTableRow(
              cells: [
                CarbonDataTableCell(child: Text(item.name)),
                CarbonDataTableCell(child: Text(item.protocol)),
                CarbonDataTableCell(child: Text(item.port.toString())),
              ],
              expandedContent: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Additional Details', style: CarbonTypography.heading03),
                    const SizedBox(height: 8),
                    Text('Rule: ${item.rule}'),
                    Text('Status: ${item.status}'),
                    Text('ID: ${item.id}'),
                  ],
                ),
              ),
            )).toList(),
          ),
        ),
        DemoSection(
          title: 'Selectable Rows (Checkbox)',
          description: 'Multiple rows can be selected with checkboxes.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedIds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '${_selectedIds.length} item(s) selected',
                    style: TextStyle(
                      color: carbon.text.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              CarbonDataTable(
                hasSelectableRows: true,
                headers: [
                  CarbonDataTableHeader(key: 'name', label: 'Name'),
                  CarbonDataTableHeader(key: 'port', label: 'Port'),
                  CarbonDataTableHeader(key: 'status', label: 'Status'),
                ],
                rows: _basicData.map((item) => CarbonDataTableRow(
                  cells: [
                    CarbonDataTableCell(child: Text(item.name)),
                    CarbonDataTableCell(child: Text(item.port.toString())),
                    CarbonDataTableCell(child: Text(item.status)),
                  ],
                  selected: _selectedIds.contains(item.id),
                  onSelectChanged: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedIds.add(item.id);
                      } else {
                        _selectedIds.remove(item.id);
                      }
                    });
                  },
                )).toList(),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Selectable Rows (Radio)',
          description: 'Single row selection using radio buttons.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedRadioId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Selected: ${_basicData.firstWhere((e) => e.id == _selectedRadioId).name}',
                    style: TextStyle(
                      color: carbon.text.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              CarbonDataTable(
                hasSelectableRows: true,
                radio: true,
                headers: [
                  CarbonDataTableHeader(key: 'name', label: 'Name'),
                  CarbonDataTableHeader(key: 'protocol', label: 'Protocol'),
                  CarbonDataTableHeader(key: 'port', label: 'Port'),
                ],
                rows: _basicData.map((item) => CarbonDataTableRow(
                  cells: [
                    CarbonDataTableCell(child: Text(item.name)),
                    CarbonDataTableCell(child: Text(item.protocol)),
                    CarbonDataTableCell(child: Text(item.port.toString())),
                  ],
                  selected: _selectedRadioId == item.id,
                  onSelectChanged: (selected) {
                    setState(() {
                      _selectedRadioId = selected ? item.id : null;
                    });
                  },
                )).toList(),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Batch Selection',
          description: 'Select all checkbox in header with indeterminate state.',
          builder: (context) => CarbonDataTable(
            hasSelectableRows: true,
            batchSelection: true,
            onSelectAll: (selectAll) {
              setState(() {
                if (selectAll) {
                  _selectedIds.addAll(_basicData.map((e) => e.id));
                } else {
                  _selectedIds.clear();
                }
              });
            },
            headers: [
              CarbonDataTableHeader(key: 'name', label: 'Name'),
              CarbonDataTableHeader(key: 'port', label: 'Port'),
              CarbonDataTableHeader(key: 'rule', label: 'Rule'),
            ],
            rows: _basicData.map((item) => CarbonDataTableRow(
              cells: [
                CarbonDataTableCell(child: Text(item.name)),
                CarbonDataTableCell(child: Text(item.port.toString())),
                CarbonDataTableCell(child: Text(item.rule)),
              ],
              selected: _selectedIds.contains(item.id),
              onSelectChanged: (selected) {
                setState(() {
                  if (selected) {
                    _selectedIds.add(item.id);
                  } else {
                    _selectedIds.remove(item.id);
                  }
                });
              },
            )).toList(),
          ),
        ),
        DemoSection(
          title: 'Sortable Columns',
          description: 'Click headers to sort data in ascending/descending order.',
          builder: (context) => CarbonDataTable(
            sortable: true,
            sortKey: _sortKey,
            sortDirection: _sortDirection,
            onSort: _sort,
            headers: [
              CarbonDataTableHeader(key: 'name', label: 'Name'),
              CarbonDataTableHeader(key: 'protocol', label: 'Protocol', sortable: false),
              CarbonDataTableHeader(key: 'port', label: 'Port'),
              CarbonDataTableHeader(key: 'rule', label: 'Rule'),
              CarbonDataTableHeader(key: 'status', label: 'Status'),
            ],
            rows: _sortedData.map((item) => CarbonDataTableRow(
              cells: [
                CarbonDataTableCell(child: Text(item.name)),
                CarbonDataTableCell(child: Text(item.protocol)),
                CarbonDataTableCell(child: Text(item.port.toString())),
                CarbonDataTableCell(child: Text(item.rule)),
                CarbonDataTableCell(child: Text(item.status)),
              ],
            )).toList(),
          ),
        ),
        DemoSection(
          title: 'Size Variants',
          description: 'Four density options: tall, medium, short, compact.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Tall (64px rows)', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CarbonDataTable(
                size: CarbonDataTableSize.tall,
                headers: [
                  CarbonDataTableHeader(key: 'name', label: 'Name'),
                  CarbonDataTableHeader(key: 'status', label: 'Status'),
                ],
                rows: _basicData.take(2).map((item) => CarbonDataTableRow(
                  cells: [
                    CarbonDataTableCell(child: Text(item.name)),
                    CarbonDataTableCell(child: Text(item.status)),
                  ],
                )).toList(),
              ),
              const SizedBox(height: 24),
              Text('Medium (48px rows - default)', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CarbonDataTable(
                size: CarbonDataTableSize.medium,
                headers: [
                  CarbonDataTableHeader(key: 'name', label: 'Name'),
                  CarbonDataTableHeader(key: 'status', label: 'Status'),
                ],
                rows: _basicData.take(2).map((item) => CarbonDataTableRow(
                  cells: [
                    CarbonDataTableCell(child: Text(item.name)),
                    CarbonDataTableCell(child: Text(item.status)),
                  ],
                )).toList(),
              ),
              const SizedBox(height: 24),
              Text('Short (40px rows)', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CarbonDataTable(
                size: CarbonDataTableSize.short,
                headers: [
                  CarbonDataTableHeader(key: 'name', label: 'Name'),
                  CarbonDataTableHeader(key: 'status', label: 'Status'),
                ],
                rows: _basicData.take(2).map((item) => CarbonDataTableRow(
                  cells: [
                    CarbonDataTableCell(child: Text(item.name)),
                    CarbonDataTableCell(child: Text(item.status)),
                  ],
                )).toList(),
              ),
              const SizedBox(height: 24),
              Text('Compact (32px rows)', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              CarbonDataTable(
                size: CarbonDataTableSize.compact,
                headers: [
                  CarbonDataTableHeader(key: 'name', label: 'Name'),
                  CarbonDataTableHeader(key: 'status', label: 'Status'),
                ],
                rows: _basicData.take(2).map((item) => CarbonDataTableRow(
                  cells: [
                    CarbonDataTableCell(child: Text(item.name)),
                    CarbonDataTableCell(child: Text(item.status)),
                  ],
                )).toList(),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Zebra Stripes',
          description: 'Alternating row background colors for better visual separation.',
          builder: (context) => CarbonDataTable(
            zebra: true,
            headers: [
              CarbonDataTableHeader(key: 'name', label: 'Name'),
              CarbonDataTableHeader(key: 'protocol', label: 'Protocol'),
              CarbonDataTableHeader(key: 'port', label: 'Port'),
              CarbonDataTableHeader(key: 'status', label: 'Status'),
            ],
            rows: _basicData.map((item) => CarbonDataTableRow(
              cells: [
                CarbonDataTableCell(child: Text(item.name)),
                CarbonDataTableCell(child: Text(item.protocol)),
                CarbonDataTableCell(child: Text(item.port.toString())),
                CarbonDataTableCell(child: Text(item.status)),
              ],
            )).toList(),
          ),
        ),
        DemoSection(
          title: 'With Toolbar',
          description: 'Table with search toolbar and batch actions.',
          builder: (context) => CarbonDataTable(
            title: 'Load Balancers',
            description: 'Search and manage load balancers.',
            hasSelectableRows: true,
            batchSelection: true,
            onSelectAll: (selectAll) {
              setState(() {
                if (selectAll) {
                  _selectedIds.addAll(_basicData.map((e) => e.id));
                } else {
                  _selectedIds.clear();
                }
              });
            },
            toolbar: CarbonToolbar(
              selectedCount: _selectedIds.length,
              content: CarbonToolbarContent(
                children: [
                  CarbonToolbarSearch(
                    value: _searchQuery,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    placeholder: 'Search load balancers...',
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(CarbonIcons.add, size: 16),
                    label: const Text('Add'),
                  ),
                ],
              ),
              batchActions: CarbonToolbarBatchActions(
                selectedCount: _selectedIds.length,
                onCancel: () {
                  setState(() => _selectedIds.clear());
                },
                actions: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(CarbonIcons.download, size: 16),
                    label: const Text('Export'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _selectedIds.clear());
                    },
                    icon: Icon(CarbonIcons.delete, size: 16),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: carbon.layer.supportError,
                    ),
                  ),
                ],
              ),
            ),
            headers: [
              CarbonDataTableHeader(key: 'name', label: 'Name'),
              CarbonDataTableHeader(key: 'protocol', label: 'Protocol'),
              CarbonDataTableHeader(key: 'port', label: 'Port'),
            ],
            rows: _filteredData.map((item) => CarbonDataTableRow(
              cells: [
                CarbonDataTableCell(child: Text(item.name)),
                CarbonDataTableCell(child: Text(item.protocol)),
                CarbonDataTableCell(child: Text(item.port.toString())),
              ],
              selected: _selectedIds.contains(item.id),
              onSelectChanged: (selected) {
                setState(() {
                  if (selected) {
                    _selectedIds.add(item.id);
                  } else {
                    _selectedIds.remove(item.id);
                  }
                });
              },
            )).toList(),
          ),
        ),
        DemoSection(
          title: 'Skeleton Loading State',
          description: 'Animated loading placeholders while data is being fetched.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      Future.delayed(const Duration(seconds: 3), () {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    },
                    child: const Text('Simulate Loading'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CarbonDataTable(
                title: 'Load Balancers',
                description: 'Loading data from server...',
                skeleton: _isLoading,
                skeletonRowCount: 5,
                toolbar: CarbonToolbar(
                  content: CarbonToolbarContent(
                    children: [
                      CarbonToolbarSearch(onChanged: (value) {}),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
                headers: [
                  CarbonDataTableHeader(key: 'name', label: 'Name'),
                  CarbonDataTableHeader(key: 'protocol', label: 'Protocol'),
                  CarbonDataTableHeader(key: 'port', label: 'Port'),
                  CarbonDataTableHeader(key: 'status', label: 'Status'),
                ],
                rows: _basicData.map((item) => CarbonDataTableRow(
                  cells: [
                    CarbonDataTableCell(child: Text(item.name)),
                    CarbonDataTableCell(child: Text(item.protocol)),
                    CarbonDataTableCell(child: Text(item.port.toString())),
                    CarbonDataTableCell(child: Text(item.status)),
                  ],
                )).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadBalancer {
  _LoadBalancer(
    this.id,
    this.name,
    this.protocol,
    this.port,
    this.rule,
    this.status,
  );

  final String id;
  final String name;
  final String protocol;
  final int port;
  final String rule;
  final String status;
}
