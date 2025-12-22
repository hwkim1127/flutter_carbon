import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonPopover', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonPopover(
            content: const Text('Popover content'),
            child: const Text('Trigger'),
          ),
        ),
      );
      expect(find.byType(CarbonPopover), findsOneWidget);
      expect(find.text('Trigger'), findsOneWidget);
    });

    testWidgets('displays child widget', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonPopover(
            content: const Text('Content'),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Button'),
            ),
          ),
        ),
      );
      expect(find.text('Button'), findsOneWidget);
    });

    testWidgets('can show caret', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonPopover(
            caret: true,
            content: Text('Content'),
            child: Text('Trigger'),
          ),
        ),
      );

      final popover = tester.widget<CarbonPopover>(find.byType(CarbonPopover));
      expect(popover.caret, isTrue);
    });

    testWidgets('supports different alignments', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonPopover(
            content: Text('Content'),
            alignment: CarbonPopoverAlignment.top,
            child: Text('Trigger'),
          ),
        ),
      );

      final popover = tester.widget<CarbonPopover>(find.byType(CarbonPopover));
      expect(popover.alignment, CarbonPopoverAlignment.top);
    });

    testWidgets('can use high contrast mode', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonPopover(
            content: Text('Content'),
            highContrast: true,
            child: Text('Trigger'),
          ),
        ),
      );

      final popover = tester.widget<CarbonPopover>(find.byType(CarbonPopover));
      expect(popover.highContrast, isTrue);
    });
  });

  group('CarbonPopoverAlignment', () {
    test('has all alignment options', () {
      expect(CarbonPopoverAlignment.values.isNotEmpty, isTrue);
    });
  });
}
