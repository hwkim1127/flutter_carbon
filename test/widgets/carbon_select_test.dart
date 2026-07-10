import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  const items = [
    CarbonSelectItem(value: 'red', label: 'Red'),
    CarbonSelectItem(value: 'green', label: 'Green'),
    CarbonSelectItem(value: 'blue', label: 'Blue', disabled: true),
  ];

  Widget select({
    String? value,
    ValueChanged<String?>? onChanged,
    bool disabled = false,
    bool readOnly = false,
    bool invalid = false,
    String? invalidText,
    bool warn = false,
    String? warnText,
    String? placeholder,
    CarbonSelectSize size = CarbonSelectSize.md,
  }) {
    return CarbonSelect<String>(
      labelText: 'Color',
      items: items,
      value: value,
      onChanged: onChanged,
      disabled: disabled,
      readOnly: readOnly,
      invalid: invalid,
      invalidText: invalidText,
      warn: warn,
      warnText: warnText,
      placeholder: placeholder,
      size: size,
    );
  }

  group('CarbonSelect basics', () {
    testWidgets('tap opens the menu; choosing fires onChanged and closes', (
      tester,
    ) async {
      String? changed;
      await tester.pumpWidget(
        buildTestApp(
          child: select(value: 'red', onChanged: (value) => changed = value),
        ),
      );

      await tester.tap(find.text('Red'));
      await tester.pumpAndSettle();
      expect(find.text('Green'), findsOneWidget);

      await tester.tap(find.text('Green'));
      await tester.pumpAndSettle();
      expect(changed, 'green');
      expect(find.text('Green'), findsNothing); // menu closed
    });

    testWidgets('selected option shows checkmark in the open menu', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(child: select(value: 'red')));

      await tester.tap(find.text('Red').first);
      await tester.pumpAndSettle();
      expect(find.byIcon(CarbonIcons.checkmark), findsOneWidget);
    });

    testWidgets('placeholder shows while value is null', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: select(placeholder: 'Choose a color')),
      );
      expect(find.text('Choose a color'), findsOneWidget);
    });

    testWidgets('sizes set the field height', (tester) async {
      for (final size in CarbonSelectSize.values) {
        await tester.pumpWidget(
          buildTestApp(child: select(value: 'red', size: size)),
        );
        await tester.pumpAndSettle();
        final box = tester.getSize(
          find
              .descendant(
                of: find.byType(CarbonSelect<String>),
                matching: find.byType(AnimatedContainer),
              )
              .first,
        );
        expect(box.height, size.height);
      }
    });

    testWidgets('renders under a pure CarbonApp', (tester) async {
      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          home: Center(child: select(value: 'red')),
        ),
      );
      expect(find.text('Red'), findsOneWidget);
    });
  });

  group('CarbonSelect keyboard', () {
    testWidgets('Enter on the focused closed field opens the menu; arrows '
        'continue from the selection', (tester) async {
      String? changed;
      await tester.pumpWidget(
        buildTestApp(
          child: select(value: 'red', onChanged: (value) => changed = value),
        ),
      );

      // Focus the field and open with Enter.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Green'), findsOneWidget);

      // Arrow continues from Red → Green, Enter selects.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(changed, 'green');
    });

    testWidgets('Escape closes the menu and focus returns to the field', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(child: select(value: 'red')));

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(find.text('Green'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Green'), findsNothing);

      // Field focus restored: Enter re-opens immediately.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Green'), findsOneWidget);
    });
  });

  group('CarbonSelect states', () {
    testWidgets('readOnly is focusable but the menu does not open', (
      tester,
    ) async {
      final carbon = WhiteTheme.theme;
      await tester.pumpWidget(
        buildTestApp(child: select(value: 'red', readOnly: true)),
      );

      await tester.tap(find.text('Red'));
      await tester.pumpAndSettle();
      expect(find.text('Green'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Green'), findsNothing);

      final container = tester.widget<AnimatedContainer>(
        find
            .descendant(
              of: find.byType(CarbonSelect<String>),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, CarbonPalette.transparent);
      expect(decoration.border!.bottom.color, carbon.layer.borderSubtle01);
    });

    testWidgets('disabled ignores taps and takes no focus', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: select(value: 'red', disabled: true)),
      );

      await tester.tap(find.text('Red'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Green'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Green'), findsNothing);
    });

    testWidgets('invalid shows the error icon and invalidText', (
      tester,
    ) async {
      final carbon = WhiteTheme.theme;
      await tester.pumpWidget(
        buildTestApp(
          child: select(value: 'red', invalid: true, invalidText: 'Bad pick'),
        ),
      );

      expect(find.byIcon(CarbonIcons.warningFilled), findsOneWidget);
      final status = tester.widget<Text>(find.text('Bad pick'));
      expect(status.style?.color, carbon.text.textError);
    });

    testWidgets('invalid wins over warn', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: select(
            value: 'red',
            invalid: true,
            invalidText: 'error',
            warn: true,
            warnText: 'warning',
          ),
        ),
      );

      expect(find.byIcon(CarbonIcons.warningFilled), findsOneWidget);
      expect(find.byIcon(CarbonIcons.warningAltFilled), findsNothing);
      expect(find.text('error'), findsOneWidget);
      expect(find.text('warning'), findsNothing);
    });

    testWidgets('warn shows the warning icon and warnText', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: select(value: 'red', warn: true, warnText: 'Careful'),
        ),
      );

      expect(find.byIcon(CarbonIcons.warningAltFilled), findsOneWidget);
      expect(find.text('Careful'), findsOneWidget);
    });

    testWidgets('disposing while open removes the menu cleanly', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestApp(child: select(value: 'red')));

      await tester.tap(find.text('Red'));
      await tester.pumpAndSettle();
      expect(find.text('Green'), findsOneWidget);

      await tester.pumpWidget(buildTestApp(child: const SizedBox()));
      await tester.pumpAndSettle();
      expect(find.text('Green'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
