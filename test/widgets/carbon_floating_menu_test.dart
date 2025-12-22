import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonFloatingMenu', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFloatingMenu(
            items: [
              CarbonFloatingMenuItem(
                icon: Icons.add,
                label: 'Add',
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.byType(CarbonFloatingMenu), findsOneWidget);
    });

    testWidgets('displays main FAB', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFloatingMenu(icon: Icons.menu, items: []),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('displays custom icon', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFloatingMenu(icon: Icons.settings, items: []),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('shows menu items when opened', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFloatingMenu(
            initiallyOpen: true,
            items: [
              CarbonFloatingMenuItem(
                icon: Icons.create,
                label: 'Create',
                onTap: () {},
              ),
              CarbonFloatingMenuItem(
                icon: Icons.upload,
                label: 'Upload',
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Create'), findsOneWidget);
      expect(find.text('Upload'), findsOneWidget);
      expect(find.byIcon(Icons.create), findsOneWidget);
      expect(find.byIcon(Icons.upload), findsOneWidget);
    });

    testWidgets('opens menu when FAB tapped', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFloatingMenu(
            items: [
              CarbonFloatingMenuItem(
                icon: Icons.edit,
                label: 'Edit',
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      // Open menu by tapping FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Menu should be open and visible
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('changes icon when menu state changes', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFloatingMenu(
            icon: Icons.menu,
            openIcon: Icons.close,
            items: [
              CarbonFloatingMenuItem(
                icon: Icons.share,
                label: 'Share',
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      // Initially shows menu icon
      expect(find.byIcon(Icons.menu), findsOneWidget);

      // Tap to open
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Should show close icon when open
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('calls onTap when menu item tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFloatingMenu(
            initiallyOpen: true,
            items: [
              CarbonFloatingMenuItem(
                icon: Icons.save,
                label: 'Save',
                onTap: () => tapped = true,
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap menu item
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Callback should have been called
      expect(tapped, isTrue);
    });

    testWidgets('displays all menu items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFloatingMenu(
            initiallyOpen: true,
            items: [
              CarbonFloatingMenuItem(
                icon: Icons.add,
                label: 'Add',
                onTap: () {},
              ),
              CarbonFloatingMenuItem(
                icon: Icons.edit,
                label: 'Edit',
                onTap: () {},
              ),
              CarbonFloatingMenuItem(
                icon: Icons.delete,
                label: 'Delete',
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('shows custom open icon when menu is open', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFloatingMenu(
            icon: Icons.menu,
            openIcon: Icons.close,
            initiallyOpen: true,
            items: [
              CarbonFloatingMenuItem(
                icon: Icons.star,
                label: 'Star',
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show close icon when open
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsNothing);
    });

    testWidgets('animates menu items with scale transition', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonFloatingMenu(
            items: [
              CarbonFloatingMenuItem(
                icon: Icons.add,
                label: 'Add',
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      // Tap to open
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 100)); // Mid-animation

      // Should find ScaleTransition
      expect(find.byType(ScaleTransition), findsWidgets);

      await tester.pumpAndSettle();
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
              floatingActionButton: CarbonFloatingMenu(
                items: [
                  CarbonFloatingMenuItem(
                    icon: Icons.add,
                    label: 'Test',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(CarbonFloatingMenu), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });

  group('CarbonFloatingMenuItem', () {
    test('can be created with required parameters', () {
      final item = CarbonFloatingMenuItem(
        icon: Icons.star,
        label: 'Favorite',
        onTap: () {},
      );

      expect(item.icon, Icons.star);
      expect(item.label, 'Favorite');
      expect(item.onTap, isNotNull);
    });
  });
}
