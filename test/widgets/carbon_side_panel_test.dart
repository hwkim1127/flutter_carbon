import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonSidePanel', () {
    testWidgets('shows side panel', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonSidePanel.show(
                  context: context,
                  title: 'Side Panel',
                  builder: (context) => const Text('Panel content'),
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Side Panel'), findsOneWidget);
      expect(find.text('Panel content'), findsOneWidget);
    });

    testWidgets('closes when close button tapped', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonSidePanel.show(
                  context: context,
                  title: 'Panel',
                  builder: (context) => const Text('Content'),
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Panel'), findsOneWidget);

      // Close panel
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Panel'), findsNothing);
    });

    testWidgets('supports different sizes', (tester) async {
      for (final size in CarbonSidePanelSize.values) {
        await tester.pumpWidget(
          buildTestApp(
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  CarbonSidePanel.show(
                    context: context,
                    title: 'Panel',
                    size: size,
                    builder: (context) => Text(size.name),
                  );
                },
                child: const Text('Show'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show'));
        await tester.pumpAndSettle();

        expect(find.text(size.name), findsOneWidget);

        // Close
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('displays subtitle when provided', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                CarbonSidePanel.show(
                  context: context,
                  title: 'Title',
                  subtitle: 'Subtitle text',
                  builder: (context) => const Text('Content'),
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Subtitle text'), findsOneWidget);

      // Close
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
    });
  });
}
