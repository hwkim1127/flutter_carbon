import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Accordion functionality using Material's ExpansionTile.
class AccordionDemoPage extends StatefulWidget {
  const AccordionDemoPage({super.key});

  @override
  State<AccordionDemoPage> createState() => _AccordionDemoPageState();
}

class _AccordionDemoPageState extends State<AccordionDemoPage> {
  int _expandedIndex = 0;
  final Set<int> _multiExpanded = {0};

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Accordion',
      description:
          'Accordions are vertically stacked lists of headers that reveal content when clicked. '
          'Built using Material ExpansionTile with Carbon theming.',
      sections: [
        DemoSection(
          title: 'Basic Accordion',
          description: 'Simple accordion with collapsible content.',
          builder: (context) => Column(
            children: [
              ExpansionTile(
                title: const Text('Section 1'),
                subtitle: const Text('Click to expand'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'This is the content of section 1. Accordions help organize content '
                      'and reduce scrolling when there are multiple sections.',
                      style: TextStyle(
                        color: context.carbon.text.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Section 2'),
                subtitle: const Text('Another expandable section'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Each section can contain any widget as content. This keeps the '
                      'interface clean and organized.',
                      style: TextStyle(
                        color: context.carbon.text.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Controlled Accordion',
          description:
              'Accordion with controlled expansion (only one open at a time).',
          builder: (context) => Column(
            children: List.generate(3, (index) {
              return ExpansionTile(
                key: PageStorageKey('accordion_$index'),
                title: Text('Section ${index + 1}'),
                subtitle: Text('Controlled expansion ${index + 1}'),
                initiallyExpanded: _expandedIndex == index,
                onExpansionChanged: (expanded) {
                  if (expanded) {
                    setState(() => _expandedIndex = index);
                  }
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Only one section can be expanded at a time. Opening this '
                      'section closes the others.',
                      style: TextStyle(
                        color: context.carbon.text.textSecondary,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        DemoSection(
          title: 'Multiple Expansion',
          description: 'Allow multiple sections to be expanded simultaneously.',
          builder: (context) => Column(
            children: List.generate(4, (index) {
              return ExpansionTile(
                key: PageStorageKey('multi_$index'),
                title: Text('Item ${index + 1}'),
                subtitle: Text('Can expand multiple at once'),
                initiallyExpanded: _multiExpanded.contains(index),
                onExpansionChanged: (expanded) {
                  setState(() {
                    if (expanded) {
                      _multiExpanded.add(index);
                    } else {
                      _multiExpanded.remove(index);
                    }
                  });
                },
                children: [
                  ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: const Text('Sub-item 1'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.check_circle_outline),
                    title: const Text('Sub-item 2'),
                    onTap: () {},
                  ),
                ],
              );
            }),
          ),
        ),
        DemoSection(
          title: 'With Icons and Actions',
          description: 'Accordion with leading icons and trailing actions.',
          builder: (context) => Column(
            children: [
              ExpansionTile(
                leading: Icon(
                  Icons.settings,
                  color: context.carbon.text.iconPrimary,
                ),
                title: const Text('Settings'),
                subtitle: const Text('Configure your preferences'),
                trailing: Icon(
                  Icons.keyboard_arrow_down,
                  color: context.carbon.text.iconPrimary,
                ),
                children: [
                  SwitchListTile(
                    title: const Text('Enable notifications'),
                    value: true,
                    onChanged: (value) {},
                  ),
                  SwitchListTile(
                    title: const Text('Dark mode'),
                    value: false,
                    onChanged: (value) {},
                  ),
                ],
              ),
              ExpansionTile(
                leading: Icon(
                  Icons.person,
                  color: context.carbon.text.iconPrimary,
                ),
                title: const Text('Profile'),
                subtitle: const Text('Manage your account'),
                children: [
                  ListTile(
                    title: const Text('Edit profile'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Change password'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Nested Accordions',
          description: 'Accordions can be nested within each other.',
          builder: (context) => ExpansionTile(
            title: const Text('Parent Section'),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ExpansionTile(
                  title: const Text('Child Section 1'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Nested content goes here',
                        style: TextStyle(
                          color: context.carbon.text.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ExpansionTile(
                  title: const Text('Child Section 2'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Another nested section',
                        style: TextStyle(
                          color: context.carbon.text.textSecondary,
                        ),
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
