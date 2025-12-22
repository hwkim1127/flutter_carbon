import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonBreadcrumb', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonBreadcrumb(
            items: [
              CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
              const CarbonBreadcrumbItem(label: 'Current', isCurrent: true),
            ],
          ),
        ),
      );

      expect(find.byType(CarbonBreadcrumb), findsOneWidget);
    });

    testWidgets('displays all breadcrumb items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonBreadcrumb(
            items: [
              CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Products', onTap: () {}),
              const CarbonBreadcrumbItem(label: 'Details', isCurrent: true),
            ],
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Products'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
    });

    testWidgets('calls onTap when breadcrumb is tapped', (tester) async {
      bool homeTapped = false;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonBreadcrumb(
            items: [
              CarbonBreadcrumbItem(
                label: 'Home',
                onTap: () {
                  homeTapped = true;
                },
              ),
              const CarbonBreadcrumbItem(label: 'Current', isCurrent: true),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Home'));
      await tester.pump();

      expect(homeTapped, isTrue);
    });

    testWidgets('supports small size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonBreadcrumb(
            items: [
              CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
              const CarbonBreadcrumbItem(label: 'Current', isCurrent: true),
            ],
            size: CarbonBreadcrumbSize.small,
          ),
        ),
      );

      final breadcrumb = tester.widget<CarbonBreadcrumb>(
        find.byType(CarbonBreadcrumb),
      );
      expect(breadcrumb.size, CarbonBreadcrumbSize.small);
    });

    testWidgets('supports medium size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonBreadcrumb(
            items: [
              CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
              const CarbonBreadcrumbItem(label: 'Current', isCurrent: true),
            ],
            size: CarbonBreadcrumbSize.medium,
          ),
        ),
      );

      final breadcrumb = tester.widget<CarbonBreadcrumb>(
        find.byType(CarbonBreadcrumb),
      );
      expect(breadcrumb.size, CarbonBreadcrumbSize.medium);
    });

    testWidgets('marks current page correctly', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonBreadcrumb(
            items: [
              CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
              const CarbonBreadcrumbItem(label: 'Current', isCurrent: true),
            ],
          ),
        ),
      );

      final currentItem = CarbonBreadcrumbItem(
        label: 'Current',
        isCurrent: true,
      );
      expect(currentItem.isCurrent, isTrue);
    });

    testWidgets('supports noTrailingSlash option', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonBreadcrumb(
            items: [
              CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
              const CarbonBreadcrumbItem(label: 'Current', isCurrent: true),
            ],
            noTrailingSlash: true,
          ),
        ),
      );

      final breadcrumb = tester.widget<CarbonBreadcrumb>(
        find.byType(CarbonBreadcrumb),
      );
      expect(breadcrumb.noTrailingSlash, isTrue);
    });

    testWidgets('displays separator between items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonBreadcrumb(
            items: [
              CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
              CarbonBreadcrumbItem(label: 'Products', onTap: () {}),
              const CarbonBreadcrumbItem(label: 'Details', isCurrent: true),
            ],
          ),
        ),
      );

      expect(find.text('/'), findsWidgets);
    });

    testWidgets('requires at least one item', (tester) async {
      expect(() => CarbonBreadcrumb(items: const []), throwsAssertionError);
    });
  });

  group('CarbonBreadcrumbItem', () {
    test('creates item with label', () {
      const item = CarbonBreadcrumbItem(label: 'Test');
      expect(item.label, 'Test');
      expect(item.isCurrent, isFalse);
    });

    test('creates item with onTap callback', () {
      bool tapped = false;
      final item = CarbonBreadcrumbItem(
        label: 'Test',
        onTap: () {
          tapped = true;
        },
      );

      item.onTap?.call();
      expect(tapped, isTrue);
    });

    test('creates current page item', () {
      const item = CarbonBreadcrumbItem(label: 'Current', isCurrent: true);
      expect(item.isCurrent, isTrue);
    });
  });

  group('CarbonBreadcrumbSize', () {
    test('has correct enum values', () {
      expect(CarbonBreadcrumbSize.values.length, 2);
      expect(CarbonBreadcrumbSize.values, contains(CarbonBreadcrumbSize.small));
      expect(
        CarbonBreadcrumbSize.values,
        contains(CarbonBreadcrumbSize.medium),
      );
    });
  });
}
