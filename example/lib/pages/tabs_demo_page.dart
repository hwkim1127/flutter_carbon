import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Tabs functionality using Material's TabBar.
class TabsDemoPage extends StatefulWidget {
  const TabsDemoPage({super.key});

  @override
  State<TabsDemoPage> createState() => _TabsDemoPageState();
}

class _TabsDemoPageState extends State<TabsDemoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Tabs',
      description: 'Tabs organize content across different screens or views. '
          'Built using Material TabBar with Carbon theming.',
      sections: [
        DemoSection(
          title: 'Basic Tabs',
          description: 'Simple tab navigation with three tabs.',
          builder: (context) => DefaultTabController(
            length: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Details'),
                    Tab(text: 'Settings'),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: TabBarView(
                    children: [
                      Center(
                        child: Text(
                          'Overview content goes here',
                          style: TextStyle(
                            color: context.carbon.text.textSecondary,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Detailed information',
                          style: TextStyle(
                            color: context.carbon.text.textSecondary,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Settings panel',
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
        ),
        DemoSection(
          title: 'Tabs with Icons',
          description: 'Tabs can include icons alongside text.',
          builder: (context) => DefaultTabController(
            length: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  tabs: const [
                    Tab(icon: Icon(Icons.home), text: 'Home'),
                    Tab(icon: Icon(Icons.search), text: 'Search'),
                    Tab(icon: Icon(Icons.person), text: 'Profile'),
                    Tab(icon: Icon(Icons.settings), text: 'Settings'),
                  ],
                ),
                SizedBox(
                  height: 150,
                  child: TabBarView(
                    children: List.generate(
                      4,
                      (index) => Center(
                        child: Icon(
                          [
                            Icons.home,
                            Icons.search,
                            Icons.person,
                            Icons.settings,
                          ][index],
                          size: 48,
                          color: context.carbon.text.iconSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Scrollable Tabs',
          description: 'When there are many tabs, they become scrollable.',
          builder: (context) => DefaultTabController(
            length: 8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  isScrollable: true,
                  tabs: List.generate(
                    8,
                    (index) => Tab(text: 'Tab ${index + 1}'),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: TabBarView(
                    children: List.generate(
                      8,
                      (index) => Center(
                        child: Text(
                          'Content for Tab ${index + 1}',
                          style: TextStyle(
                            color: context.carbon.text.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Controlled Tabs',
          description: 'Programmatically control tab selection.',
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'First'),
                  Tab(text: 'Second'),
                  Tab(text: 'Third'),
                ],
              ),
              SizedBox(
                height: 150,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _tabController.animateTo(1),
                        child: const Text('Go to Second Tab'),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _tabController.animateTo(2),
                        child: const Text('Go to Third Tab'),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _tabController.animateTo(0),
                        child: const Text('Go to First Tab'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Icon-Only Tabs',
          description: 'Tabs with only icons, no text labels.',
          builder: (context) => DefaultTabController(
            length: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  tabs: const [
                    Tab(icon: Icon(Icons.dashboard)),
                    Tab(icon: Icon(Icons.article)),
                    Tab(icon: Icon(Icons.analytics)),
                    Tab(icon: Icon(Icons.notifications)),
                    Tab(icon: Icon(Icons.settings)),
                  ],
                ),
                SizedBox(
                  height: 100,
                  child: TabBarView(
                    children: [
                      'Dashboard',
                      'Articles',
                      'Analytics',
                      'Notifications',
                      'Settings',
                    ].map((name) {
                      return Center(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            color: context.carbon.text.textPrimary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
