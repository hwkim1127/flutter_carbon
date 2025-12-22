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
      ],
    );
  }
}
