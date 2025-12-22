import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonLink', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonLink(text: 'Test Link', onTap: () {}),
        ),
      );
      expect(find.byType(CarbonLink), findsOneWidget);
      expect(find.text('Test Link'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonLink(text: 'Click me', onTap: () => tapped = true),
        ),
      );
      await tester.tap(find.text('Click me'));
      expect(tapped, isTrue);
    });

    testWidgets('supports small size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonLink(text: 'Small link', size: CarbonLinkSize.small),
        ),
      );
      final link = tester.widget<CarbonLink>(find.byType(CarbonLink));
      expect(link.size, CarbonLinkSize.small);
    });

    testWidgets('supports medium size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: CarbonLink(text: 'Medium link')),
      );
      final link = tester.widget<CarbonLink>(find.byType(CarbonLink));
      expect(link.size, CarbonLinkSize.medium);
    });

    testWidgets('supports large size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonLink(text: 'Large link', size: CarbonLinkSize.large),
        ),
      );
      final link = tester.widget<CarbonLink>(find.byType(CarbonLink));
      expect(link.size, CarbonLinkSize.large);
    });

    testWidgets('can be disabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: CarbonLink(text: 'Disabled', disabled: true)),
      );
      final link = tester.widget<CarbonLink>(find.byType(CarbonLink));
      expect(link.disabled, isTrue);
    });

    testWidgets('supports visited state', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: CarbonLink(text: 'Visited', visited: true)),
      );
      final link = tester.widget<CarbonLink>(find.byType(CarbonLink));
      expect(link.visited, isTrue);
    });

    testWidgets('displays icon when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonLink(text: 'With icon', icon: const Icon(Icons.launch)),
        ),
      );
      expect(find.byIcon(Icons.launch), findsOneWidget);
    });
  });

  group('CarbonLinkSize', () {
    test('has correct enum values', () {
      expect(CarbonLinkSize.values.length, 3);
      expect(CarbonLinkSize.values, contains(CarbonLinkSize.small));
      expect(CarbonLinkSize.values, contains(CarbonLinkSize.medium));
      expect(CarbonLinkSize.values, contains(CarbonLinkSize.large));
    });
  });
}
