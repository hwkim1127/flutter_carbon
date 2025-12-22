import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonTile', () {
    testWidgets('renders base tile without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTile(title: 'Test Tile', child: const Text('Content')),
        ),
      );

      expect(find.byType(CarbonTile), findsOneWidget);
      expect(find.text('Test Tile'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('displays subtitle when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTile(
            title: 'Title',
            subtitle: 'Subtitle text',
            child: const Text('Content'),
          ),
        ),
      );

      expect(find.text('Subtitle text'), findsOneWidget);
    });

    testWidgets('displays leading widget', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTile(
            title: 'With Icon',
            leading: const Icon(Icons.star),
            child: const Text('Content'),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('displays trailing widget', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonTile(
            title: 'With trailing',
            trailing: const Icon(Icons.arrow_forward),
            child: const Text('Content'),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    group('Clickable variant', () {
      testWidgets('renders clickable tile', (tester) async {
        await tester.pumpWidget(
          buildTestApp(
            child: CarbonTile.clickable(
              title: 'Clickable',
              onTap: () {},
              child: const Text('Click me'),
            ),
          ),
        );

        expect(find.byType(CarbonTile), findsOneWidget);
      });

      testWidgets('calls onTap when tapped', (tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          buildTestApp(
            child: CarbonTile.clickable(
              title: 'Clickable',
              onTap: () => tapped = true,
              child: const Text('Click me'),
            ),
          ),
        );

        await tester.tap(find.byType(CarbonTile));
        await tester.pumpAndSettle();

        expect(tapped, isTrue);
      });

      testWidgets('does not call onTap when disabled', (tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          buildTestApp(
            child: CarbonTile.clickable(
              title: 'Disabled',
              onTap: () => tapped = true,
              disabled: true,
              child: const Text('Disabled'),
            ),
          ),
        );

        await tester.tap(find.byType(CarbonTile));
        await tester.pumpAndSettle();

        expect(tapped, isFalse);
      });
    });

    group('Selectable variant', () {
      testWidgets('renders selectable tile', (tester) async {
        await tester.pumpWidget(
          buildTestApp(
            child: CarbonTile.selectable(
              title: 'Selectable',
              selected: false,
              onSelectedChanged: (_) {},
              child: const Text('Select me'),
            ),
          ),
        );

        expect(find.byType(CarbonTile), findsOneWidget);
      });

      testWidgets('shows selection state', (tester) async {
        bool selected = false;

        await tester.pumpWidget(
          buildTestApp(
            child: StatefulBuilder(
              builder: (context, setState) {
                return CarbonTile.selectable(
                  title: 'Selectable',
                  selected: selected,
                  onSelectedChanged: (value) {
                    setState(() => selected = value);
                  },
                  child: const Text('Select me'),
                );
              },
            ),
          ),
        );

        final tile = tester.widget<CarbonTile>(find.byType(CarbonTile));
        expect(tile.selected, isFalse);

        await tester.tap(find.byType(CarbonTile));
        await tester.pumpAndSettle();

        expect(selected, isTrue);
      });

      testWidgets('onSelectedChanged callback works', (tester) async {
        bool selected = false;

        await tester.pumpWidget(
          buildTestApp(
            child: StatefulBuilder(
              builder: (context, setState) {
                return CarbonTile.selectable(
                  title: 'Test',
                  selected: selected,
                  onSelectedChanged: (value) {
                    setState(() => selected = value);
                  },
                  child: const Text('Content'),
                );
              },
            ),
          ),
        );

        expect(selected, isFalse);

        await tester.tap(find.byType(CarbonTile));
        await tester.pumpAndSettle();

        expect(selected, isTrue);

        await tester.tap(find.byType(CarbonTile));
        await tester.pumpAndSettle();

        expect(selected, isFalse);
      });
    });

    group('Expandable variant', () {
      testWidgets('renders expandable tile', (tester) async {
        await tester.pumpWidget(
          buildTestApp(
            child: CarbonTile.expandable(
              title: 'Expandable',
              expanded: false,
              onExpansionChanged: (_) {},
              expandedContent: const Text('Expanded content'),
              child: const Text('Collapsed content'),
            ),
          ),
        );

        expect(find.byType(CarbonTile), findsOneWidget);
      });

      testWidgets('shows collapsed state initially', (tester) async {
        await tester.pumpWidget(
          buildTestApp(
            child: CarbonTile.expandable(
              title: 'Expandable',
              expanded: false,
              onExpansionChanged: (_) {},
              expandedContent: const Text('Expanded'),
              child: const Text('Collapsed'),
            ),
          ),
        );

        expect(find.text('Collapsed'), findsOneWidget);
        expect(find.text('Expanded'), findsNothing);
      });

      testWidgets('expands when tapped', (tester) async {
        bool expanded = false;

        await tester.pumpWidget(
          buildTestApp(
            child: StatefulBuilder(
              builder: (context, setState) {
                return CarbonTile.expandable(
                  title: 'Expandable',
                  expanded: expanded,
                  onExpansionChanged: (value) {
                    setState(() => expanded = value);
                  },
                  expandedContent: const Text('Expanded content'),
                  child: const Text('Collapsed content'),
                );
              },
            ),
          ),
        );

        expect(find.text('Expanded content'), findsNothing);

        await tester.tap(find.byType(CarbonTile));
        await tester.pumpAndSettle();

        expect(expanded, isTrue);
        expect(find.text('Expanded content'), findsOneWidget);
      });

      testWidgets('collapses when tapped again', (tester) async {
        bool expanded = true;

        await tester.pumpWidget(
          buildTestApp(
            child: StatefulBuilder(
              builder: (context, setState) {
                return CarbonTile.expandable(
                  title: 'Expandable',
                  expanded: expanded,
                  onExpansionChanged: (value) {
                    setState(() => expanded = value);
                  },
                  expandedContent: const Text('Expanded content'),
                  child: const Text('Collapsed content'),
                );
              },
            ),
          ),
        );

        expect(find.text('Expanded content'), findsOneWidget);

        await tester.tap(find.byType(CarbonTile));
        await tester.pumpAndSettle();

        expect(expanded, isFalse);
      });
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
              body: CarbonTile(
                title: 'Theme test',
                child: const Text('Content'),
              ),
            ),
          ),
        );

        expect(find.byType(CarbonTile), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });
}
