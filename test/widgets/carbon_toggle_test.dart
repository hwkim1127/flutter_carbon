import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonToggle', () {
    testWidgets('renders without error', (tester) async {
      bool value = false;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonToggle(
            value: value,
            onChanged: (newValue) {
              value = newValue;
            },
          ),
        ),
      );

      expect(find.byType(CarbonToggle), findsOneWidget);
    });

    testWidgets('displays on and off text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonToggle(
            value: false,
            onChanged: (_) {},
            onText: 'Enabled',
            offText: 'Disabled',
          ),
        ),
      );

      expect(find.text('Disabled'), findsOneWidget);
    });

    testWidgets('displays label text when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonToggle(
            value: false,
            onChanged: (_) {},
            labelText: 'Enable feature',
          ),
        ),
      );

      expect(find.text('Enable feature'), findsOneWidget);
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      bool value = false;

      await tester.pumpWidget(
        buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return CarbonToggle(
                value: value,
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                  });
                },
              );
            },
          ),
        ),
      );

      expect(value, isFalse);

      await tester.tap(find.byType(CarbonToggle));
      await tester.pumpAndSettle();

      expect(value, isTrue);
    });

    testWidgets('can be disabled', (tester) async {
      bool value = false;

      await tester.pumpWidget(
        buildTestApp(child: CarbonToggle(value: value, onChanged: null)),
      );

      final toggle = tester.widget<CarbonToggle>(find.byType(CarbonToggle));
      expect(toggle.enabled, isFalse);
    });

    testWidgets('can be read-only', (tester) async {
      bool value = false;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonToggle(value: value, onChanged: (_) {}, readOnly: true),
        ),
      );

      final toggle = tester.widget<CarbonToggle>(find.byType(CarbonToggle));
      expect(toggle.enabled, isFalse);
    });

    testWidgets('supports regular size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonToggle(
            value: false,
            onChanged: (_) {},
            size: CarbonToggleSize.regular,
          ),
        ),
      );

      final toggle = tester.widget<CarbonToggle>(find.byType(CarbonToggle));
      expect(toggle.size, CarbonToggleSize.regular);
    });

    testWidgets('supports small size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonToggle(
            value: false,
            onChanged: (_) {},
            size: CarbonToggleSize.small,
          ),
        ),
      );

      final toggle = tester.widget<CarbonToggle>(find.byType(CarbonToggle));
      expect(toggle.size, CarbonToggleSize.small);
    });

    testWidgets('can hide label visually', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonToggle(
            value: false,
            onChanged: (_) {},
            labelText: 'Hidden label',
            hideLabel: true,
          ),
        ),
      );

      final toggle = tester.widget<CarbonToggle>(find.byType(CarbonToggle));
      expect(toggle.hideLabel, isTrue);
    });

    testWidgets('value changes reflect in UI', (tester) async {
      bool value = false;

      await tester.pumpWidget(
        buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) {
              return CarbonToggle(
                value: value,
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                  });
                },
                onText: 'On',
                offText: 'Off',
              );
            },
          ),
        ),
      );

      expect(find.text('Off'), findsOneWidget);

      await tester.tap(find.byType(CarbonToggle));
      await tester.pumpAndSettle();

      expect(find.text('On'), findsOneWidget);
    });
  });

  group('CarbonToggleSize', () {
    test('has correct enum values', () {
      expect(CarbonToggleSize.values.length, 2);
      expect(CarbonToggleSize.values, contains(CarbonToggleSize.regular));
      expect(CarbonToggleSize.values, contains(CarbonToggleSize.small));
    });
  });
}
