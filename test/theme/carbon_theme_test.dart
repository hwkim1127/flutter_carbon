import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  group('CarbonTheme', () {
    testWidgets('can be created and provides theme data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          home: Builder(
            builder: (context) {
              final carbon = context.carbon;
              return Scaffold(
                body: Text(
                  'Test',
                  style: TextStyle(color: carbon.text.textPrimary),
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('provides CarbonThemeData through context extension', (
      tester,
    ) async {
      CarbonThemeData? themeData;

      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          home: Builder(
            builder: (context) {
              themeData = context.carbon;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      expect(themeData, isNotNull);
      expect(themeData, isA<CarbonThemeData>());
    });

    testWidgets('throws StateError when CarbonThemeData is not in theme', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(() => context.carbon, throwsStateError);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('supports light theme mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          home: const Scaffold(body: SizedBox()),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('supports dark theme mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: G90Theme.theme),
          home: const Scaffold(body: SizedBox()),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('carbonTheme', () {
    test('creates ThemeData from CarbonThemeData', () {
      final carbon = WhiteTheme.theme;

      final themeData = carbonTheme(carbon: carbon);

      expect(themeData, isA<ThemeData>());
      expect(themeData.useMaterial3, isTrue);
      expect(themeData.extensions[CarbonThemeData], carbon);
    });

    test('sets correct scaffold background color', () {
      final carbon = WhiteTheme.theme;

      final themeData = carbonTheme(carbon: carbon);

      expect(themeData.scaffoldBackgroundColor, carbon.layer.background);
    });

    test('creates color scheme from Carbon tokens', () {
      final carbon = WhiteTheme.theme;

      final themeData = carbonTheme(carbon: carbon);

      expect(themeData.colorScheme.primary, carbon.button.buttonPrimary);
      expect(themeData.colorScheme.onPrimary, carbon.text.textOnColor);
      expect(themeData.colorScheme.error, carbon.layer.supportError);
      expect(themeData.colorScheme.surface, carbon.layer.layer01);
      expect(themeData.colorScheme.onSurface, carbon.text.textPrimary);
    });

    test('sets correct brightness for light theme', () {
      final carbon = WhiteTheme.theme;

      final themeData = carbonTheme(carbon: carbon);

      expect(themeData.colorScheme.brightness, Brightness.light);
    });

    test('sets correct brightness for dark theme', () {
      final carbon = G90Theme.theme;

      final themeData = carbonTheme(carbon: carbon);

      expect(themeData.colorScheme.brightness, Brightness.dark);
    });
  });

  group('CarbonThemeContext extension', () {
    testWidgets('provides access to CarbonThemeData', (tester) async {
      CarbonThemeData? carbonData;

      await tester.pumpWidget(
        MaterialApp(
          theme: carbonTheme(carbon: WhiteTheme.theme),
          home: Builder(
            builder: (context) {
              carbonData = context.carbon;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      expect(carbonData, isNotNull);
      expect(carbonData!.text, isA<CarbonTextThemeData>());
      expect(carbonData!.layer, isA<CarbonLayerThemeData>());
      expect(carbonData!.button, isA<CarbonButtonThemeData>());
    });
  });
}
