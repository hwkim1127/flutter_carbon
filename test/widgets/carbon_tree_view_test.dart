import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonTreeView', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTreeView(
            nodes: [CarbonTreeNode(label: 'Root', children: [])],
          ),
        ),
      );

      expect(find.byType(CarbonTreeView), findsOneWidget);
      expect(find.text('Root'), findsOneWidget);
    });

    testWidgets('displays nested nodes', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTreeView(
            nodes: [
              CarbonTreeNode(
                label: 'Parent',
                children: [
                  CarbonTreeNode(label: 'Child 1'),
                  CarbonTreeNode(label: 'Child 2'),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('Parent'), findsOneWidget);
    });

    testWidgets('expands node when tapped', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTreeView(
            nodes: [
              CarbonTreeNode(
                label: 'Expandable',
                children: [CarbonTreeNode(label: 'Hidden Child')],
              ),
            ],
          ),
        ),
      );

      // Child initially hidden
      expect(find.text('Hidden Child'), findsNothing);

      // Tap to expand
      await tester.tap(find.text('Expandable'));
      await tester.pumpAndSettle();

      expect(find.text('Hidden Child'), findsOneWidget);
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
              body: CarbonTreeView(nodes: [CarbonTreeNode(label: 'Test')]),
            ),
          ),
        );

        expect(find.byType(CarbonTreeView), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });
}
