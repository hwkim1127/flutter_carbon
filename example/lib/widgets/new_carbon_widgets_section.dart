import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

/// Section demonstrating new Carbon widgets.
class NewCarbonWidgetsSection extends StatefulWidget {
  const NewCarbonWidgetsSection({super.key});

  @override
  State<NewCarbonWidgetsSection> createState() =>
      _NewCarbonWidgetsSectionState();
}

class _NewCarbonWidgetsSectionState extends State<NewCarbonWidgetsSection> {
  List<String> _selectedCountries = ['kr'];
  bool _tile1Selected = false;
  bool _tile2Expanded = false;
  int _tabIndex = 0;
  int _progressIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'New Carbon Widgets',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // CarbonTag
        const Text(
          'Tags',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const CarbonTag(text: 'Red', type: CarbonTagType.red),
            const CarbonTag(text: 'Blue', type: CarbonTagType.blue),
            const CarbonTag(text: 'Green', type: CarbonTagType.green),
            const CarbonTag(text: 'Purple', type: CarbonTagType.purple),
            const CarbonTag(text: 'Outline', type: CarbonTagType.outline),
            CarbonTag(
              text: 'Dismissible',
              type: CarbonTagType.cyan,
              onDismiss: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),

        // CarbonTabs
        const Text(
          'Tabs',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CarbonTabs(
          initialIndex: _tabIndex,
          tabs: const [
            CarbonTab(label: 'Overview'),
            CarbonTab(label: 'Details'),
            CarbonTab(label: 'Settings'),
          ],
          onTabChanged: (i) => setState(() => _tabIndex = i),
        ),
        Container(
          height: 60,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(16),
          child: Text(
            'Tab ${_tabIndex + 1} content',
            style: TextStyle(color: context.carbon.text.textSecondary),
          ),
        ),
        const SizedBox(height: 16),

        // CarbonProgressIndicator
        const Text(
          'Progress Indicator',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CarbonProgressIndicator(
          currentIndex: _progressIndex,
          onStepTap: (i) => setState(() => _progressIndex = i),
          steps: const [
            CarbonProgressStep(label: 'Cart'),
            CarbonProgressStep(label: 'Shipping'),
            CarbonProgressStep(label: 'Payment'),
            CarbonProgressStep(label: 'Review'),
          ],
        ),
        const SizedBox(height: 16),

        // CarbonDataTable
        const Text(
          'Data Table',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CarbonDataTable(
          size: CarbonDataTableSize.short,
          headers: const [
            CarbonDataTableHeader(key: 'name', label: 'Name'),
            CarbonDataTableHeader(key: 'protocol', label: 'Protocol'),
            CarbonDataTableHeader(key: 'status', label: 'Status'),
          ],
          rows: const [
            CarbonDataTableRow(cells: [
              CarbonDataTableCell(child: Text('Load Balancer 1')),
              CarbonDataTableCell(child: Text('HTTP')),
              CarbonDataTableCell(child: Text('Active')),
            ]),
            CarbonDataTableRow(cells: [
              CarbonDataTableCell(child: Text('Load Balancer 2')),
              CarbonDataTableCell(child: Text('HTTPS')),
              CarbonDataTableCell(child: Text('Inactive')),
            ]),
          ],
        ),
        const SizedBox(height: 16),

        // CarbonTile
        const Text(
          'Tiles',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CarbonTile.selectable(
          title: 'Selectable Tile',
          selected: _tile1Selected,
          onSelectedChanged: (v) => setState(() => _tile1Selected = v),
          child: const Text('Click to select'),
        ),
        const SizedBox(height: 8),
        CarbonTile.expandable(
          title: 'Expandable Tile',
          expanded: _tile2Expanded,
          onExpansionChanged: (v) => setState(() => _tile2Expanded = v),
          expandedContent: const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Additional content shown when expanded'),
          ),
          child: const Text('Click to expand'),
        ),
        const SizedBox(height: 16),

        // CarbonMultiSelect
        const Text(
          'Multi-Select',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CarbonMultiSelect<String>(
          label: 'Select countries',
          hint: 'Choose countries',
          values: _selectedCountries,
          items: const [
            CarbonMultiSelectItem(value: 'kr', child: Text('South Korea')),
            CarbonMultiSelectItem(value: 'us', child: Text('United States')),
            CarbonMultiSelectItem(value: 'uk', child: Text('United Kingdom')),
          ],
          onChanged: (v) => setState(() => _selectedCountries = v),
          itemToString: (v) =>
              {
                'kr': 'South Korea',
                'us': 'United States',
                'uk': 'United Kingdom',
              }[v] ??
              v,
        ),
        const SizedBox(height: 16),

        // CarbonContainedList
        const Text(
          'Contained List',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        CarbonContainedList(
          title: 'Quick Actions',
          items: [
            CarbonContainedListItem(
              leading: Icon(Icons.add, color: context.carbon.text.iconPrimary),
              child: const Text('Add item'),
              onTap: () {},
            ),
            CarbonContainedListItem(
              leading: Icon(Icons.edit, color: context.carbon.text.iconPrimary),
              child: const Text('Edit'),
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),

        // CarbonFloatingMenu
        const Text(
          'Floating Menu',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: Stack(
            children: [
              Positioned(
                bottom: 8,
                right: 8,
                child: CarbonFloatingMenu(
                  icon: Icons.add,
                  items: [
                    CarbonFloatingMenuItem(
                      icon: Icons.create,
                      label: 'Create new',
                      onTap: () {},
                    ),
                    CarbonFloatingMenuItem(
                      icon: Icons.upload,
                      label: 'Upload file',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
