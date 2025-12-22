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
