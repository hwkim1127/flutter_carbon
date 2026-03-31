import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonTabs and Material TabBar components.
class TabsDemoPage extends StatefulWidget {
  const TabsDemoPage({super.key});

  @override
  State<TabsDemoPage> createState() => _TabsDemoPageState();
}

class _TabsDemoPageState extends State<TabsDemoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _carbonLineTab = 0;
  int _carbonContainedTab = 0;
  int _carbonExtendedTab = 0;

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
      description:
          'Tabs organize content across different screens or views. '
          'CarbonTabs is a native Carbon Design System implementation with Line and Contained variants. '
          'Material TabBar is also available with Carbon theming.',
      sections: [
        // ── CarbonTabs ────────────────────────────────────────────────────

        DemoSection(
          title: 'CarbonTabs — Line (default)',
          description:
              'Line tabs use an underline indicator. '
              'The selected tab is highlighted with a 2px bottom border.',
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonTabs(
                initialIndex: _carbonLineTab,
                tabs: const [
                  CarbonTab(label: 'Overview'),
                  CarbonTab(label: 'Details'),
                  CarbonTab(label: 'Settings'),
                ],
                onTabChanged: (i) => setState(() => _carbonLineTab = i),
              ),
              Container(
                height: 120,
                alignment: Alignment.center,
                child: Text(
                  ['Overview content', 'Details content', 'Settings content'][_carbonLineTab],
                  style: TextStyle(color: context.carbon.text.textSecondary),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'CarbonTabs — Line with extendLine',
          description:
              'The extendLine parameter stretches the bottom border across the full container width.',
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonTabs(
                initialIndex: _carbonExtendedTab,
                tabs: const [
                  CarbonTab(label: 'Tab One'),
                  CarbonTab(label: 'Tab Two'),
                  CarbonTab(label: 'Tab Three'),
                  CarbonTab(label: 'Tab Four'),
                ],
                extendLine: true,
                onTabChanged: (i) => setState(() => _carbonExtendedTab = i),
              ),
              Container(
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  'Content for Tab ${_carbonExtendedTab + 1}',
                  style: TextStyle(color: context.carbon.text.textSecondary),
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'CarbonTabs — Contained',
          description:
              'Contained tabs use a filled background indicator for higher visual emphasis.',
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonTabs(
                initialIndex: _carbonContainedTab,
                tabs: const [
                  CarbonTab(label: 'Overview'),
                  CarbonTab(label: 'Details'),
                  CarbonTab(label: 'Settings'),
                ],
                type: CarbonTabsType.contained,
                onTabChanged: (i) => setState(() => _carbonContainedTab = i),
              ),
              Container(
                height: 120,
                alignment: Alignment.center,
                child: Text(
                  ['Overview content', 'Details content', 'Settings content'][_carbonContainedTab],
                  style: TextStyle(color: context.carbon.text.textSecondary),
                ),
              ),
            ],
          ),
        ),

        // ── Material TabBar (with Carbon theming) ─────────────────────────

        DemoSection(
          title: 'Material TabBar (with Carbon theming)',
          description:
              'Standard Material TabBar styled via Carbon\'s TabBarTheme. '
              'Use when you need Material\'s swipe-to-navigate behaviour.',
          builder: (context) => DefaultTabController(
            length: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TabBar(
                  tabs: [
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
          title: 'Material TabBar — With Icons',
          description: 'Tabs can include icons alongside text.',
          builder: (context) => DefaultTabController(
            length: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TabBar(
                  tabs: [
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
          title: 'Material TabBar — Scrollable',
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
          title: 'Material TabBar — Programmatic Control',
          description: 'Programmatically control tab selection via TabController.',
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
      ],
    );
  }
}
