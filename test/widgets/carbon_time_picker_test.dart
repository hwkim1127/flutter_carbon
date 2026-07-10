import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  const periods = [
    CarbonSelectItem(value: 'AM', label: 'AM'),
    CarbonSelectItem(value: 'PM', label: 'PM'),
  ];

  group('CarbonTimePicker input', () {
    testWidgets('masks input to digits and colon, capped at maxLength', (
      tester,
    ) async {
      String? changed;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTimePicker(
            labelText: 'Time',
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.enterText(find.byType(EditableText), 'ab1:2c3');
      expect(changed, '1:23');

      await tester.enterText(find.byType(EditableText), '12:34:56');
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.controller.text, '12:34'); // maxLength 5
    });

    testWidgets('time12h matches the spec pattern', (tester) async {
      expect(CarbonTimePicker.time12h.hasMatch('12:30'), isTrue);
      expect(CarbonTimePicker.time12h.hasMatch('1:05'), isTrue);
      expect(CarbonTimePicker.time12h.hasMatch('13:00'), isFalse);
      expect(CarbonTimePicker.time12h.hasMatch('1:60'), isFalse);
      expect(CarbonTimePicker.time12h.hasMatch('0:30'), isFalse);
    });

    testWidgets('invalid widens the field and shows icon and text', (
      tester,
    ) async {
      final carbon = WhiteTheme.theme;
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTimePicker(
            labelText: 'Time',
            invalid: true,
            invalidText: 'Not a valid time',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getSize(find.byType(AnimatedContainer).first).width,
        closeTo(98.8, 0.01),
      );
      expect(find.byIcon(CarbonIcons.warningFilled), findsOneWidget);
      final status = tester.widget<Text>(find.text('Not a valid time'));
      expect(status.style?.color, carbon.text.textError);
    });

    testWidgets('warn shows the warning icon; spec width when normal', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTimePicker(
            labelText: 'Time',
            warn: true,
            warnText: 'Outside business hours',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(CarbonIcons.warningAltFilled), findsOneWidget);
      expect(find.text('Outside business hours'), findsOneWidget);

      await tester.pumpWidget(
        buildTestApp(child: const CarbonTimePicker(labelText: 'Time')),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(AnimatedContainer).first).width, 78);
    });

    testWidgets('sizes set the field height', (tester) async {
      for (final size in CarbonTimePickerSize.values) {
        await tester.pumpWidget(
          buildTestApp(child: CarbonTimePicker(labelText: 'Time', size: size)),
        );
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byType(AnimatedContainer).first).height,
          size.height,
        );
      }
    });

    testWidgets('readOnly swallows value keys and keeps focus', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTimePicker(
            labelText: 'Time',
            value: '10:30',
            readOnly: true,
          ),
        ),
      );

      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      // Held-key auto-repeats must be swallowed too — the app-level arrow
      // shortcuts act on repeats and would yank focus.
      await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isTrue);
      expect(editable.controller.text, '10:30');
    });

    testWidgets('disabled takes no focus', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTimePicker(labelText: 'Time', disabled: true),
        ),
      );

      await tester.tap(find.byType(EditableText), warnIfMissed: false);
      await tester.pump();
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isFalse);
    });
  });

  group('CarbonTimePickerSelect', () {
    testWidgets('renders label-less next to the input and picks a value', (
      tester,
    ) async {
      String? period = 'AM';
      await tester.pumpWidget(
        buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => CarbonTimePicker(
              labelText: 'Time',
              selects: [
                CarbonTimePickerSelect<String>(
                  labelText: 'AM/PM',
                  items: periods,
                  value: period,
                  onChanged: (value) => setState(() => period = value),
                ),
              ],
            ),
          ),
        ),
      );

      // The select's label is a11y-only: not rendered as text.
      expect(find.text('AM/PM'), findsNothing);
      expect(find.text('AM'), findsOneWidget);

      await tester.tap(find.text('AM'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('PM').last);
      await tester.pumpAndSettle();
      expect(period, 'PM');
      expect(find.text('PM'), findsOneWidget);
    });

    testWidgets('multiple selects lay out with the 2px gaps', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTimePicker(
            labelText: 'Time',
            selects: [
              CarbonTimePickerSelect<String>(
                labelText: 'AM/PM',
                items: periods,
                value: 'AM',
              ),
              CarbonTimePickerSelect<String>(
                labelText: 'Timezone',
                items: const [
                  CarbonSelectItem(value: 'utc', label: 'UTC'),
                  CarbonSelectItem(value: 'kst', label: 'KST'),
                ],
                value: 'utc',
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CarbonTimePickerSelect<String>), findsNWidgets(2));
      final inputRight = tester
          .getTopRight(find.byType(AnimatedContainer).first)
          .dx;
      final firstSelectLeft = tester
          .getTopLeft(find.byType(CarbonTimePickerSelect<String>).first)
          .dx;
      expect(firstSelectLeft - inputRight, 2);
    });
  });

  testWidgets('renders under a pure CarbonApp', (tester) async {
    await tester.pumpWidget(
      CarbonApp(
        theme: WhiteTheme.theme,
        home: Center(
          child: CarbonTimePicker(
            labelText: 'Time',
            selects: [
              CarbonTimePickerSelect<String>(
                labelText: 'AM/PM',
                items: periods,
                value: 'AM',
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('AM'), findsOneWidget);
  });
}
