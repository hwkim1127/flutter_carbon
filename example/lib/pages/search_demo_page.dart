import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for the native CarbonSearch widget.
class SearchDemoPage extends StatefulWidget {
  const SearchDemoPage({super.key});

  @override
  State<SearchDemoPage> createState() => _SearchDemoPageState();
}

class _SearchDemoPageState extends State<SearchDemoPage> {
  String _searchQuery = '';
  String _lastEvent = 'No events yet';

  final List<String> _allItems = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
  ];

  List<String> get _filteredItems {
    if (_searchQuery.isEmpty) return _allItems;
    return _allItems
        .where(
          (item) => item.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Search',
      description:
          'Search allows users to find specific content. Native Carbon '
          'implementation: sizes, clear button, Escape handling, and an '
          'expandable variant.',
      sections: [
        DemoSection(
          title: 'Basic',
          description:
              'Default (md) search field. Escape clears the current text.',
          builder: (context) => const CarbonSearch(),
        ),
        DemoSection(
          title: 'Sizes',
          description: 'Extra small (24px) to large (48px).',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final size in CarbonSearchSize.values) ...[
                Text(
                  '${size.name} — ${size.height.toInt()}px',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.carbon.text.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                CarbonSearch(size: size),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
        DemoSection(
          title: 'Search with Results',
          description: 'Filtering a list as the user types.',
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonSearch(
                placeholder: 'Search fruits',
                onChanged: (value) => setState(() => _searchQuery = value),
                onClear: () => setState(() => _searchQuery = ''),
              ),
              if (_searchQuery.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.carbon.layer.borderSubtle01,
                    ),
                  ),
                  child: _filteredItems.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'No results',
                            style: TextStyle(
                              color: context.carbon.text.textSecondary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Text(_filteredItems[index]),
                          ),
                        ),
                ),
              ],
            ],
          ),
        ),
        DemoSection(
          title: 'Expandable',
          description:
              'Collapses to a square icon button; expands on click or '
              'keyboard focus, collapses again on blur or Escape while '
              'empty.',
          builder: (context) => Row(
            children: [
              Container(
                width: 300,
                color: context.carbon.layer.layer01,
                child: const CarbonSearch(expandable: true),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Disabled',
          description: 'Non-interactive with disabled colors.',
          builder: (context) => const CarbonSearch(disabled: true),
        ),
        DemoSection(
          title: 'Events',
          description: 'onChanged, onSubmitted and onClear callbacks.',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonSearch(
                placeholder: 'Type, submit, or clear',
                onChanged: (value) =>
                    setState(() => _lastEvent = 'onChanged: "$value"'),
                onSubmitted: (value) =>
                    setState(() => _lastEvent = 'onSubmitted: "$value"'),
                onClear: () => setState(() => _lastEvent = 'onClear'),
              ),
              const SizedBox(height: 12),
              Text(
                _lastEvent,
                style: TextStyle(
                  fontSize: 12,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
