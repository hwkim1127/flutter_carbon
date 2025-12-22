/// Carbon Design System Layout & Spacing.
///
/// Contains spacing constants, container sizes, breakpoints, and icon sizes.
///
/// See: https://carbondesignsystem.com/guidelines/spacing/overview/
class CarbonSpacing {
  const CarbonSpacing._();

  /// 2px (0.125rem)
  static const double spacing01 = 2.0;

  /// 4px (0.25rem)
  static const double spacing02 = 4.0;

  /// 8px (0.5rem)
  static const double spacing03 = 8.0;

  /// 12px (0.75rem)
  static const double spacing04 = 12.0;

  /// 16px (1rem)
  static const double spacing05 = 16.0;

  /// 24px (1.5rem)
  static const double spacing06 = 24.0;

  /// 32px (2rem)
  static const double spacing07 = 32.0;

  /// 40px (2.5rem)
  static const double spacing08 = 40.0;

  /// 48px (3rem)
  static const double spacing09 = 48.0;

  /// 64px (4rem)
  static const double spacing10 = 64.0;

  /// 80px (5rem)
  static const double spacing11 = 80.0;

  /// 96px (6rem)
  static const double spacing12 = 96.0;

  /// 160px (10rem)
  static const double spacing13 = 160.0;
}

/// Carbon Design System Fluid Spacing (Approximations).
///
/// In web, these are viewport units (vw). In Flutter, these might need responsive calculation.
/// We provide the intended 'base' scalar or string representation as a note,
/// but for a theme file, constants are hard to map to VW.
/// We will map them to the 16px base equivalent or leave as placeholders for now.
class CarbonFluidSpacing {
  const CarbonFluidSpacing._();

  static const double fluidSpacing01 = 0.0;
  // fluid-spacing-02: 2vw
  // fluid-spacing-03: 5vw
  // fluid-spacing-04: 10vw
}

/// Carbon Design System generic sizes.
class CarbonSizes {
  const CarbonSizes._();

  /// 24px (1.5rem)
  static const double sizeXSmall = 24.0;

  /// 32px (2rem)
  static const double sizeSmall = 32.0;

  /// 40px (2.5rem)
  static const double sizeMedium = 40.0;

  /// 48px (3rem)
  static const double sizeLarge = 48.0;

  /// 64px (4rem)
  static const double sizeXLarge = 64.0;

  /// 80px (5rem)
  static const double size2XLarge = 80.0;

  // Containers (MiniUnits based)
  // container-01: 3 * 8 = 24
  static const double container01 = 24.0;
  // container-02: 4 * 8 = 32
  static const double container02 = 32.0;
  // container-03: 5 * 8 = 40
  static const double container03 = 40.0;
  // container-04: 6 * 8 = 48
  static const double container04 = 48.0;
  // container-05: 8 * 8 = 64
  static const double container05 = 64.0;
}

/// Carbon Design System Icon Sizes.
class CarbonIconSizes {
  const CarbonIconSizes._();

  /// 16px (1rem)
  static const double iconSize01 = 16.0;

  /// 20px (1.25rem)
  static const double iconSize02 = 20.0;
}

/// Carbon Design System Breakpoints and Grid System.
class CarbonBreakpoints {
  const CarbonBreakpoints._();

  /// 320px
  static const double sm = 320.0;

  /// 672px
  static const double md = 672.0;

  /// 1056px
  static const double lg = 1056.0;

  /// 1312px
  static const double xlg = 1312.0;

  /// 1584px
  static const double max = 1584.0;
}

/// Carbon Design System Grid Parameters.
class CarbonGrid {
  const CarbonGrid._();

  // Small
  static const int columnsSm = 4;
  static const double marginSm = 0.0;
  static const double gutterSm =
      32.0; // Standard 32px gutter mentioned in guidelines usually

  // Medium
  static const int columnsMd = 8;
  static const double marginMd = 16.0;
  static const double gutterMd = 32.0;

  // Large
  static const int columnsLg = 16;
  static const double marginLg = 16.0;
  static const double gutterLg = 32.0;

  // XLarge
  static const int columnsXlg = 16;
  static const double marginXlg = 16.0;
  static const double gutterXlg = 32.0;

  // Max
  static const int columnsMax = 16;
  static const double marginMax = 24.0;
  static const double gutterMax = 32.0;
}
