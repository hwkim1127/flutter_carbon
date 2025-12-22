import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Tooltip functionality using Material's Tooltip widget.
class TooltipDemoPage extends StatelessWidget {
  const TooltipDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Tooltip',
      description:
          'Tooltips display helpful text when users hover over or focus on UI elements. '
          'Built using Material Tooltip widget with Carbon theming.',
      sections: [
        DemoSection(
          title: 'Basic Tooltips',
          description: 'Simple tooltips on various widgets.',
          builder: (context) => Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              Tooltip(
                message: 'This is a tooltip',
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Hover Me'),
                ),
              ),
              Tooltip(
                message: 'Click to add item',
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ),
              Tooltip(
                message: 'Delete this item',
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Tooltips on Icons',
          description: 'Common pattern: tooltips explaining icon actions.',
          builder: (context) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: 'Edit',
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
              ),
              Tooltip(
                message: 'Save',
                child: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {},
                ),
              ),
              Tooltip(
                message: 'Share',
                child: IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ),
              Tooltip(
                message: 'Settings',
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Long Text Tooltips',
          description: 'Tooltips automatically wrap long text.',
          builder: (context) => Tooltip(
            message:
                'This is a longer tooltip message that provides more detailed '
                'information about the element. Tooltips will wrap text to fit.',
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Hover for Long Message'),
            ),
          ),
        ),
        DemoSection(
          title: 'Tooltips with Custom Wait Duration',
          description: 'Control how long before tooltip appears.',
          builder: (context) => Wrap(
            spacing: 16,
            children: [
              Tooltip(
                message: 'Instant tooltip',
                waitDuration: Duration.zero,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Instant'),
                ),
              ),
              Tooltip(
                message: 'Default delay (500ms)',
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Default'),
                ),
              ),
              Tooltip(
                message: 'Custom delay (1000ms)',
                waitDuration: const Duration(milliseconds: 1000),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Delayed'),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Different Tooltip Positions',
          description:
              'Tooltips can be positioned above, below, left, or right.',
          builder: (context) => Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              Tooltip(
                message: 'Tooltip above',
                preferBelow: false,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Above'),
                ),
              ),
              Tooltip(
                message: 'Tooltip below',
                preferBelow: true,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Below'),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Tooltips in Lists',
          description: 'Common use case: tooltips in list items.',
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Documents'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tooltip(
                      message: 'Download',
                      child: IconButton(
                        icon: const Icon(Icons.download, size: 20),
                        onPressed: () {},
                      ),
                    ),
                    Tooltip(
                      message: 'Share',
                      child: IconButton(
                        icon: const Icon(Icons.share, size: 20),
                        onPressed: () {},
                      ),
                    ),
                    Tooltip(
                      message: 'More options',
                      child: IconButton(
                        icon: const Icon(Icons.more_vert, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: context.carbon.layer.borderSubtle01),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Photos'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tooltip(
                      message: 'View',
                      child: IconButton(
                        icon: const Icon(Icons.visibility, size: 20),
                        onPressed: () {},
                      ),
                    ),
                    Tooltip(
                      message: 'Delete',
                      child: IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
