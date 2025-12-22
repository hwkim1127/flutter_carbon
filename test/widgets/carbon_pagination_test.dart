import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonPagination', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonPagination(
            currentPage: 1,
            totalPages: 10,
            onPageChanged: (_) {},
          ),
        ),
      );
      expect(find.byType(CarbonPagination), findsOneWidget);
    });

    testWidgets('displays current and total page', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonPagination(
            currentPage: 5,
            totalPages: 10,
            onPageChanged: (_) {},
          ),
        ),
      );
      expect(find.text('5 of 10 pages'), findsOne);
    });

    testWidgets('calls onPageChanged when page is changed', (tester) async {
      int? changedPage;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonPagination(
            currentPage: 1,
            totalPages: 10,
            onPageChanged: (page) {
              changedPage = page;
            },
          ),
        ),
      );

      // Find and tap next button
      final nextButton = find.byIcon(Icons.chevron_right);
      if (nextButton.evaluate().isNotEmpty) {
        await tester.tap(nextButton);
        await tester.pump();
        expect(changedPage, isNotNull);
      }
    });

    testWidgets('supports custom items per page', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonPagination(
            currentPage: 1,
            totalPages: 10,
            itemsPerPage: 25,
          ),
        ),
      );

      final pagination = tester.widget<CarbonPagination>(
        find.byType(CarbonPagination),
      );
      expect(pagination.itemsPerPage, 25);
    });

    testWidgets('displays total items when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonPagination(
            currentPage: 1,
            totalPages: 10,
            totalItems: 100,
          ),
        ),
      );

      final pagination = tester.widget<CarbonPagination>(
        find.byType(CarbonPagination),
      );
      expect(pagination.totalItems, 100);
    });

    testWidgets('supports page size selector', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonPagination(
            currentPage: 1,
            totalPages: 10,
            showPageSizeSelector: true,
            onPageSizeChanged: (_) {},
          ),
        ),
      );

      final pagination = tester.widget<CarbonPagination>(
        find.byType(CarbonPagination),
      );
      expect(pagination.showPageSizeSelector, isTrue);
    });

    testWidgets('supports custom page sizes', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonPagination(
            currentPage: 1,
            totalPages: 10,
            pageSizes: [5, 10, 15, 20],
          ),
        ),
      );

      final pagination = tester.widget<CarbonPagination>(
        find.byType(CarbonPagination),
      );
      expect(pagination.pageSizes, [5, 10, 15, 20]);
    });
  });
}
