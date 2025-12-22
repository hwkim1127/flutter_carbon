import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonSkeleton', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonSkeleton(height: 24)),
      );

      expect(find.byType(CarbonSkeleton), findsOneWidget);
    });

    testWidgets('renders rectangle variant', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonSkeleton.rectangle(width: 200, height: 100),
        ),
      );

      expect(find.byType(CarbonSkeleton), findsOneWidget);
    });

    testWidgets('renders circle variant', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonSkeleton.circle(size: 48)),
      );

      expect(find.byType(CarbonSkeleton), findsOneWidget);
    });

    testWidgets('renders text variant with multiple lines', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: CarbonSkeleton.text(lines: 3)),
      );

      expect(find.byType(CarbonSkeleton), findsNWidgets(3));
    });

    testWidgets('respects width property', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonSkeleton(width: 300, height: 24)),
      );

      final skeleton = tester.widget<CarbonSkeleton>(
        find.byType(CarbonSkeleton),
      );
      expect(skeleton.width, 300);
    });

    testWidgets('respects height property', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonSkeleton(height: 50)),
      );

      final skeleton = tester.widget<CarbonSkeleton>(
        find.byType(CarbonSkeleton),
      );
      expect(skeleton.height, 50);
    });

    testWidgets('supports custom border radius', (tester) async {
      const customRadius = BorderRadius.all(Radius.circular(8));

      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonSkeleton(height: 24, borderRadius: customRadius),
        ),
      );

      final skeleton = tester.widget<CarbonSkeleton>(
        find.byType(CarbonSkeleton),
      );
      expect(skeleton.borderRadius, customRadius);
    });

    testWidgets('animates by default', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonSkeleton(height: 24)),
      );

      final skeleton = tester.widget<CarbonSkeleton>(
        find.byType(CarbonSkeleton),
      );
      expect(skeleton.animate, isTrue);
    });

    testWidgets('can disable animation', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonSkeleton(height: 24, animate: false)),
      );

      final skeleton = tester.widget<CarbonSkeleton>(
        find.byType(CarbonSkeleton),
      );
      expect(skeleton.animate, isFalse);
    });

    testWidgets('text variant creates correct number of lines', (tester) async {
      for (int lineCount in [1, 2, 3, 5]) {
        await tester.pumpWidget(
          buildTestApp(child: CarbonSkeleton.text(lines: lineCount)),
        );

        expect(find.byType(CarbonSkeleton), findsNWidgets(lineCount));
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('text variant respects lineHeight', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: CarbonSkeleton.text(lines: 2, lineHeight: 20)),
      );

      expect(find.byType(CarbonSkeleton), findsNWidgets(2));
    });

    testWidgets('circle variant has equal width and height', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonSkeleton.circle(size: 64)),
      );

      final skeleton = tester.widget<CarbonSkeleton>(
        find.byType(CarbonSkeleton),
      );
      expect(skeleton.width, 64);
      expect(skeleton.height, 64);
    });

    testWidgets('circle variant has circular border radius', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonSkeleton.circle(size: 48)),
      );

      final skeleton = tester.widget<CarbonSkeleton>(
        find.byType(CarbonSkeleton),
      );
      expect(skeleton.borderRadius, isNotNull);
      expect(skeleton.borderRadius!.topLeft.x, greaterThan(100));
    });

    testWidgets('renders with animation controller', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonSkeleton(height: 24, animate: true)),
      );

      // Pump a few frames to ensure animation starts
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(CarbonSkeleton), findsOneWidget);
    });
  });
}
