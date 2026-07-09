import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonDropdown', () {
    testWidgets('renders without error', (tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDropdown<String>(
            value: selectedValue,
            items: const [
              CarbonDropdownItem(value: 'option1', child: Text('Option 1')),
              CarbonDropdownItem(value: 'option2', child: Text('Option 2')),
            ],
            onChanged: (value) {
              selectedValue = value;
            },
          ),
        ),
      );

      expect(find.byType(CarbonDropdown<String>), findsOneWidget);
    });

    testWidgets('displays label when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDropdown<String>(
            value: null,
            label: 'Select an option',
            items: const [
              CarbonDropdownItem(value: 'option1', child: Text('Option 1')),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Select an option'), findsOneWidget);
    });

    testWidgets('displays hint when no value is selected', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDropdown<String>(
            value: null,
            hint: 'Choose an option',
            items: const [
              CarbonDropdownItem(value: 'option1', child: Text('Option 1')),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Choose an option'), findsOneWidget);
    });

    testWidgets('displays helper text when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDropdown<String>(
            value: null,
            helperText: 'This is helper text',
            items: const [
              CarbonDropdownItem(value: 'option1', child: Text('Option 1')),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('This is helper text'), findsOneWidget);
    });

    testWidgets('displays error text when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDropdown<String>(
            value: null,
            errorText: 'This field is required',
            items: const [
              CarbonDropdownItem(value: 'option1', child: Text('Option 1')),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('can be disabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDropdown<String>(
            value: null,
            enabled: false,
            items: const [
              CarbonDropdownItem(value: 'option1', child: Text('Option 1')),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      final dropdown = tester.widget<CarbonDropdown<String>>(
        find.byType(CarbonDropdown<String>),
      );
      expect(dropdown.enabled, isFalse);
    });

    testWidgets('displays selected value', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDropdown<String>(
            value: 'option2',
            items: const [
              CarbonDropdownItem(value: 'option1', child: Text('Option 1')),
              CarbonDropdownItem(value: 'option2', child: Text('Option 2')),
            ],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Option 2'), findsWidgets);
    });
  });

  group('CarbonDropdown opening upward', () {
    testWidgets('long menu near the screen bottom stays on screen and works', (
      tester,
    ) async {
      int? selected;

      await tester.pumpWidget(
        buildTestApp(
          child: Column(
            children: [
              const Spacer(),
              // Pinned to the bottom → the menu must open upward.
              CarbonDropdown<int>(
                label: 'Select a number',
                value: null,
                items: List.generate(
                  50,
                  (i) => CarbonDropdownItem(
                    value: i + 1,
                    child: Text('Option ${i + 1}'),
                  ),
                ),
                onChanged: (v) => selected = v,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(CarbonDropdown<int>));
      await tester.pumpAndSettle();

      // The menu (capped at 300px) must be visible above the trigger,
      // not items×height (=2000px) off-screen.
      expect(find.text('Option 1'), findsOneWidget);
      final menuItemTop = tester.getTopLeft(find.text('Option 1')).dy;
      expect(menuItemTop, greaterThanOrEqualTo(0));

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(selected, 1);
    });
  });

  group('CarbonDropdown flip decision', () {
    testWidgets('short menu with enough room below does not flip upward', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Column(
            children: [
              const Spacer(),
              CarbonDropdown<String>(
                label: 'Short',
                value: null,
                items: const [
                  CarbonDropdownItem(value: '1', child: Text('One')),
                  CarbonDropdownItem(value: '2', child: Text('Two')),
                ],
                onChanged: (_) {},
              ),
              // ~150px free below the trigger — more than the 2-item menu
              // needs, less than the 300px cap the old predicate compared to.
              const SizedBox(height: 150),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(CarbonDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.text('One'), findsOneWidget);
      final triggerBottom =
          tester.getBottomLeft(find.byType(CarbonDropdown<String>)).dy;
      final menuItemTop = tester.getTopLeft(find.text('One')).dy;
      expect(menuItemTop, greaterThan(triggerBottom - 1));
    });
  });

  group('CarbonDropdownItem', () {
    test('creates item with value and child', () {
      const item = CarbonDropdownItem<String>(
        value: 'test',
        child: Text('Test'),
      );

      expect(item.value, 'test');
      expect(item.child, isA<Text>());
    });
  });
}
