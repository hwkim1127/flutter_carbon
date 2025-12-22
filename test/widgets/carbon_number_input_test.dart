import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonNumberInput', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: CarbonNumberInput(value: 10, onChanged: (_) {})),
      );
      expect(find.byType(CarbonNumberInput), findsOneWidget);
    });

    testWidgets('displays current value', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: CarbonNumberInput(value: 42, onChanged: (_) {})),
      );
      expect(find.text('42.0'), findsOneWidget);
    });

    testWidgets('displays label when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonNumberInput(
            value: 10,
            label: 'Quantity',
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Quantity'), findsOneWidget);
    });

    testWidgets('displays helper text when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonNumberInput(
            value: 10,
            helperText: 'Enter a number',
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Enter a number'), findsOneWidget);
    });

    testWidgets('displays invalid text when invalid', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonNumberInput(
            value: 10,
            invalid: true,
            invalidText: 'Invalid value',
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Invalid value'), findsOneWidget);
    });

    testWidgets('calls onChanged when value changes', (tester) async {
      double? changedValue;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonNumberInput(
            value: 10,
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '20');
      expect(changedValue, isNotNull);
    });

    testWidgets('can be disabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonNumberInput(value: 10, disabled: true)),
      );

      final input = tester.widget<CarbonNumberInput>(
        find.byType(CarbonNumberInput),
      );
      expect(input.disabled, isTrue);
    });

    testWidgets('can be read-only', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonNumberInput(value: 10, readOnly: true)),
      );

      final input = tester.widget<CarbonNumberInput>(
        find.byType(CarbonNumberInput),
      );
      expect(input.readOnly, isTrue);
    });

    testWidgets('supports min value', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonNumberInput(value: 10, min: 5, onChanged: (_) {}),
        ),
      );

      final input = tester.widget<CarbonNumberInput>(
        find.byType(CarbonNumberInput),
      );
      expect(input.min, 5);
    });

    testWidgets('supports max value', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonNumberInput(value: 10, max: 100, onChanged: (_) {}),
        ),
      );

      final input = tester.widget<CarbonNumberInput>(
        find.byType(CarbonNumberInput),
      );
      expect(input.max, 100);
    });

    testWidgets('supports custom step value', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonNumberInput(value: 10, step: 5, onChanged: (_) {}),
        ),
      );

      final input = tester.widget<CarbonNumberInput>(
        find.byType(CarbonNumberInput),
      );
      expect(input.step, 5);
    });

    testWidgets('can hide steppers', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonNumberInput(
            value: 10,
            hideSteppers: true,
            onChanged: (_) {},
          ),
        ),
      );

      final input = tester.widget<CarbonNumberInput>(
        find.byType(CarbonNumberInput),
      );
      expect(input.hideSteppers, isTrue);
    });
  });
}
