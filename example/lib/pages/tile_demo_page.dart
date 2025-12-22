import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Tile functionality using Carbon's CarbonTile.
class TileDemoPage extends StatefulWidget {
  const TileDemoPage({super.key});

  @override
  State<TileDemoPage> createState() => _TileDemoPageState();
}

class _TileDemoPageState extends State<TileDemoPage> {
  int? _selectedTile;
  final Set<int> _multiSelectedTiles = {0};
  final Map<int, bool> _expandedStates = {};

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Tile',
      description:
          'Tiles are containers for organizing content. They support clickable, selectable, and expandable variants.',
      sections: [
        DemoSection(
          title: 'Base Tiles',
          description: 'Non-interactive tiles for displaying content.',
          builder: (context) => Column(
            children: [
              CarbonTile(
                title: 'Basic Tile',
                subtitle: 'Non-interactive content container',
                child: const Text(
                  'This is a base tile used for displaying information without interaction.',
                ),
              ),
              const SizedBox(height: 16),
              CarbonTile(
                leading: Icon(
                  Icons.info_outline,
                  color: context.carbon.text.iconPrimary,
                ),
                title: 'Tile with Icon',
                child: const Text('Tiles can include leading icons.'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Clickable Tiles',
          description: 'Tiles for navigation - the entire tile is clickable.',
          builder: (context) => Column(
            children: [
              CarbonTile.clickable(
                title: 'Navigate to Page',
                subtitle: 'Click anywhere on this tile',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tile clicked!')),
                  );
                },
                child: const Text('Clickable tiles are used for navigation.'),
              ),
              const SizedBox(height: 16),
              CarbonTile.clickable(
                leading: Icon(
                  Icons.arrow_forward,
                  color: context.carbon.text.iconPrimary,
                ),
                title: 'With Icon',
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Navigate!')));
                },
                child: const Text('Navigate to detailed view'),
              ),
              const SizedBox(height: 16),
              CarbonTile.clickable(
                title: 'Disabled Tile',
                disabled: true,
                onTap: () {},
                child: const Text('This tile is disabled'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Selectable Tiles (Single Select)',
          description: 'Select one tile from a group (radio button behavior).',
          builder: (context) => Column(
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CarbonTile.selectable(
                  title: 'Option ${index + 1}',
                  selected: _selectedTile == index,
                  onSelectedChanged: (selected) {
                    setState(() {
                      _selectedTile = selected ? index : null;
                    });
                  },
                  child: Text('Select this option for choice ${index + 1}'),
                ),
              );
            }),
          ),
        ),
        DemoSection(
          title: 'Selectable Tiles (Multi Select)',
          description:
              'Select multiple tiles from a group (checkbox behavior).',
          builder: (context) => Column(
            children: List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CarbonTile.selectable(
                  title: 'Feature ${index + 1}',
                  subtitle: 'Can select multiple',
                  selected: _multiSelectedTiles.contains(index),
                  onSelectedChanged: (selected) {
                    setState(() {
                      if (selected) {
                        _multiSelectedTiles.add(index);
                      } else {
                        _multiSelectedTiles.remove(index);
                      }
                    });
                  },
                  child: Text('Feature description ${index + 1}'),
                ),
              );
            }),
          ),
        ),
        DemoSection(
          title: 'Expandable Tiles',
          description: 'Tiles that reveal additional content when expanded.',
          builder: (context) => Column(
            children: List.generate(3, (index) {
              final isExpanded = _expandedStates[index] ?? false;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CarbonTile.expandable(
                  title: 'Section ${index + 1}',
                  subtitle: 'Click to expand',
                  expanded: isExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _expandedStates[index] = expanded;
                    });
                  },
                  expandedContent: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Additional Details',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: context.carbon.text.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This content is revealed when the tile is expanded. '
                          'It can contain any widgets including lists, forms, or images.',
                          style: TextStyle(
                            color: context.carbon.text.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: const Text('Click to see more details'),
                ),
              );
            }),
          ),
        ),
        DemoSection(
          title: 'Tiles with Rich Content',
          description: 'Tiles can contain various types of content.',
          builder: (context) => Column(
            children: [
              CarbonTile.clickable(
                leading: CircleAvatar(
                  backgroundColor: context.carbon.button.buttonPrimary,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                title: 'User Profile',
                subtitle: 'John Doe',
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
                child: const Text('View profile details'),
              ),
              const SizedBox(height: 16),
              CarbonTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.carbon.layer.supportInfo.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: context.carbon.layer.supportInfo,
                  ),
                ),
                title: 'Tip',
                child: const Text(
                  'Use tiles to organize related content into distinct, actionable units.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
