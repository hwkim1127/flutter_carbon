import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

import '../shared/build.dart';

void main() {
  group('CarbonChatButton', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonChatButton(onPressed: () {}, child: const Text('Send')),
        ),
      );

      expect(find.byType(CarbonChatButton), findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        buildTestApp(
          child: CarbonChatButton(
            onPressed: () => pressed = true,
            child: const Text('Button'),
          ),
        ),
      );

      await tester.tap(find.byType(CarbonChatButton));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('supports different kinds', (tester) async {
      for (final kind in CarbonChatButtonKind.values) {
        await tester.pumpWidget(
          buildTestApp(
            child: CarbonChatButton(
              kind: kind,
              onPressed: () {},
              child: Text(kind.name),
            ),
          ),
        );

        expect(find.byType(CarbonChatButton), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('can be disabled', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonChatButton(
            onPressed: null,
            disabled: true,
            child: const Text('Disabled'),
          ),
        ),
      );

      final button = tester.widget<CarbonChatButton>(
        find.byType(CarbonChatButton),
      );
      expect(button.disabled, isTrue);
    });

    testWidgets('supports quick action mode', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          child: CarbonChatButton(
            onPressed: () {},
            isQuickAction: true,
            icon: const Icon(Icons.attach_file),
            child: const Text('Attach'),
          ),
        ),
      );

      final button = tester.widget<CarbonChatButton>(
        find.byType(CarbonChatButton),
      );
      expect(button.isQuickAction, isTrue);
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
              body: CarbonChatButton(
                onPressed: () {},
                child: const Text('Test'),
              ),
            ),
          ),
        );

        expect(find.byType(CarbonChatButton), findsOneWidget);
        await tester.pumpAndSettle();
      }
    });
  });

  group('CarbonChatButtonKind', () {
    test('has correct enum values', () {
      expect(CarbonChatButtonKind.values.length, 5);
      expect(
        CarbonChatButtonKind.values,
        contains(CarbonChatButtonKind.primary),
      );
      expect(
        CarbonChatButtonKind.values,
        contains(CarbonChatButtonKind.secondary),
      );
      expect(
        CarbonChatButtonKind.values,
        contains(CarbonChatButtonKind.tertiary),
      );
      expect(CarbonChatButtonKind.values, contains(CarbonChatButtonKind.ghost));
      expect(
        CarbonChatButtonKind.values,
        contains(CarbonChatButtonKind.danger),
      );
    });
  });
}
