import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonContainedList', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            items: const [CarbonContainedListItem(child: Text('Item 1'))],
          ),
        ),
      );

      expect(find.byType(CarbonContainedList), findsOneWidget);
    });

    testWidgets('displays title when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            title: 'My List',
            items: const [CarbonContainedListItem(child: Text('Item'))],
          ),
        ),
      );

      expect(find.text('My List'), findsOneWidget);
    });

    testWidgets('displays header action', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            title: 'Actions',
            headerAction: const Icon(Icons.search),
            items: const [CarbonContainedListItem(child: Text('Item'))],
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('displays multiple items', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            items: const [
              CarbonContainedListItem(child: Text('Item 1')),
              CarbonContainedListItem(child: Text('Item 2')),
              CarbonContainedListItem(child: Text('Item 3')),
            ],
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('displays leading icons', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            items: [
              CarbonContainedListItem(
                leading: const Icon(Icons.person),
                child: const Text('User'),
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('displays trailing widgets', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            items: [
              CarbonContainedListItem(
                child: const Text('Item'),
                trailing: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('displays subtitles', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            items: const [
              CarbonContainedListItem(
                child: Text('Title'),
                subtitle: 'Subtitle text',
              ),
            ],
          ),
        ),
      );

      expect(find.text('Subtitle text'), findsOneWidget);
    });

    testWidgets('calls onTap when item tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            items: [
              CarbonContainedListItem(
                child: const Text('Clickable'),
                onTap: () => tapped = true,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Clickable'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap when disabled', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            items: [
              CarbonContainedListItem(
                child: const Text('Disabled'),
                onTap: () => tapped = true,
                enabled: false,
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('shows dividers by default', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            items: const [
              CarbonContainedListItem(child: Text('Item 1')),
              CarbonContainedListItem(child: Text('Item 2')),
            ],
          ),
        ),
      );

      expect(
        find.byType(Divider),
        findsOneWidget,
      ); // One divider between two items
    });

    testWidgets('can hide dividers', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            showDividers: false,
            items: const [
              CarbonContainedListItem(child: Text('Item 1')),
              CarbonContainedListItem(child: Text('Item 2')),
            ],
          ),
        ),
      );

      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('supports inset dividers', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            insetDividers: true,
            items: const [
              CarbonContainedListItem(child: Text('Item 1')),
              CarbonContainedListItem(child: Text('Item 2')),
            ],
          ),
        ),
      );

      final widget = tester.widget<CarbonContainedList>(
        find.byType(CarbonContainedList),
      );
      expect(widget.insetDividers, isTrue);
    });

    testWidgets('supports disclosed variant with elevation', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            disclosed: true,
            items: const [CarbonContainedListItem(child: Text('Item'))],
          ),
        ),
      );

      final widget = tester.widget<CarbonContainedList>(
        find.byType(CarbonContainedList),
      );
      expect(widget.disclosed, isTrue);
    });

    testWidgets('supports custom item height', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonContainedList(
            itemHeight: 64,
            items: const [CarbonContainedListItem(child: Text('Tall item'))],
          ),
        ),
      );

      final widget = tester.widget<CarbonContainedList>(
        find.byType(CarbonContainedList),
      );
      expect(widget.itemHeight, 64);
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
              body: CarbonContainedList(
                title: 'Test',
                items: const [CarbonContainedListItem(child: Text('Item'))],
              ),
            ),
          ),
        );

        expect(find.byType(CarbonContainedList), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });

  group('CarbonContainedListItem', () {
    test('can be created with minimal parameters', () {
      const item = CarbonContainedListItem(child: Text('Test'));
      expect(item.child, isA<Text>());
      expect(item.enabled, isTrue);
    });

    test('supports all optional parameters', () {
      final item = CarbonContainedListItem(
        child: const Text('Test'),
        leading: const Icon(Icons.star),
        trailing: const Icon(Icons.arrow_forward),
        subtitle: 'Subtitle',
        onTap: () {},
        enabled: false,
      );

      expect(item.leading, isNotNull);
      expect(item.trailing, isNotNull);
      expect(item.subtitle, 'Subtitle');
      expect(item.onTap, isNotNull);
      expect(item.enabled, isFalse);
    });
  });
}
