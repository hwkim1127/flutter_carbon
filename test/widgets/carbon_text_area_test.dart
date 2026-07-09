import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

import '../shared/build.dart';

void main() {
  group('CarbonTextArea', () {
    testWidgets('renders label, placeholder, and helper', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTextArea(
            labelText: 'Notes',
            placeholder: 'Type here',
            helperText: 'Optional',
          ),
        ),
      );

      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('Type here'), findsOneWidget);
      expect(find.text('Optional'), findsOneWidget);
    });

    testWidgets('grows with content and respects maxLines', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildTestApp(
          child: SizedBox(
            width: 300,
            child: CarbonTextArea(
              labelText: 'Grow',
              minLines: 2,
              maxLines: 4,
              controller: controller,
            ),
          ),
        ),
      );

      final fieldFinder = find.descendant(
        of: find.byType(CarbonTextArea),
        matching: find.byType(AnimatedContainer),
      );
      final initialHeight = tester.getSize(fieldFinder).height;

      controller.text = 'one\ntwo\nthree\nfour';
      await tester.pumpAndSettle();
      final grownHeight = tester.getSize(fieldFinder).height;
      expect(grownHeight, greaterThan(initialHeight));

      controller.text = 'one\ntwo\nthree\nfour\nfive\nsix\nseven';
      await tester.pumpAndSettle();
      // Capped at maxLines: no further growth.
      expect(tester.getSize(fieldFinder).height, grownHeight);
    });

    testWidgets('invalid anchors the icon to the top-right', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: SizedBox(
            width: 300,
            child: CarbonTextArea(
              labelText: 'Err',
              minLines: 4,
              invalid: true,
              invalidText: 'Bad',
            ),
          ),
        ),
      );

      final field = find.descendant(
        of: find.byType(CarbonTextArea),
        matching: find.byType(AnimatedContainer),
      );
      final icon = find.byIcon(CarbonIcons.warningFilled);
      expect(icon, findsOneWidget);

      final fieldRect = tester.getRect(field);
      final iconRect = tester.getRect(icon);
      // Top-anchored (12px from the field top), right inset 16.
      expect(iconRect.top - fieldRect.top, closeTo(12, 1));
      expect(fieldRect.right - iconRect.right, closeTo(16, 1));
      expect(find.text('Bad'), findsOneWidget);
    });

    testWidgets('disabled and readOnly state parity', (tester) async {
      final controller = TextEditingController(text: 'fixed');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTextArea(
            labelText: 'RO',
            readOnly: true,
            controller: controller,
          ),
        ),
      );
      await tester.enterText(find.byType(CarbonTextArea), 'changed');
      expect(controller.text, 'fixed');

      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTextArea(labelText: 'Off', disabled: true),
        ),
      );
      await tester.tap(find.byType(CarbonTextArea), warnIfMissed: false);
      await tester.pump();
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isFalse);
    });

    testWidgets('works Material-free under CarbonApp', (tester) async {
      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          home: const Center(
            child: SizedBox(
              width: 300,
              child: CarbonTextArea(labelText: 'Pure'),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(CarbonTextArea), 'no material here');
      expect(find.text('no material here'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
