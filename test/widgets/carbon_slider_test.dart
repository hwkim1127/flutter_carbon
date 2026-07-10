import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonSlider math', () {
    test('snapValue snaps to the nearest step and clamps', () {
      expect(CarbonSlider.snapValue(47, 0, 100, 10), 50);
      expect(CarbonSlider.snapValue(44.9, 0, 100, 10), 40);
      expect(CarbonSlider.snapValue(-5, 0, 100, 1), 0);
      expect(CarbonSlider.snapValue(150, 0, 100, 1), 100);
      // Steps count from min, not from zero.
      expect(CarbonSlider.snapValue(7, 5, 25, 5), 5);
      expect(CarbonSlider.snapValue(8, 5, 25, 5), 10);
    });

    test('valueForRatio maps and clamps the ratio', () {
      expect(CarbonSlider.valueForRatio(0.25, 0, 100, 1), 25);
      expect(CarbonSlider.valueForRatio(-0.5, 0, 100, 1), 0);
      expect(CarbonSlider.valueForRatio(1.5, 0, 100, 1), 100);
      expect(CarbonSlider.valueForRatio(0.5, 0, 100, 10), 50);
    });
  });

  group('CarbonSlider interaction', () {
    /// Controlled harness: 400px track (total 488 = 400 + labels 14+42 +
    /// gaps 32 with the Ahem test font at body-compact-01 size 14).
    Widget harness({
      required double initial,
      double? initialUpper,
      double step = 1,
      bool disabled = false,
      bool readOnly = false,
      bool hideTextInput = true,
      double width = 488,
      TextDirection direction = TextDirection.ltr,
      List<CarbonSliderChange>? changes,
      List<CarbonSliderChange>? releases,
    }) {
      var value = initial;
      var valueUpper = initialUpper;
      return buildTestApp(
        child: Directionality(
          textDirection: direction,
          child: SizedBox(
            width: width,
            child: StatefulBuilder(
              builder: (context, setState) => CarbonSlider(
                min: 0,
                max: 100,
                value: value,
                valueUpper: valueUpper,
                step: step,
                hideTextInput: hideTextInput,
                disabled: disabled,
                readOnly: readOnly,
                onChanged: (change) {
                  changes?.add(change);
                  setState(() {
                    value = change.value;
                    valueUpper = change.valueUpper;
                  });
                },
                onRelease: (change) => releases?.add(change),
              ),
            ),
          ),
        ),
      );
    }

    Finder body() => find
        .descendant(
          of: find.byType(CarbonSlider),
          matching: find.byType(GestureDetector),
        )
        .first;

    testWidgets('track tap moves the handle to the snapped value', (
      tester,
    ) async {
      final changes = <CarbonSliderChange>[];
      final releases = <CarbonSliderChange>[];
      await tester.pumpWidget(
        harness(initial: 50, changes: changes, releases: releases),
      );

      final rect = tester.getRect(body());
      await tester.tapAt(Offset(rect.left + rect.width * 0.25, rect.center.dy));
      await tester.pumpAndSettle();

      expect(changes.last.value, 25);
      expect(releases, hasLength(1));
      expect(releases.single.value, 25);
    });

    testWidgets('dragging updates continuously and fires onRelease', (
      tester,
    ) async {
      final changes = <CarbonSliderChange>[];
      final releases = <CarbonSliderChange>[];
      await tester.pumpWidget(
        harness(initial: 50, changes: changes, releases: releases),
      );

      final rect = tester.getRect(body());
      final gesture = await tester.startGesture(
        Offset(rect.left + rect.width * 0.5, rect.center.dy),
      );
      await gesture.moveTo(Offset(rect.left + rect.width * 0.75, rect.center.dy));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(changes.last.value, 75);
      expect(releases.last.value, 75);
    });

    testWidgets('values snap to the step while dragging', (tester) async {
      final changes = <CarbonSliderChange>[];
      await tester.pumpWidget(
        harness(initial: 50, step: 10, changes: changes),
      );

      final rect = tester.getRect(body());
      // 43% of the track → 43 → snapped to 40; 47% → 50.
      await tester.tapAt(Offset(rect.left + rect.width * 0.43, rect.center.dy));
      await tester.pumpAndSettle();
      expect(changes.last.value, 40);

      await tester.tapAt(Offset(rect.left + rect.width * 0.47, rect.center.dy));
      await tester.pumpAndSettle();
      expect(changes.last.value, 50);
    });

    testWidgets('keyboard: arrows step, Shift multiplies, Home/End jump', (
      tester,
    ) async {
      final changes = <CarbonSliderChange>[];
      final releases = <CarbonSliderChange>[];
      await tester.pumpWidget(
        harness(initial: 50, changes: changes, releases: releases),
      );

      // Tab onto the (only) handle.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(changes.last.value, 51);
      // Arrow keyup fires onRelease.
      expect(releases, hasLength(1));

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump();
      expect(changes.last.value, 55);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(changes.last.value, 54);

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      expect(changes.last.value, 0);

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      expect(changes.last.value, 100);
    });

    testWidgets('RTL: dragging towards the left increases the value', (
      tester,
    ) async {
      final changes = <CarbonSliderChange>[];
      await tester.pumpWidget(
        harness(
          initial: 50,
          direction: TextDirection.rtl,
          changes: changes,
        ),
      );

      final rect = tester.getRect(body());
      // 25% from the LEFT edge = 75% logical in RTL → 75.
      await tester.tapAt(Offset(rect.left + rect.width * 0.25, rect.center.dy));
      await tester.pumpAndSettle();
      expect(changes.last.value, 75);
    });

    testWidgets('disabled and readOnly ignore gestures', (tester) async {
      for (final variant in ['disabled', 'readOnly']) {
        final changes = <CarbonSliderChange>[];
        await tester.pumpWidget(
          harness(
            initial: 50,
            disabled: variant == 'disabled',
            readOnly: variant == 'readOnly',
            changes: changes,
          ),
        );

        final rect = tester.getRect(body());
        await tester.tapAt(
          Offset(rect.left + rect.width * 0.25, rect.center.dy),
        );
        await tester.pumpAndSettle();
        expect(changes, isEmpty, reason: variant);
      }
    });

    testWidgets('slider semantics are emitted per handle', (tester) async {
      await tester.pumpWidget(harness(initial: 50, initialUpper: 80));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.slider == true,
        ),
        findsNWidgets(2),
      );
    });
  });

  group('CarbonSlider range mode', () {
    Widget rangeHarness({
      required List<CarbonSliderChange> changes,
      double initial = 20,
      double initialUpper = 80,
    }) {
      var value = initial;
      double? valueUpper = initialUpper;
      return buildTestApp(
        child: SizedBox(
          width: 488,
          child: StatefulBuilder(
            builder: (context, setState) => CarbonSlider(
              min: 0,
              max: 100,
              value: value,
              valueUpper: valueUpper,
              hideTextInput: true,
              onChanged: (change) {
                changes.add(change);
                setState(() {
                  value = change.value;
                  valueUpper = change.valueUpper;
                });
              },
            ),
          ),
        ),
      );
    }

    Finder body() => find
        .descendant(
          of: find.byType(CarbonSlider),
          matching: find.byType(GestureDetector),
        )
        .first;

    testWidgets('track tap moves the nearest handle', (tester) async {
      final changes = <CarbonSliderChange>[];
      await tester.pumpWidget(rangeHarness(changes: changes));

      final rect = tester.getRect(body());
      // 90% is nearest the upper handle (80).
      await tester.tapAt(Offset(rect.left + rect.width * 0.9, rect.center.dy));
      await tester.pumpAndSettle();
      expect(changes.last.value, 20);
      expect(changes.last.valueUpper, 90);

      // 10% is nearest the lower handle (20).
      await tester.tapAt(Offset(rect.left + rect.width * 0.1, rect.center.dy));
      await tester.pumpAndSettle();
      expect(changes.last.value, 10);
      expect(changes.last.valueUpper, 90);
    });

    testWidgets('handles cannot cross', (tester) async {
      final changes = <CarbonSliderChange>[];
      await tester.pumpWidget(rangeHarness(changes: changes));

      final rect = tester.getRect(body());
      // Grab the lower handle (at 20%) and drag past the upper (at 80%).
      final gesture = await tester.startGesture(
        Offset(rect.left + rect.width * 0.2, rect.center.dy),
      );
      await gesture.moveTo(
        Offset(rect.left + rect.width * 0.975, rect.center.dy),
      );
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(changes.last.value, 80); // clamped to valueUpper
      expect(changes.last.valueUpper, 80);
    });
  });

  group('CarbonSlider number input', () {
    Widget inputHarness({
      required List<CarbonSliderChange> changes,
      List<CarbonSliderChange>? releases,
    }) {
      var value = 50.0;
      return buildTestApp(
        child: SizedBox(
          width: 600,
          child: StatefulBuilder(
            builder: (context, setState) => CarbonSlider(
              min: 0,
              max: 100,
              value: value,
              onChanged: (change) {
                changes.add(change);
                setState(() => value = change.value);
              },
              onRelease: (change) => releases?.add(change),
            ),
          ),
        ),
      );
    }

    testWidgets('shows the current value and commits typed values', (
      tester,
    ) async {
      final changes = <CarbonSliderChange>[];
      final releases = <CarbonSliderChange>[];
      await tester.pumpWidget(
        inputHarness(changes: changes, releases: releases),
      );

      expect(find.text('50'), findsOneWidget);

      await tester.enterText(find.byType(EditableText), '72');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Exactly once — Enter also blurs, and the blur commit must not
      // re-fire the callbacks.
      expect(changes, hasLength(1));
      expect(changes.last.value, 72);
      expect(releases, hasLength(1));
      expect(releases.last.value, 72);
    });

    testWidgets('out-of-range input clamps on commit', (tester) async {
      final changes = <CarbonSliderChange>[];
      await tester.pumpWidget(inputHarness(changes: changes));

      await tester.enterText(find.byType(EditableText), '150');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(changes.last.value, 100);
      // The max label plus the committed input text.
      expect(find.text('100'), findsNWidgets(2));
    });

    testWidgets('unparsable input restores the current value', (
      tester,
    ) async {
      final changes = <CarbonSliderChange>[];
      await tester.pumpWidget(inputHarness(changes: changes));

      await tester.enterText(find.byType(EditableText), '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(changes, isEmpty);
      expect(find.text('50'), findsOneWidget);
    });
  });
}
