# Step 19 — Date foundations

## Goal

Zero-dependency date helpers and the localization class everything else in
the wave builds on. No widgets yet.

## API

**`lib/src/widgets/carbon_date_utils.dart`** — internal (not exported;
tests import `package:flutter_carbon/src/widgets/carbon_date_utils.dart`
directly). Pure, date-only functions; all arithmetic goes through the
`DateTime(y, m, d)` constructor — never `Duration` math (DST-safe):

```dart
final DateTime carbonMinDate;                    // Jan 1, year 1
final DateTime carbonMaxDate;                    // Dec 31, 9999 — hard cap
DateTime effectiveMinDate(DateTime? min);        // user min ∩ hard bounds
DateTime effectiveMaxDate(DateTime? max);        // user max ∩ hard bounds
DateTime dateOnly(DateTime d);
bool isSameDay(DateTime? a, DateTime? b);
bool isBeforeDay(DateTime a, DateTime b);        // date-only compare
int daysInMonth(int year, int month);            // DateTime(y, m+1, 0).day — leap-safe
int firstDayOffset(int year, int month, int firstDayOfWeek); // 0 = Sunday
DateTime addMonthsClamped(DateTime d, int months); // Jan 31 +1mo → Feb 28/29
DateTime clampDate(DateTime d, DateTime? min, DateTime? max);
String formatMDY(DateTime d);                    // '07/04/2026' (zero-padded m/d/Y)
DateTime? parseMDY(String text);                 // \d{1,2}/\d{1,2}/\d{4};
                                                 // validates month 1-12 and
                                                 // day 1-daysInMonth; null on failure
```

**`CarbonDatePickerLabels`** (public, lives in `carbon_date_picker.dart`;
this step defines it, step 21 exports it) — exactly the
`CarbonTextSelectionLabels` shape: const constructor, defaulted English
finals, `.en()` factory:

```dart
CarbonDatePickerLabels({
  List<String> monthNames = ['January', …, 'December'],    // length 12
  List<String> weekdayLabels = ['Su','Mo','Tu','We','Th','Fr','Sa'], // length 7, Sunday-first
  String previousMonth = 'Previous month',
  String nextMonth = 'Next month',
  String openCalendar = 'Open calendar',   // calendar icon semantics
  String year = 'Year',                    // year input semantics
})
```

`weekdayLabels` is stored Sunday-first and rotated by `firstDayOfWeek`
when the weekday row is built — consumers must NOT pre-rotate.

## Implementation notes

- Format decision: fixed `m/d/Y` default (flatpickr's Carbon default) plus
  `formatDate`/`parseDate` callbacks on the widget for anything else — no
  flatpickr token engine.
- `parseMDY` accepts non-padded input (`7/4/2026`) but requires a 4-digit
  year; rejects out-of-range months/days rather than normalizing them.
- **Hard selection cap: year 1 – 9999** (maintainer decision). Everything
  downstream — grid navigation, year input, typed input — clamps to
  `effectiveMinDate/effectiveMaxDate`, which intersect the user's
  `minDate`/`maxDate` with the hard bounds. This also keeps the 4-digit
  `m/d/Y` format lossless.

## Tests

`test/widgets/carbon_date_utils_test.dart` (pure `test()`s):

- `daysInMonth`: Feb 2024 = 29, Feb 2000 = 29, Feb 2100 = 28,
  Feb 2025 = 28, Apr = 30, Dec = 31.
- `firstDayOffset` for firstDayOfWeek 0 and 1 on known months.
- `addMonthsClamped`: Jan 31 → Feb 28/29; Dec → Jan year rollover;
  negative months.
- `clampDate` below/inside/above.
- `formatMDY`/`parseMDY` round-trips; parse accepts `7/4/2026`; rejects
  `13/1/2020`, `2/30/2021`, `abc`, `''`, `1/2/26`.

## Example

None (no widgets yet).
