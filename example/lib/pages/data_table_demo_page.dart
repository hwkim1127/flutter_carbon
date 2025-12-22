import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Data Table functionality using Material's DataTable.
class DataTableDemoPage extends StatefulWidget {
  const DataTableDemoPage({super.key});

  @override
  State<DataTableDemoPage> createState() => _DataTableDemoPageState();
}

class _DataTableDemoPageState extends State<DataTableDemoPage> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  final Set<int> _selectedRows = {};
  final List<_Employee> _employees = [
    _Employee('John Doe', 'Engineering', 75000, 'Active'),
    _Employee('Jane Smith', 'Design', 72000, 'Active'),
    _Employee('Bob Johnson', 'Product', 80000, 'Active'),
    _Employee('Alice Williams', 'Engineering', 78000, 'Inactive'),
    _Employee('Charlie Brown', 'Sales', 65000, 'Active'),
  ];

  void _sort<T>(
    Comparable<T> Function(_Employee e) getField,
    int columnIndex,
    bool ascending,
  ) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _employees.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return DemoPageTemplate(
      title: 'Data Table',
      description:
          'Data tables display sets of data across rows and columns. '
          'Built using Material DataTable with Carbon theming.',
      sections: [
        DemoSection(
          title: 'Basic Data Table',
          description: 'Simple data table with rows and columns.',
          builder: (context) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Department')),
                DataColumn(label: Text('Status')),
              ],
              rows: const [
                DataRow(
                  cells: [
                    DataCell(Text('John Doe')),
                    DataCell(Text('Engineering')),
                    DataCell(Text('Active')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Jane Smith')),
                    DataCell(Text('Design')),
                    DataCell(Text('Active')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Bob Johnson')),
                    DataCell(Text('Product')),
                    DataCell(Text('Inactive')),
                  ],
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Sortable Columns',
          description: 'Click column headers to sort data.',
          builder: (context) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              sortColumnIndex: _sortColumnIndex,
              sortAscending: _sortAscending,
              columns: [
                DataColumn(
                  label: const Text('Name'),
                  onSort: (columnIndex, ascending) {
                    _sort<String>((e) => e.name, columnIndex, ascending);
                  },
                ),
                DataColumn(
                  label: const Text('Department'),
                  onSort: (columnIndex, ascending) {
                    _sort<String>((e) => e.department, columnIndex, ascending);
                  },
                ),
                DataColumn(
                  label: const Text('Salary'),
                  numeric: true,
                  onSort: (columnIndex, ascending) {
                    _sort<num>((e) => e.salary, columnIndex, ascending);
                  },
                ),
                DataColumn(
                  label: const Text('Status'),
                  onSort: (columnIndex, ascending) {
                    _sort<String>((e) => e.status, columnIndex, ascending);
                  },
                ),
              ],
              rows: _employees.map((employee) {
                return DataRow(
                  cells: [
                    DataCell(Text(employee.name)),
                    DataCell(Text(employee.department)),
                    DataCell(Text('\$${employee.salary}')),
                    DataCell(
                      Chip(
                        label: Text(
                          employee.status,
                          style: TextStyle(
                            fontSize: 12,
                            color: employee.status == 'Active'
                                ? carbon.layer.supportSuccess
                                : carbon.text.textSecondary,
                          ),
                        ),
                        backgroundColor: employee.status == 'Active'
                            ? carbon.layer.supportSuccess.withValues(alpha: 0.1)
                            : carbon.layer.layer02,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        DemoSection(
          title: 'Selectable Rows',
          description: 'Rows can be selected with checkboxes.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedRows.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '${_selectedRows.length} row(s) selected',
                    style: TextStyle(
                      color: carbon.text.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: true,
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Product')),
                    DataColumn(label: Text('Price')),
                  ],
                  rows: List.generate(5, (index) {
                    final isSelected = _selectedRows.contains(index);
                    return DataRow(
                      selected: isSelected,
                      onSelectChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedRows.add(index);
                          } else {
                            _selectedRows.remove(index);
                          }
                        });
                      },
                      cells: [
                        DataCell(Text('${1000 + index}')),
                        DataCell(Text('Product ${index + 1}')),
                        DataCell(Text('\$${(index + 1) * 10}.00')),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Table with Actions',
          description: 'Data table with row actions.',
          builder: (context) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('File')),
                DataColumn(label: Text('Size')),
                DataColumn(label: Text('Modified')),
                DataColumn(label: Text('Actions')),
              ],
              rows: [
                DataRow(
                  cells: [
                    const DataCell(Text('document.pdf')),
                    const DataCell(Text('2.4 MB')),
                    const DataCell(Text('2 hours ago')),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.download, size: 20),
                            onPressed: () {},
                            tooltip: 'Download',
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, size: 20),
                            onPressed: () {},
                            tooltip: 'Share',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () {},
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    const DataCell(Text('image.png')),
                    const DataCell(Text('1.8 MB')),
                    const DataCell(Text('5 hours ago')),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.download, size: 20),
                            onPressed: () {},
                            tooltip: 'Download',
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, size: 20),
                            onPressed: () {},
                            tooltip: 'Share',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () {},
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Employee {
  _Employee(this.name, this.department, this.salary, this.status);
  final String name;
  final String department;
  final int salary;
  final String status;
}
