import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

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

    testWidgets('menu floats over content without shifting layout',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Column(
            children: [
              CarbonMultiSelect<String>(
                label: 'Select',
                values: const [],
                items: const [
                  CarbonMultiSelectItem(value: '1', child: Text('Option 1')),
                ],
                onChanged: (_) {},
                itemToString: (v) => v,
              ),
              const Text('Content below'),
            ],
          ),
        ),
      );

      final positionBefore = tester.getTopLeft(find.text('Content below'));

      await tester.tap(find.byType(CarbonMultiSelect<String>));
      await tester.pumpAndSettle();

      // The menu is an overlay now — content below must not move.
      expect(find.text('Option 1'), findsOneWidget);
      expect(tester.getTopLeft(find.text('Content below')), positionBefore);
    });

    testWidgets('dismisses on tap outside, stays open on selection',
        (tester) async {
      List<String> selected = [];
      await tester.pumpWidget(
        buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => CarbonMultiSelect<String>(
              label: 'Select',
              values: selected,
              items: const [
                CarbonMultiSelectItem(value: 'a', child: Text('Item A')),
                CarbonMultiSelectItem(value: 'b', child: Text('Item B')),
              ],
              onChanged: (values) => setState(() => selected = values),
              itemToString: (v) => v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CarbonMultiSelect<String>));
      await tester.pumpAndSettle();
      expect(find.text('Item A'), findsOneWidget);

      // Selecting an item must keep the menu open (multi-select).
      await tester.tap(find.text('Item A'));
      await tester.pumpAndSettle();
      expect(selected, contains('a'));
      expect(find.text('Item B'), findsOneWidget);

      // Tapping outside must dismiss it.
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Item B'), findsNothing);
    });

    testWidgets('removes an open menu overlay when unmounted', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonMultiSelect<String>(
            values: const [],
            items: const [
              CarbonMultiSelectItem(value: '1', child: Text('Leaky?')),
            ],
            onChanged: (_) {},
            itemToString: (v) => v,
          ),
        ),
      );

      await tester.tap(find.byType(CarbonMultiSelect<String>));
      await tester.pumpAndSettle();
      expect(find.text('Leaky?'), findsOneWidget);

      await tester.pumpWidget(buildTestApp(child: const SizedBox()));
      await tester.pumpAndSettle();

      expect(find.text('Leaky?'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('menu width matches the field width', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SizedBox(
            width: 280,
            child: CarbonMultiSelect<String>(
              values: const [],
              items: const [
                CarbonMultiSelectItem(value: '1', child: Text('Option 1')),
              ],
              onChanged: (_) {},
              itemToString: (v) => v,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CarbonMultiSelect<String>));
      await tester.pumpAndSettle();

      // The options list sits inside the menu's 1px border on each side.
      expect(
        tester.getSize(find.byType(ListView)).width,
        closeTo(280, 2.5),
      );
    });

    testWidgets(
        'filter is focused on open (even when another widget held focus) '
        'and Escape closes the menu', (tester) async {
      final neighborFocus = FocusNode();
      addTearDown(neighborFocus.dispose);

      await tester.pumpWidget(
        buildTestApp(
          child: Column(
            children: [
              Focus(
                focusNode: neighborFocus,
                child: const SizedBox(width: 40, height: 40),
              ),
              CarbonMultiSelect<String>(
                filterable: true,
                values: const [],
                items: const [
                  CarbonMultiSelectItem(value: 'apple', child: Text('Apple')),
                  CarbonMultiSelectItem(value: 'banana', child: Text('Banana')),
                ],
                onChanged: (_) {},
                itemToString: (v) => v,
              ),
            ],
          ),
        ),
      );

      neighborFocus.requestFocus();
      await tester.pump();

      await tester.tap(find.byType(CarbonMultiSelect<String>));
      await tester.pumpAndSettle();

      // The filter field takes focus, so typing filters immediately.
      final filter = tester.widget<EditableText>(find.byType(EditableText));
      expect(filter.focusNode.hasFocus, isTrue);
      await tester.enterText(find.byType(EditableText), 'ban');
      await tester.pumpAndSettle();
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);

      // Escape closes and focus returns to the previous holder.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Banana'), findsNothing);
      expect(neighborFocus.hasPrimaryFocus, isTrue);
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

      // Should have a filter field (native editable, not Material TextField)
      expect(find.byType(EditableText), findsOneWidget);
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
            builder: (context, child) => CarbonMaterialBridge(child: child!),
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
