import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  group('CarbonTypography', () {
    group('Font Families', () {
      test('font family constants are correct', () {
        expect(CarbonTypography.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.fontFamilyMono, 'IBM Plex Mono');
        expect(CarbonTypography.fontFamilySerif, 'IBM Plex Serif');
      });
    });

    group('Font Weights', () {
      test('font weight constants are correct', () {
        expect(CarbonTypography.regular, FontWeight.w400);
        expect(CarbonTypography.semiBold, FontWeight.w600);
        expect(CarbonTypography.light, FontWeight.w300);
      });
    });

    group('Caption Styles', () {
      test('caption01 has correct properties', () {
        expect(CarbonTypography.caption01.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.caption01.fontSize, 12);
        expect(CarbonTypography.caption01.fontWeight, FontWeight.w400);
        expect(CarbonTypography.caption01.letterSpacing, 0.32);
      });

      test('caption02 has correct properties', () {
        expect(CarbonTypography.caption02.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.caption02.fontSize, 14);
        expect(CarbonTypography.caption02.fontWeight, FontWeight.w400);
        expect(CarbonTypography.caption02.letterSpacing, 0.32);
      });
    });

    group('Label Styles', () {
      test('label01 has correct properties', () {
        expect(CarbonTypography.label01.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.label01.fontSize, 12);
        expect(CarbonTypography.label01.letterSpacing, 0.32);
      });

      test('label02 has correct properties', () {
        expect(CarbonTypography.label02.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.label02.fontSize, 14);
        expect(CarbonTypography.label02.letterSpacing, 0.16);
      });
    });

    group('Helper Text Styles', () {
      test('helperText01 has correct properties', () {
        expect(CarbonTypography.helperText01.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.helperText01.fontSize, 12);
      });

      test('helperText02 has correct properties', () {
        expect(CarbonTypography.helperText02.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.helperText02.fontSize, 14);
      });
    });

    group('Legal Text Styles', () {
      test('legal01 has correct properties', () {
        expect(CarbonTypography.legal01.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.legal01.fontSize, 12);
      });

      test('legal02 has correct properties', () {
        expect(CarbonTypography.legal02.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.legal02.fontSize, 14);
      });
    });

    group('Body Styles', () {
      test('bodyShort01 has correct properties', () {
        expect(CarbonTypography.bodyShort01.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.bodyShort01.fontSize, 14);
        expect(CarbonTypography.bodyShort01.fontWeight, FontWeight.w400);
      });

      test('bodyLong01 has correct properties', () {
        expect(CarbonTypography.bodyLong01.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.bodyLong01.fontSize, 14);
      });

      test('bodyShort02 has correct properties', () {
        expect(CarbonTypography.bodyShort02.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.bodyShort02.fontSize, 16);
      });

      test('bodyLong02 has correct properties', () {
        expect(CarbonTypography.bodyLong02.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.bodyLong02.fontSize, 16);
      });

      test('body aliases match corresponding styles', () {
        expect(CarbonTypography.bodyCompact01, CarbonTypography.bodyShort01);
        expect(CarbonTypography.bodyCompact02, CarbonTypography.bodyShort02);
        expect(CarbonTypography.body01, CarbonTypography.bodyLong01);
        expect(CarbonTypography.body02, CarbonTypography.bodyLong02);
      });
    });

    group('Code Styles', () {
      test('code01 uses monospace font', () {
        expect(CarbonTypography.code01.fontFamily, 'IBM Plex Mono');
        expect(CarbonTypography.code01.fontSize, 12);
      });

      test('code02 uses monospace font', () {
        expect(CarbonTypography.code02.fontFamily, 'IBM Plex Mono');
        expect(CarbonTypography.code02.fontSize, 14);
      });
    });

    group('Heading Styles', () {
      test('heading01 has correct properties', () {
        expect(CarbonTypography.heading01.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.heading01.fontSize, 14);
        expect(CarbonTypography.heading01.fontWeight, FontWeight.w600);
      });

      test('heading02 has correct properties', () {
        expect(CarbonTypography.heading02.fontFamily, 'IBM Plex Sans');
        expect(CarbonTypography.heading02.fontSize, 16);
        expect(CarbonTypography.heading02.fontWeight, FontWeight.w600);
      });

      test('productive headings have correct properties', () {
        expect(CarbonTypography.productiveHeading01.fontSize, 14);
        expect(CarbonTypography.productiveHeading02.fontSize, 16);
        expect(CarbonTypography.productiveHeading03.fontSize, 20);
        expect(CarbonTypography.productiveHeading04.fontSize, 28);
        expect(CarbonTypography.productiveHeading05.fontSize, 32);
        expect(CarbonTypography.productiveHeading06.fontSize, 42);
        expect(CarbonTypography.productiveHeading07.fontSize, 54);
      });

      test('heading compact aliases match productive headings', () {
        expect(
          CarbonTypography.headingCompact01,
          CarbonTypography.productiveHeading01,
        );
        expect(
          CarbonTypography.headingCompact02,
          CarbonTypography.productiveHeading02,
        );
        expect(
          CarbonTypography.heading03,
          CarbonTypography.productiveHeading03,
        );
        expect(
          CarbonTypography.heading04,
          CarbonTypography.productiveHeading04,
        );
        expect(
          CarbonTypography.heading05,
          CarbonTypography.productiveHeading05,
        );
        expect(
          CarbonTypography.heading06,
          CarbonTypography.productiveHeading06,
        );
        expect(
          CarbonTypography.heading07,
          CarbonTypography.productiveHeading07,
        );
      });
    });

    group('Expressive Heading Styles', () {
      test('expressive headings have correct properties', () {
        expect(CarbonTypography.expressiveHeading01.fontSize, 14);
        expect(CarbonTypography.expressiveHeading02.fontSize, 16);
        expect(CarbonTypography.expressiveHeading03.fontSize, 20);
        expect(CarbonTypography.expressiveHeading04.fontSize, 28);
        expect(CarbonTypography.expressiveHeading05.fontSize, 32);
        expect(CarbonTypography.expressiveHeading06.fontSize, 32);
      });

      test('expressiveHeading03 matches productiveHeading03', () {
        expect(
          CarbonTypography.expressiveHeading03,
          CarbonTypography.productiveHeading03,
        );
      });
    });

    group('Quotation Styles', () {
      test('quotation styles use serif font', () {
        expect(CarbonTypography.quotation01.fontFamily, 'IBM Plex Serif');
        expect(CarbonTypography.quotation01.fontSize, 20);

        expect(CarbonTypography.quotation02.fontFamily, 'IBM Plex Serif');
        expect(CarbonTypography.quotation02.fontSize, 32);
      });
    });

    group('Display Styles', () {
      test('display styles have correct properties', () {
        expect(CarbonTypography.display01.fontSize, 42);
        expect(CarbonTypography.display01.fontWeight, FontWeight.w300);

        expect(CarbonTypography.display02.fontSize, 42);
        expect(CarbonTypography.display02.fontWeight, FontWeight.w600);

        expect(CarbonTypography.display03.fontSize, 60);
        expect(CarbonTypography.display03.fontWeight, FontWeight.w300);
        expect(CarbonTypography.display03.letterSpacing, -0.64);

        expect(CarbonTypography.display04.fontSize, 92);
        expect(CarbonTypography.display04.fontWeight, FontWeight.w300);
        expect(CarbonTypography.display04.letterSpacing, -0.64);
      });
    });

    group('Fluid Aliases', () {
      test('fluid aliases match their corresponding styles', () {
        expect(
          CarbonTypography.fluidHeading03,
          CarbonTypography.expressiveHeading03,
        );
        expect(
          CarbonTypography.fluidHeading04,
          CarbonTypography.expressiveHeading04,
        );
        expect(
          CarbonTypography.fluidHeading05,
          CarbonTypography.expressiveHeading05,
        );
        expect(
          CarbonTypography.fluidHeading06,
          CarbonTypography.expressiveHeading06,
        );
        expect(
          CarbonTypography.fluidParagraph01,
          CarbonTypography.expressiveParagraph01,
        );
        expect(CarbonTypography.fluidQuotation01, CarbonTypography.quotation01);
        expect(CarbonTypography.fluidQuotation02, CarbonTypography.quotation02);
        expect(CarbonTypography.fluidDisplay01, CarbonTypography.display01);
        expect(CarbonTypography.fluidDisplay02, CarbonTypography.display02);
        expect(CarbonTypography.fluidDisplay03, CarbonTypography.display03);
        expect(CarbonTypography.fluidDisplay04, CarbonTypography.display04);
      });
    });

    group('Font Size Progression', () {
      test('headings increase in size', () {
        expect(
          CarbonTypography.productiveHeading02.fontSize,
          greaterThan(CarbonTypography.productiveHeading01.fontSize!),
        );
        expect(
          CarbonTypography.productiveHeading03.fontSize,
          greaterThan(CarbonTypography.productiveHeading02.fontSize!),
        );
        expect(
          CarbonTypography.productiveHeading07.fontSize,
          greaterThan(CarbonTypography.productiveHeading06.fontSize!),
        );
      });

      test('displays increase in size', () {
        expect(
          CarbonTypography.display03.fontSize,
          greaterThan(CarbonTypography.display02.fontSize!),
        );
        expect(
          CarbonTypography.display04.fontSize,
          greaterThan(CarbonTypography.display03.fontSize!),
        );
      });
    });
  });
}
