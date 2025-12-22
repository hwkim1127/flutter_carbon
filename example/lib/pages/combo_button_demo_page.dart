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
              CarbonComboButton(
                label: 'Save',
                onPressed: () {
                  setState(() => _lastAction = 'Save');
                },
                menuItems: [
                  PopupMenuItem(
                    value: 'save-as',
                    child: const Text('Save as...'),
                  ),
                  PopupMenuItem(
                    value: 'save-copy',
                    child: const Text('Save a copy'),
                  ),
                  PopupMenuItem(
                    value: 'save-template',
                    child: const Text('Save as template'),
                  ),
                ],
                onMenuItemSelected: (value) {
                  setState(() => _lastMenuItem = value.toString());
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
          builder: (context) => CarbonComboButton(
            label: 'Export',
            size: CarbonComboButtonSize.large,
            onPressed: () {},
            menuItems: [
              PopupMenuItem(value: 'pdf', child: const Text('Export as PDF')),
              PopupMenuItem(value: 'csv', child: const Text('Export as CSV')),
              PopupMenuItem(value: 'json', child: const Text('Export as JSON')),
            ],
            onMenuItemSelected: (value) {},
          ),
        ),
        DemoSection(
          title: 'Medium Size',
          description: 'Combo button at 40px height',
          builder: (context) => CarbonComboButton(
            label: 'Publish',
            size: CarbonComboButtonSize.medium,
            onPressed: () {},
            menuItems: [
              PopupMenuItem(value: 'draft', child: const Text('Save as draft')),
              PopupMenuItem(
                value: 'schedule',
                child: const Text('Schedule for later'),
              ),
            ],
            onMenuItemSelected: (value) {},
          ),
        ),
        DemoSection(
          title: 'Small Size',
          description: 'Combo button at 32px height',
          builder: (context) => CarbonComboButton(
            label: 'Send',
            size: CarbonComboButtonSize.small,
            onPressed: () {},
            menuItems: [
              PopupMenuItem(
                value: 'send-copy',
                child: const Text('Send a copy'),
              ),
              PopupMenuItem(
                value: 'send-later',
                child: const Text('Send later'),
              ),
            ],
            onMenuItemSelected: (value) {},
          ),
        ),
        DemoSection(
          title: 'Disabled State',
          description: 'Combo button when disabled',
          builder: (context) => CarbonComboButton(
            label: 'Submit',
            disabled: true,
            onPressed: () {},
            menuItems: [
              PopupMenuItem(
                value: 'review',
                child: const Text('Submit for review'),
              ),
            ],
            onMenuItemSelected: (value) {},
          ),
        ),
        DemoSection(
          title: 'With Dividers',
          description: 'Menu with dividers separating actions',
          builder: (context) => CarbonComboButton(
            label: 'Actions',
            onPressed: () {},
            menuItems: [
              PopupMenuItem(value: 'edit', child: const Text('Edit')),
              PopupMenuItem(value: 'duplicate', child: const Text('Duplicate')),
              const PopupMenuDivider(),
              PopupMenuItem(value: 'share', child: const Text('Share')),
              PopupMenuItem(value: 'download', child: const Text('Download')),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.red)),
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
              CarbonComboButton(
                label: 'Create',
                onPressed: () {},
                menuItems: [
                  PopupMenuItem(
                    value: 'document',
                    child: const Text('New document'),
                  ),
                  PopupMenuItem(
                    value: 'folder',
                    child: const Text('New folder'),
                  ),
                  PopupMenuItem(
                    value: 'template',
                    child: const Text('From template'),
                  ),
                ],
                onMenuItemSelected: (value) {},
              ),
              CarbonComboButton(
                label: 'Download',
                size: CarbonComboButtonSize.medium,
                onPressed: () {},
                menuItems: [
                  PopupMenuItem(
                    value: 'original',
                    child: const Text('Original quality'),
                  ),
                  PopupMenuItem(
                    value: 'compressed',
                    child: const Text('Compressed'),
                  ),
                  PopupMenuItem(
                    value: 'zip',
                    child: const Text('Download as ZIP'),
                  ),
                ],
                onMenuItemSelected: (value) {},
              ),
              CarbonComboButton(
                label: 'Share',
                size: CarbonComboButtonSize.small,
                onPressed: () {},
                menuItems: [
                  PopupMenuItem(value: 'link', child: const Text('Copy link')),
                  PopupMenuItem(
                    value: 'email',
                    child: const Text('Share via email'),
                  ),
                  PopupMenuItem(
                    value: 'embed',
                    child: const Text('Get embed code'),
                  ),
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
