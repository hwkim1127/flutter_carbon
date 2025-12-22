import 'package:flutter/material.dart';

/// Carbon Design System Typography.
///
/// Contains font families, weights, and type styles.
///
/// See: https://carbondesignsystem.com/guidelines/typography/overview/
class CarbonTypography {
  const CarbonTypography._();

  static const String fontFamily = 'IBM Plex Sans';
  static const String fontFamilyMono = 'IBM Plex Mono';
  static const String fontFamilySerif = 'IBM Plex Serif';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight light = FontWeight.w300;

  // Type Styles (Size, LineHeight in logical pixels assuming base 16)
  // 1 rem = 16px.

  // 12px / 1.33
  static const TextStyle caption01 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    height: 1.33333,
    letterSpacing: 0.32,
  );

  // 14px / 1.28
  static const TextStyle caption02 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.28572,
    letterSpacing: 0.32,
  );

  // 12px / 1.33
  static const TextStyle label01 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    height: 1.33333,
    letterSpacing: 0.32,
  );

  // 14px / 1.28
  static const TextStyle label02 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.28572,
    letterSpacing: 0.16,
  );

  // 12px / 1.33
  static const TextStyle helperText01 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight:
        regular, // Interpreted as regular, though usually it picks up parent weight
    height: 1.33333,
    letterSpacing: 0.32,
  );

  // 14px / 1.28
  static const TextStyle helperText02 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.28572,
    letterSpacing: 0.16,
  );

  // 12px / 1.33
  static const TextStyle legal01 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    height: 1.33333,
    letterSpacing: 0.32,
  );

  // 14px / 1.28
  static const TextStyle legal02 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.28572,
    letterSpacing: 0.16,
  );

  // 14px / 1.28
  static const TextStyle bodyShort01 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.28572,
    letterSpacing: 0.16,
  );

  // 14px / 1.42
  static const TextStyle bodyLong01 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    height: 1.42857,
    letterSpacing: 0.16,
  );

  // 16px / 1.375
  static const TextStyle bodyShort02 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: regular,
    height: 1.375,
    letterSpacing: 0,
  );

  // 16px / 1.5
  static const TextStyle bodyLong02 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: regular,
    height: 1.5,
    letterSpacing: 0,
  );

  // Body Compact (Aliases)
  static const TextStyle bodyCompact01 = bodyShort01;
  static const TextStyle bodyCompact02 = bodyShort02;
  static const TextStyle body01 = bodyLong01;
  static const TextStyle body02 = bodyLong02;

  // 12px / 1.33 - Mono
  static const TextStyle code01 = TextStyle(
    fontFamily: fontFamilyMono,
    fontSize: 12,
    fontWeight: regular,
    height: 1.33333,
    letterSpacing: 0.32,
  );

  // 14px / 1.42 - Mono
  static const TextStyle code02 = TextStyle(
    fontFamily: fontFamilyMono,
    fontSize: 14,
    fontWeight: regular,
    height: 1.42857,
    letterSpacing: 0.32,
  );

  // 14px / 1.42
  static const TextStyle heading01 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.42857,
    letterSpacing: 0.16,
  );

  // 14px / 1.28
  static const TextStyle productiveHeading01 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.28572,
    letterSpacing: 0.16,
  );

  // 16px / 1.5
  static const TextStyle heading02 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    height: 1.5,
    letterSpacing: 0,
  );

  // 16px / 1.375
  static const TextStyle productiveHeading02 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    height: 1.375,
    letterSpacing: 0,
  );

  // 20px / 1.4
  static const TextStyle productiveHeading03 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: regular,
    height: 1.4,
    letterSpacing: 0,
  );

  // 28px / 1.28
  static const TextStyle productiveHeading04 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: regular,
    height: 1.28572,
    letterSpacing: 0,
  );

  // 32px / 1.25
  static const TextStyle productiveHeading05 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: regular,
    height: 1.25,
    letterSpacing: 0,
  );

  // 42px / 1.199
  static const TextStyle productiveHeading06 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 42,
    fontWeight: light,
    height: 1.199,
    letterSpacing: 0,
  );

  // 54px / 1.199
  static const TextStyle productiveHeading07 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 54,
    fontWeight: light,
    height: 1.199,
    letterSpacing: 0,
  );

  // Heading Compact (Aliases)
  static const TextStyle headingCompact01 = productiveHeading01;
  static const TextStyle headingCompact02 = productiveHeading02;
  static const TextStyle heading03 = productiveHeading03;
  static const TextStyle heading04 = productiveHeading04;
  static const TextStyle heading05 = productiveHeading05;
  static const TextStyle heading06 = productiveHeading06;
  static const TextStyle heading07 = productiveHeading07;

  // Expressive headings (Fluid in web, mapped to fixed breakpoints here for simplicity,
  // typically matching the 'max' or 'lg' breakpoint values for a standard mobile/desktop app).

  // 14px / 1.25
  static const TextStyle expressiveHeading01 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.25,
    letterSpacing: 0.16,
  );

  // 16px / 1.5
  static const TextStyle expressiveHeading02 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    height: 1.5,
    letterSpacing: 0,
  );

  // 20px / 1.4 (Same as productiveHeading03)
  static const TextStyle expressiveHeading03 = productiveHeading03;

  // 28px / 1.25 (lg breakpoint)
  static const TextStyle expressiveHeading04 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: regular,
    height: 1.25,
    letterSpacing: 0,
  );

  // 32px / 1.25 (lg breakpoint)
  static const TextStyle expressiveHeading05 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: regular,
    height: 1.25,
    letterSpacing: 0,
  );

  // 32px / 1.25 (lg breakpoint) - Semibold
  static const TextStyle expressiveHeading06 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: semiBold,
    height: 1.25,
    letterSpacing: 0,
  );

  // 24px / 1.28 (lg breakpoint)
  static const TextStyle expressiveParagraph01 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: light,
    height: 1.28572,
    letterSpacing: 0,
  );

  // 20px / 1.3 (md breakpoint) - Serif - Quotation01
  static const TextStyle quotation01 = TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: 20,
    fontWeight: regular,
    height: 1.3,
    letterSpacing: 0,
  );

  // 32px / 1.25 (lg breakpoint) - Serif - Quotation02
  static const TextStyle quotation02 = TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: 32,
    fontWeight: light,
    height: 1.25,
    letterSpacing: 0,
  );

  // 42px / 1.19 (lg breakpoint) - Display01
  static const TextStyle display01 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 42, // scale[9] is 42
    fontWeight: light,
    height: 1.19,
    letterSpacing: 0,
  );

  // 42px / 1.19 (lg breakpoint) - Semibold - Display02
  static const TextStyle display02 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 42,
    fontWeight: semiBold,
    height: 1.19,
    letterSpacing: 0,
  );

  // 42px -> 54px (lg) -> 96px (scale[12]?) - Display03
  // styles.js says display03 @ lg is scale[12], scale[12] is 60.
  // Wait, scale array in scale.js:
  // 12, 14, 16, 18, 20, 24, 28, 32, 36, 42, 48, 54, 60, 68...
  // 0   1   2   3   4   5   6   7   8   9   10  11  12  13
  // scale[9] = 42. scale[11] = 54. scale[12] = 60.
  // display03 @ lg: fontSize: rem(scale[12]) -> 60px.
  static const TextStyle display03 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 60,
    fontWeight: light,
    height: 1.16,
    letterSpacing: -0.64,
  );

  // display04 @ lg: fontSize: rem(scale[16]) -> scale[16] is 92?
  // scale: 12.. 60(12), 68(13), 76(14), 84(15), 92(16).
  // Correct.
  static const TextStyle display04 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 92,
    fontWeight: light,
    height: 1.11,
    letterSpacing: -0.64,
  );

  // Fluid Aliases
  static const TextStyle fluidHeading03 = expressiveHeading03;
  static const TextStyle fluidHeading04 = expressiveHeading04;
  static const TextStyle fluidHeading05 = expressiveHeading05;
  static const TextStyle fluidHeading06 = expressiveHeading06;
  static const TextStyle fluidParagraph01 = expressiveParagraph01;
  static const TextStyle fluidQuotation01 = quotation01;
  static const TextStyle fluidQuotation02 = quotation02;
  static const TextStyle fluidDisplay01 = display01;
  static const TextStyle fluidDisplay02 = display02;
  static const TextStyle fluidDisplay03 = display03;
  static const TextStyle fluidDisplay04 = display04;
}
