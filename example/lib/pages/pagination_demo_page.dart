import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonPagination component.
class PaginationDemoPage extends StatefulWidget {
  const PaginationDemoPage({super.key});

  @override
  State<PaginationDemoPage> createState() => _PaginationDemoPageState();
}

class _PaginationDemoPageState extends State<PaginationDemoPage> {
  int _currentPage = 1;
  int _pageSize = 10;
  final int _totalItems = 95;

  int get _totalPages => (_totalItems / _pageSize).ceil();

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Pagination',
      description:
          'Pagination allows users to navigate through pages of content.',
      sections: [
        DemoSection(
          title: 'Basic Pagination',
          description: 'Simple pagination with page navigation',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonPagination(
                currentPage: _currentPage,
                totalPages: _totalPages,
                totalItems: _totalItems,
                itemsPerPage: _pageSize,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Current page: $_currentPage of $_totalPages',
                style: TextStyle(
                  fontSize: 14,
                  color: context.carbon.text.textSecondary,
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Pagination with Content',
          description: 'Pagination controlling displayed content',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mock content list
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.carbon.layer.borderSubtle01,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    _pageSize.clamp(
                      1,
                      _totalItems - (_currentPage - 1) * _pageSize,
                    ),
                    (index) {
                      final itemNumber =
                          (_currentPage - 1) * _pageSize + index + 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Item $itemNumber',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.carbon.text.textPrimary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CarbonPagination(
                currentPage: _currentPage,
                totalPages: _totalPages,
                totalItems: _totalItems,
                itemsPerPage: _pageSize,
                showPageSizeSelector: true,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                onPageSizeChanged: (size) {
                  setState(() {
                    _pageSize = size;
                    _currentPage = 1; // Reset to first page
                  });
                },
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Large Dataset Pagination',
          description: 'Pagination with many pages',
          builder: (context) => CarbonPagination(
            currentPage: 1,
            totalPages: 100,
            totalItems: 1000,
            itemsPerPage: 10,
            onPageChanged: (page) {},
          ),
        ),
        DemoSection(
          title: 'Pagination with Page Size Selector',
          description: 'Allows changing items per page',
          builder: (context) => CarbonPagination(
            currentPage: 1,
            totalPages: 4,
            totalItems: 100,
            itemsPerPage: 25,
            showPageSizeSelector: true,
            pageSizes: const [10, 25, 50, 100],
            onPageChanged: (page) {},
            onPageSizeChanged: (size) {},
          ),
        ),
        DemoSection(
          title: 'Small Dataset',
          description: 'Pagination with fewer items',
          builder: (context) => CarbonPagination(
            currentPage: 1,
            totalPages: 3,
            totalItems: 25,
            itemsPerPage: 10,
            onPageChanged: (page) {},
          ),
        ),
        DemoSection(
          title: 'Single Page',
          description: 'Pagination with only one page',
          builder: (context) => CarbonPagination(
            currentPage: 1,
            totalPages: 1,
            totalItems: 5,
            itemsPerPage: 10,
            onPageChanged: (page) {},
          ),
        ),
      ],
    );
  }
}
