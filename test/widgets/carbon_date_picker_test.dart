import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import 'package:flutter_carbon/src/widgets/carbon_calendar_panel.dart';

import '../shared/build.dart';

void main() {
  group('CarbonCalendarPanel', () {
    Widget panel({
      DateTime? selectedStart,
      DateTime? selectedEnd,
      bool isRange = false,
      ValueChanged<DateTime>? onSelectDay,
      VoidCallback? onClose,
      DateTime? minDate,
      DateTime? maxDate,
      int firstDayOfWeek = 0,
      DateTime? initialFocusedDay,
    }) {
      return buildTestApp(
        child: Center(
          child: CarbonCalendarPanel(
            selectedStart: selectedStart,
            selectedEnd: selectedEnd,
            isRange: isRange,
            onSelectDay: onSelectDay ?? (_) {},
            onClose: onClose ?? () {},
            minDate: minDate,
            maxDate: maxDate,
            firstDayOfWeek: firstDayOfWeek,
            labels: CarbonDatePickerLabels.en(),
            initialFocusedDay:
                initialFocusedDay ?? DateTime(2026, 7, 15),
          ),
        ),
      );
    }

    /// The cell Container for a given day-number text: the nearest
    /// Container ancestor of the day label.
    Container cellOf(WidgetTester tester, String dayText, {int index = 0}) {
      return tester.widget<Container>(
        find
            .ancestor(
              of: find.text(dayText).at(index),
              matching: find.byType(Container),
            )
            .first,
      );
    }

    testWidgets('renders a 7×6 grid with outside-month days', (tester) async {
      await tester.pumpWidget(panel());
      await tester.pumpAndSettle();

      // July 2026 starts on a Wednesday (offset 3, Sunday-first): the grid
      // leads with June 28–30 and trails into August 8.
      expect(find.text('July'), findsOneWidget);
      expect(find.text('Su'), findsOneWidget);
      expect(find.text('Sa'), findsOneWidget);
      // '28' appears twice: June 28 (outside) and July 28.
      expect(find.text('28'), findsNWidgets(2));
      // '8' appears twice: July 8 and August 8 (last cell).
      expect(find.text('8'), findsNWidgets(2));
      // 42 day cells via semantics labels.
      expect(
        find.bySemanticsLabel(RegExp(r'^\w+ \d+, \d+$')),
        findsNWidgets(42),
      );
    });

    testWidgets('weekday labels rotate with firstDayOfWeek', (tester) async {
      await tester.pumpWidget(panel(firstDayOfWeek: 1));
      await tester.pumpAndSettle();

      final su = tester.getTopLeft(find.text('Su'));
      final mo = tester.getTopLeft(find.text('Mo'));
      // Monday-first: Sunday is the LAST column.
      expect(mo.dx, lessThan(su.dx));
    });

    testWidgets('arrows move the focused day and cross month boundaries', (
      tester,
    ) async {
      final selected = <DateTime>[];
      await tester.pumpWidget(
        panel(
          initialFocusedDay: DateTime(2026, 7, 31),
          onSelectDay: selected.add,
        ),
      );
      await tester.pumpAndSettle(); // panel grabs grid focus post-frame

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      // Crossing the month edge follows the month.
      expect(find.text('August'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(selected, [DateTime(2026, 8, 1)]);
    });

    testWidgets('RTL mirrors the horizontal arrows', (tester) async {
      final selected = <DateTime>[];
      await tester.pumpWidget(
        buildTestApp(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: CarbonCalendarPanel(
                selectedStart: null,
                onSelectDay: selected.add,
                onClose: () {},
                labels: CarbonDatePickerLabels.en(),
                initialFocusedDay: DateTime(2026, 7, 15),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // In RTL, ArrowLeft moves FORWARD a day.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(selected, [DateTime(2026, 7, 16)]);
    });

    testWidgets('PageDown / Shift+PageDown navigate month and year', (
      tester,
    ) async {
      await tester.pumpWidget(panel());
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.pump();
      expect(find.text('August'), findsOneWidget);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump();
      expect(find.text('August'), findsOneWidget);
      expect(find.text('2027'), findsOneWidget);
    });

    testWidgets('Home/End jump to the week-row bounds', (tester) async {
      final selected = <DateTime>[];
      await tester.pumpWidget(panel(onSelectDay: selected.add));
      await tester.pumpAndSettle();

      // July 15, 2026 is a Wednesday (column 3, Sunday-first).
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(selected.last, DateTime(2026, 7, 12)); // Sunday

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(selected.last, DateTime(2026, 7, 18)); // Saturday
    });

    testWidgets('Escape closes from the grid and from the year input', (
      tester,
    ) async {
      var closed = 0;
      await tester.pumpWidget(panel(onClose: () => closed++));
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      expect(closed, 1);

      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      expect(closed, 2);
    });

    testWidgets('tap selects; disabled days are inert', (tester) async {
      final selected = <DateTime>[];
      await tester.pumpWidget(
        panel(
          minDate: DateTime(2026, 7, 10),
          maxDate: DateTime(2026, 7, 20),
          onSelectDay: selected.add,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      expect(selected, [DateTime(2026, 7, 15)]);

      await tester.tap(find.text('5').first, warnIfMissed: false);
      expect(selected, hasLength(1)); // July 5 is below minDate

      // Both chevrons disabled: min and max are inside the same month.
      await tester.tap(find.bySemanticsLabel('Previous month'));
      await tester.pump();
      await tester.tap(find.bySemanticsLabel('Next month'));
      await tester.pump();
      expect(find.text('July'), findsOneWidget);
    });

    testWidgets('chevrons navigate months', (tester) async {
      await tester.pumpWidget(panel());
      await tester.pumpAndSettle();

      await tester.tap(find.bySemanticsLabel('Next month'));
      await tester.pump();
      expect(find.text('August'), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('Previous month'));
      await tester.pump();
      await tester.tap(find.bySemanticsLabel('Previous month'));
      await tester.pump();
      expect(find.text('June'), findsOneWidget);
    });

    testWidgets('today renders the 4×4 dot; selected today hides it', (
      tester,
    ) async {
      final today = DateTime.now();
      Finder dot() => find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.maxWidth == 4 &&
            widget.constraints?.maxHeight == 4,
      );

      await tester.pumpWidget(panel(initialFocusedDay: today));
      await tester.pumpAndSettle();
      expect(dot(), findsOneWidget);

      await tester.pumpWidget(
        panel(initialFocusedDay: today, selectedStart: today),
      );
      await tester.pumpAndSettle();
      expect(dot(), findsNothing);
    });

    testWidgets('selected and in-range days paint per spec', (tester) async {
      final carbon = WhiteTheme.theme;
      await tester.pumpWidget(
        panel(
          isRange: true,
          selectedStart: DateTime(2026, 7, 10),
          selectedEnd: DateTime(2026, 7, 20),
        ),
      );
      await tester.pumpAndSettle();

      expect(cellOf(tester, '10').color, carbon.button.buttonPrimary);
      expect(cellOf(tester, '20').color, carbon.button.buttonPrimary);
      expect(cellOf(tester, '15').color, carbon.layer.highlight);
      // Outside the range: transparent.
      expect(cellOf(tester, '25').color, CarbonPalette.transparent);
    });

    testWidgets('year input commits typed years and clamps', (tester) async {
      await tester.pumpWidget(panel());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(EditableText), '2030');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('July'), findsOneWidget);
      expect(find.text('2030'), findsOneWidget);

      // Beyond the hard cap: clamps to 9999.
      await tester.enterText(find.byType(EditableText), '0');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsWidgets); // year 1 shown in the field
    });

    testWidgets('year spinners step the year on hover', (tester) async {
      await tester.pumpWidget(panel());
      await tester.pumpAndSettle();

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.byType(EditableText)));
      await tester.pumpAndSettle();

      expect(find.byIcon(CarbonIcons.caretUp), findsOneWidget);
      await tester.tap(find.byIcon(CarbonIcons.caretUp));
      await tester.pumpAndSettle();
      expect(find.text('2027'), findsOneWidget);

      await tester.tap(find.byIcon(CarbonIcons.caretDown));
      await tester.pumpAndSettle();
      expect(find.text('2026'), findsOneWidget);
    });

    testWidgets('renders under a pure CarbonApp', (tester) async {
      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          home: Center(
            child: CarbonCalendarPanel(
              selectedStart: null,
              onSelectDay: (_) {},
              onClose: () {},
              labels: CarbonDatePickerLabels.en(),
              initialFocusedDay: DateTime(2026, 7, 15),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('July'), findsOneWidget);
    });
  });

  group('CarbonDatePicker simple', () {
    testWidgets('plain input: no calendar icon, spec width, typed commit', (
      tester,
    ) async {
      DateTime? changed;
      var calls = 0;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDatePicker(
            variant: CarbonDatePickerVariant.simple,
            labelText: 'Date',
            onChanged: (value) {
              changed = value;
              calls++;
            },
          ),
        ),
      );

      expect(find.byIcon(CarbonIcons.calendar), findsNothing);
      expect(
        tester.getSize(find.byType(AnimatedContainer).first).width,
        120,
      );

      await tester.enterText(find.byType(EditableText), '07/04/2026');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(changed, DateTime(2026, 7, 4));
      expect(calls, 1);

      // Garbage: text preserved, nothing fired.
      await tester.enterText(find.byType(EditableText), '99/99/9999');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(calls, 1);
      expect(find.text('99/99/9999'), findsOneWidget);
    });

    testWidgets('invalid widens to 152 and shows the error icon', (
      tester,
    ) async {
      final carbon = WhiteTheme.theme;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDatePicker(
            variant: CarbonDatePickerVariant.simple,
            labelText: 'Date',
            invalid: true,
            invalidText: 'Bad date',
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getSize(find.byType(AnimatedContainer).first).width,
        152,
      );
      expect(find.byIcon(CarbonIcons.warningFilled), findsOneWidget);
      final status = tester.widget<Text>(find.text('Bad date'));
      expect(status.style?.color, carbon.text.textError);
    });

    testWidgets('clearing the input fires null', (tester) async {
      final log = <DateTime?>[];
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDatePicker(
            variant: CarbonDatePickerVariant.simple,
            labelText: 'Date',
            value: DateTime(2026, 7, 4),
            onChanged: log.add,
          ),
        ),
      );

      await tester.enterText(find.byType(EditableText), '');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(log, [null]);
    });

    testWidgets('typed date outside min/max fires nothing', (tester) async {
      final log = <DateTime?>[];
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDatePicker(
            variant: CarbonDatePickerVariant.simple,
            labelText: 'Date',
            minDate: DateTime(2026, 7, 10),
            maxDate: DateTime(2026, 7, 20),
            onChanged: log.add,
          ),
        ),
      );

      await tester.enterText(find.byType(EditableText), '07/25/2026');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(log, isEmpty);
    });
  });

  group('CarbonDatePicker single', () {
    testWidgets('tap opens; picking a day fires, fills, and closes', (
      tester,
    ) async {
      DateTime? changed;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDatePicker(
            labelText: 'Date',
            value: DateTime(2026, 7, 4),
            onChanged: (value) => changed = value,
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(AnimatedContainer).first).width,
        288,
      );

      await tester.tap(find.byType(CarbonDatePicker));
      await tester.pumpAndSettle();
      expect(find.text('July'), findsOneWidget);

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      expect(changed, DateTime(2026, 7, 15));
      expect(find.text('07/15/2026'), findsOneWidget);
      expect(find.text('July'), findsNothing); // closed (closeOnSelect)
    });

    testWidgets('closeOnSelect: false keeps the calendar open', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDatePicker(
            labelText: 'Date',
            value: DateTime(2026, 7, 4),
            closeOnSelect: false,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(CarbonDatePicker));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      expect(find.text('July'), findsOneWidget);
    });

    testWidgets('ArrowDown opens with grid focus; Escape restores the input', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDatePicker(
            labelText: 'Date',
            value: DateTime(2026, 7, 15),
            onChanged: (_) {},
          ),
        ),
      );

      // Focus the input, then ArrowDown into the calendar.
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape); // close tap-open
      await tester.pumpAndSettle();
      expect(find.text('July'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(find.text('July'), findsOneWidget);

      // Grid has focus: arrows navigate days, not the app.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('July'), findsNothing);

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isTrue); // focus restored
    });

    testWidgets('readOnly never opens and swallows value keys', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDatePicker(
            labelText: 'Date',
            value: DateTime(2026, 7, 4),
            readOnly: true,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(CarbonDatePicker));
      await tester.pumpAndSettle();
      expect(find.text('July'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(find.text('July'), findsNothing);
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isTrue); // not yanked away
    });

    testWidgets('disabled is inert', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDatePicker(
            labelText: 'Date',
            disabled: true,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(CarbonDatePicker), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('July'), findsNothing);
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isFalse);
    });

    testWidgets('disposing while open removes the calendar cleanly', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonDatePicker(
            labelText: 'Date',
            value: DateTime(2026, 7, 4),
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(CarbonDatePicker));
      await tester.pumpAndSettle();
      expect(find.text('July'), findsOneWidget);

      await tester.pumpWidget(buildTestApp(child: const SizedBox()));
      await tester.pumpAndSettle();
      expect(find.text('July'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('works under a pure CarbonApp', (tester) async {
      DateTime? changed;
      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          home: Center(
            child: CarbonDatePicker(
              labelText: 'Date',
              value: DateTime(2026, 7, 4),
              onChanged: (value) => changed = value,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CarbonDatePicker));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      expect(changed, DateTime(2026, 7, 15));
    });
  });

  group('CarbonDatePicker range', () {
    Widget rangeHarness({
      required List<(DateTime?, DateTime?)> log,
      DateTime? start,
      DateTime? end,
    }) {
      var value = start;
      var endValue = end;
      return buildTestApp(
        child: StatefulBuilder(
          builder: (context, setState) => CarbonDatePicker(
            variant: CarbonDatePickerVariant.range,
            labelText: 'Start',
            endLabelText: 'End',
            value: value,
            endValue: endValue,
            onRangeChanged: (s, e) {
              log.add((s, e));
              setState(() {
                value = s;
                endValue = e;
              });
            },
          ),
        ),
      );
    }

    testWidgets('start pick then end pick fill both inputs and close', (
      tester,
    ) async {
      final log = <(DateTime?, DateTime?)>[];
      await tester.pumpWidget(
        rangeHarness(log: log, start: DateTime(2026, 7, 4)),
      );

      expect(find.byType(EditableText), findsNWidgets(2));

      await tester.tap(find.byType(EditableText).first);
      await tester.pumpAndSettle();
      expect(find.text('July'), findsOneWidget);

      // First pick restarts the range (a start already exists → both set
      // rule does not apply since end is null and 10 > 4 → end pick).
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();
      expect(log.last, (DateTime(2026, 7, 4), DateTime(2026, 7, 10)));
      expect(find.text('July'), findsNothing); // closed after the end pick
      expect(find.text('07/04/2026'), findsOneWidget);
      expect(find.text('07/10/2026'), findsOneWidget);
    });

    testWidgets('picking before the start restarts the range', (
      tester,
    ) async {
      final log = <(DateTime?, DateTime?)>[];
      await tester.pumpWidget(
        rangeHarness(
          log: log,
          start: DateTime(2026, 7, 10),
          end: DateTime(2026, 7, 20),
        ),
      );

      await tester.tap(find.byType(EditableText).first);
      await tester.pumpAndSettle();

      // Completed range exists → any pick restarts.
      await tester.tap(find.text('5').first);
      await tester.pumpAndSettle();
      expect(log.last, (DateTime(2026, 7, 5), null));
      expect(find.text('July'), findsOneWidget); // still open, end pending

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      expect(log.last, (DateTime(2026, 7, 5), DateTime(2026, 7, 15)));
    });

    testWidgets('dismissing the calendar preserves the picked start', (
      tester,
    ) async {
      final log = <(DateTime?, DateTime?)>[];
      await tester.pumpWidget(rangeHarness(log: log));

      await tester.tap(find.byType(EditableText).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();
      expect(log.last, (DateTime(2026, 7, 10), null));

      // Tap outside (the barrier).
      await tester.tapAt(const Offset(790, 590));
      await tester.pumpAndSettle();
      expect(find.text('July'), findsNothing);
      expect(find.text('07/10/2026'), findsOneWidget); // start survives
      expect(log.last, (DateTime(2026, 7, 10), null));
    });

    testWidgets('the end input opens the same shared calendar', (
      tester,
    ) async {
      final log = <(DateTime?, DateTime?)>[];
      await tester.pumpWidget(
        rangeHarness(log: log, start: DateTime(2026, 7, 4)),
      );

      await tester.tap(find.byType(EditableText).at(1));
      await tester.pumpAndSettle();
      expect(find.byType(CarbonCalendarPanel), findsOneWidget);
    });

    testWidgets('typing a start then clicking a day completes the range', (
      tester,
    ) async {
      // Regression: the click blur-commits the typed text and the day tap
      // runs BEFORE the parent rebuild — the handler must read the
      // latest-fired values, not the stale widget.value (null here).
      final log = <(DateTime?, DateTime?)>[];
      await tester.pumpWidget(rangeHarness(log: log));

      await tester.tap(find.byType(EditableText).first);
      await tester.pumpAndSettle(); // calendar opens under the typing input
      await tester.enterText(
        find.byType(EditableText).first,
        '07/04/2026',
      );

      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();

      expect(log.first, (DateTime(2026, 7, 4), null)); // blur commit
      expect(log.last, (DateTime(2026, 7, 4), DateTime(2026, 7, 10)));
    });

    testWidgets('typing an end before the start restarts from it', (
      tester,
    ) async {
      final log = <(DateTime?, DateTime?)>[];
      await tester.pumpWidget(
        rangeHarness(log: log, start: DateTime(2026, 7, 10)),
      );

      await tester.enterText(find.byType(EditableText).at(1), '07/05/2026');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(log.last, (DateTime(2026, 7, 5), null));
    });
  });
}
