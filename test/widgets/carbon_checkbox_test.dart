import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

import '../shared/build.dart';

void main() {
  group('CarbonCheckbox', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCheckbox(
            value: false,
            onChanged: (_) {},
            label: 'Accept terms',
          ),
        ),
      );

      expect(find.byType(CarbonCheckbox), findsOneWidget);
      expect(find.text('Accept terms'), findsOneWidget);
    });

    testWidgets('toggles on tap', (tester) async {
      bool? next;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCheckbox(
            value: false,
            onChanged: (value) => next = value,
            label: 'Toggle me',
          ),
        ),
      );

      await tester.tap(find.byType(CarbonCheckbox));
      expect(next, isTrue);
    });

    testWidgets('unchecks when checked', (tester) async {
      bool? next;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCheckbox(
            value: true,
            onChanged: (value) => next = value,
          ),
        ),
      );

      await tester.tap(find.byType(CarbonCheckbox));
      expect(next, isFalse);
    });

    testWidgets('tristate cycles false → true → null → false',
        (tester) async {
      bool? state = false;
      await tester.pumpWidget(
        buildTestApp(
          child: StatefulBuilder(
            builder: (context, setState) => CarbonCheckbox(
              value: state,
              tristate: true,
              onChanged: (value) => setState(() => state = value),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CarbonCheckbox));
      await tester.pump();
      expect(state, isTrue);

      await tester.tap(find.byType(CarbonCheckbox));
      await tester.pump();
      expect(state, isNull);

      await tester.tap(find.byType(CarbonCheckbox));
      await tester.pump();
      expect(state, isFalse);
    });

    testWidgets('disabled checkbox ignores taps', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonCheckbox(
            value: false,
            onChanged: null,
            label: 'Disabled',
          ),
        ),
      );

      await tester.tap(find.byType(CarbonCheckbox));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('space key toggles when focused', (tester) async {
      bool? next;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCheckbox(
            value: false,
            onChanged: (value) => next = value,
          ),
        ),
      );

      final focusWidget = tester.widget<Focus>(
        find
            .descendant(
              of: find.byType(CarbonCheckbox),
              matching: find.byType(Focus),
            )
            .first,
      );
      focusWidget.focusNode!.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(next, isTrue);
    });

    testWidgets('shows invalid text when invalid', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonCheckbox(
            value: false,
            onChanged: (_) {},
            invalid: true,
            invalidText: 'Required field',
          ),
        ),
      );

      expect(find.text('Required field'), findsOneWidget);
    });

    testWidgets('works in all themes', (tester) async {
      for (final theme in [
        WhiteTheme.theme,
        G10Theme.theme,
        G90Theme.theme,
        G100Theme.theme,
      ]) {
        await tester.pumpWidget(
          CarbonApp(
            theme: theme,
            home: Center(
              child: CarbonCheckbox(
                value: true,
                onChanged: (_) {},
                label: 'Themed',
              ),
            ),
          ),
        );
        expect(find.byType(CarbonCheckbox), findsOneWidget);
      }
    });
  });
}
