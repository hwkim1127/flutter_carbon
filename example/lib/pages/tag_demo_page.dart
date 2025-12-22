import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Tag/Label functionality using Material's Chip widgets.
class TagDemoPage extends StatefulWidget {
  const TagDemoPage({super.key});

  @override
  State<TagDemoPage> createState() => _TagDemoPageState();
}

class _TagDemoPageState extends State<TagDemoPage> {
  final Set<String> _selectedFilters = {'all'};
  String _selectedChoice = 'option1';
  final List<String> _inputTags = ['Design', 'Development'];

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Tag / Label',
      description:
          'Tags categorize and label content. Built using Material Chip widgets with Carbon theming.',
      sections: [
        DemoSection(
          title: 'Basic Tags',
          description: 'Simple non-interactive tags for displaying categories.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              Chip(label: Text('Technology')),
              Chip(label: Text('Design')),
              Chip(label: Text('Business')),
              Chip(label: Text('Development')),
              Chip(label: Text('Marketing')),
            ],
          ),
        ),
        DemoSection(
          title: 'Tags with Avatars',
          description: 'Tags can include icons or avatars.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: Icon(
                  Icons.person,
                  size: 20,
                  color: context.carbon.text.iconPrimary,
                ),
                label: const Text('User'),
              ),
              Chip(
                avatar: Icon(
                  Icons.location_on,
                  size: 20,
                  color: context.carbon.text.iconPrimary,
                ),
                label: const Text('Location'),
              ),
              Chip(
                avatar: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: context.carbon.text.iconPrimary,
                ),
                label: const Text('Date'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Filter Chips',
          description: 'Selectable chips for filtering content.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: _selectedFilters.contains('all'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFilters.add('all');
                    } else {
                      _selectedFilters.remove('all');
                    }
                  });
                },
              ),
              FilterChip(
                label: const Text('Active'),
                selected: _selectedFilters.contains('active'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFilters.add('active');
                    } else {
                      _selectedFilters.remove('active');
                    }
                  });
                },
              ),
              FilterChip(
                label: const Text('Completed'),
                selected: _selectedFilters.contains('completed'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFilters.add('completed');
                    } else {
                      _selectedFilters.remove('completed');
                    }
                  });
                },
              ),
              FilterChip(
                label: const Text('Archived'),
                selected: _selectedFilters.contains('archived'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFilters.add('archived');
                    } else {
                      _selectedFilters.remove('archived');
                    }
                  });
                },
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Choice Chips',
          description: 'Single-select chips (radio button alternative).',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Option 1'),
                selected: _selectedChoice == 'option1',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedChoice = 'option1');
                },
              ),
              ChoiceChip(
                label: const Text('Option 2'),
                selected: _selectedChoice == 'option2',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedChoice = 'option2');
                },
              ),
              ChoiceChip(
                label: const Text('Option 3'),
                selected: _selectedChoice == 'option3',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedChoice = 'option3');
                },
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Input Chips',
          description: 'Removable chips often used in tag inputs.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._inputTags.map((tag) {
                return InputChip(
                  label: Text(tag),
                  onDeleted: () {
                    setState(() => _inputTags.remove(tag));
                  },
                );
              }),
              ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: const Text('Add Tag'),
                onPressed: () {
                  setState(() {
                    _inputTags.add('New Tag ${_inputTags.length + 1}');
                  });
                },
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Status Tags',
          description: 'Tags with different colors for status indication.',
          builder: (context) {
            final carbon = context.carbon;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  backgroundColor: carbon.layer.supportSuccess.withValues(
                    alpha: 0.1,
                  ),
                  label: Text(
                    'Success',
                    style: TextStyle(color: carbon.layer.supportSuccess),
                  ),
                ),
                Chip(
                  backgroundColor: carbon.layer.supportError.withValues(
                    alpha: 0.1,
                  ),
                  label: Text(
                    'Error',
                    style: TextStyle(color: carbon.layer.supportError),
                  ),
                ),
                Chip(
                  backgroundColor: carbon.layer.supportWarning.withValues(
                    alpha: 0.1,
                  ),
                  label: Text(
                    'Warning',
                    style: TextStyle(color: carbon.layer.supportWarning),
                  ),
                ),
                Chip(
                  backgroundColor: carbon.layer.supportInfo.withValues(
                    alpha: 0.1,
                  ),
                  label: Text(
                    'Info',
                    style: TextStyle(color: carbon.layer.supportInfo),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
