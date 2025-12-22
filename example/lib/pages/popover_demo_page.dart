import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonPopover component.
class PopoverDemoPage extends StatefulWidget {
  const PopoverDemoPage({super.key});

  @override
  State<PopoverDemoPage> createState() => _PopoverDemoPageState();
}

class _PopoverDemoPageState extends State<PopoverDemoPage> {
  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Popover',
      description:
          'Popovers are floating panels that display contextual information or actions.',
      sections: [
        DemoSection(
          title: 'Basic Popover',
          description: 'Simple popover with text content',
          builder: (context) => Center(
            child: CarbonPopover(
              content: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'This is a basic popover with some helpful information.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Show Popover'),
              ),
            ),
          ),
        ),
        DemoSection(
          title: 'Popover Alignments',
          description: 'Popovers can be aligned in different positions',
          builder: (context) => Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              CarbonPopover(
                alignment: CarbonPopoverAlignment.top,
                content: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Top aligned popover'),
                ),
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Top'),
                ),
              ),
              CarbonPopover(
                alignment: CarbonPopoverAlignment.bottom,
                content: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Bottom aligned popover'),
                ),
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Bottom'),
                ),
              ),
              CarbonPopover(
                alignment: CarbonPopoverAlignment.left,
                content: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Left aligned popover'),
                ),
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Left'),
                ),
              ),
              CarbonPopover(
                alignment: CarbonPopoverAlignment.right,
                content: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Right aligned popover'),
                ),
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Right'),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Popover with Caret',
          description: 'Popover with arrow pointer',
          builder: (context) => Center(
            child: CarbonPopover(
              caret: true,
              content: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'This popover has a caret (arrow pointer).',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('With Caret'),
              ),
            ),
          ),
        ),
        DemoSection(
          title: 'Popover with Drop Shadow',
          description: 'Popover with shadow for elevation',
          builder: (context) => Center(
            child: CarbonPopover(
              dropShadow: true,
              content: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'This popover has a drop shadow for visual depth.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('With Shadow'),
              ),
            ),
          ),
        ),
        DemoSection(
          title: 'Interactive Popover Content',
          description: 'Popover with interactive elements like buttons',
          builder: (context) => Center(
            child: CarbonPopover(
              content: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirm Action',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Are you sure you want to proceed?',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Action confirmed!'),
                              ),
                            );
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Interactive Content'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
