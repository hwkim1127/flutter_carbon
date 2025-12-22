import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonOverflowMenu', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonOverflowMenu(
            items: [
              CarbonOverflowMenuItem(label: 'Option 1', onTap: () {}),
              CarbonOverflowMenuItem(label: 'Option 2', onTap: () {}),
            ],
          ),
        ),
      );
      expect(find.byType(CarbonOverflowMenu), findsOneWidget);
    });

    testWidgets('displays menu icon', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonOverflowMenu(
            items: [CarbonOverflowMenuItem(label: 'Option 1', onTap: () {})],
          ),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('can use custom icon', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonOverflowMenu(
            icon: Icons.settings,
            items: [CarbonOverflowMenuItem(label: 'Option 1', onTap: () {})],
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('supports flipped mode', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonOverflowMenu(
            flipped: true,
            items: [CarbonOverflowMenuItem(label: 'Option 1', onTap: () {})],
          ),
        ),
      );

      final menu = tester.widget<CarbonOverflowMenu>(
        find.byType(CarbonOverflowMenu),
      );
      expect(menu.flipped, isTrue);
    });
  });

  group('CarbonOverflowMenuItem', () {
    test('creates item with label', () {
      final item = CarbonOverflowMenuItem(label: 'Test', onTap: () {});
      expect(item.label, 'Test');
    });

    test('supports danger kind', () {
      final item = CarbonOverflowMenuItem(
        label: 'Delete',
        onTap: () {},
        isDanger: true,
      );
      expect(item.isDanger, isTrue);
    });

    test('supports disabled state', () {
      final item = CarbonOverflowMenuItem(
        label: 'Disabled',
        onTap: () {},
        disabled: true,
      );
      expect(item.disabled, isTrue);
    });
  });
}
