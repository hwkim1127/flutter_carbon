import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonMultiSelect', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMultiSelect<String>(
            label: 'Select items',
            values: const [],
            items: const [
              CarbonMultiSelectItem(value: '1', child: Text('Item 1')),
              CarbonMultiSelectItem(value: '2', child: Text('Item 2')),
            ],
            onChanged: (_) {},
            itemToString: (v) => v,
          ),
        ),
      );

      expect(find.byType(CarbonMultiSelect<String>), findsOneWidget);
    });

    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMultiSelect<String>(
            label: 'Choose options',
            values: const [],
            items: const [],
            onChanged: (_) {},
            itemToString: (v) => v,
          ),
        ),
      );

      expect(find.text('Choose options'), findsOneWidget);
    });

    testWidgets('displays hint when no selection', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMultiSelect<String>(
            label: 'Select',
            hint: 'Please choose',
            values: const [],
            items: const [],
            onChanged: (_) {},
            itemToString: (v) => v,
          ),
        ),
      );

      expect(find.text('Please choose'), findsOneWidget);
    });

    testWidgets('displays helper text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMultiSelect<String>(
            label: 'Select',
            helperText: 'Select one or more items',
            values: const [],
            items: const [],
            onChanged: (_) {},
            itemToString: (v) => v,
          ),
        ),
      );

      expect(find.text('Select one or more items'), findsOneWidget);
    });

    testWidgets('shows selected items as chips', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMultiSelect<String>(
            label: 'Select',
            values: const ['a', 'b'],
            items: const [
              CarbonMultiSelectItem(value: 'a', child: Text('Item A')),
              CarbonMultiSelectItem(value: 'b', child: Text('Item B')),
              CarbonMultiSelectItem(value: 'c', child: Text('Item C')),
            ],
            onChanged: (_) {},
            itemToString: (v) =>
                {'a': 'Item A', 'b': 'Item B', 'c': 'Item C'}[v] ?? v,
          ),
        ),
      );

      // Chips should display selected items
      expect(find.text('Item A'), findsWidgets);
      expect(find.text('Item B'), findsWidgets);
    });

    testWidgets('opens dropdown when tapped', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMultiSelect<String>(
            label: 'Select',
            values: const [],
            items: const [
              CarbonMultiSelectItem(value: '1', child: Text('Option 1')),
              CarbonMultiSelectItem(value: '2', child: Text('Option 2')),
            ],
            onChanged: (_) {},
            itemToString: (v) => v,
          ),
        ),
      );

      // Tap to open dropdown
      await tester.tap(find.byType(CarbonMultiSelect<String>));
      await tester.pumpAndSettle();

      // Should show dropdown items
      expect(find.text('Option 1'), findsWidgets);
      expect(find.text('Option 2'), findsWidgets);
    });

    testWidgets('calls onChanged when item selected', (tester) async {
      List<String> selectedValues = [];

      await tester.pumpWidget(
        buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return CarbonMultiSelect<String>(
                label: 'Select',
                values: selectedValues,
                items: const [
                  CarbonMultiSelectItem(value: 'a', child: Text('Item A')),
                  CarbonMultiSelectItem(value: 'b', child: Text('Item B')),
                ],
                onChanged: (values) {
                  setState(() => selectedValues = values);
                },
                itemToString: (v) => v,
              );
            },
          ),
        ),
      );

      expect(selectedValues, isEmpty);

      // Open dropdown
      await tester.tap(find.byType(CarbonMultiSelect<String>));
      await tester.pumpAndSettle();

      // Select first item
      await tester.tap(find.text('Item A').first);
      await tester.pumpAndSettle();

      expect(selectedValues, contains('a'));
    });

    testWidgets('supports filterable mode', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMultiSelect<String>(
            label: 'Search',
            filterable: true,
            values: const [],
            items: const [
              CarbonMultiSelectItem(value: 'apple', child: Text('Apple')),
              CarbonMultiSelectItem(value: 'banana', child: Text('Banana')),
            ],
            onChanged: (_) {},
            itemToString: (v) => v,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(CarbonMultiSelect<String>));
      await tester.pumpAndSettle();

      // Should have a filter TextField
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('can be disabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMultiSelect<String>(
            label: 'Select',
            enabled: false,
            values: const [],
            items: const [],
            onChanged: (_) {},
            itemToString: (v) => v,
          ),
        ),
      );

      final widget = tester.widget<CarbonMultiSelect<String>>(
        find.byType(CarbonMultiSelect<String>),
      );
      expect(widget.enabled, isFalse);
    });

    testWidgets('works with different value types', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMultiSelect<int>(
            label: 'Numbers',
            values: const [1, 3],
            items: const [
              CarbonMultiSelectItem(value: 1, child: Text('One')),
              CarbonMultiSelectItem(value: 2, child: Text('Two')),
              CarbonMultiSelectItem(value: 3, child: Text('Three')),
            ],
            onChanged: (_) {},
            itemToString: (v) => v.toString(),
          ),
        ),
      );

      expect(find.byType(CarbonMultiSelect<int>), findsOneWidget);
    });

    testWidgets('works in all themes', (tester) async {
      for (final theme in [
        WhiteTheme.theme,
        G10Theme.theme,
        G90Theme.theme,
        G100Theme.theme,
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: carbonTheme(carbon: theme),
            home: Scaffold(
              body: CarbonMultiSelect<String>(
                label: 'Test',
                values: const [],
                items: const [],
                onChanged: (_) {},
                itemToString: (v) => v,
              ),
            ),
          ),
        );

        expect(find.byType(CarbonMultiSelect<String>), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });

  group('CarbonMultiSelectItem', () {
    test('can be created with required parameters', () {
      const item = CarbonMultiSelectItem<String>(
        value: 'test',
        child: Text('Test'),
      );

      expect(item.value, 'test');
      expect(item.child, isA<Text>());
    });

    test('supports disabled state', () {
      const item = CarbonMultiSelectItem<String>(
        value: 'test',
        child: Text('Test'),
        enabled: false,
      );

      expect(item.enabled, isFalse);
    });
  });
}
