import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonTag and Material Chip (Tag) components.
class TagDemoPage extends StatefulWidget {
  const TagDemoPage({super.key});

  @override
  State<TagDemoPage> createState() => _TagDemoPageState();
}

class _TagDemoPageState extends State<TagDemoPage> {
  final Set<String> _selectedFilters = {'all'};
  String _selectedChoice = 'option1';
  final List<String> _inputTags = ['Design', 'Development'];
  final List<CarbonTagType> _dismissibleTags = CarbonTagType.values.toList();

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Tag',
      description:
          'Tags are used to label, categorize, or organize items using keywords. '
          'CarbonTag is a native Carbon Design System implementation with 12 color variants and 3 sizes. '
          'Material Chip is also available with Carbon theming for filter/choice/input interactions.',
      sections: [
        // ── CarbonTag ──────────────────────────────────────────────────────

        DemoSection(
          title: 'CarbonTag — Color Variants',
          description:
              'All 12 Carbon tag color types with fixed IBM Design Language palette colors, '
              'independent of the active theme.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              CarbonTag(text: 'Red', type: CarbonTagType.red),
              CarbonTag(text: 'Magenta', type: CarbonTagType.magenta),
              CarbonTag(text: 'Purple', type: CarbonTagType.purple),
              CarbonTag(text: 'Blue', type: CarbonTagType.blue),
              CarbonTag(text: 'Cyan', type: CarbonTagType.cyan),
              CarbonTag(text: 'Teal', type: CarbonTagType.teal),
              CarbonTag(text: 'Green', type: CarbonTagType.green),
              CarbonTag(text: 'Gray', type: CarbonTagType.gray),
              CarbonTag(text: 'Cool Gray', type: CarbonTagType.coolGray),
              CarbonTag(text: 'Warm Gray', type: CarbonTagType.warmGray),
              CarbonTag(text: 'High Contrast', type: CarbonTagType.highContrast),
              CarbonTag(text: 'Outline', type: CarbonTagType.outline),
            ],
          ),
        ),
        DemoSection(
          title: 'CarbonTag — Size Variants',
          description: 'Three sizes: sm (18px), md (24px, default), lg (32px).',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              CarbonTag(text: 'Small', type: CarbonTagType.blue, size: CarbonTagSize.sm),
              CarbonTag(text: 'Medium', type: CarbonTagType.blue, size: CarbonTagSize.md),
              CarbonTag(text: 'Large', type: CarbonTagType.blue, size: CarbonTagSize.lg),
              CarbonTag(text: 'Small', type: CarbonTagType.green, size: CarbonTagSize.sm),
              CarbonTag(text: 'Medium', type: CarbonTagType.green, size: CarbonTagSize.md),
              CarbonTag(text: 'Large', type: CarbonTagType.green, size: CarbonTagSize.lg),
            ],
          ),
        ),
        DemoSection(
          title: 'CarbonTag — Dismissible',
          description: 'Tags with an onDismiss callback show a close button.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _dismissibleTags.map((type) {
              return CarbonTag(
                text: type.name,
                type: type,
                onDismiss: () {
                  setState(() => _dismissibleTags.remove(type));
                },
              );
            }).toList(),
          ),
        ),
        DemoSection(
          title: 'CarbonTag — Disabled',
          description:
              'Disabled tags dim the text and make the close button inert.',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              CarbonTag(text: 'Blue', type: CarbonTagType.blue, disabled: true),
              CarbonTag(text: 'Green', type: CarbonTagType.green, disabled: true),
              CarbonTag(
                text: 'Dismissible',
                type: CarbonTagType.gray,
                disabled: true,
                onDismiss: null,
              ),
              CarbonTag(
                text: 'High Contrast',
                type: CarbonTagType.highContrast,
                disabled: true,
              ),
            ],
          ),
        ),

        // ── Material Chip (with Carbon theming) ────────────────────────────

        DemoSection(
          title: 'Material Chip — Basic (with Carbon theming)',
          description:
              'Standard Material Chip widgets styled via the Carbon ChipThemeData. '
              'Use these when you need filter/choice/input chip interactions '
              'that integrate with Flutter\'s chip selection model.',
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
          title: 'Material FilterChip — Selectable',
          description: 'Multi-selectable chips for filtering content.',
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
          title: 'Material ChoiceChip — Single Select',
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
          title: 'Material InputChip — Removable',
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
                    _inputTags.add('Tag ${_inputTags.length + 1}');
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
