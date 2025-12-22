import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonBreadcrumb component.
class BreadcrumbDemoPage extends StatefulWidget {
  const BreadcrumbDemoPage({super.key});

  @override
  State<BreadcrumbDemoPage> createState() => _BreadcrumbDemoPageState();
}

class _BreadcrumbDemoPageState extends State<BreadcrumbDemoPage> {
  String _currentPage = 'Settings';

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Breadcrumb',
      description:
          'Breadcrumbs show the path to the current page and allow users to navigate up the hierarchy.',
      sections: [
        DemoSection(
          title: 'Basic Breadcrumb',
          description: 'Simple breadcrumb navigation',
          builder: (context) => CarbonBreadcrumb(
            items: [
              CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Products', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Details', isCurrent: true),
            ],
          ),
        ),
        DemoSection(
          title: 'Interactive Breadcrumb',
          description: 'Breadcrumb with navigation functionality',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonBreadcrumb(
                items: [
                  CarbonBreadcrumbItem(
                    label: 'Dashboard',
                    onTap: () {
                      setState(() {
                        _currentPage = 'Dashboard';
                      });
                    },
                  ),
                  CarbonBreadcrumbItem(
                    label: 'Account',
                    onTap: () {
                      setState(() {
                        _currentPage = 'Account';
                      });
                    },
                  ),
                  CarbonBreadcrumbItem(
                    label: 'Settings',
                    isCurrent: _currentPage == 'Settings',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Current page: $_currentPage',
                style: TextStyle(
                  fontSize: 14,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Long Breadcrumb Path',
          description: 'Breadcrumb with many levels',
          builder: (context) => CarbonBreadcrumb(
            items: [
              CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Category', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Subcategory', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Product Type', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Product Name', isCurrent: true),
            ],
          ),
        ),
        DemoSection(
          title: 'Small Size Breadcrumb',
          description: 'Compact breadcrumb with smaller text',
          builder: (context) => CarbonBreadcrumb(
            size: CarbonBreadcrumbSize.small,
            items: [
              CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Products', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Details', isCurrent: true),
            ],
          ),
        ),
        DemoSection(
          title: 'Breadcrumb Without Trailing Slash',
          description: 'Breadcrumb with noTrailingSlash option',
          builder: (context) => CarbonBreadcrumb(
            noTrailingSlash: true,
            items: [
              CarbonBreadcrumbItem(label: 'Root', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Level 1', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Level 2', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Current Page', isCurrent: true),
            ],
          ),
        ),
      ],
    );
  }
}
