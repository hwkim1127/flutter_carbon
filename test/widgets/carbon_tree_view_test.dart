import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/material.dart';

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

      expect(
        find.byWidgetPredicate((w) => w is CarbonTreeView),
        findsOneWidget,
      );
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

    testWidgets('selects by value and reports the tapped node', (tester) async {
      CarbonTreeNode<String>? selected;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTreeView<String>(
            selectable: true,
            selectedValue: 'b',
            onNodeSelected: (node) => selected = node,
            nodes: const [
              CarbonTreeNode(label: 'Alpha', value: 'a'),
              CarbonTreeNode(label: 'Beta', value: 'b'),
            ],
          ),
        ),
      );

      // The node whose value matches selectedValue renders selected (w600).
      final betaText = tester.widget<Text>(find.text('Beta'));
      expect(betaText.style?.fontWeight, FontWeight.w600);
      final alphaText = tester.widget<Text>(find.text('Alpha'));
      expect(alphaText.style?.fontWeight, FontWeight.w400);

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();
      expect(selected?.value, 'a');
    });

    testWidgets('expansion keyed by value survives rebuilding the node list',
        (tester) async {
      Widget build() => buildTestApp(
            // Fresh node instances every build — values keep the state.
            child: CarbonTreeView<String>(
              nodes: [
                CarbonTreeNode(
                  label: 'Expandable',
                  value: 'root',
                  children: [CarbonTreeNode(label: 'Hidden Child', value: 'c')],
                ),
              ],
            ),
          );

      await tester.pumpWidget(build());
      await tester.tap(find.text('Expandable'));
      await tester.pumpAndSettle();
      expect(find.text('Hidden Child'), findsOneWidget);

      await tester.pumpWidget(build());
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
            builder: (context, child) => CarbonMaterialBridge(child: child!),
            home: Scaffold(
              body: CarbonTreeView(nodes: [CarbonTreeNode(label: 'Test')]),
            ),
          ),
        );

        expect(
          find.byWidgetPredicate((w) => w is CarbonTreeView),
          findsOneWidget,
        );
        await tester.pumpAndSettle();
      }
    });
  });
}
