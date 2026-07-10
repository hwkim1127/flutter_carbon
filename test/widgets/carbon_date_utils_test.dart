import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_carbon/src/widgets/carbon_date_utils.dart';

void main() {
  group('daysInMonth', () {
    test('handles leap years', () {
      expect(daysInMonth(2024, 2), 29); // divisible by 4
      expect(daysInMonth(2000, 2), 29); // divisible by 400
      expect(daysInMonth(2100, 2), 28); // divisible by 100, not 400
      expect(daysInMonth(2025, 2), 28);
    });

    test('regular months', () {
      expect(daysInMonth(2026, 4), 30);
      expect(daysInMonth(2026, 12), 31);
      expect(daysInMonth(2026, 1), 31);
    });
  });

  group('firstDayOffset', () {
    // July 2026 starts on a Wednesday.
    test('Sunday-first weeks', () {
      expect(firstDayOffset(2026, 7, 0), 3);
      // February 2026 starts on a Sunday.
      expect(firstDayOffset(2026, 2, 0), 0);
      // March 2026 starts on a Sunday too.
      expect(firstDayOffset(2026, 3, 0), 0);
    });

    test('Monday-first weeks', () {
      expect(firstDayOffset(2026, 7, 1), 2);
      expect(firstDayOffset(2026, 2, 1), 6); // Sunday is the last column
    });
  });

  group('addMonthsClamped', () {
    test('clamps the day to the target month length', () {
      expect(
        addMonthsClamped(DateTime(2026, 1, 31), 1),
        DateTime(2026, 2, 28),
      );
      expect(
        addMonthsClamped(DateTime(2024, 1, 31), 1),
        DateTime(2024, 2, 29), // leap year
      );
      expect(
        addMonthsClamped(DateTime(2026, 3, 31), -1),
        DateTime(2026, 2, 28),
      );
    });

    test('rolls over years in both directions', () {
      expect(
        addMonthsClamped(DateTime(2026, 12, 15), 1),
        DateTime(2027, 1, 15),
      );
      expect(
        addMonthsClamped(DateTime(2026, 1, 15), -1),
        DateTime(2025, 12, 15),
      );
      expect(
        addMonthsClamped(DateTime(2026, 6, 15), -18),
        DateTime(2024, 12, 15),
      );
    });

    test('keeps the day when it fits', () {
      expect(
        addMonthsClamped(DateTime(2026, 2, 28), 1),
        DateTime(2026, 3, 28),
      );
    });
  });

  group('clampDate', () {
    final min = DateTime(2026, 3, 10);
    final max = DateTime(2026, 3, 20);

    test('clamps below, inside, above', () {
      expect(clampDate(DateTime(2026, 3, 1), min, max), DateTime(2026, 3, 10));
      expect(
        clampDate(DateTime(2026, 3, 15), min, max),
        DateTime(2026, 3, 15),
      );
      expect(
        clampDate(DateTime(2026, 3, 25), min, max),
        DateTime(2026, 3, 20),
      );
    });

    test('null bounds are open', () {
      expect(
        clampDate(DateTime(2026, 3, 1), null, null),
        DateTime(2026, 3, 1),
      );
    });

    test('strips the time component', () {
      expect(
        clampDate(DateTime(2026, 3, 15, 13, 45), min, max),
        DateTime(2026, 3, 15),
      );
    });
  });

  group('hard selection bounds', () {
    test('effective bounds default to year 1 through 9999', () {
      expect(effectiveMinDate(null), DateTime(1, 1, 1));
      expect(effectiveMaxDate(null), DateTime(9999, 12, 31));
    });

    test('user bounds are intersected with the hard cap', () {
      expect(effectiveMinDate(DateTime(2020, 5, 1)), DateTime(2020, 5, 1));
      expect(effectiveMaxDate(DateTime(2030, 5, 1)), DateTime(2030, 5, 1));
      // Beyond the cap: the cap wins.
      expect(effectiveMaxDate(DateTime(12000, 1, 1)), DateTime(9999, 12, 31));
      expect(effectiveMinDate(DateTime(-5, 1, 1)), DateTime(1, 1, 1));
      // A LOWER bound beyond the cap clamps too — the effective range can
      // never invert (min > max) no matter what the caller passes.
      expect(effectiveMinDate(DateTime(12000, 1, 1)), DateTime(9999, 12, 31));
      expect(effectiveMaxDate(DateTime(-5, 1, 1)), DateTime(1, 1, 1));
    });

    test('navigation past the cap clamps to it', () {
      expect(
        clampDate(
          addMonthsClamped(DateTime(9999, 12, 15), 1),
          effectiveMinDate(null),
          effectiveMaxDate(null),
        ),
        DateTime(9999, 12, 31),
      );
    });
  });

  group('isSameDay / isBeforeDay / dateOnly', () {
    test('isSameDay ignores time and handles null', () {
      expect(
        isSameDay(DateTime(2026, 7, 4, 9), DateTime(2026, 7, 4, 21)),
        isTrue,
      );
      expect(isSameDay(DateTime(2026, 7, 4), DateTime(2026, 7, 5)), isFalse);
      expect(isSameDay(DateTime(2026, 7, 4), null), isFalse);
      expect(isSameDay(null, DateTime(2026, 7, 4)), isFalse);
      // DateUtils convention, documented on the helper: two nulls compare
      // as the same day.
      expect(isSameDay(null, null), isTrue);
    });

    test('isBeforeDay compares dates only', () {
      expect(
        isBeforeDay(DateTime(2026, 7, 4, 23), DateTime(2026, 7, 5, 1)),
        isTrue,
      );
      expect(
        isBeforeDay(DateTime(2026, 7, 5, 1), DateTime(2026, 7, 5, 23)),
        isFalse,
      );
    });

    test('dateOnly strips time', () {
      expect(dateOnly(DateTime(2026, 7, 4, 13, 45, 12)), DateTime(2026, 7, 4));
    });
  });

  group('formatMDY / parseMDY', () {
    test('formats zero-padded m/d/Y', () {
      expect(formatMDY(DateTime(2026, 7, 4)), '07/04/2026');
      expect(formatMDY(DateTime(2026, 12, 25)), '12/25/2026');
    });

    test('round-trips', () {
      for (final date in [
        DateTime(2026, 7, 4),
        DateTime(2024, 2, 29),
        DateTime(1999, 12, 31),
        DateTime(2000, 1, 1),
      ]) {
        expect(parseMDY(formatMDY(date)), date);
      }
    });

    test('accepts non-padded input and surrounding whitespace', () {
      expect(parseMDY('7/4/2026'), DateTime(2026, 7, 4));
      expect(parseMDY(' 07/04/2026 '), DateTime(2026, 7, 4));
    });

    test('rejects invalid input', () {
      expect(parseMDY('13/1/2020'), isNull); // month out of range
      expect(parseMDY('2/30/2021'), isNull); // day out of range
      expect(parseMDY('02/30/2021'), isNull);
      expect(parseMDY('2/29/2025'), isNull); // not a leap year
      expect(parseMDY('abc'), isNull);
      expect(parseMDY(''), isNull);
      expect(parseMDY('1/2/26'), isNull); // 2-digit year
      expect(parseMDY('1-2-2026'), isNull); // wrong separator
      expect(parseMDY('01/01/0000'), isNull); // year 0 — below the hard cap
      expect(parseMDY('-1/01/2026'), isNull); // signs never match
      expect(parseMDY('01/01/-005'), isNull);
    });

    test('accepts the hard-cap boundary years', () {
      expect(parseMDY('01/01/0001'), DateTime(1, 1, 1));
      expect(parseMDY('12/31/9999'), DateTime(9999, 12, 31));
    });

    test('accepts leap day in leap years', () {
      expect(parseMDY('2/29/2024'), DateTime(2024, 2, 29));
    });
  });
}
