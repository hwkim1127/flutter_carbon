import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

import '../shared/build.dart';

void main() {
  group('CarbonTooltip', () {
    testWidgets('shows after hover enter delay and hides after exit delay',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTooltip(
            message: 'Helpful hint',
            child: SizedBox(width: 40, height: 40),
          ),
        ),
      );
      expect(find.text('Helpful hint'), findsNothing);

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: const Offset(600, 500));
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(CarbonTooltip)));
      await tester.pump();
      // Before the 100ms enter delay: not shown yet.
      expect(find.text('Helpful hint'), findsNothing);

      await tester.pump(const Duration(milliseconds: 150));
      expect(find.text('Helpful hint'), findsOneWidget);

      await gesture.moveTo(const Offset(600, 500));
      await tester.pump();
      // Before the 300ms leave delay: still visible.
      expect(find.text('Helpful hint'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      expect(find.text('Helpful hint'), findsNothing);
    });

    testWidgets('does not block taps on the trigger', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTooltip(
            message: 'Hint',
            child: GestureDetector(
              onTap: () => taps++,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox(width: 40, height: 40),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: const Offset(600, 500));
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byType(CarbonTooltip)));
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.text('Hint'), findsOneWidget);

      // The tooltip overlay must not intercept the click on the trigger.
      await tester.tap(find.byType(CarbonTooltip));
      expect(taps, 1);
    });

    testWidgets('removes the overlay when unmounted while visible',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTooltip(
            message: 'Leaky?',
            child: SizedBox(width: 40, height: 40),
          ),
        ),
      );

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: const Offset(600, 500));
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byType(CarbonTooltip)));
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.text('Leaky?'), findsOneWidget);

      await gesture.moveTo(const Offset(600, 500));
      await tester.pumpWidget(buildTestApp(child: const SizedBox()));
      await tester.pump();

      expect(find.text('Leaky?'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('works without Material (under CarbonApp)', (tester) async {
      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          home: const Center(
            child: CarbonTooltip(
              message: 'Material-free',
              child: SizedBox(width: 40, height: 40),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: const Offset(600, 500));
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byType(CarbonTooltip)));
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.text('Material-free'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
