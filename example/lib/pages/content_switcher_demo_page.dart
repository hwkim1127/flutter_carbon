import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonContentSwitcher component.
class ContentSwitcherDemoPage extends StatefulWidget {
  const ContentSwitcherDemoPage({super.key});

  @override
  State<ContentSwitcherDemoPage> createState() =>
      _ContentSwitcherDemoPageState();
}

class _ContentSwitcherDemoPageState extends State<ContentSwitcherDemoPage> {
  String _basicValue = '1';
  String _iconValue = 'grid';
  String _sizeSmallValue = 'day';
  String _sizeLargeValue = 'overview';

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Content Switcher',
      description:
          'Content switchers allow users to toggle between different views or content sections.',
      sections: [
        DemoSection(
          title: 'Basic Content Switcher',
          description: 'Simple content switcher with text labels',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonContentSwitcher(
                selectedValue: _basicValue,
                onChanged: (value) {
                  setState(() {
                    _basicValue = value;
                  });
                },
                items: const [
                  CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
                  CarbonContentSwitcherItem(label: 'Option 2', value: '2'),
                  CarbonContentSwitcherItem(label: 'Option 3', value: '3'),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.carbon.layer.borderSubtle01,
                  ),
                ),
                child: Text(
                  'Content for Option $_basicValue',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.carbon.text.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Content Switcher with Icons',
          description: 'Content switcher with icon and text',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonContentSwitcher(
                selectedValue: _iconValue,
                onChanged: (value) {
                  setState(() {
                    _iconValue = value;
                  });
                },
                items: const [
                  CarbonContentSwitcherItem(
                    label: 'Grid View',
                    icon: Icon(Icons.grid_view),
                    value: 'grid',
                  ),
                  CarbonContentSwitcherItem(
                    label: 'List View',
                    icon: Icon(Icons.list),
                    value: 'list',
                  ),
                  CarbonContentSwitcherItem(
                    label: 'Table View',
                    icon: Icon(Icons.table_chart),
                    value: 'table',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.carbon.layer.borderSubtle01,
                  ),
                ),
                child: Text(
                  _iconValue == 'grid'
                      ? 'Grid view content'
                      : _iconValue == 'list'
                          ? 'List view content'
                          : 'Table view content',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.carbon.text.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Small Size Content Switcher',
          description: 'Compact content switcher for tight spaces',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonContentSwitcher(
                selectedValue: _sizeSmallValue,
                size: CarbonContentSwitcherSize.small,
                onChanged: (value) {
                  setState(() {
                    _sizeSmallValue = value;
                  });
                },
                items: const [
                  CarbonContentSwitcherItem(label: 'Day', value: 'day'),
                  CarbonContentSwitcherItem(label: 'Week', value: 'week'),
                  CarbonContentSwitcherItem(label: 'Month', value: 'month'),
                  CarbonContentSwitcherItem(label: 'Year', value: 'year'),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Large Size Content Switcher',
          description: 'Larger content switcher for better touch targets',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonContentSwitcher(
                selectedValue: _sizeLargeValue,
                size: CarbonContentSwitcherSize.large,
                onChanged: (value) {
                  setState(() {
                    _sizeLargeValue = value;
                  });
                },
                items: const [
                  CarbonContentSwitcherItem(
                    label: 'Overview',
                    value: 'overview',
                  ),
                  CarbonContentSwitcherItem(label: 'Details', value: 'details'),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Disabled Item',
          description: 'Content switcher with a disabled option',
          builder: (context) => CarbonContentSwitcher(
            selectedValue: '1',
            onChanged: (value) {},
            items: const [
              CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
              CarbonContentSwitcherItem(
                label: 'Option 2 (Disabled)',
                value: '2',
                disabled: true,
              ),
              CarbonContentSwitcherItem(label: 'Option 3', value: '3'),
            ],
          ),
        ),
        DemoSection(
          title: 'Icon-Only Content Switcher',
          description: 'Content switcher with only icons',
          builder: (context) => CarbonContentSwitcher(
            selectedValue: 'list',
            onChanged: (value) {},
            items: const [
              CarbonContentSwitcherItem(
                icon: Icon(Icons.view_list),
                value: 'list',
              ),
              CarbonContentSwitcherItem(
                icon: Icon(Icons.view_module),
                value: 'grid',
              ),
              CarbonContentSwitcherItem(
                icon: Icon(Icons.view_column),
                value: 'columns',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Many Options',
          description: 'Content switcher with multiple options',
          builder: (context) => CarbonContentSwitcher(
            selectedValue: 'all',
            onChanged: (value) {},
            items: const [
              CarbonContentSwitcherItem(label: 'All', value: 'all'),
              CarbonContentSwitcherItem(label: 'Active', value: 'active'),
              CarbonContentSwitcherItem(label: 'Pending', value: 'pending'),
              CarbonContentSwitcherItem(label: 'Complete', value: 'complete'),
              CarbonContentSwitcherItem(label: 'Archived', value: 'archived'),
            ],
          ),
        ),
      ],
    );
  }
}
