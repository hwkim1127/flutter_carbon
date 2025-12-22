import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonOverflowMenu component.
class OverflowMenuDemoPage extends StatefulWidget {
  const OverflowMenuDemoPage({super.key});

  @override
  State<OverflowMenuDemoPage> createState() => _OverflowMenuDemoPageState();
}

class _OverflowMenuDemoPageState extends State<OverflowMenuDemoPage> {
  String _lastAction = 'None';

  void _handleAction(String action) {
    setState(() {
      _lastAction = action;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$action clicked')));
  }

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Overflow Menu',
      description:
          'Overflow menus provide a compact way to present additional actions or options.',
      sections: [
        DemoSection(
          title: 'Basic Overflow Menu',
          description: 'Simple overflow menu with actions',
          builder: (context) => Row(
            children: [
              const Text('More actions'),
              const SizedBox(width: 8),
              CarbonOverflowMenu(
                items: [
                  CarbonOverflowMenuItem(
                    label: 'Edit',
                    onTap: () => _handleAction('Edit'),
                  ),
                  CarbonOverflowMenuItem(
                    label: 'Duplicate',
                    onTap: () => _handleAction('Duplicate'),
                  ),
                  CarbonOverflowMenuItem(
                    label: 'Delete',
                    onTap: () => _handleAction('Delete'),
                    isDanger: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Overflow Menu with Icons',
          description: 'Menu items with leading icons',
          builder: (context) => Row(
            children: [
              const Text('Actions'),
              const SizedBox(width: 8),
              CarbonOverflowMenu(
                items: [
                  CarbonOverflowMenuItem(
                    label: 'Share',
                    icon: const Icon(Icons.share, size: 16),
                    onTap: () => _handleAction('Share'),
                  ),
                  CarbonOverflowMenuItem(
                    label: 'Download',
                    icon: const Icon(Icons.download, size: 16),
                    onTap: () => _handleAction('Download'),
                  ),
                  CarbonOverflowMenuItem(
                    label: 'Print',
                    icon: const Icon(Icons.print, size: 16),
                    onTap: () => _handleAction('Print'),
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Overflow Menu with Dividers',
          description: 'Grouping menu items with dividers',
          builder: (context) => Row(
            children: [
              const Text('File options'),
              const SizedBox(width: 8),
              CarbonOverflowMenu(
                items: [
                  CarbonOverflowMenuItem(
                    label: 'New File',
                    icon: const Icon(Icons.add, size: 16),
                    onTap: () => _handleAction('New File'),
                  ),
                  CarbonOverflowMenuItem(
                    label: 'Open',
                    icon: const Icon(Icons.folder_open, size: 16),
                    onTap: () => _handleAction('Open'),
                  ),
                  const CarbonOverflowMenuDivider(),
                  CarbonOverflowMenuItem(
                    label: 'Settings',
                    icon: const Icon(Icons.settings, size: 16),
                    onTap: () => _handleAction('Settings'),
                  ),
                  const CarbonOverflowMenuDivider(),
                  CarbonOverflowMenuItem(
                    label: 'Exit',
                    onTap: () => _handleAction('Exit'),
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Overflow Menu with Disabled Items',
          description: 'Some menu items are disabled',
          builder: (context) => Row(
            children: [
              const Text('Mixed states'),
              const SizedBox(width: 8),
              CarbonOverflowMenu(
                items: [
                  CarbonOverflowMenuItem(
                    label: 'Available Action',
                    onTap: () => _handleAction('Available Action'),
                  ),
                  const CarbonOverflowMenuItem(
                    label: 'Disabled Action',
                    disabled: true,
                  ),
                  CarbonOverflowMenuItem(
                    label: 'Another Available',
                    onTap: () => _handleAction('Another Available'),
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Overflow Menu Sizes',
          description: 'Different menu sizes',
          builder: (context) => Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Extra Small', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  CarbonOverflowMenu(
                    size: CarbonOverflowMenuSize.xs,
                    items: [
                      CarbonOverflowMenuItem(label: 'Action 1', onTap: () {}),
                      CarbonOverflowMenuItem(label: 'Action 2', onTap: () {}),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Small', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  CarbonOverflowMenu(
                    size: CarbonOverflowMenuSize.sm,
                    items: [
                      CarbonOverflowMenuItem(label: 'Action 1', onTap: () {}),
                      CarbonOverflowMenuItem(label: 'Action 2', onTap: () {}),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Medium (default)',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  CarbonOverflowMenu(
                    size: CarbonOverflowMenuSize.md,
                    items: [
                      CarbonOverflowMenuItem(label: 'Action 1', onTap: () {}),
                      CarbonOverflowMenuItem(label: 'Action 2', onTap: () {}),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Large', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  CarbonOverflowMenu(
                    size: CarbonOverflowMenuSize.lg,
                    items: [
                      CarbonOverflowMenuItem(label: 'Action 1', onTap: () {}),
                      CarbonOverflowMenuItem(label: 'Action 2', onTap: () {}),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Flipped Overflow Menu',
          description: 'Menu opens upward instead of downward',
          builder: (context) => Row(
            children: [
              const Text('Flipped menu'),
              const SizedBox(width: 8),
              CarbonOverflowMenu(
                flipped: true,
                items: [
                  CarbonOverflowMenuItem(
                    label: 'Action 1',
                    onTap: () => _handleAction('Action 1'),
                  ),
                  CarbonOverflowMenuItem(
                    label: 'Action 2',
                    onTap: () => _handleAction('Action 2'),
                  ),
                  CarbonOverflowMenuItem(
                    label: 'Action 3',
                    onTap: () => _handleAction('Action 3'),
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Last Action',
          description: 'Displaying the result of menu interactions',
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: context.carbon.layer.borderSubtle01),
            ),
            child: Text(
              'Last action: $_lastAction',
              style: TextStyle(
                fontSize: 14,
                color: context.carbon.text.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
