import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonContentSwitcher', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContentSwitcher(
            items: const [
              CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
              CarbonContentSwitcherItem(label: 'Option 2', value: '2'),
            ],
            selectedValue: '1',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(CarbonContentSwitcher), findsOneWidget);
    });

    testWidgets('displays all items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContentSwitcher(
            items: const [
              CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
              CarbonContentSwitcherItem(label: 'Option 2', value: '2'),
              CarbonContentSwitcherItem(label: 'Option 3', value: '3'),
            ],
            selectedValue: '1',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);
    });

    testWidgets('calls onChanged when item is selected', (tester) async {
      String? selectedValue = '1';

      await tester.pumpWidget(
        buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return CarbonContentSwitcher(
                items: const [
                  CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
                  CarbonContentSwitcherItem(label: 'Option 2', value: '2'),
                ],
                selectedValue: selectedValue!,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Option 2'));
      await tester.pump();

      expect(selectedValue, '2');
    });

    testWidgets('supports small size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContentSwitcher(
            items: const [
              CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
              CarbonContentSwitcherItem(label: 'Option 2', value: '2'),
            ],
            selectedValue: '1',
            size: CarbonContentSwitcherSize.small,
          ),
        ),
      );

      final switcher = tester.widget<CarbonContentSwitcher>(
        find.byType(CarbonContentSwitcher),
      );
      expect(switcher.size, CarbonContentSwitcherSize.small);
    });

    testWidgets('supports medium size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContentSwitcher(
            items: const [
              CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
              CarbonContentSwitcherItem(label: 'Option 2', value: '2'),
            ],
            selectedValue: '1',
            size: CarbonContentSwitcherSize.medium,
          ),
        ),
      );

      final switcher = tester.widget<CarbonContentSwitcher>(
        find.byType(CarbonContentSwitcher),
      );
      expect(switcher.size, CarbonContentSwitcherSize.medium);
    });

    testWidgets('supports large size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContentSwitcher(
            items: const [
              CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
              CarbonContentSwitcherItem(label: 'Option 2', value: '2'),
            ],
            selectedValue: '1',
            size: CarbonContentSwitcherSize.large,
          ),
        ),
      );

      final switcher = tester.widget<CarbonContentSwitcher>(
        find.byType(CarbonContentSwitcher),
      );
      expect(switcher.size, CarbonContentSwitcherSize.large);
    });

    testWidgets('supports fullWidth option', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContentSwitcher(
            items: const [
              CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
              CarbonContentSwitcherItem(label: 'Option 2', value: '2'),
            ],
            selectedValue: '1',
            fullWidth: true,
          ),
        ),
      );

      final switcher = tester.widget<CarbonContentSwitcher>(
        find.byType(CarbonContentSwitcher),
      );
      expect(switcher.fullWidth, isTrue);
    });

    testWidgets('disables items when disabled property is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContentSwitcher(
            items: const [
              CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
              CarbonContentSwitcherItem(
                label: 'Option 2',
                value: '2',
                disabled: true,
              ),
            ],
            selectedValue: '1',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('requires at least 2 items', (tester) async {
      expect(
        () => CarbonContentSwitcher(
          items: const [
            CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
          ],
          selectedValue: '1',
        ),
        throwsAssertionError,
      );
    });

    testWidgets('supports icon-only items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContentSwitcher(
            items: const [
              CarbonContentSwitcherItem(
                icon: Icon(Icons.grid_view),
                value: '1',
              ),
              CarbonContentSwitcherItem(icon: Icon(Icons.list), value: '2'),
            ],
            selectedValue: '1',
          ),
        ),
      );

      expect(find.byIcon(Icons.grid_view), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);
    });
  });

  group('CarbonContentSwitcherItem', () {
    test('creates item with label', () {
      const item = CarbonContentSwitcherItem(label: 'Test', value: '1');
      expect(item.label, 'Test');
      expect(item.value, '1');
      expect(item.disabled, isFalse);
    });

    test('creates icon-only item', () {
      const item = CarbonContentSwitcherItem(
        icon: Icon(Icons.settings),
        value: '1',
      );
      expect(item.icon, isNotNull);
      expect(item.isIconOnly, isTrue);
    });

    test('creates disabled item', () {
      const item = CarbonContentSwitcherItem(
        label: 'Test',
        value: '1',
        disabled: true,
      );
      expect(item.disabled, isTrue);
    });

    test('requires label or icon', () {
      expect(() => CarbonContentSwitcherItem(value: '1'), throwsAssertionError);
    });
  });

  group('CarbonContentSwitcherSize', () {
    test('has correct enum values', () {
      expect(CarbonContentSwitcherSize.values.length, 3);
      expect(
        CarbonContentSwitcherSize.values,
        contains(CarbonContentSwitcherSize.small),
      );
      expect(
        CarbonContentSwitcherSize.values,
        contains(CarbonContentSwitcherSize.medium),
      );
      expect(
        CarbonContentSwitcherSize.values,
        contains(CarbonContentSwitcherSize.large),
      );
    });
  });
}
