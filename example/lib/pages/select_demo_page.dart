import 'package:flutter/material.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Select/Dropdown functionality using Material's DropdownMenu.
class SelectDemoPage extends StatefulWidget {
  const SelectDemoPage({super.key});

  @override
  State<SelectDemoPage> createState() => _SelectDemoPageState();
}

class _SelectDemoPageState extends State<SelectDemoPage> {
  // String? _selectedFruit;
  // String? _selectedCountry;
  // String? _searchableSelection;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Select / Dropdown',
      description: 'Select menus allow users to choose from a list of options. '
          'Built using Material DropdownMenu with Carbon theming.',
      sections: [
        DemoSection(
          title: 'Basic Select',
          description: 'Simple dropdown selection.',
          builder: (context) => DropdownMenu<String>(
            label: const Text('Select a fruit'),
            hintText: 'Choose one',
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 'apple', label: 'Apple'),
              DropdownMenuEntry(value: 'banana', label: 'Banana'),
              DropdownMenuEntry(value: 'cherry', label: 'Cherry'),
              DropdownMenuEntry(value: 'date', label: 'Date'),
              DropdownMenuEntry(value: 'elderberry', label: 'Elderberry'),
            ],
            onSelected: (value) {
              // setState(() => _selectedFruit = value);
            },
          ),
        ),
        DemoSection(
          title: 'Select with Helper Text',
          description: 'Dropdown with additional helper information.',
          builder: (context) => DropdownMenu<String>(
            label: const Text('Country'),
            hintText: 'Select your country',
            helperText: 'Choose the country where you reside',
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 'kr', label: 'South Korea'),
              DropdownMenuEntry(value: 'us', label: 'United States'),
              DropdownMenuEntry(value: 'ca', label: 'Canada'),
              DropdownMenuEntry(value: 'au', label: 'Australia'),
              DropdownMenuEntry(value: 'jp', label: 'Japan'),
            ],
            onSelected: (value) {
              // setState(() => _selectedCountry = value);
            },
          ),
        ),
        DemoSection(
          title: 'Searchable Select',
          description: 'Dropdown with search/filter capability.',
          builder: (context) => DropdownMenu<String>(
            label: const Text('Select product'),
            hintText: 'Type to search...',
            enableFilter: true,
            enableSearch: true,
            requestFocusOnTap: true,
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 'laptop', label: 'Laptop Computer'),
              DropdownMenuEntry(value: 'desktop', label: 'Desktop Computer'),
              DropdownMenuEntry(value: 'tablet', label: 'Tablet Device'),
              DropdownMenuEntry(value: 'phone', label: 'Mobile Phone'),
              DropdownMenuEntry(value: 'monitor', label: 'Monitor Screen'),
              DropdownMenuEntry(value: 'keyboard', label: 'Keyboard'),
              DropdownMenuEntry(value: 'mouse', label: 'Computer Mouse'),
            ],
            onSelected: (value) {
              // setState(() => _searchableSelection = value);
            },
          ),
        ),
        DemoSection(
          title: 'Select with Icons',
          description: 'Dropdown items with leading icons.',
          builder: (context) => DropdownMenu<String>(
            label: const Text('Select action'),
            leadingIcon: const Icon(Icons.settings),
            dropdownMenuEntries: const [
              DropdownMenuEntry(
                value: 'edit',
                label: 'Edit',
                leadingIcon: Icon(Icons.edit),
              ),
              DropdownMenuEntry(
                value: 'copy',
                label: 'Copy',
                leadingIcon: Icon(Icons.copy),
              ),
              DropdownMenuEntry(
                value: 'share',
                label: 'Share',
                leadingIcon: Icon(Icons.share),
              ),
              DropdownMenuEntry(
                value: 'delete',
                label: 'Delete',
                leadingIcon: Icon(Icons.delete),
              ),
            ],
            onSelected: (value) {},
          ),
        ),
        DemoSection(
          title: 'Disabled Select',
          description: 'Dropdown in disabled state.',
          builder: (context) => DropdownMenu<String>(
            label: const Text('Disabled'),
            hintText: 'Cannot select',
            enabled: false,
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: '1', label: 'Option 1'),
              DropdownMenuEntry(value: '2', label: 'Option 2'),
            ],
            onSelected: null,
          ),
        ),
        DemoSection(
          title: 'Select in Form',
          description: 'Dropdown as part of a form layout.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                ),
              ),
              const SizedBox(height: 16),
              DropdownMenu<String>(
                label: const Text('Department'),
                hintText: 'Select department',
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'eng', label: 'Engineering'),
                  DropdownMenuEntry(value: 'design', label: 'Design'),
                  DropdownMenuEntry(value: 'product', label: 'Product'),
                  DropdownMenuEntry(value: 'sales', label: 'Sales'),
                ],
                onSelected: (value) {},
              ),
              const SizedBox(height: 16),
              DropdownMenu<String>(
                label: const Text('Role'),
                hintText: 'Select your role',
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'dev', label: 'Developer'),
                  DropdownMenuEntry(value: 'designer', label: 'Designer'),
                  DropdownMenuEntry(value: 'manager', label: 'Manager'),
                ],
                onSelected: (value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
