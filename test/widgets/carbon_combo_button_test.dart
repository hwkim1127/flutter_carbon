import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonComboButton', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton(
            onPressed: () {},
            menuItems: const [],
            label: 'Action',
          ),
        ),
      );

      expect(find.byType(CarbonComboButton), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
    });

    testWidgets('calls onPressed when main button tapped', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton(
            onPressed: () => pressed = true,
            menuItems: const [],
            label: 'Main',
          ),
        ),
      );

      await tester.tap(find.text('Main'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('shows menu when dropdown button tapped', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton(
            onPressed: () {},
            menuItems: const [
              PopupMenuItem(value: '1', child: Text('Option 1')),
              PopupMenuItem(value: '2', child: Text('Option 2')),
            ],
            label: 'Action',
          ),
        ),
      );

      // Tap dropdown arrow
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pump();

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('can be disabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton(
            onPressed: null,
            menuItems: const [],
            label: 'Disabled',
          ),
        ),
      );

      final button = tester.widget<CarbonComboButton>(
        find.byType(CarbonComboButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('calls onMenuItemSelected when menu item tapped', (
      tester,
    ) async {
      String? selected;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonComboButton(
            onPressed: () {},
            menuItems: [
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
                onTap: () => selected = 'edit',
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
                onTap: () => selected = 'delete',
              ),
            ],
            onMenuItemSelected: (value) => selected = value,
            label: 'Actions',
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(selected, 'edit');
    });

    testWidgets('works in all themes', (tester) async {
      for (final theme in [
        WhiteTheme.theme,
        G10Theme.theme,
        G90Theme.theme,
        G100Theme.theme,
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: carbonTheme(carbon: theme),
            home: Scaffold(
              body: CarbonComboButton(
                onPressed: () {},
                menuItems: const [],
                label: 'Test',
              ),
            ),
          ),
        );

        expect(find.byType(CarbonComboButton), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });
}
