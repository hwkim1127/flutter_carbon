import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonPageHeader component.
class PageHeaderDemoPage extends StatefulWidget {
  const PageHeaderDemoPage({super.key});

  @override
  State<PageHeaderDemoPage> createState() => _PageHeaderDemoPageState();
}

class _PageHeaderDemoPageState extends State<PageHeaderDemoPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Page Header',
      description:
          'Provides a consistent header area for pages with title, breadcrumbs, description, and actions.',
      sections: [
        DemoSection(
          title: 'Basic Page Header',
          description: 'Simple page header with title only',
          builder: (context) => const CarbonPageHeader(title: 'Page Title'),
        ),
        DemoSection(
          title: 'With Subtitle',
          description: 'Page header with title and subtitle',
          builder: (context) => const CarbonPageHeader(
            title: 'Dashboard',
            subtitle: 'Overview of your workspace',
          ),
        ),
        DemoSection(
          title: 'With Description',
          description: 'Page header with additional description text',
          builder: (context) => const CarbonPageHeader(
            title: 'Project Settings',
            subtitle: 'Configure your project',
            description:
                'Manage project settings, team members, and integrations. Changes made here will affect all team members.',
          ),
        ),
        DemoSection(
          title: 'With Icon',
          description: 'Page header with icon next to title',
          builder: (context) => const CarbonPageHeader(
            title: 'Analytics',
            subtitle: 'View your data',
            icon: Icons.bar_chart,
          ),
        ),
        DemoSection(
          title: 'With Actions',
          description: 'Page header with action buttons',
          builder: (context) => CarbonPageHeader(
            title: 'Team Members',
            subtitle: '12 members',
            actions: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Export'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Member'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'With Breadcrumb',
          description: 'Page header with breadcrumb navigation',
          builder: (context) => CarbonPageHeader(
            title: 'Product Details',
            subtitle: 'SKU: ABC-123',
            breadcrumb: CarbonBreadcrumb(
              items: [
                CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
                CarbonBreadcrumbItem(label: 'Products', onTap: () {}),
                CarbonBreadcrumbItem(label: 'Product Details'),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'With Breadcrumb Border',
          description: 'Page header with bordered breadcrumb area',
          builder: (context) => CarbonPageHeader(
            title: 'Settings',
            subtitle: 'Configure your preferences',
            showBreadcrumbBorder: true,
            breadcrumb: CarbonBreadcrumb(
              items: [
                CarbonBreadcrumbItem(label: 'Dashboard', onTap: () {}),
                CarbonBreadcrumbItem(label: 'Settings'),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'With Tabs',
          description: 'Page header with tab navigation',
          builder: (context) => CarbonPageHeader(
            title: 'User Profile',
            subtitle: 'john.doe@example.com',
            icon: Icons.person,
            tabs: Row(
              children: [
                _TabButton(
                  label: 'Overview',
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _TabButton(
                  label: 'Activity',
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
                _TabButton(
                  label: 'Settings',
                  isSelected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'With Tabs and Tags',
          description: 'Page header with tabs and status tags',
          builder: (context) => CarbonPageHeader(
            title: 'Deployment',
            subtitle: 'Production environment',
            tabs: Row(
              children: [
                _TabButton(
                  label: 'Details',
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _TabButton(
                  label: 'Logs',
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
                _TabButton(
                  label: 'Metrics',
                  isSelected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                ),
              ],
            ),
            tags: [
              _StatusTag(label: 'Live', color: Colors.green),
              _StatusTag(label: 'v2.4.1', color: Colors.blue),
            ],
          ),
        ),
        DemoSection(
          title: 'Complete Example',
          description: 'Page header with all features combined',
          builder: (context) => CarbonPageHeader(
            title: 'Product Catalog',
            subtitle: '248 items',
            description:
                'Browse and manage your product inventory. Add new products, update existing ones, or remove discontinued items.',
            icon: Icons.inventory_2_outlined,
            showBreadcrumbBorder: true,
            breadcrumb: CarbonBreadcrumb(
              items: [
                CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
                CarbonBreadcrumbItem(label: 'Inventory', onTap: () {}),
                CarbonBreadcrumbItem(label: 'Products'),
              ],
            ),
            actions: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list, size: 16),
                label: const Text('Filter'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Export'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Product'),
              ),
            ],
            tabs: Row(
              children: [
                _TabButton(
                  label: 'All Products',
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _TabButton(
                  label: 'Active',
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
                _TabButton(
                  label: 'Discontinued',
                  isSelected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                ),
              ],
            ),
            tags: [_StatusTag(label: 'Updated Today', color: Colors.blue)],
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: widget.isSelected
                ? Border(
                    bottom: BorderSide(
                      color: carbon.layer.borderStrong01,
                      width: 2,
                    ),
                  )
                : null,
            color: _isHovered && !widget.isSelected
                ? carbon.layer.layerHover01
                : Colors.transparent,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.isSelected
                  ? carbon.text.textPrimary
                  : carbon.text.textSecondary,
              fontSize: 14,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
