import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonAILabel', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonAILabel(aiText: 'AI')),
      );
      expect(find.byType(CarbonAILabel), findsOneWidget);
    });

    testWidgets('displays AI text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(child: const CarbonAILabel(aiText: 'AI')),
      );
      expect(find.text('AI'), findsOneWidget);
    });

    testWidgets('supports inline kind with label', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonAILabel(
            aiText: 'AI',
            aiTextLabel: 'Generated content',
            kind: CarbonAILabelKind.inline,
          ),
        ),
      );

      final label = tester.widget<CarbonAILabel>(find.byType(CarbonAILabel));
      expect(label.kind, CarbonAILabelKind.inline);
      expect(label.aiTextLabel, 'Generated content');
    });

    testWidgets('supports default kind', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: const CarbonAILabel(
            aiText: 'AI',
            kind: CarbonAILabelKind.defaultKind,
          ),
        ),
      );

      final label = tester.widget<CarbonAILabel>(find.byType(CarbonAILabel));
      expect(label.kind, CarbonAILabelKind.defaultKind);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonAILabel(aiText: 'AI', onTap: () => tapped = true),
        ),
      );

      await tester.tap(find.byType(CarbonAILabel));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('supports different sizes', (tester) async {
      for (final size in CarbonAILabelSize.values) {
        await tester.pumpWidget(
          buildTestApp(
            child: CarbonAILabel(aiText: 'AI', size: size),
          ),
        );

        final label = tester.widget<CarbonAILabel>(find.byType(CarbonAILabel));
        expect(label.size, size);
        await tester.pumpWidget(Container());
      }
    });
  });

  group('CarbonAILabelSize', () {
    test('has all size variants', () {
      expect(CarbonAILabelSize.values.length, 7);
      expect(CarbonAILabelSize.values, contains(CarbonAILabelSize.mini));
      expect(CarbonAILabelSize.values, contains(CarbonAILabelSize.xs2));
      expect(CarbonAILabelSize.values, contains(CarbonAILabelSize.xs));
      expect(CarbonAILabelSize.values, contains(CarbonAILabelSize.sm));
      expect(CarbonAILabelSize.values, contains(CarbonAILabelSize.md));
      expect(CarbonAILabelSize.values, contains(CarbonAILabelSize.lg));
      expect(CarbonAILabelSize.values, contains(CarbonAILabelSize.xl));
    });
  });

  group('CarbonAILabelKind', () {
    test('has correct enum values', () {
      expect(CarbonAILabelKind.values.length, 2);
      expect(CarbonAILabelKind.values, contains(CarbonAILabelKind.defaultKind));
      expect(CarbonAILabelKind.values, contains(CarbonAILabelKind.inline));
    });
  });
}
