import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonToggleTip component.
class ToggleTipDemoPage extends StatefulWidget {
  const ToggleTipDemoPage({super.key});

  @override
  State<ToggleTipDemoPage> createState() => _ToggleTipDemoPageState();
}

class _ToggleTipDemoPageState extends State<ToggleTipDemoPage> {
  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Toggle Tip',
      description:
          'Toggle tips are interactive tooltips that stay open when clicked, allowing users to interact with the content.',
      sections: [
        DemoSection(
          title: 'Basic Toggle Tip',
          description: 'Simple toggle tip with text content',
          builder: (context) => Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Hover or click for more info'),
                const SizedBox(width: 8),
                CarbonToggleTip(
                  content: const Text(
                    'This is a toggle tip with helpful information that stays open when you click it.',
                  ),
                  buttonLabel: 'More information',
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Toggle Tip with Label',
          description: 'Toggle tip with a visible label',
          builder: (context) => Center(
            child: CarbonToggleTip(
              label: 'Feature explanation',
              content: const Text(
                'This feature allows you to customize your experience with various settings and options.',
              ),
              buttonLabel: 'More about this feature',
            ),
          ),
        ),
        DemoSection(
          title: 'Toggle Tip with Actions',
          description: 'Toggle tip with interactive buttons',
          builder: (context) => Center(
            child: CarbonToggleTip(
              label: 'New feature',
              content: const Text(
                'We have added a new feature that improves your workflow.',
              ),
              actions: [
                TextButton(onPressed: () {}, child: const Text('Learn More')),
                FilledButton(onPressed: () {}, child: const Text('Got it')),
              ],
              buttonLabel: 'Learn about new feature',
            ),
          ),
        ),
        DemoSection(
          title: 'Toggle Tip Alignments',
          description: 'Toggle tips can be aligned in different positions',
          builder: (context) => Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              CarbonToggleTip(
                label: 'Top',
                alignment: CarbonPopoverAlignment.top,
                content: const Text('Top aligned toggle tip'),
                buttonLabel: 'Top toggle tip',
              ),
              CarbonToggleTip(
                label: 'Bottom',
                alignment: CarbonPopoverAlignment.bottom,
                content: const Text('Bottom aligned toggle tip'),
                buttonLabel: 'Bottom toggle tip',
              ),
              CarbonToggleTip(
                label: 'Left',
                alignment: CarbonPopoverAlignment.left,
                content: const Text('Left aligned toggle tip'),
                buttonLabel: 'Left toggle tip',
              ),
              CarbonToggleTip(
                label: 'Right',
                alignment: CarbonPopoverAlignment.right,
                content: const Text('Right aligned toggle tip'),
                buttonLabel: 'Right toggle tip',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Toggle Tip with Custom Icon',
          description: 'Toggle tip with a custom trigger icon',
          builder: (context) => Center(
            child: CarbonToggleTip(
              label: 'Help',
              triggerIcon: const Icon(Icons.help_outline, size: 16),
              content: const Text(
                'Click the help icon to get assistance with this feature.',
              ),
              buttonLabel: 'Help information',
            ),
          ),
        ),
        DemoSection(
          title: 'Toggle Tip Default Open',
          description: 'Toggle tip that is initially open',
          builder: (context) => Center(
            child: CarbonToggleTip(
              label: 'Welcome',
              defaultOpen: true,
              content: const Text(
                'This toggle tip is open by default. Click the close button or outside to dismiss.',
              ),
              buttonLabel: 'Welcome message',
            ),
          ),
        ),
      ],
    );
  }
}
