import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonComboButton component.
class ComboButtonDemoPage extends StatefulWidget {
  const ComboButtonDemoPage({super.key});

  @override
  State<ComboButtonDemoPage> createState() => _ComboButtonDemoPageState();
}

class _ComboButtonDemoPageState extends State<ComboButtonDemoPage> {
  String _lastAction = 'None';
  String _lastMenuItem = 'None';

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Combo Button',
      description:
          'Split button that combines a primary action with a dropdown menu for additional actions.',
      sections: [
        DemoSection(
          title: 'Basic Combo Button',
          description: 'Primary button with dropdown menu',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonComboButton<String>(
                label: 'Save',
                onPressed: () {
                  setState(() => _lastAction = 'Save');
                },
                menuItems: const [
                  CarbonMenuItem(value: 'save-as', label: 'Save as...'),
                  CarbonMenuItem(value: 'save-copy', label: 'Save a copy'),
                  CarbonMenuItem(
                    value: 'save-template',
                    label: 'Save as template',
                  ),
                ],
                onMenuItemSelected: (value) {
                  setState(() => _lastMenuItem = value);
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Last action: $_lastAction',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
              Text(
                'Last menu item: $_lastMenuItem',
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Large Size (Default)',
          description: 'Combo button at 48px height',
          builder: (context) => CarbonComboButton<String>(
            label: 'Export',
            size: CarbonComboButtonSize.large,
            onPressed: () {},
            menuItems: const [
              CarbonMenuItem(value: 'pdf', label: 'Export as PDF'),
              CarbonMenuItem(value: 'csv', label: 'Export as CSV'),
              CarbonMenuItem(value: 'json', label: 'Export as JSON'),
            ],
            onMenuItemSelected: (value) {},
          ),
        ),
        DemoSection(
          title: 'Medium Size',
          description: 'Combo button at 40px height',
          builder: (context) => CarbonComboButton<String>(
            label: 'Publish',
            size: CarbonComboButtonSize.medium,
            onPressed: () {},
            menuItems: const [
              CarbonMenuItem(value: 'draft', label: 'Save as draft'),
              CarbonMenuItem(value: 'schedule', label: 'Schedule for later'),
            ],
            onMenuItemSelected: (value) {},
          ),
        ),
        DemoSection(
          title: 'Small Size',
          description: 'Combo button at 32px height',
          builder: (context) => CarbonComboButton<String>(
            label: 'Send',
            size: CarbonComboButtonSize.small,
            onPressed: () {},
            menuItems: const [
              CarbonMenuItem(value: 'send-copy', label: 'Send a copy'),
              CarbonMenuItem(value: 'send-later', label: 'Send later'),
            ],
            onMenuItemSelected: (value) {},
          ),
        ),
        DemoSection(
          title: 'Disabled State',
          description: 'Combo button when disabled',
          builder: (context) => CarbonComboButton<String>(
            label: 'Submit',
            disabled: true,
            onPressed: () {},
            menuItems: const [
              CarbonMenuItem(value: 'review', label: 'Submit for review'),
            ],
            onMenuItemSelected: (value) {},
          ),
        ),
        DemoSection(
          title: 'With Dividers and Danger Item',
          description: 'Menu with dividers and a destructive action',
          builder: (context) => CarbonComboButton<String>(
            label: 'Actions',
            onPressed: () {},
            menuItems: const [
              CarbonMenuItem(value: 'edit', label: 'Edit'),
              CarbonMenuItem(value: 'duplicate', label: 'Duplicate'),
              CarbonMenuItemDivider(),
              CarbonMenuItem(value: 'share', label: 'Share'),
              CarbonMenuItem(value: 'download', label: 'Download'),
              CarbonMenuItemDivider(),
              CarbonMenuItem(
                value: 'delete',
                label: 'Delete',
                kind: CarbonMenuItemKind.danger,
              ),
            ],
            onMenuItemSelected: (value) {},
          ),
        ),
        DemoSection(
          title: 'Common Use Cases',
          description: 'Examples of typical combo button usage',
          builder: (context) => Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              CarbonComboButton<String>(
                label: 'Create',
                onPressed: () {},
                menuItems: const [
                  CarbonMenuItem(value: 'document', label: 'New document'),
                  CarbonMenuItem(value: 'folder', label: 'New folder'),
                  CarbonMenuItem(value: 'template', label: 'From template'),
                ],
                onMenuItemSelected: (value) {},
              ),
              CarbonComboButton<String>(
                label: 'Download',
                size: CarbonComboButtonSize.medium,
                onPressed: () {},
                menuItems: const [
                  CarbonMenuItem(value: 'original', label: 'Original quality'),
                  CarbonMenuItem(value: 'compressed', label: 'Compressed'),
                  CarbonMenuItem(value: 'zip', label: 'Download as ZIP'),
                ],
                onMenuItemSelected: (value) {},
              ),
              CarbonComboButton<String>(
                label: 'Share',
                size: CarbonComboButtonSize.small,
                onPressed: () {},
                menuItems: const [
                  CarbonMenuItem(value: 'link', label: 'Copy link'),
                  CarbonMenuItem(value: 'email', label: 'Share via email'),
                  CarbonMenuItem(value: 'embed', label: 'Get embed code'),
                ],
                onMenuItemSelected: (value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
