import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

/// Main test file for Flutter Carbon package.
///
/// This file provides a comprehensive test suite that validates:
/// - Foundation modules (colors, layout, motion, typography)
/// - Theme system and variants (White, G10, G90, G100)
/// - Widget implementations
/// - Icon system
///
/// Individual test files are organized in subdirectories:
/// - test/foundation/ - Foundation module tests
/// - test/theme/ - Theme system tests
/// - test/widgets/ - Widget component tests
/// - test/icons/ - Icon tests
void main() {
  group('Flutter Carbon Package', () {
    test('package can be imported', () {
      expect(CarbonPalette, isNotNull);
      expect(CarbonSpacing, isNotNull);
      expect(CarbonMotion, isNotNull);
      expect(CarbonTypography, isNotNull);
    });

    test('theme variants are available', () {
      expect(WhiteTheme.theme, isA<CarbonThemeData>());
      expect(G10Theme.theme, isA<CarbonThemeData>());
      expect(G90Theme.theme, isA<CarbonThemeData>());
      expect(G100Theme.theme, isA<CarbonThemeData>());
    });

    test('foundation modules are accessible', () {
      // Colors
      expect(CarbonPalette.black, isNotNull);
      expect(CarbonPalette.white, isNotNull);
      expect(CarbonPalette.blue60, isNotNull);

      // Layout
      expect(CarbonSpacing.spacing05, 16.0);
      expect(CarbonBreakpoints.lg, 1056.0);
      expect(CarbonSizes.sizeMedium, 40.0);

      // Motion
      expect(CarbonMotion.fast01.inMilliseconds, 70);
      expect(CarbonMotion.moderate01.inMilliseconds, 150);
      expect(CarbonMotion.slow01.inMilliseconds, 400);

      // Typography
      expect(CarbonTypography.fontFamily, 'IBM Plex Sans');
      expect(CarbonTypography.heading01.fontSize, 14);
    });

    test('widgets are exported', () {
      expect(CarbonDropdown, isNotNull);
      expect(CarbonLoading, isNotNull);
      expect(CarbonToggle, isNotNull);
      expect(CarbonSkeleton, isNotNull);
    });

    test('theme data types are exported', () {
      expect(CarbonTextThemeData, isNotNull);
      expect(CarbonLayerThemeData, isNotNull);
      expect(CarbonButtonThemeData, isNotNull);
      expect(CarbonStatusThemeData, isNotNull);
      expect(CarbonNotificationThemeData, isNotNull);
    });

    test('icons are available', () {
      expect(CarbonIcons.add, isNotNull);
      expect(CarbonIcons.close, isNotNull);
      expect(CarbonIcons.search, isNotNull);
    });
  });

  group('Theme System', () {
    test('White theme has light background', () {
      final theme = WhiteTheme.theme;
      expect(theme.layer.background.computeLuminance(), greaterThan(0.5));
    });

    test('G10 theme has light background', () {
      final theme = G10Theme.theme;
      expect(theme.layer.background.computeLuminance(), greaterThan(0.5));
    });

    test('G90 theme has dark background', () {
      final theme = G90Theme.theme;
      expect(theme.layer.background.computeLuminance(), lessThan(0.5));
    });

    test('G100 theme has darkest background', () {
      final theme = G100Theme.theme;
      expect(theme.layer.background.computeLuminance(), lessThan(0.1));
    });

    test('all themes have required component themes', () {
      final themes = [
        WhiteTheme.theme,
        G10Theme.theme,
        G90Theme.theme,
        G100Theme.theme,
      ];

      for (final theme in themes) {
        expect(theme.text, isNotNull);
        expect(theme.layer, isNotNull);
        expect(theme.button, isNotNull);
        expect(theme.notification, isNotNull);
        expect(theme.status, isNotNull);
        expect(theme.skeleton, isNotNull);
        expect(theme.chat, isNotNull);
        expect(theme.ai, isNotNull);
        expect(theme.syntax, isNotNull);
        expect(theme.breadcrumb, isNotNull);
        expect(theme.numberInput, isNotNull);
        expect(theme.codeSnippet, isNotNull);
      }
    });
  });

  group('Foundation Values', () {
    test('spacing values follow 8px grid', () {
      expect(CarbonSpacing.spacing03, 8.0);
      expect(CarbonSpacing.spacing05, 16.0);
      expect(CarbonSpacing.spacing07, 32.0);
      expect(CarbonSpacing.spacing09, 48.0);
    });

    test('icon sizes are correct', () {
      expect(CarbonIconSizes.iconSize01, 16.0);
      expect(CarbonIconSizes.iconSize02, 20.0);
    });

    test('motion durations are progressive', () {
      expect(
        CarbonMotion.fast02.inMilliseconds,
        greaterThan(CarbonMotion.fast01.inMilliseconds),
      );
      expect(
        CarbonMotion.moderate01.inMilliseconds,
        greaterThan(CarbonMotion.fast02.inMilliseconds),
      );
      expect(
        CarbonMotion.slow01.inMilliseconds,
        greaterThan(CarbonMotion.moderate02.inMilliseconds),
      );
    });

    test('color palette is comprehensive', () {
      // Test presence of color scales
      expect(CarbonPalette.gray10, isNotNull);
      expect(CarbonPalette.gray100, isNotNull);
      expect(CarbonPalette.blue10, isNotNull);
      expect(CarbonPalette.blue100, isNotNull);
      expect(CarbonPalette.red10, isNotNull);
      expect(CarbonPalette.red100, isNotNull);
      expect(CarbonPalette.green10, isNotNull);
      expect(CarbonPalette.green100, isNotNull);
    });

    test('typography styles have correct font families', () {
      expect(CarbonTypography.body01.fontFamily, 'IBM Plex Sans');
      expect(CarbonTypography.heading01.fontFamily, 'IBM Plex Sans');
      expect(CarbonTypography.code01.fontFamily, 'IBM Plex Mono');
      expect(CarbonTypography.quotation01.fontFamily, 'IBM Plex Serif');
    });
  });

  group('Widget Enums', () {
    test('CarbonLoadingSize has all values', () {
      expect(CarbonLoadingSize.values.length, 3);
      expect(CarbonLoadingSize.values, contains(CarbonLoadingSize.small));
      expect(CarbonLoadingSize.values, contains(CarbonLoadingSize.medium));
      expect(CarbonLoadingSize.values, contains(CarbonLoadingSize.large));
    });

    test('CarbonToggleSize has all values', () {
      expect(CarbonToggleSize.values.length, 2);
      expect(CarbonToggleSize.values, contains(CarbonToggleSize.regular));
      expect(CarbonToggleSize.values, contains(CarbonToggleSize.small));
    });
  });

  group('Package Exports', () {
    test('all foundation modules are exported', () {
      // This ensures all public APIs are accessible
      expect(CarbonPalette, isNotNull);
      expect(CarbonSpacing, isNotNull);
      expect(CarbonMotion, isNotNull);
      expect(CarbonTypography, isNotNull);
      expect(CarbonSizes, isNotNull);
      expect(CarbonIconSizes, isNotNull);
      expect(CarbonBreakpoints, isNotNull);
      expect(CarbonGrid, isNotNull);
    });

    test('all theme variants are exported', () {
      expect(WhiteTheme, isNotNull);
      expect(G10Theme, isNotNull);
      expect(G90Theme, isNotNull);
      expect(G100Theme, isNotNull);
    });

    test('theme data classes are exported', () {
      expect(CarbonThemeData, isNotNull);
      expect(CarbonTextThemeData, isNotNull);
      expect(CarbonLayerThemeData, isNotNull);
      expect(CarbonButtonThemeData, isNotNull);
    });
  });
}
