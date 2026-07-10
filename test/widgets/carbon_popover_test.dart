import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
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

    testWidgets('Escape closes an open popover (mouse-opened, no prior '
        'keyboard focus)', (tester) async {
      var closed = 0;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonPopover(
            content: const Text('Popover content'),
            onClose: () => closed++,
            child: const Text('Trigger'),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsNothing);
      expect(closed, 1);
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

    testWidgets('opens when the trigger is an interactive button', (
      tester,
    ) async {
      var buttonPressed = false;

      await tester.pumpWidget(
        buildTestApp(
          child: Center(
            child: CarbonPopover(
              content: const Text('Popover content'),
              child: ElevatedButton(
                onPressed: () => buttonPressed = true,
                child: const Text('Show Popover'),
              ),
            ),
          ),
        ),
      );

      // The button's own tap recognizer must not swallow the popover's tap.
      await tester.tap(find.text('Show Popover'));
      await tester.pumpAndSettle();

      expect(find.text('Popover content'), findsOneWidget);
      expect(buttonPressed, isTrue);

      // The popover must sit below the trigger, not on top of it.
      final triggerBottom =
          tester.getBottomLeft(find.byType(ElevatedButton)).dy;
      final popoverTop = tester.getTopLeft(find.text('Popover content')).dy;
      expect(popoverTop, greaterThan(triggerBottom));

      // Tapping outside closes it.
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets('scroll-drag on the trigger does not open it, next tap works', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: ListView(
            children: [
              const SizedBox(height: 100),
              Center(
                child: CarbonPopover(
                  content: const Text('Popover content'),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Show Popover'),
                  ),
                ),
              ),
              const SizedBox(height: 2000),
            ],
          ),
        ),
      );

      // A scroll that starts on the trigger must not toggle the popover
      // (and must not corrupt gesture state for subsequent taps).
      await tester.drag(find.text('Show Popover'), const Offset(0, -150));
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsNothing);

      await tester.drag(find.byType(ListView), const Offset(0, 150));
      await tester.pumpAndSettle();

      // The next plain tap still opens it.
      await tester.tap(find.text('Show Popover'));
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('bottom-aligned popover flips above near the screen bottom', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Column(
            children: [
              const Spacer(),
              // Pinned to the bottom → no room below, must flip upward.
              CarbonPopover(
                alignment: CarbonPopoverAlignment.bottom,
                content: const Text('Flipped content'),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Bottom'),
                ),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Bottom'));
      await tester.pumpAndSettle();

      expect(find.text('Flipped content'), findsOneWidget);
      final triggerTop = tester.getTopLeft(find.byType(ElevatedButton)).dy;
      final popoverBottom =
          tester.getBottomLeft(find.text('Flipped content')).dy;
      // Fully visible above the trigger, on screen.
      expect(popoverBottom, lessThan(triggerTop));
      expect(tester.getTopLeft(find.text('Flipped content')).dy,
          greaterThanOrEqualTo(0));
    });

    testWidgets('right-aligned popover flips left near the screen edge', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Align(
            alignment: Alignment.centerRight,
            child: CarbonPopover(
              alignment: CarbonPopoverAlignment.right,
              content: const Text('Side content'),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Right'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Right'));
      await tester.pumpAndSettle();

      expect(find.text('Side content'), findsOneWidget);
      final screenWidth = tester.view.physicalSize.width /
          tester.view.devicePixelRatio;
      final popoverRight = tester.getBottomRight(find.text('Side content')).dx;
      // Fully on screen (flipped to the left of the trigger).
      expect(popoverRight, lessThanOrEqualTo(screenWidth));
      final triggerLeft = tester.getTopLeft(find.byType(ElevatedButton)).dx;
      expect(popoverRight, lessThan(triggerLeft));
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
