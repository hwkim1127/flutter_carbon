import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonOverflowMenu', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonOverflowMenu(
            items: [
              CarbonOverflowMenuItem(label: 'Option 1', onTap: () {}),
              CarbonOverflowMenuItem(label: 'Option 2', onTap: () {}),
            ],
          ),
        ),
      );
      expect(find.byType(CarbonOverflowMenu), findsOneWidget);
    });

    testWidgets('removes an open menu overlay when unmounted', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonOverflowMenu(
            items: [CarbonOverflowMenuItem(label: 'Leaky?', onTap: () {})],
          ),
        ),
      );

      await tester.tap(find.byType(CarbonOverflowMenu));
      await tester.pumpAndSettle();
      expect(find.text('Leaky?'), findsOneWidget);

      // Unmount the widget while the menu is open — the overlay entry must
      // be removed with it, not linger over the replacement UI.
      await tester.pumpWidget(buildTestApp(child: const SizedBox()));
      await tester.pumpAndSettle();

      expect(find.text('Leaky?'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'menu keyboard: arrows + Enter activate, Escape closes, focus '
        'restores even when another widget held focus', (tester) async {
      var activated = false;
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
              CarbonOverflowMenu(
                items: [
                  CarbonOverflowMenuItem(label: 'Disabled', disabled: true),
                  CarbonOverflowMenuItem(
                    label: 'Delete',
                    onTap: () => activated = true,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      neighborFocus.requestFocus();
      await tester.pump();

      await tester.tap(find.byType(CarbonOverflowMenu));
      await tester.pumpAndSettle();
      expect(find.text('Delete'), findsOneWidget);

      // ArrowDown skips the disabled item; Enter activates.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(activated, isTrue);
      expect(find.text('Delete'), findsNothing); // menu closed
      expect(neighborFocus.hasPrimaryFocus, isTrue); // focus restored

      // Escape closes too.
      await tester.tap(find.byType(CarbonOverflowMenu));
      await tester.pumpAndSettle();
      expect(find.text('Delete'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('displays menu icon', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonOverflowMenu(
            items: [CarbonOverflowMenuItem(label: 'Option 1', onTap: () {})],
          ),
        ),
      );

      expect(find.byIcon(CarbonIcons.overflowMenuVertical), findsOneWidget);
    });

    testWidgets('can use custom icon', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonOverflowMenu(
            icon: Icons.settings,
            items: [CarbonOverflowMenuItem(label: 'Option 1', onTap: () {})],
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('supports flipped mode', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonOverflowMenu(
            flipped: true,
            items: [CarbonOverflowMenuItem(label: 'Option 1', onTap: () {})],
          ),
        ),
      );

      final menu = tester.widget<CarbonOverflowMenu>(
        find.byType(CarbonOverflowMenu),
      );
      expect(menu.flipped, isTrue);
    });
  });

  group('CarbonOverflowMenuItem', () {
    test('creates item with label', () {
      final item = CarbonOverflowMenuItem(label: 'Test', onTap: () {});
      expect(item.label, 'Test');
    });

    test('supports danger kind', () {
      final item = CarbonOverflowMenuItem(
        label: 'Delete',
        onTap: () {},
        isDanger: true,
      );
      expect(item.isDanger, isTrue);
    });

    test('supports disabled state', () {
      final item = CarbonOverflowMenuItem(
        label: 'Disabled',
        onTap: () {},
        disabled: true,
      );
      expect(item.disabled, isTrue);
    });
  });
}
