import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonComboBox component.
class ComboBoxDemoPage extends StatefulWidget {
  const ComboBoxDemoPage({super.key});

  @override
  State<ComboBoxDemoPage> createState() => _ComboBoxDemoPageState();
}

class _ComboBoxDemoPageState extends State<ComboBoxDemoPage> {
  String? _selectedValue;
  String? _customValue;

  final List<CarbonComboBoxItem<String>> _countryItems = [
    const CarbonComboBoxItem(value: 'kr', label: 'South Korea'),
    const CarbonComboBoxItem(value: 'us', label: 'United States'),
    const CarbonComboBoxItem(value: 'uk', label: 'United Kingdom'),
    const CarbonComboBoxItem(value: 'ca', label: 'Canada'),
    const CarbonComboBoxItem(value: 'au', label: 'Australia'),
    const CarbonComboBoxItem(value: 'de', label: 'Germany'),
    const CarbonComboBoxItem(value: 'fr', label: 'France'),
    const CarbonComboBoxItem(value: 'jp', label: 'Japan'),
    const CarbonComboBoxItem(value: 'cn', label: 'China'),
    const CarbonComboBoxItem(value: 'in', label: 'India'),
    const CarbonComboBoxItem(value: 'br', label: 'Brazil'),
  ];

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Combo Box',
      description:
          'Combo boxes combine a text input with a dropdown, allowing users to search and select from a list.',
      sections: [
        DemoSection(
          title: 'Basic Combo Box',
          description: 'Searchable dropdown with filtering',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonComboBox<String>(
                label: 'Select a country',
                helperText: 'Type to search',
                items: _countryItems,
                value: _selectedValue,
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              if (_selectedValue != null)
                Text(
                  'Selected: ${_countryItems.firstWhere((item) => item.value == _selectedValue).label}',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.carbon.text.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        DemoSection(
          title: 'Combo Box with Placeholder',
          description: 'Custom placeholder text',
          builder: (context) => CarbonComboBox<String>(
            label: 'Search for a country',
            placeholder: 'Start typing to search...',
            items: _countryItems,
            value: null,
            onChanged: (value) {},
          ),
        ),
        DemoSection(
          title: 'Disabled Combo Box',
          description: 'Combo box in disabled state',
          builder: (context) => CarbonComboBox<String>(
            label: 'Disabled combo box',
            helperText: 'This combo box is disabled',
            items: _countryItems,
            value: null,
            enabled: false,
            onChanged: (value) {},
          ),
        ),
        DemoSection(
          title: 'Invalid Combo Box',
          description: 'Combo box with validation error',
          builder: (context) => CarbonComboBox<String>(
            label: 'Required field',
            items: _countryItems,
            value: null,
            errorText: 'Please select a country',
            onChanged: (value) {},
          ),
        ),
        DemoSection(
          title: 'Combo Box with Many Items',
          description: 'Efficient filtering with large datasets',
          builder: (context) => CarbonComboBox<int>(
            label: 'Select from many options',
            helperText: 'Type to filter the list',
            items: List.generate(
              100,
              (index) =>
                  CarbonComboBoxItem(value: index, label: 'Item ${index + 1}'),
            ),
            value: null,
            onChanged: (value) {},
          ),
        ),
        DemoSection(
          title: 'Combo Box with Clear Button',
          description: 'Allows clearing the selection',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonComboBox<String>(
                label: 'Select a country',
                helperText: 'Click the X to clear',
                items: _countryItems,
                value: _customValue,
                allowClear: true,
                onChanged: (value) {
                  setState(() {
                    _customValue = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              if (_customValue != null)
                Text(
                  'Selected: ${_countryItems.firstWhere((item) => item.value == _customValue).label}',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.carbon.text.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        DemoSection(
          title: 'Combo Box with Disabled Items',
          description: 'Some items are not selectable',
          builder: (context) => CarbonComboBox<String>(
            label: 'Select a country',
            helperText: 'Some options are disabled',
            items: const [
              CarbonComboBoxItem(value: 'kr', label: 'South Korea'),
              CarbonComboBoxItem(value: 'us', label: 'United States'),
              CarbonComboBoxItem(
                value: 'uk',
                label: 'United Kingdom (disabled)',
                enabled: false,
              ),
              CarbonComboBoxItem(value: 'ca', label: 'Canada'),
              CarbonComboBoxItem(
                value: 'au',
                label: 'Australia (disabled)',
                enabled: false,
              ),
              CarbonComboBoxItem(value: 'de', label: 'Germany'),
            ],
            value: null,
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}
