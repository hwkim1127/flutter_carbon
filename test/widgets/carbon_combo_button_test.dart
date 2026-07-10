import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

import '../shared/build.dart';

void main() {
  group('CarbonComboButton', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton<String>(
            onPressed: () {},
            label: 'Action',
          ),
        ),
      );

      expect(find.byType(CarbonComboButton<String>), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
    });

    testWidgets('calls onPressed when main button tapped', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton<String>(
            onPressed: () => pressed = true,
            label: 'Main',
          ),
        ),
      );

      await tester.tap(find.text('Main'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('shows menu when the chevron is tapped; divider renders', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton<String>(
            onPressed: () {},
            menuItems: const [
              CarbonMenuItem(value: '1', label: 'Option 1'),
              CarbonMenuItemDivider(),
              CarbonMenuItem(value: '2', label: 'Option 2'),
            ],
            label: 'Action',
          ),
        ),
      );

      await tester.tap(find.byIcon(CarbonIcons.chevronDown));
      await tester.pumpAndSettle();

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('selecting an item fires onTap AND onMenuItemSelected, '
        'then closes', (tester) async {
      final calls = <String>[];

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton<String>(
            onPressed: () {},
            menuItems: [
              CarbonMenuItem(
                value: 'edit',
                label: 'Edit',
                onTap: () => calls.add('onTap'),
              ),
              const CarbonMenuItem(value: 'delete', label: 'Delete'),
            ],
            onMenuItemSelected: (value) => calls.add('selected:$value'),
            label: 'Actions',
          ),
        ),
      );

      await tester.tap(find.byIcon(CarbonIcons.chevronDown));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(calls, ['onTap', 'selected:edit']);
      expect(find.text('Delete'), findsNothing); // menu closed
    });

    testWidgets('tap outside dismisses the menu', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton<String>(
            onPressed: () {},
            menuItems: const [CarbonMenuItem(value: '1', label: 'Option 1')],
            label: 'Action',
          ),
        ),
      );

      await tester.tap(find.byIcon(CarbonIcons.chevronDown));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);

      await tester.tapAt(const Offset(700, 500));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsNothing);
    });

    testWidgets('chevron rotates while the menu is open', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton<String>(
            onPressed: () {},
            menuItems: const [CarbonMenuItem(value: '1', label: 'One')],
            label: 'Action',
          ),
        ),
      );

      AnimatedRotation rotation() =>
          tester.widget<AnimatedRotation>(find.byType(AnimatedRotation));

      expect(rotation().turns, 0.0);

      await tester.tap(find.byIcon(CarbonIcons.chevronDown));
      await tester.pumpAndSettle();
      expect(rotation().turns, 0.5);

      await tester.tapAt(const Offset(700, 500));
      await tester.pumpAndSettle();
      expect(rotation().turns, 0.0);
    });

    testWidgets('menu width matches the full container width', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton<String>(
            onPressed: () {},
            menuItems: const [CarbonMenuItem(value: '1', label: 'One')],
            label: 'A very long primary action label',
          ),
        ),
      );

      final containerWidth =
          tester.getSize(find.byType(CarbonComboButton<String>)).width;

      await tester.tap(find.byIcon(CarbonIcons.chevronDown));
      await tester.pumpAndSettle();

      final menuFinder = find.ancestor(
        of: find.text('One'),
        matching: find.byWidgetPredicate(
          (widget) => widget.runtimeType.toString() == 'CarbonMenuPanel<String>',
        ),
      );
      expect(
        tester.getSize(menuFinder).width,
        closeTo(containerWidth, 0.5),
      );
    });

    testWidgets('disabled: primary inert and chevron opens nothing', (
      tester,
    ) async {
      bool pressed = false;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton<String>(
            onPressed: () => pressed = true,
            menuItems: const [CarbonMenuItem(value: '1', label: 'Option 1')],
            label: 'Submit',
            disabled: true,
          ),
        ),
      );

      await tester.tap(find.text('Submit'), warnIfMissed: false);
      await tester.tap(
        find.byIcon(CarbonIcons.chevronDown),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      expect(pressed, isFalse);
      expect(find.text('Option 1'), findsNothing);
    });

    testWidgets(
        'arrow keys drive the menu (not focus traversal) even when another '
        'widget held focus; focus is restored on close', (tester) async {
      String? selected;
      final neighborFocus = FocusNode();
      addTearDown(neighborFocus.dispose);

      await tester.pumpWidget(
        buildTestApp(
          child: Column(
            children: [
              Focus(
                focusNode: neighborFocus,
                child: const SizedBox(width: 40, height: 40),
              ),
              CarbonComboButton<String>(
                onPressed: () {},
                menuItems: const [
                  CarbonMenuItem(value: 'one', label: 'One'),
                  CarbonMenuItem(value: 'two', label: 'Two'),
                ],
                onMenuItemSelected: (value) => selected = value,
                label: 'Action',
              ),
            ],
          ),
        ),
      );

      // Reproduce the report: something else already holds focus, so the
      // panel's old `autofocus` would have been silently ignored.
      neighborFocus.requestFocus();
      await tester.pump();
      expect(neighborFocus.hasPrimaryFocus, isTrue);

      await tester.tap(find.byIcon(CarbonIcons.chevronDown));
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(selected, 'two');
      // Focus went back to where it was before the menu opened.
      expect(neighborFocus.hasPrimaryFocus, isTrue);
    });

    testWidgets('removes an open menu overlay when unmounted', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton<String>(
            onPressed: () {},
            menuItems: const [CarbonMenuItem(value: '1', label: 'Leaky?')],
            label: 'Action',
          ),
        ),
      );

      await tester.tap(find.byIcon(CarbonIcons.chevronDown));
      await tester.pumpAndSettle();
      expect(find.text('Leaky?'), findsOneWidget);

      await tester.pumpWidget(buildTestApp(child: const SizedBox()));
      await tester.pumpAndSettle();

      expect(find.text('Leaky?'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('works in all themes', (tester) async {
      for (final theme in [
        WhiteTheme.theme,
        G10Theme.theme,
        G90Theme.theme,
        G100Theme.theme,
      ]) {
        await tester.pumpWidget(
          buildTestApp(
            theme: theme,
            child: CarbonComboButton<String>(
              onPressed: () {},
              label: 'Test',
            ),
          ),
        );

        expect(find.byType(CarbonComboButton<String>), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });
}
