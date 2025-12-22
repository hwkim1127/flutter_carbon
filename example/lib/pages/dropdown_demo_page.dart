import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonDropdown component.
class DropdownDemoPage extends StatefulWidget {
  const DropdownDemoPage({super.key});

  @override
  State<DropdownDemoPage> createState() => _DropdownDemoPageState();
}

class _DropdownDemoPageState extends State<DropdownDemoPage> {
  String? _basicValue;
  String? _withIconValue;
  String? _countryValue;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Dropdown',
      description:
          'Dropdowns present a list of options from which a user can select one option.',
      sections: [
        DemoSection(
          title: 'Basic Dropdown',
          description: 'Simple dropdown with text options',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonDropdown<String>(
                label: 'Select an option',
                value: _basicValue,
                items: const [
                  CarbonDropdownItem(value: '1', child: Text('Option 1')),
                  CarbonDropdownItem(value: '2', child: Text('Option 2')),
                  CarbonDropdownItem(value: '3', child: Text('Option 3')),
                  CarbonDropdownItem(value: '4', child: Text('Option 4')),
                ],
                onChanged: (value) {
                  setState(() {
                    _basicValue = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              if (_basicValue != null)
                Text(
                  'Selected: $_basicValue',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.carbon.text.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        DemoSection(
          title: 'Dropdown with Helper Text',
          description: 'Dropdown with additional helper information',
          builder: (context) => CarbonDropdown<String>(
            label: 'Choose your country',
            helperText: 'Select the country where you reside',
            value: _countryValue,
            items: const [
              CarbonDropdownItem(value: 'kr', child: Text('South Korea')),
              CarbonDropdownItem(value: 'us', child: Text('United States')),
              CarbonDropdownItem(value: 'uk', child: Text('United Kingdom')),
              CarbonDropdownItem(value: 'ca', child: Text('Canada')),
              CarbonDropdownItem(value: 'au', child: Text('Australia')),
            ],
            onChanged: (value) {
              setState(() {
                _countryValue = value;
              });
            },
          ),
        ),
        DemoSection(
          title: 'Dropdown with Icons',
          description: 'Dropdown items with leading icons',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonDropdown<String>(
                label: 'Select action',
                value: _withIconValue,
                items: const [
                  CarbonDropdownItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  CarbonDropdownItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                  CarbonDropdownItem(
                    value: 'share',
                    child: Row(
                      children: [
                        Icon(Icons.share, size: 16),
                        SizedBox(width: 8),
                        Text('Share'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _withIconValue = value;
                  });
                },
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Disabled Dropdown',
          description: 'Dropdown in disabled state',
          builder: (context) => const CarbonDropdown<String>(
            label: 'Disabled dropdown',
            helperText: 'This dropdown is disabled',
            value: null,
            items: [
              CarbonDropdownItem(value: '1', child: Text('Option 1')),
              CarbonDropdownItem(value: '2', child: Text('Option 2')),
            ],
            enabled: false,
            onChanged: null,
          ),
        ),
        DemoSection(
          title: 'Invalid Dropdown',
          description: 'Dropdown with validation error',
          builder: (context) => const CarbonDropdown<String>(
            label: 'Required field',
            value: null,
            items: [
              CarbonDropdownItem(value: '1', child: Text('Option 1')),
              CarbonDropdownItem(value: '2', child: Text('Option 2')),
            ],
            errorText: 'This field is required',
            onChanged: null,
          ),
        ),
        DemoSection(
          title: 'Dropdown with Hint',
          description: 'Dropdown with placeholder text',
          builder: (context) => CarbonDropdown<String>(
            label: 'Select an option',
            hint: 'Please choose...',
            value: null,
            items: const [
              CarbonDropdownItem(value: '1', child: Text('Option 1')),
              CarbonDropdownItem(value: '2', child: Text('Option 2')),
              CarbonDropdownItem(value: '3', child: Text('Option 3')),
            ],
            onChanged: (value) {},
          ),
        ),
        DemoSection(
          title: 'Dropdown with Disabled Items',
          description: 'Some dropdown items are not selectable',
          builder: (context) => CarbonDropdown<String>(
            label: 'Select an option',
            helperText: 'Some options are disabled',
            value: null,
            items: const [
              CarbonDropdownItem(
                value: '1',
                child: Text('Option 1 (Available)'),
              ),
              CarbonDropdownItem(
                value: '2',
                child: Text('Option 2 (Disabled)'),
                enabled: false,
              ),
              CarbonDropdownItem(
                value: '3',
                child: Text('Option 3 (Available)'),
              ),
              CarbonDropdownItem(
                value: '4',
                child: Text('Option 4 (Disabled)'),
                enabled: false,
              ),
            ],
            onChanged: (value) {},
          ),
        ),
        DemoSection(
          title: 'Dropdown with Many Options',
          description: 'Scrollable dropdown with many items',
          builder: (context) => CarbonDropdown<int>(
            label: 'Select a number',
            value: null,
            items: List.generate(
              50,
              (index) => CarbonDropdownItem(
                value: index + 1,
                child: Text('Option ${index + 1}'),
              ),
            ),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}
