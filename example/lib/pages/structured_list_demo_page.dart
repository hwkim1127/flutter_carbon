import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonStructuredList component.
class StructuredListDemoPage extends StatefulWidget {
  const StructuredListDemoPage({super.key});

  @override
  State<StructuredListDemoPage> createState() => _StructuredListDemoPageState();
}

class _StructuredListDemoPageState extends State<StructuredListDemoPage> {
  int? _selectedIndex1;
  int? _selectedIndex2;
  int? _selectedIndex3;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Structured List',
      description:
          'Table-like list with rows and columns for displaying structured data.',
      sections: [
        DemoSection(
          title: 'Basic List',
          description: 'Simple structured list with headers',
          builder: (context) => CarbonStructuredList(
            headers: [
              const CarbonStructuredListHeader(label: 'Name'),
              const CarbonStructuredListHeader(label: 'Role'),
              const CarbonStructuredListHeader(label: 'Location'),
            ],
            rows: [
              CarbonStructuredListRow(
                cells: [
                  const CarbonStructuredListCell(child: Text('John Doe')),
                  const CarbonStructuredListCell(child: Text('Developer')),
                  const CarbonStructuredListCell(child: Text('New York')),
                ],
              ),
              CarbonStructuredListRow(
                cells: [
                  const CarbonStructuredListCell(child: Text('Jane Smith')),
                  const CarbonStructuredListCell(child: Text('Designer')),
                  const CarbonStructuredListCell(child: Text('San Francisco')),
                ],
              ),
              CarbonStructuredListRow(
                cells: [
                  const CarbonStructuredListCell(child: Text('Bob Johnson')),
                  const CarbonStructuredListCell(child: Text('Manager')),
                  const CarbonStructuredListCell(child: Text('Chicago')),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Without Headers',
          description: 'List without header row',
          builder: (context) => CarbonStructuredList(
            rows: [
              CarbonStructuredListRow(
                cells: [
                  const CarbonStructuredListCell(child: Text('Product A')),
                  const CarbonStructuredListCell(child: Text('\$29.99')),
                  const CarbonStructuredListCell(child: Text('In Stock')),
                ],
              ),
              CarbonStructuredListRow(
                cells: [
                  const CarbonStructuredListCell(child: Text('Product B')),
                  const CarbonStructuredListCell(child: Text('\$49.99')),
                  const CarbonStructuredListCell(child: Text('Low Stock')),
                ],
              ),
              CarbonStructuredListRow(
                cells: [
                  const CarbonStructuredListCell(child: Text('Product C')),
                  const CarbonStructuredListCell(child: Text('\$19.99')),
                  const CarbonStructuredListCell(child: Text('Out of Stock')),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Without Borders',
          description: 'List with borders disabled',
          builder: (context) => CarbonStructuredList(
            showBorders: false,
            headers: [
              const CarbonStructuredListHeader(label: 'Item'),
              const CarbonStructuredListHeader(label: 'Quantity'),
              const CarbonStructuredListHeader(label: 'Price'),
            ],
            rows: [
              CarbonStructuredListRow(
                cells: [
                  const CarbonStructuredListCell(child: Text('Widget')),
                  const CarbonStructuredListCell(child: Text('10')),
                  const CarbonStructuredListCell(child: Text('\$100')),
                ],
              ),
              CarbonStructuredListRow(
                cells: [
                  const CarbonStructuredListCell(child: Text('Gadget')),
                  const CarbonStructuredListCell(child: Text('5')),
                  const CarbonStructuredListCell(child: Text('\$250')),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Selectable Rows',
          description: 'Interactive list with selectable rows',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonStructuredList(
                selectable: true,
                selectedIndex: _selectedIndex1,
                onRowSelected: (index) {
                  setState(() => _selectedIndex1 = index);
                },
                headers: [
                  const CarbonStructuredListHeader(label: 'Server'),
                  const CarbonStructuredListHeader(label: 'Status'),
                  const CarbonStructuredListHeader(label: 'CPU'),
                ],
                rows: [
                  CarbonStructuredListRow(
                    cells: [
                      const CarbonStructuredListCell(child: Text('Server 1')),
                      const CarbonStructuredListCell(
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text('Online'),
                          ],
                        ),
                      ),
                      const CarbonStructuredListCell(child: Text('45%')),
                    ],
                  ),
                  CarbonStructuredListRow(
                    cells: [
                      const CarbonStructuredListCell(child: Text('Server 2')),
                      const CarbonStructuredListCell(
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text('Online'),
                          ],
                        ),
                      ),
                      const CarbonStructuredListCell(child: Text('67%')),
                    ],
                  ),
                  CarbonStructuredListRow(
                    cells: [
                      const CarbonStructuredListCell(child: Text('Server 3')),
                      const CarbonStructuredListCell(
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 16),
                            SizedBox(width: 4),
                            Text('Offline'),
                          ],
                        ),
                      ),
                      const CarbonStructuredListCell(child: Text('0%')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _selectedIndex1 != null
                    ? 'Selected: Server ${_selectedIndex1! + 1}'
                    : 'No selection',
                style: TextStyle(
                  fontSize: 14,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Custom Column Widths',
          description: 'Columns with different flex values',
          builder: (context) => CarbonStructuredList(
            headers: [
              const CarbonStructuredListHeader(label: 'Name', flex: 2),
              const CarbonStructuredListHeader(label: 'Size', flex: 1),
              const CarbonStructuredListHeader(label: 'Modified', flex: 2),
            ],
            rows: [
              CarbonStructuredListRow(
                cells: [
                  const CarbonStructuredListCell(
                    child: Text('document.pdf'),
                    flex: 2,
                  ),
                  const CarbonStructuredListCell(
                    child: Text('2.4 MB'),
                    flex: 1,
                  ),
                  const CarbonStructuredListCell(
                    child: Text('2024-01-15 10:30'),
                    flex: 2,
                  ),
                ],
              ),
              CarbonStructuredListRow(
                cells: [
                  const CarbonStructuredListCell(
                    child: Text('image-large-filename.png'),
                    flex: 2,
                  ),
                  const CarbonStructuredListCell(
                    child: Text('8.7 MB'),
                    flex: 1,
                  ),
                  const CarbonStructuredListCell(
                    child: Text('2024-01-14 15:22'),
                    flex: 2,
                  ),
                ],
              ),
              CarbonStructuredListRow(
                cells: [
                  const CarbonStructuredListCell(
                    child: Text('report.xlsx'),
                    flex: 2,
                  ),
                  const CarbonStructuredListCell(
                    child: Text('156 KB'),
                    flex: 1,
                  ),
                  const CarbonStructuredListCell(
                    child: Text('2024-01-13 09:15'),
                    flex: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'With Custom Widgets',
          description: 'Cells containing custom widgets',
          builder: (context) => CarbonStructuredList(
            selectable: true,
            selectedIndex: _selectedIndex2,
            onRowSelected: (index) {
              setState(() => _selectedIndex2 = index);
            },
            headers: [
              const CarbonStructuredListHeader(label: 'User'),
              const CarbonStructuredListHeader(label: 'Status'),
              const CarbonStructuredListHeader(label: 'Actions'),
            ],
            rows: [
              CarbonStructuredListRow(
                cells: [
                  CarbonStructuredListCell(
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'JD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('John Doe'),
                      ],
                    ),
                  ),
                  CarbonStructuredListCell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ),
                  ),
                  CarbonStructuredListCell(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 16),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 16),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CarbonStructuredListRow(
                cells: [
                  CarbonStructuredListCell(
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Colors.purple,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'JS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Jane Smith'),
                      ],
                    ),
                  ),
                  CarbonStructuredListCell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text(
                        'Away',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                  ),
                  CarbonStructuredListCell(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 16),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 16),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Large Data Set',
          description: 'List with many rows',
          builder: (context) => CarbonStructuredList(
            selectable: true,
            selectedIndex: _selectedIndex3,
            onRowSelected: (index) {
              setState(() => _selectedIndex3 = index);
            },
            headers: [
              const CarbonStructuredListHeader(label: 'ID'),
              const CarbonStructuredListHeader(label: 'Order'),
              const CarbonStructuredListHeader(label: 'Date'),
              const CarbonStructuredListHeader(label: 'Amount'),
            ],
            rows: List.generate(
              10,
              (index) => CarbonStructuredListRow(
                cells: [
                  CarbonStructuredListCell(child: Text('#${1000 + index}')),
                  CarbonStructuredListCell(child: Text('ORDER-${index + 1}')),
                  CarbonStructuredListCell(
                    child: Text(
                      '2024-01-${(index + 1).toString().padLeft(2, '0')}',
                    ),
                  ),
                  CarbonStructuredListCell(
                    child: Text('\$${(index + 1) * 99}.99'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
