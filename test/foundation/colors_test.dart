import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  group('CarbonPalette', () {
    test('overlay color has correct value', () {
      expect(CarbonPalette.overlay, const Color(0x52999999));
    });

    group('Black & White colors', () {
      test('black colors are defined correctly', () {
        expect(CarbonPalette.black, const Color(0xFF000000));
        expect(CarbonPalette.black100, CarbonPalette.black);
        expect(CarbonPalette.blackHover, const Color(0xFF212121));
      });

      test('white colors are defined correctly', () {
        expect(CarbonPalette.white, const Color(0xFFFFFFFF));
        expect(CarbonPalette.white0, CarbonPalette.white);
        expect(CarbonPalette.whiteHover, const Color(0xFFE8E8E8));
      });
    });

    group('Gray colors', () {
      test('gray scale colors are defined correctly', () {
        expect(CarbonPalette.gray10, const Color(0xFFF4F4F4));
        expect(CarbonPalette.gray20, const Color(0xFFE0E0E0));
        expect(CarbonPalette.gray30, const Color(0xFFC6C6C6));
        expect(CarbonPalette.gray40, const Color(0xFFA8A8A8));
        expect(CarbonPalette.gray50, const Color(0xFF8D8D8D));
        expect(CarbonPalette.gray60, const Color(0xFF6F6F6F));
        expect(CarbonPalette.gray70, const Color(0xFF525252));
        expect(CarbonPalette.gray80, const Color(0xFF393939));
        expect(CarbonPalette.gray90, const Color(0xFF262626));
        expect(CarbonPalette.gray100, const Color(0xFF161616));
      });

      test('gray hover colors are defined correctly', () {
        expect(CarbonPalette.gray10Hover, const Color(0xFFE8E8E8));
        expect(CarbonPalette.gray20Hover, const Color(0xFFD1D1D1));
        expect(CarbonPalette.gray30Hover, const Color(0xFFB5B5B5));
        expect(CarbonPalette.gray40Hover, const Color(0xFF999999));
        expect(CarbonPalette.gray50Hover, const Color(0xFF7A7A7A));
        expect(CarbonPalette.gray60Hover, const Color(0xFF5E5E5E));
        expect(CarbonPalette.gray70Hover, const Color(0xFF636363));
        expect(CarbonPalette.gray80Hover, const Color(0xFF474747));
        expect(CarbonPalette.gray90Hover, const Color(0xFF333333));
        expect(CarbonPalette.gray100Hover, const Color(0xFF292929));
      });
    });

    group('Cool Gray colors', () {
      test('cool gray scale colors are defined correctly', () {
        expect(CarbonPalette.coolGray10, const Color(0xFFF2F4F8));
        expect(CarbonPalette.coolGray20, const Color(0xFFDDE1E6));
        expect(CarbonPalette.coolGray30, const Color(0xFFC1C7CD));
        expect(CarbonPalette.coolGray40, const Color(0xFFA2A9B0));
        expect(CarbonPalette.coolGray50, const Color(0xFF878D96));
        expect(CarbonPalette.coolGray60, const Color(0xFF697077));
        expect(CarbonPalette.coolGray70, const Color(0xFF4D5358));
        expect(CarbonPalette.coolGray80, const Color(0xFF343A3F));
        expect(CarbonPalette.coolGray90, const Color(0xFF21272A));
        expect(CarbonPalette.coolGray100, const Color(0xFF121619));
      });
    });

    group('Warm Gray colors', () {
      test('warm gray scale colors are defined correctly', () {
        expect(CarbonPalette.warmGray10, const Color(0xFFF7F3F2));
        expect(CarbonPalette.warmGray20, const Color(0xFFE5E0DF));
        expect(CarbonPalette.warmGray30, const Color(0xFFCAC5C4));
        expect(CarbonPalette.warmGray40, const Color(0xFFADA8A8));
        expect(CarbonPalette.warmGray50, const Color(0xFF8F8B8B));
        expect(CarbonPalette.warmGray60, const Color(0xFF726E6E));
        expect(CarbonPalette.warmGray70, const Color(0xFF565151));
        expect(CarbonPalette.warmGray80, const Color(0xFF3C3838));
        expect(CarbonPalette.warmGray90, const Color(0xFF272525));
        expect(CarbonPalette.warmGray100, const Color(0xFF171414));
      });
    });

    group('Blue colors', () {
      test('blue scale colors are defined correctly', () {
        expect(CarbonPalette.blue10, const Color(0xFFEDF5FF));
        expect(CarbonPalette.blue20, const Color(0xFFD0E2FF));
        expect(CarbonPalette.blue30, const Color(0xFFA6C8FF));
        expect(CarbonPalette.blue40, const Color(0xFF78A9FF));
        expect(CarbonPalette.blue50, const Color(0xFF4589FF));
        expect(CarbonPalette.blue60, const Color(0xFF0F62FE));
        expect(CarbonPalette.blue70, const Color(0xFF0043CE));
        expect(CarbonPalette.blue80, const Color(0xFF002D9C));
        expect(CarbonPalette.blue90, const Color(0xFF001D6C));
        expect(CarbonPalette.blue100, const Color(0xFF001141));
      });
    });

    group('Red colors', () {
      test('red scale colors are defined correctly', () {
        expect(CarbonPalette.red10, const Color(0xFFFFF1F1));
        expect(CarbonPalette.red20, const Color(0xFFFFD7D9));
        expect(CarbonPalette.red30, const Color(0xFFFFB3B8));
        expect(CarbonPalette.red40, const Color(0xFFFF8389));
        expect(CarbonPalette.red50, const Color(0xFFFA4D56));
        expect(CarbonPalette.red60, const Color(0xFFDA1E28));
        expect(CarbonPalette.red70, const Color(0xFFA2191F));
        expect(CarbonPalette.red80, const Color(0xFF750E13));
        expect(CarbonPalette.red90, const Color(0xFF520408));
        expect(CarbonPalette.red100, const Color(0xFF2D0709));
      });
    });

    group('Magenta colors', () {
      test('magenta scale colors are defined correctly', () {
        expect(CarbonPalette.magenta10, const Color(0xFFFFF0F7));
        expect(CarbonPalette.magenta60, const Color(0xFFD02670));
        expect(CarbonPalette.magenta100, const Color(0xFF2A0A18));
      });
    });

    group('Purple colors', () {
      test('purple scale colors are defined correctly', () {
        expect(CarbonPalette.purple10, const Color(0xFFF6F2FF));
        expect(CarbonPalette.purple60, const Color(0xFF8A3FFC));
        expect(CarbonPalette.purple100, const Color(0xFF1C0F30));
      });
    });

    group('Cyan colors', () {
      test('cyan scale colors are defined correctly', () {
        expect(CarbonPalette.cyan10, const Color(0xFFE5F6FF));
        expect(CarbonPalette.cyan60, const Color(0xFF0072C3));
        expect(CarbonPalette.cyan100, const Color(0xFF061727));
      });
    });

    group('Teal colors', () {
      test('teal scale colors are defined correctly', () {
        expect(CarbonPalette.teal10, const Color(0xFFD9FBFB));
        expect(CarbonPalette.teal60, const Color(0xFF007D79));
        expect(CarbonPalette.teal100, const Color(0xFF081A1C));
      });
    });

    group('Green colors', () {
      test('green scale colors are defined correctly', () {
        expect(CarbonPalette.green10, const Color(0xFFDEFBE6));
        expect(CarbonPalette.green60, const Color(0xFF198038));
        expect(CarbonPalette.green100, const Color(0xFF071908));
      });
    });

    group('Yellow colors', () {
      test('yellow scale colors are defined correctly', () {
        expect(CarbonPalette.yellow10, const Color(0xFFFCF4D6));
        expect(CarbonPalette.yellow30, const Color(0xFFF1C21B));
        expect(CarbonPalette.yellow60, const Color(0xFF8E6A00));
        expect(CarbonPalette.yellow100, const Color(0xFF1C1500));
      });
    });

    group('Orange colors', () {
      test('orange scale colors are defined correctly', () {
        expect(CarbonPalette.orange10, const Color(0xFFFFF2E8));
        expect(CarbonPalette.orange40, const Color(0xFFFF832B));
        expect(CarbonPalette.orange60, const Color(0xFFBA4E00));
        expect(CarbonPalette.orange100, const Color(0xFF231000));
      });
    });
  });
}
