import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

/// Demo page for CarbonUIShell component.
class UIShellDemoPage extends StatefulWidget {
  const UIShellDemoPage({super.key});

  @override
  State<UIShellDemoPage> createState() => _UIShellDemoPageState();
}

class _UIShellDemoPageState extends State<UIShellDemoPage> {
  int _selectedHeaderIndex = 0;
  int _selectedSideNavIndex = 0;
  CarbonSideNavCollapseMode _collapseMode =
      CarbonSideNavCollapseMode.responsive;
  bool _showRightPanel = false;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return CarbonUIShell(
      appName: 'Carbon App',
      appNamePrefix: 'IBM',
      collapseMode: _collapseMode,
      initialSideNavExpanded: true,
      headerNavItems: [
        CarbonNavItem(
          label: 'Dashboard',
          isSelected: _selectedHeaderIndex == 0,
          onTap: () => setState(() => _selectedHeaderIndex = 0),
        ),
        CarbonNavItem(
          label: 'Analytics',
          isSelected: _selectedHeaderIndex == 1,
          onTap: () => setState(() => _selectedHeaderIndex = 1),
        ),
        CarbonNavItem(
          label: 'Reports',
          isSelected: _selectedHeaderIndex == 2,
          onTap: () => setState(() => _selectedHeaderIndex = 2),
        ),
      ],
      headerActions: [
        // Wrap actions in IconTheme and Theme to fix visibility
        Theme(
          data: Theme.of(context).copyWith(
            tooltipTheme: TooltipThemeData(
              decoration: BoxDecoration(
                color: carbon.layer.layer03,
                borderRadius: BorderRadius.circular(2),
              ),
              textStyle: TextStyle(
                color: carbon.text.textInverse,
                fontSize: 12,
              ),
              waitDuration: const Duration(milliseconds: 500),
            ),
          ),
          child: IconButtonTheme(
            data: IconButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                  carbon.uiShell.headerIconPrimary,
                ),
                iconSize: WidgetStateProperty.all(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                  tooltip: 'Search',
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                  tooltip: 'Notifications',
                ),
                IconButton(
                  icon: const Icon(Icons.account_circle_outlined),
                  onPressed: () {},
                  tooltip: 'Account',
                ),
              ],
            ),
          ),
        ),
      ],
      sideNavItems: [
        CarbonNavItem(
          label: 'Home',
          icon: Icons.home_outlined,
          isSelected: _selectedSideNavIndex == 0,
          onTap: () => setState(() => _selectedSideNavIndex = 0),
        ),
        CarbonNavItem(
          label: 'Projects',
          icon: Icons.folder_outlined,
          isSelected: _selectedSideNavIndex == 1,
          children: [
            CarbonNavItem(
              label: 'All Projects',
              onTap: () => setState(() => _selectedSideNavIndex = 1),
            ),
            CarbonNavItem(label: 'Recent', onTap: () {}),
            CarbonNavItem(label: 'Favorites', onTap: () {}),
          ],
        ),
        CarbonNavItem(
          label: 'Team',
          icon: Icons.people_outlined,
          isSelected: _selectedSideNavIndex == 2,
          onTap: () => setState(() => _selectedSideNavIndex = 2),
        ),
        CarbonNavItem(
          label: 'Settings',
          icon: Icons.settings_outlined,
          isSelected: _selectedSideNavIndex == 3,
          children: [
            CarbonNavItem(label: 'General', onTap: () {}),
            CarbonNavItem(label: 'Security', onTap: () {}),
            CarbonNavItem(
              label: 'Notifications',
              onTap: () => setState(() => _selectedSideNavIndex = 3),
            ),
          ],
        ),
        CarbonNavItem(
          label: 'Help',
          icon: Icons.help_outline,
          isSelected: _selectedSideNavIndex == 4,
          onTap: () => setState(() => _selectedSideNavIndex = 4),
        ),
      ],
      rightPanel: _showRightPanel
          ? Container(
              padding: const EdgeInsets.all(16),
              color: carbon.layer.layer01,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Panel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: carbon.text.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: carbon.text.iconPrimary),
                        onPressed: () =>
                            setState(() => _showRightPanel = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Additional content can be displayed here.',
                    style: TextStyle(color: carbon.text.textSecondary),
                  ),
                ],
              ),
            )
          : null,
      initialRightPanelOpen: _showRightPanel,
      child: Container(
        color: carbon.layer.layer01,
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            // Demo controls
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: carbon.layer.layer02,
                border: Border.all(color: carbon.layer.borderSubtle01),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UI Shell Demo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: carbon.text.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete navigation scaffold with header, side navigation, and content area.',
                    style: TextStyle(
                      fontSize: 14,
                      color: carbon.text.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Collapse Mode',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: carbon.text.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RadioGroup<CarbonSideNavCollapseMode>(
                    groupValue: _collapseMode,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _collapseMode = value);
                      }
                    },
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            'Fixed',
                            style: TextStyle(color: carbon.text.textPrimary),
                          ),
                          subtitle: Text(
                            'Side nav always visible at full width',
                            style: TextStyle(
                              color: carbon.text.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          leading: Radio<CarbonSideNavCollapseMode>(
                            value: CarbonSideNavCollapseMode.fixed,
                          ),
                          onTap: () => setState(
                            () =>
                                _collapseMode = CarbonSideNavCollapseMode.fixed,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Rail',
                            style: TextStyle(color: carbon.text.textPrimary),
                          ),
                          subtitle: Text(
                            'Side nav collapses to narrow rail with icons',
                            style: TextStyle(
                              color: carbon.text.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          leading: Radio<CarbonSideNavCollapseMode>(
                            value: CarbonSideNavCollapseMode.rail,
                          ),
                          onTap: () => setState(
                            () =>
                                _collapseMode = CarbonSideNavCollapseMode.rail,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Responsive',
                            style: TextStyle(color: carbon.text.textPrimary),
                          ),
                          subtitle: Text(
                            'Fully collapsible and responsive (default)',
                            style: TextStyle(
                              color: carbon.text.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          leading: Radio<CarbonSideNavCollapseMode>(
                            value: CarbonSideNavCollapseMode.responsive,
                          ),
                          onTap: () => setState(
                            () => _collapseMode =
                                CarbonSideNavCollapseMode.responsive,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        setState(() => _showRightPanel = !_showRightPanel),
                    child: Text(
                      _showRightPanel ? 'Hide Right Panel' : 'Show Right Panel',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Content sections
            _ContentSection(
              title: 'Features',
              items: [
                '48px header with app name and optional prefix',
                'Horizontal header navigation with selection state',
                'Vertical side navigation (256px expanded, 48px collapsed)',
                'Collapsible side nav with three modes: fixed, rail, responsive',
                'Submenu support in side navigation',
                'Optional right panel (320px width)',
                'Header action buttons',
                'Active state indicators (3px border for header, 4px for side nav)',
                'Smooth animations using Carbon motion tokens',
              ],
            ),
            const SizedBox(height: 24),

            _ContentSection(
              title: 'Current State',
              items: [
                'Header Nav: ${_getHeaderLabel(_selectedHeaderIndex)}',
                'Side Nav: ${_getSideNavLabel(_selectedSideNavIndex)}',
                'Collapse Mode: ${_collapseMode.name}',
                'Right Panel: ${_showRightPanel ? "Open" : "Closed"}',
              ],
            ),
            const SizedBox(height: 24),

            _ContentSection(
              title: 'Usage',
              items: [
                'Click the menu button (☰) to toggle side navigation',
                'Select items in header or side nav to see active states',
                'Try different collapse modes to see behavior changes',
                'Side nav items with children can be expanded',
                'Toggle the right panel to see additional content area',
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getHeaderLabel(int index) {
    const labels = ['Dashboard', 'Analytics', 'Reports'];
    return index < labels.length ? labels[index] : 'Unknown';
  }

  String _getSideNavLabel(int index) {
    const labels = ['Home', 'Projects', 'Team', 'Settings', 'Help'];
    return index < labels.length ? labels[index] : 'Unknown';
  }
}

class _ContentSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _ContentSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: carbon.layer.layer02,
        border: Border.all(color: carbon.layer.borderSubtle01),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: carbon.text.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: carbon.text.textPrimary)),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        color: carbon.text.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
