import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  group('WhiteTheme', () {
    test('creates valid CarbonThemeData', () {
      final theme = WhiteTheme.theme;

      expect(theme, isA<CarbonThemeData>());
      expect(theme.text, isA<CarbonTextThemeData>());
      expect(theme.layer, isA<CarbonLayerThemeData>());
      expect(theme.button, isA<CarbonButtonThemeData>());
      expect(theme.notification, isA<CarbonNotificationThemeData>());
      expect(theme.contentSwitcher, isA<CarbonContentSwitcherThemeData>());
      expect(theme.status, isA<CarbonStatusThemeData>());
      expect(theme.skeleton, isA<CarbonSkeletonThemeData>());
      expect(theme.chat, isA<CarbonChatThemeData>());
      expect(theme.ai, isA<CarbonAIThemeData>());
      expect(theme.syntax, isA<CarbonSyntaxThemeData>());
    });

    test('has light background', () {
      final theme = WhiteTheme.theme;

      expect(theme.layer.background, isNot(equals(const Color(0xFF000000))));
    });
  });

  group('G10Theme', () {
    test('creates valid CarbonThemeData', () {
      final theme = G10Theme.theme;

      expect(theme, isA<CarbonThemeData>());
      expect(theme.text, isA<CarbonTextThemeData>());
      expect(theme.layer, isA<CarbonLayerThemeData>());
      expect(theme.button, isA<CarbonButtonThemeData>());
      expect(theme.notification, isA<CarbonNotificationThemeData>());
      expect(theme.contentSwitcher, isA<CarbonContentSwitcherThemeData>());
      expect(theme.status, isA<CarbonStatusThemeData>());
      expect(theme.skeleton, isA<CarbonSkeletonThemeData>());
      expect(theme.chat, isA<CarbonChatThemeData>());
      expect(theme.ai, isA<CarbonAIThemeData>());
      expect(theme.syntax, isA<CarbonSyntaxThemeData>());
    });

    test('has light background', () {
      final theme = G10Theme.theme;

      expect(theme.layer.background, isNot(equals(const Color(0xFF000000))));
    });
  });

  group('G90Theme', () {
    test('creates valid CarbonThemeData', () {
      final theme = G90Theme.theme;

      expect(theme, isA<CarbonThemeData>());
      expect(theme.text, isA<CarbonTextThemeData>());
      expect(theme.layer, isA<CarbonLayerThemeData>());
      expect(theme.button, isA<CarbonButtonThemeData>());
      expect(theme.notification, isA<CarbonNotificationThemeData>());
      expect(theme.contentSwitcher, isA<CarbonContentSwitcherThemeData>());
      expect(theme.status, isA<CarbonStatusThemeData>());
      expect(theme.skeleton, isA<CarbonSkeletonThemeData>());
      expect(theme.chat, isA<CarbonChatThemeData>());
      expect(theme.ai, isA<CarbonAIThemeData>());
      expect(theme.syntax, isA<CarbonSyntaxThemeData>());
    });

    test('has dark background', () {
      final theme = G90Theme.theme;

      expect(theme.layer.background, const Color(0xFF262626));
    });
  });

  group('G100Theme', () {
    test('creates valid CarbonThemeData', () {
      final theme = G100Theme.theme;

      expect(theme, isA<CarbonThemeData>());
      expect(theme.text, isA<CarbonTextThemeData>());
      expect(theme.layer, isA<CarbonLayerThemeData>());
      expect(theme.button, isA<CarbonButtonThemeData>());
      expect(theme.notification, isA<CarbonNotificationThemeData>());
      expect(theme.contentSwitcher, isA<CarbonContentSwitcherThemeData>());
      expect(theme.status, isA<CarbonStatusThemeData>());
      expect(theme.skeleton, isA<CarbonSkeletonThemeData>());
      expect(theme.chat, isA<CarbonChatThemeData>());
      expect(theme.ai, isA<CarbonAIThemeData>());
      expect(theme.syntax, isA<CarbonSyntaxThemeData>());
    });

    test('has darkest background', () {
      final theme = G100Theme.theme;

      expect(theme.layer.background, const Color(0xFF161616));
    });
  });

  group('Theme Comparisons', () {
    test('different themes have different background colors', () {
      final white = WhiteTheme.theme;
      final g10 = G10Theme.theme;
      final g90 = G90Theme.theme;
      final g100 = G100Theme.theme;

      expect(white.layer.background, isNot(equals(g10.layer.background)));
      expect(g10.layer.background, isNot(equals(g90.layer.background)));
      expect(g90.layer.background, isNot(equals(g100.layer.background)));
    });

    test('light themes have lighter backgrounds than dark themes', () {
      final white = WhiteTheme.theme;
      final g100 = G100Theme.theme;

      expect(
        white.layer.background.computeLuminance(),
        greaterThan(g100.layer.background.computeLuminance()),
      );
    });

    test('all themes have button theme data', () {
      final themes = [
        WhiteTheme.theme,
        G10Theme.theme,
        G90Theme.theme,
        G100Theme.theme,
      ];

      for (final theme in themes) {
        expect(theme.button, isNotNull);
        expect(theme.button.buttonPrimary, isNotNull);
        expect(theme.button.buttonSecondary, isNotNull);
        expect(theme.button.buttonTertiary, isNotNull);
      }
    });

    test('all themes have text theme data', () {
      final themes = [
        WhiteTheme.theme,
        G10Theme.theme,
        G90Theme.theme,
        G100Theme.theme,
      ];

      for (final theme in themes) {
        expect(theme.text, isNotNull);
        expect(theme.text.textPrimary, isNotNull);
        expect(theme.text.textSecondary, isNotNull);
        expect(theme.text.textPlaceholder, isNotNull);
      }
    });

    test('all themes have layer theme data', () {
      final themes = [
        WhiteTheme.theme,
        G10Theme.theme,
        G90Theme.theme,
        G100Theme.theme,
      ];

      for (final theme in themes) {
        expect(theme.layer, isNotNull);
        expect(theme.layer.background, isNotNull);
        expect(theme.layer.layer01, isNotNull);
        expect(theme.layer.layer02, isNotNull);
      }
    });

    test('all themes have component theme data', () {
      final themes = [
        WhiteTheme.theme,
        G10Theme.theme,
        G90Theme.theme,
        G100Theme.theme,
      ];

      for (final theme in themes) {
        expect(theme.notification, isNotNull);
        expect(theme.contentSwitcher, isNotNull);
        expect(theme.status, isNotNull);
        expect(theme.skeleton, isNotNull);
        expect(theme.chat, isNotNull);
        expect(theme.ai, isNotNull);
        expect(theme.syntax, isNotNull);
      }
    });
  });

  group('Theme Integration', () {
    testWidgets('WhiteTheme can be used in widget tree', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          home: Builder(
            builder: (context) {
              final carbon = context.carbon;
              return Scaffold(
                backgroundColor: carbon.layer.background,
                body: Text(
                  'White Theme',
                  style: TextStyle(color: carbon.text.textPrimary),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('White Theme'), findsOneWidget);
    });

    testWidgets('G10Theme can be used in widget tree', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: G10Theme.theme),
          home: Builder(
            builder: (context) {
              final carbon = context.carbon;
              return Scaffold(
                backgroundColor: carbon.layer.background,
                body: Text(
                  'G10 Theme',
                  style: TextStyle(color: carbon.text.textPrimary),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('G10 Theme'), findsOneWidget);
    });

    testWidgets('G90Theme can be used in widget tree', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: G90Theme.theme),
          home: Builder(
            builder: (context) {
              final carbon = context.carbon;
              return Scaffold(
                backgroundColor: carbon.layer.background,
                body: Text(
                  'G90 Theme',
                  style: TextStyle(color: carbon.text.textPrimary),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('G90 Theme'), findsOneWidget);
    });

    testWidgets('G100Theme can be used in widget tree', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: G100Theme.theme),
          home: Builder(
            builder: (context) {
              final carbon = context.carbon;
              return Scaffold(
                backgroundColor: carbon.layer.background,
                body: Text(
                  'G100 Theme',
                  style: TextStyle(color: carbon.text.textPrimary),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('G100 Theme'), findsOneWidget);
    });
  });
}
