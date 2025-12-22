import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonLoading', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(buildTestApp(child: const CarbonLoading()));

      expect(find.byType(CarbonLoading), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays with small size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonLoading(size: CarbonLoadingSize.small)),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.width, 16.0);
      expect(sizedBox.height, 16.0);
    });

    testWidgets('displays with medium size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonLoading(size: CarbonLoadingSize.medium),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.width, 48.0);
      expect(sizedBox.height, 48.0);
    });

    testWidgets('displays with large size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonLoading(size: CarbonLoadingSize.large)),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(SizedBox),
        ),
      );

      expect(sizedBox.width, 88.0);
      expect(sizedBox.height, 88.0);
    });

    testWidgets('displays description when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonLoading(description: 'Loading data...'),
        ),
      );

      expect(find.text('Loading data...'), findsOneWidget);
    });

    testWidgets('displays with overlay when withOverlay is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonLoading(withOverlay: true)),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('does not display overlay when withOverlay is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonLoading(withOverlay: false)),
      );

      expect(find.byType(Column), findsOneWidget);
    });
  });

  group('CarbonLoadingSize', () {
    test('has correct enum values', () {
      expect(CarbonLoadingSize.values.length, 3);
      expect(CarbonLoadingSize.values, contains(CarbonLoadingSize.small));
      expect(CarbonLoadingSize.values, contains(CarbonLoadingSize.medium));
      expect(CarbonLoadingSize.values, contains(CarbonLoadingSize.large));
    });
  });
}
