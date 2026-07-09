import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonLoading', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(buildTestApp(child: const CarbonLoading()));

      expect(find.byType(CarbonLoading), findsOneWidget);
      expect(find.byType(CarbonSpinner), findsOneWidget);
    });

    testWidgets('displays with small size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonLoading(size: CarbonLoadingSize.small)),
      );

      expect(tester.getSize(find.byType(CarbonSpinner)), const Size(16, 16));
    });

    testWidgets('displays with medium size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonLoading(size: CarbonLoadingSize.medium),
        ),
      );

      expect(tester.getSize(find.byType(CarbonSpinner)), const Size(48, 48));
    });

    testWidgets('displays with large size', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonLoading(size: CarbonLoadingSize.large)),
      );

      expect(tester.getSize(find.byType(CarbonSpinner)), const Size(88, 88));
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

    testWidgets('spinner animates without Material', (tester) async {
      await tester.pumpWidget(
        CarbonApp(
          theme: WhiteTheme.theme,
          home: const Center(child: CarbonSpinner(size: 88)),
        ),
      );

      expect(find.byType(CarbonSpinner), findsOneWidget);
      // Advance a few frames — the repeating rotation must not throw.
      await tester.pump(const Duration(milliseconds: 345));
      await tester.pump(const Duration(milliseconds: 345));
      expect(tester.takeException(), isNull);
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
