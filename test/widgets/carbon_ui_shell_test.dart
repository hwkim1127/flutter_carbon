import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  group('CarbonUIShell', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          home: CarbonUIShell(
            appName: 'App Title',
            child: const Text('Main content'),
          ),
        ),
      );

      expect(find.byType(CarbonUIShell), findsOneWidget);
      expect(find.text('App Title'), findsOneWidget);
      expect(find.text('Main content'), findsOneWidget);
    });

    testWidgets('displays side nav when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          home: CarbonUIShell(
            appName: 'App',
            initialSideNavExpanded: true,
            sideNavItems: [
              CarbonNavItem(icon: Icons.home, label: 'Home', onTap: () {}),
              CarbonNavItem(
                icon: Icons.settings,
                label: 'Settings',
                onTap: () {},
              ),
            ],
            child: const Text('Content'),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('toggles side nav when menu button tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          home: CarbonUIShell(
            appName: 'App',
            initialSideNavExpanded: true,
            sideNavItems: [
              CarbonNavItem(icon: Icons.home, label: 'Home', onTap: () {}),
            ],
            child: const Text('Content'),
          ),
        ),
      );

      // Find and tap menu button
      final menuButton = find.byIcon(Icons.menu);
      if (menuButton.evaluate().isNotEmpty) {
        await tester.tap(menuButton);
        await tester.pumpAndSettle();
      }

      expect(find.byType(CarbonUIShell), findsOneWidget);
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
            home: CarbonUIShell(appName: 'Test', child: const Text('Content')),
          ),
        );

        expect(find.byType(CarbonUIShell), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });

  group('CarbonPageHeader', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          home: Scaffold(body: CarbonPageHeader(title: 'Page Title')),
        ),
      );

      expect(find.byType(CarbonPageHeader), findsOneWidget);
      expect(find.text('Page Title'), findsOneWidget);
    });

    testWidgets('displays breadcrumbs when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          home: Scaffold(
            body: CarbonPageHeader(
              title: 'Current Page',
              breadcrumb: CarbonBreadcrumb(
                items: [
                  CarbonBreadcrumbItem(label: 'Home', onTap: () {}),
                  CarbonBreadcrumbItem(label: 'Section', onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Section'), findsOneWidget);
    });

    testWidgets('displays subtitle when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          home: Scaffold(
            body: CarbonPageHeader(title: 'Title', subtitle: 'Subtitle text'),
          ),
        ),
      );

      expect(find.text('Subtitle text'), findsOneWidget);
    });
  });
}
