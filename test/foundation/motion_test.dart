import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  group('CarbonMotion', () {
    group('Durations', () {
      test('fast durations are correct', () {
        expect(CarbonMotion.fast01, const Duration(milliseconds: 70));
        expect(CarbonMotion.fast02, const Duration(milliseconds: 110));
      });

      test('moderate durations are correct', () {
        expect(CarbonMotion.moderate01, const Duration(milliseconds: 150));
        expect(CarbonMotion.moderate02, const Duration(milliseconds: 240));
      });

      test('slow durations are correct', () {
        expect(CarbonMotion.slow01, const Duration(milliseconds: 400));
        expect(CarbonMotion.slow02, const Duration(milliseconds: 700));
      });

      test('durations increase progressively', () {
        expect(
          CarbonMotion.fast02.inMilliseconds,
          greaterThan(CarbonMotion.fast01.inMilliseconds),
        );
        expect(
          CarbonMotion.moderate01.inMilliseconds,
          greaterThan(CarbonMotion.fast02.inMilliseconds),
        );
        expect(
          CarbonMotion.moderate02.inMilliseconds,
          greaterThan(CarbonMotion.moderate01.inMilliseconds),
        );
        expect(
          CarbonMotion.slow01.inMilliseconds,
          greaterThan(CarbonMotion.moderate02.inMilliseconds),
        );
        expect(
          CarbonMotion.slow02.inMilliseconds,
          greaterThan(CarbonMotion.slow01.inMilliseconds),
        );
      });
    });

    group('V11 Token Aliases', () {
      test('duration aliases match their corresponding values', () {
        expect(CarbonMotion.durationFast01, CarbonMotion.fast01);
        expect(CarbonMotion.durationFast02, CarbonMotion.fast02);
        expect(CarbonMotion.durationModerate01, CarbonMotion.moderate01);
        expect(CarbonMotion.durationModerate02, CarbonMotion.moderate02);
        expect(CarbonMotion.durationSlow01, CarbonMotion.slow01);
        expect(CarbonMotion.durationSlow02, CarbonMotion.slow02);
      });
    });

    group('Standard Easings', () {
      test('standard productive curve is defined', () {
        expect(CarbonMotion.standardProductive, isA<Cubic>());
        final curve = CarbonMotion.standardProductive as Cubic;
        expect(curve.a, 0.2);
        expect(curve.b, 0.0);
        expect(curve.c, 0.38);
        expect(curve.d, 0.9);
      });

      test('standard expressive curve is defined', () {
        expect(CarbonMotion.standardExpressive, isA<Cubic>());
        final curve = CarbonMotion.standardExpressive as Cubic;
        expect(curve.a, 0.4);
        expect(curve.b, 0.14);
        expect(curve.c, 0.3);
        expect(curve.d, 1.0);
      });
    });

    group('Entrance Easings', () {
      test('entrance productive curve is defined', () {
        expect(CarbonMotion.entranceProductive, isA<Cubic>());
        final curve = CarbonMotion.entranceProductive as Cubic;
        expect(curve.a, 0.0);
        expect(curve.b, 0.0);
        expect(curve.c, 0.38);
        expect(curve.d, 0.9);
      });

      test('entrance expressive curve is defined', () {
        expect(CarbonMotion.entranceExpressive, isA<Cubic>());
        final curve = CarbonMotion.entranceExpressive as Cubic;
        expect(curve.a, 0.0);
        expect(curve.b, 0.0);
        expect(curve.c, 0.3);
        expect(curve.d, 1.0);
      });
    });

    group('Exit Easings', () {
      test('exit productive curve is defined', () {
        expect(CarbonMotion.exitProductive, isA<Cubic>());
        final curve = CarbonMotion.exitProductive as Cubic;
        expect(curve.a, 0.2);
        expect(curve.b, 0.0);
        expect(curve.c, 1.0);
        expect(curve.d, 0.9);
      });

      test('exit expressive curve is defined', () {
        expect(CarbonMotion.exitExpressive, isA<Cubic>());
        final curve = CarbonMotion.exitExpressive as Cubic;
        expect(curve.a, 0.4);
        expect(curve.b, 0.14);
        expect(curve.c, 1.0);
        expect(curve.d, 1.0);
      });
    });

    group('Curve behavior', () {
      test('curves transform values correctly', () {
        expect(CarbonMotion.standardProductive.transform(0.0), 0.0);
        expect(CarbonMotion.standardProductive.transform(1.0), 1.0);

        expect(CarbonMotion.entranceProductive.transform(0.0), 0.0);
        expect(CarbonMotion.entranceProductive.transform(1.0), 1.0);

        expect(CarbonMotion.exitProductive.transform(0.0), 0.0);
        expect(CarbonMotion.exitProductive.transform(1.0), 1.0);
      });
    });
  });
}
