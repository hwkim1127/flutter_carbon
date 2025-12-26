import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Search functionality using Material's SearchBar and SearchAnchor.
class SearchDemoPage extends StatefulWidget {
  const SearchDemoPage({super.key});

  @override
  State<SearchDemoPage> createState() => _SearchDemoPageState();
}

class _SearchDemoPageState extends State<SearchDemoPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Search',
      description: 'Search allows users to find specific content. '
          'Built using Material SearchBar and SearchAnchor with Carbon theming.',
      sections: [
        DemoSection(
          title: 'Basic Search Bar',
          description: 'Simple search input field.',
          builder: (context) => SearchBar(
            controller: _searchController,
            hintText: 'Search...',
            leading: const Icon(Icons.search),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
        ),
        DemoSection(
          title: 'Search with Results',
          description: 'Search bar with filtered results display.',
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchBar(
                hintText: 'Search fruits...',
                leading: const Icon(Icons.search),
                trailing: _searchQuery.isNotEmpty
                    ? [
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        ),
                      ]
                    : null,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_filteredItems[index]),
                        onTap: () {
                          setState(() {
                            _searchQuery = _filteredItems[index];
                            _searchController.text = _filteredItems[index];
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        DemoSection(
          title: 'Search Anchor with Suggestions',
          description: 'Search with autocomplete suggestions.',
          builder: (context) => SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                hintText: 'Search with suggestions...',
                leading: const Icon(Icons.search),
                onTap: controller.openView,
                onChanged: (_) {
                  controller.openView();
                },
              );
            },
            suggestionsBuilder: (context, controller) {
              final keyword = controller.text.toLowerCase();
              if (keyword.isEmpty) {
                return _allItems.map((item) {
                  return ListTile(
                    leading: const Icon(Icons.search),
                    title: Text(item),
                    onTap: () {
                      controller.closeView(item);
                    },
                  );
                });
              }
              return _allItems.where((item) {
                return item.toLowerCase().contains(keyword);
              }).map((item) {
                return ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(item),
                  onTap: () {
                    controller.closeView(item);
                  },
                );
              });
            },
          ),
        ),
        DemoSection(
          title: 'Search with Recent Searches',
          description: 'Show recent search history.',
          builder: (context) {
            final List<String> recentSearches = ['Apple', 'Banana', 'Cherry'];

            return SearchAnchor(
              builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  hintText: 'Search (with history)...',
                  leading: const Icon(Icons.search),
                  onTap: controller.openView,
                );
              },
              suggestionsBuilder: (context, controller) {
                if (controller.text.isEmpty) {
                  // Show recent searches
                  return [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Recent Searches',
                        style: TextStyle(
                          fontSize: 12,
                          color: context.carbon.text.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ...recentSearches.map((search) {
                      return ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(search),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {},
                        ),
                        onTap: () {
                          controller.closeView(search);
                        },
                      );
                    }),
                  ];
                }
                // Show filtered results
                return _allItems.where((item) {
                  return item.toLowerCase().contains(
                        controller.text.toLowerCase(),
                      );
                }).map((item) {
                  return ListTile(
                    leading: const Icon(Icons.search),
                    title: Text(item),
                    onTap: () {
                      controller.closeView(item);
                    },
                  );
                });
              },
            );
          },
        ),
      ],
    );
  }
}
