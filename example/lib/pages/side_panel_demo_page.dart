import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

class SidePanelDemoPage extends StatelessWidget {
  const SidePanelDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Side Panel',
      description:
          'Side panels are slide-in panels from the left or right side. Use for auxiliary content or actions.',
      sections: [
        DemoSection(
          title: 'Basic Side Panel',
          description: 'Simple side panel with title and content.',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonSidePanel.show(
                context: context,
                title: 'Side Panel',
                subtitle: 'This is a simple side panel',
                builder: (context) => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'This is the content of the side panel. '
                    'You can put any widget here.',
                  ),
                ),
              );
            },
            child: const Text('Show Side Panel (Right)'),
          ),
        ),
        DemoSection(
          title: 'Left Placement',
          description: 'Side panel sliding from the left.',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonSidePanel.show(
                context: context,
                title: 'Left Side Panel',
                placement: CarbonSidePanelPlacement.left,
                builder: (context) => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('This panel slides in from the left.'),
                ),
              );
            },
            child: const Text('Show Side Panel (Left)'),
          ),
        ),
        DemoSection(
          title: 'With Label',
          description: 'Side panel with label above title.',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonSidePanel.show(
                context: context,
                label: 'OPTIONAL LABEL',
                title: 'Panel Title',
                subtitle: 'Panel subtitle with additional context',
                builder: (context) => ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text('This panel has a label, title, and subtitle.'),
                    const SizedBox(height: 16),
                    const Text(
                      'Labels are useful for categorization or context.',
                    ),
                  ],
                ),
              );
            },
            child: const Text('Show Panel with Label'),
          ),
        ),
        DemoSection(
          title: 'With Actions',
          description: 'Side panel with action buttons at the bottom.',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonSidePanel.show(
                context: context,
                title: 'Configure Settings',
                builder: (context) => ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const TextField(
                      decoration: InputDecoration(labelText: 'Setting 1'),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(labelText: 'Setting 2'),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(labelText: 'Setting 3'),
                    ),
                  ],
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings saved')),
                      );
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
            child: const Text('Show Panel with Actions'),
          ),
        ),
        DemoSection(
          title: 'Different Sizes',
          description: 'Side panels come in small, medium, and large sizes.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  CarbonSidePanel.show(
                    context: context,
                    title: 'Small Panel (256px)',
                    size: CarbonSidePanelSize.sm,
                    builder: (context) => const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('This is a small side panel.'),
                    ),
                  );
                },
                child: const Text('Small'),
              ),
              ElevatedButton(
                onPressed: () {
                  CarbonSidePanel.show(
                    context: context,
                    title: 'Medium Panel (512px)',
                    size: CarbonSidePanelSize.md,
                    builder: (context) => const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('This is a medium side panel.'),
                    ),
                  );
                },
                child: const Text('Medium'),
              ),
              ElevatedButton(
                onPressed: () {
                  CarbonSidePanel.show(
                    context: context,
                    title: 'Large Panel (768px)',
                    size: CarbonSidePanelSize.lg,
                    builder: (context) => const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('This is a large side panel.'),
                    ),
                  );
                },
                child: const Text('Large'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Non-Dismissible',
          description:
              'Side panel that cannot be dismissed by clicking outside.',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonSidePanel.show(
                context: context,
                title: 'Required Action',
                barrierDismissible: false,
                builder: (context) => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'This panel cannot be dismissed by clicking outside. '
                    'You must use the close button.',
                  ),
                ),
              );
            },
            child: const Text('Show Non-Dismissible'),
          ),
        ),
      ],
    );
  }
}
