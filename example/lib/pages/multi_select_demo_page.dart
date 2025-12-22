import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Multi-Select functionality using Carbon's CarbonMultiSelect.
class MultiSelectDemoPage extends StatefulWidget {
  const MultiSelectDemoPage({super.key});

  @override
  State<MultiSelectDemoPage> createState() => _MultiSelectDemoPageState();
}

class _MultiSelectDemoPageState extends State<MultiSelectDemoPage> {
  List<String> _selectedCountries = ['us', 'ca'];
  List<String> _selectedFeatures = [];
  List<String> _selectedCategories = [];
  List<int> _selectedNumbers = [1, 3];

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Multi-Select',
      description:
          'Multi-select dropdowns allow users to select multiple options from a list. Selected items are displayed as chips.',
      sections: [
        DemoSection(
          title: 'Basic Multi-Select',
          description: 'Simple multi-select with predefined values.',
          builder: (context) => CarbonMultiSelect<String>(
            label: 'Select countries',
            hint: 'Choose one or more countries',
            values: _selectedCountries,
            items: const [
              CarbonMultiSelectItem(value: 'kr', child: Text('South Korea')),
              CarbonMultiSelectItem(value: 'us', child: Text('United States')),
              CarbonMultiSelectItem(value: 'ca', child: Text('Canada')),
              CarbonMultiSelectItem(value: 'uk', child: Text('United Kingdom')),
              CarbonMultiSelectItem(value: 'au', child: Text('Australia')),
              CarbonMultiSelectItem(value: 'jp', child: Text('Japan')),
            ],
            onChanged: (value) {
              setState(() => _selectedCountries = value);
            },
            itemToString: (value) {
              final map = {
                'kr': 'South Korea',
                'us': 'United States',
                'ca': 'Canada',
                'uk': 'United Kingdom',
                'au': 'Australia',
                'jp': 'Japan',
              };
              return map[value] ?? value;
            },
          ),
        ),
        DemoSection(
          title: 'With Helper Text',
          description: 'Multi-select with helper text for guidance.',
          builder: (context) => CarbonMultiSelect<String>(
            label: 'Select features',
            hint: 'Choose features to enable',
            helperText: 'Select all features you want to enable',
            values: _selectedFeatures,
            items: const [
              CarbonMultiSelectItem(
                value: 'notifications',
                child: Text('Email notifications'),
              ),
              CarbonMultiSelectItem(
                value: 'darkmode',
                child: Text('Dark mode'),
              ),
              CarbonMultiSelectItem(
                value: 'autosave',
                child: Text('Auto-save'),
              ),
              CarbonMultiSelectItem(value: 'sync', child: Text('Cloud sync')),
              CarbonMultiSelectItem(
                value: 'offline',
                child: Text('Offline mode'),
              ),
            ],
            onChanged: (value) {
              setState(() => _selectedFeatures = value);
            },
            itemToString: (value) {
              final map = {
                'notifications': 'Email notifications',
                'darkmode': 'Dark mode',
                'autosave': 'Auto-save',
                'sync': 'Cloud sync',
                'offline': 'Offline mode',
              };
              return map[value] ?? value;
            },
          ),
        ),
        DemoSection(
          title: 'Filterable Multi-Select',
          description:
              'Multi-select with search/filter capability for long lists.',
          builder: (context) => CarbonMultiSelect<String>(
            label: 'Select categories',
            hint: 'Choose categories',
            filterable: true,
            values: _selectedCategories,
            items: const [
              CarbonMultiSelectItem(value: 'tech', child: Text('Technology')),
              CarbonMultiSelectItem(value: 'health', child: Text('Healthcare')),
              CarbonMultiSelectItem(value: 'finance', child: Text('Finance')),
              CarbonMultiSelectItem(
                value: 'education',
                child: Text('Education'),
              ),
              CarbonMultiSelectItem(value: 'retail', child: Text('Retail')),
              CarbonMultiSelectItem(
                value: 'manufacturing',
                child: Text('Manufacturing'),
              ),
              CarbonMultiSelectItem(value: 'energy', child: Text('Energy')),
              CarbonMultiSelectItem(
                value: 'telecom',
                child: Text('Telecommunications'),
              ),
              CarbonMultiSelectItem(
                value: 'transport',
                child: Text('Transportation'),
              ),
              CarbonMultiSelectItem(
                value: 'real-estate',
                child: Text('Real Estate'),
              ),
            ],
            onChanged: (value) {
              setState(() => _selectedCategories = value);
            },
            itemToString: (value) {
              final map = {
                'tech': 'Technology',
                'health': 'Healthcare',
                'finance': 'Finance',
                'education': 'Education',
                'retail': 'Retail',
                'manufacturing': 'Manufacturing',
                'energy': 'Energy',
                'telecom': 'Telecommunications',
                'transport': 'Transportation',
                'real-estate': 'Real Estate',
              };
              return map[value] ?? value;
            },
          ),
        ),
        DemoSection(
          title: 'Numbers Multi-Select',
          description: 'Multi-select with numeric values.',
          builder: (context) => CarbonMultiSelect<int>(
            label: 'Select priority levels',
            hint: 'Choose priority levels',
            values: _selectedNumbers,
            items: const [
              CarbonMultiSelectItem(value: 1, child: Text('1 - Critical')),
              CarbonMultiSelectItem(value: 2, child: Text('2 - High')),
              CarbonMultiSelectItem(value: 3, child: Text('3 - Medium')),
              CarbonMultiSelectItem(value: 4, child: Text('4 - Low')),
              CarbonMultiSelectItem(value: 5, child: Text('5 - Minimal')),
            ],
            onChanged: (value) {
              setState(() => _selectedNumbers = value);
            },
            itemToString: (value) {
              final map = {
                1: '1 - Critical',
                2: '2 - High',
                3: '3 - Medium',
                4: '4 - Low',
                5: '5 - Minimal',
              };
              return map[value] ?? value.toString();
            },
          ),
        ),
        DemoSection(
          title: 'Disabled Multi-Select',
          description: 'Multi-select in disabled state.',
          builder: (context) => CarbonMultiSelect<String>(
            label: 'Disabled multi-select',
            hint: 'This is disabled',
            enabled: false,
            values: const ['option1'],
            items: const [
              CarbonMultiSelectItem(value: 'option1', child: Text('Option 1')),
              CarbonMultiSelectItem(value: 'option2', child: Text('Option 2')),
            ],
            onChanged: (value) {},
            itemToString: (value) => value,
          ),
        ),
      ],
    );
  }
}
