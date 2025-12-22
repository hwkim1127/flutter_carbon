import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  group('CarbonSpacing', () {
    test('spacing values are correct', () {
      expect(CarbonSpacing.spacing01, 2.0);
      expect(CarbonSpacing.spacing02, 4.0);
      expect(CarbonSpacing.spacing03, 8.0);
      expect(CarbonSpacing.spacing04, 12.0);
      expect(CarbonSpacing.spacing05, 16.0);
      expect(CarbonSpacing.spacing06, 24.0);
      expect(CarbonSpacing.spacing07, 32.0);
      expect(CarbonSpacing.spacing08, 40.0);
      expect(CarbonSpacing.spacing09, 48.0);
      expect(CarbonSpacing.spacing10, 64.0);
      expect(CarbonSpacing.spacing11, 80.0);
      expect(CarbonSpacing.spacing12, 96.0);
      expect(CarbonSpacing.spacing13, 160.0);
    });

    test('spacing values increase progressively', () {
      expect(CarbonSpacing.spacing02, greaterThan(CarbonSpacing.spacing01));
      expect(CarbonSpacing.spacing03, greaterThan(CarbonSpacing.spacing02));
      expect(CarbonSpacing.spacing13, greaterThan(CarbonSpacing.spacing12));
    });
  });

  group('CarbonFluidSpacing', () {
    test('fluid spacing values are defined', () {
      expect(CarbonFluidSpacing.fluidSpacing01, 0.0);
    });
  });

  group('CarbonSizes', () {
    test('size values are correct', () {
      expect(CarbonSizes.sizeXSmall, 24.0);
      expect(CarbonSizes.sizeSmall, 32.0);
      expect(CarbonSizes.sizeMedium, 40.0);
      expect(CarbonSizes.sizeLarge, 48.0);
      expect(CarbonSizes.sizeXLarge, 64.0);
      expect(CarbonSizes.size2XLarge, 80.0);
    });

    test('container values are correct', () {
      expect(CarbonSizes.container01, 24.0);
      expect(CarbonSizes.container02, 32.0);
      expect(CarbonSizes.container03, 40.0);
      expect(CarbonSizes.container04, 48.0);
      expect(CarbonSizes.container05, 64.0);
    });

    test('sizes increase progressively', () {
      expect(CarbonSizes.sizeSmall, greaterThan(CarbonSizes.sizeXSmall));
      expect(CarbonSizes.sizeMedium, greaterThan(CarbonSizes.sizeSmall));
      expect(CarbonSizes.sizeLarge, greaterThan(CarbonSizes.sizeMedium));
      expect(CarbonSizes.sizeXLarge, greaterThan(CarbonSizes.sizeLarge));
      expect(CarbonSizes.size2XLarge, greaterThan(CarbonSizes.sizeXLarge));
    });
  });

  group('CarbonIconSizes', () {
    test('icon size values are correct', () {
      expect(CarbonIconSizes.iconSize01, 16.0);
      expect(CarbonIconSizes.iconSize02, 20.0);
    });

    test('icon sizes increase progressively', () {
      expect(
        CarbonIconSizes.iconSize02,
        greaterThan(CarbonIconSizes.iconSize01),
      );
    });
  });

  group('CarbonBreakpoints', () {
    test('breakpoint values are correct', () {
      expect(CarbonBreakpoints.sm, 320.0);
      expect(CarbonBreakpoints.md, 672.0);
      expect(CarbonBreakpoints.lg, 1056.0);
      expect(CarbonBreakpoints.xlg, 1312.0);
      expect(CarbonBreakpoints.max, 1584.0);
    });

    test('breakpoints increase progressively', () {
      expect(CarbonBreakpoints.md, greaterThan(CarbonBreakpoints.sm));
      expect(CarbonBreakpoints.lg, greaterThan(CarbonBreakpoints.md));
      expect(CarbonBreakpoints.xlg, greaterThan(CarbonBreakpoints.lg));
      expect(CarbonBreakpoints.max, greaterThan(CarbonBreakpoints.xlg));
    });
  });

  group('CarbonGrid', () {
    test('small grid values are correct', () {
      expect(CarbonGrid.columnsSm, 4);
      expect(CarbonGrid.marginSm, 0.0);
      expect(CarbonGrid.gutterSm, 32.0);
    });

    test('medium grid values are correct', () {
      expect(CarbonGrid.columnsMd, 8);
      expect(CarbonGrid.marginMd, 16.0);
      expect(CarbonGrid.gutterMd, 32.0);
    });

    test('large grid values are correct', () {
      expect(CarbonGrid.columnsLg, 16);
      expect(CarbonGrid.marginLg, 16.0);
      expect(CarbonGrid.gutterLg, 32.0);
    });

    test('xlarge grid values are correct', () {
      expect(CarbonGrid.columnsXlg, 16);
      expect(CarbonGrid.marginXlg, 16.0);
      expect(CarbonGrid.gutterXlg, 32.0);
    });

    test('max grid values are correct', () {
      expect(CarbonGrid.columnsMax, 16);
      expect(CarbonGrid.marginMax, 24.0);
      expect(CarbonGrid.gutterMax, 32.0);
    });

    test('column count increases with breakpoint', () {
      expect(CarbonGrid.columnsMd, greaterThan(CarbonGrid.columnsSm));
      expect(CarbonGrid.columnsLg, greaterThan(CarbonGrid.columnsMd));
    });
  });
}
