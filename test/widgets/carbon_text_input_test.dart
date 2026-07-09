import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

import '../shared/build.dart';

/// The field's 2px inset outline color; transparent when inactive (the
/// decoration itself is always present to keep the tree shape stable).
Color _outlineColor(WidgetTester tester) {
  final container = tester.widget<AnimatedContainer>(
    find.descendant(
      of: find.byType(CarbonTextInput),
      matching: find.byType(AnimatedContainer),
    ),
  );
  final decoration = container.foregroundDecoration! as BoxDecoration;
  return (decoration.border! as Border).top.color;
}

void main() {
  group('CarbonTextInput', () {
    testWidgets('renders label, placeholder, and helper text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTextInput(
            labelText: 'User name',
            placeholder: 'jane.doe',
            helperText: 'Lowercase only',
          ),
        ),
      );

      expect(find.text('User name'), findsOneWidget);
      expect(find.text('jane.doe'), findsOneWidget);
      expect(find.text('Lowercase only'), findsOneWidget);
    });

    testWidgets('hideLabel hides the visible label but keeps semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTextInput(labelText: 'Hidden', hideLabel: true),
        ),
      );

      expect(find.text('Hidden'), findsNothing);
      final semantics = tester.getSemantics(find.byType(CarbonTextInput));
      expect(semantics.label, contains('Hidden'));
    });

    testWidgets('entering text fires onChanged and updates the controller', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      String? changed;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTextInput(
            labelText: 'Name',
            controller: controller,
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.enterText(find.byType(CarbonTextInput), 'hello');
      expect(changed, 'hello');
      expect(controller.text, 'hello');
    });

    testWidgets('external controller changes render in the field', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTextInput(labelText: 'Name', controller: controller),
        ),
      );

      controller.text = 'from outside';
      await tester.pump();
      expect(find.text('from outside'), findsOneWidget);
    });

    testWidgets('onSubmitted fires on keyboard action', (tester) async {
      String? submitted;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTextInput(
            labelText: 'Name',
            onSubmitted: (value) => submitted = value,
          ),
        ),
      );

      await tester.enterText(find.byType(CarbonTextInput), 'done');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(submitted, 'done');
    });

    testWidgets('focus shows the 2px focus outline and unfocus removes it', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonTextInput(labelText: 'Focus me')),
      );

      expect(_outlineColor(tester), CarbonPalette.transparent);

      await tester.tap(find.byType(CarbonTextInput));
      await tester.pumpAndSettle();
      expect(_outlineColor(tester), isNot(CarbonPalette.transparent));

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      expect(_outlineColor(tester), CarbonPalette.transparent);
    });

    testWidgets('invalid shows outline, icon, and invalidText over helper', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTextInput(
            labelText: 'Field',
            helperText: 'Helper',
            invalid: true,
            invalidText: 'Required',
          ),
        ),
      );

      expect(find.text('Required'), findsOneWidget);
      expect(find.text('Helper'), findsNothing);
      expect(find.byIcon(CarbonIcons.warningFilled), findsOneWidget);
      expect(_outlineColor(tester), isNot(CarbonPalette.transparent));
    });

    testWidgets('warn shows the warning icon and warnText, no outline', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTextInput(
            labelText: 'Field',
            warn: true,
            warnText: 'Careful',
          ),
        ),
      );

      expect(find.text('Careful'), findsOneWidget);
      expect(find.byIcon(CarbonIcons.warningAltFilled), findsOneWidget);
      expect(_outlineColor(tester), CarbonPalette.transparent);
    });

    testWidgets('invalid wins over warn; readOnly wins over both', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTextInput(
            labelText: 'Field',
            invalid: true,
            invalidText: 'Bad',
            warn: true,
            warnText: 'Careful',
          ),
        ),
      );
      expect(find.text('Bad'), findsOneWidget);
      expect(find.byIcon(CarbonIcons.warningFilled), findsOneWidget);
      expect(find.byIcon(CarbonIcons.warningAltFilled), findsNothing);

      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTextInput(
            labelText: 'Field',
            readOnly: true,
            invalid: true,
            invalidText: 'Bad',
            warn: true,
          ),
        ),
      );
      expect(find.byIcon(CarbonIcons.warningFilled), findsNothing);
      expect(find.byIcon(CarbonIcons.warningAltFilled), findsNothing);
    });

    testWidgets('disabled field rejects focus and text entry', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTextInput(
            labelText: 'Off',
            disabled: true,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(CarbonTextInput), warnIfMissed: false);
      await tester.pump();
      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.focusNode.hasFocus, isFalse);
      expect(controller.text, isEmpty);
    });

    testWidgets('readOnly field is focusable but not editable', (tester) async {
      final controller = TextEditingController(text: 'fixed');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTextInput(
            labelText: 'RO',
            readOnly: true,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(CarbonTextInput));
      await tester.pumpAndSettle();

      // Focus outline present (read-only stays focusable).
      expect(_outlineColor(tester), isNot(CarbonPalette.transparent));

      // Typing does nothing.
      await tester.enterText(find.byType(CarbonTextInput), 'changed');
      expect(controller.text, 'fixed');
    });

    testWidgets('sizes produce 24/32/40/48 field heights', (tester) async {
      for (final size in CarbonTextInputSize.values) {
        await tester.pumpWidget(
          buildTestApp(
            child: CarbonTextInput(labelText: 'Sized', size: size),
          ),
        );
        // Let the AnimatedContainer finish animating from the prior size.
        await tester.pumpAndSettle();
        final height = tester
            .getSize(
              find.descendant(
                of: find.byType(CarbonTextInput),
                matching: find.byType(AnimatedContainer),
              ),
            )
            .height;
        expect(height, size.height, reason: 'size $size');
      }
    });

    testWidgets('maxLength limits input length', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTextInput(
            labelText: 'Limited',
            maxLength: 5,
            controller: controller,
          ),
        ),
      );

      await tester.enterText(find.byType(CarbonTextInput), '1234567890');
      expect(controller.text, '12345');
    });

    testWidgets('obscureText renders obscured', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonTextInput(labelText: 'PW', obscureText: true),
        ),
      );
      await tester.enterText(find.byType(CarbonTextInput), 'secret');

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.obscureText, isTrue);
    });

    testWidgets('works Material-free: long-press selects a word and shows the '
        'Carbon toolbar under CarbonApp', (tester) async {
      final controller = TextEditingController(text: 'hello carbon world');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          home: Center(
            child: SizedBox(
              width: 300,
              child: CarbonTextInput(
                labelText: 'Select',
                controller: controller,
              ),
            ),
          ),
        ),
      );

      // Long-press (touch) on the text: selects the word, shows handles
      // and the Carbon context menu.
      await tester.longPress(find.byType(EditableText));
      await tester.pumpAndSettle();

      expect(controller.selection.isCollapsed, isFalse);
      expect(find.text('Copy'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('mouse click positions the caret without handles', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'abcdef');
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTextInput(labelText: 'Mouse', controller: controller),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(EditableText)),
        kind: PointerDeviceKind.mouse,
      );
      await gesture.up();
      await tester.pumpAndSettle();

      expect(controller.selection.isCollapsed, isTrue);
      expect(controller.selection.baseOffset, greaterThanOrEqualTo(0));
      expect(find.text('Copy'), findsNothing);
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
            home: const Center(child: CarbonTextInput(labelText: 'Themed')),
          ),
        );
        expect(find.byType(CarbonTextInput), findsOneWidget);
      }
    });
  });
}
