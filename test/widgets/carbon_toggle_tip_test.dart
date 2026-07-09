import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

import '../shared/build.dart';

void main() {
  group('CarbonToggleTip', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonToggleTip(content: const Text('Tooltip message')),
        ),
      );

      expect(find.byType(CarbonToggleTip), findsOneWidget);
    });

    testWidgets('has label when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonToggleTip(
            label: 'Help',
            content: const Text('Toggle message'),
          ),
        ),
      );

      expect(find.text('Help'), findsOneWidget);
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
            home: Scaffold(body: CarbonToggleTip(content: const Text('Test'))),
          ),
        );

        expect(find.byType(CarbonToggleTip), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('alignments position content on distinct sides', (
      tester,
    ) async {
      Future<Rect> openAndMeasure(CarbonPopoverAlignment alignment) async {
        await tester.pumpWidget(
          buildTestApp(
            child: Center(
              child: CarbonToggleTip(
                alignment: alignment,
                content: const Text('Tip'),
              ),
            ),
          ),
        );
        await tester.tap(find.byType(CarbonToggleTip));
        await tester.pumpAndSettle();
        expect(find.text('Tip'), findsOneWidget);
        final rect = tester.getRect(find.text('Tip'));
        // Close and tear down before the next variant.
        await tester.tapAt(const Offset(5, 5));
        await tester.pumpAndSettle();
        return rect;
      }

      await tester.pumpWidget(
        buildTestApp(
          child: Center(child: CarbonToggleTip(content: const Text('x'))),
        ),
      );
      final triggerRect = tester.getRect(find.byType(CarbonToggleTip));

      final top = await openAndMeasure(CarbonPopoverAlignment.top);
      expect(top.bottom, lessThan(triggerRect.top));

      final bottom = await openAndMeasure(CarbonPopoverAlignment.bottom);
      expect(bottom.top, greaterThan(triggerRect.bottom));

      final left = await openAndMeasure(CarbonPopoverAlignment.left);
      expect(left.right, lessThan(triggerRect.left));

      final right = await openAndMeasure(CarbonPopoverAlignment.right);
      expect(right.left, greaterThan(triggerRect.right));
    });

    testWidgets('flips to the other side at the screen edge', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Column(
            children: [
              // Pinned to the top → a top-aligned tip must flip below.
              CarbonToggleTip(
                alignment: CarbonPopoverAlignment.top,
                content: const Text('Tip'),
              ),
              const Spacer(),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(CarbonToggleTip));
      await tester.pumpAndSettle();

      final triggerBottom =
          tester.getBottomLeft(find.byType(CarbonToggleTip)).dy;
      final tipTop = tester.getTopLeft(find.text('Tip')).dy;
      expect(tipTop, greaterThan(triggerBottom));
    });
  });
}
