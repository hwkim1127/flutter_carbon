/// Internal date-only helpers for the Carbon date picker.
///
/// All arithmetic goes through the `DateTime(year, month, day)` constructor
/// (which normalizes overflow) — never `Duration` math — so results are
/// immune to daylight-saving transitions.
///
/// Not exported — building blocks like `CarbonAnchoredOverlay`. Tests
/// import this file directly via its `package:flutter_carbon/src/...` path.
library;

/// Hard lower bound of selectable dates (year 1).
final DateTime carbonMinDate = DateTime(1, 1, 1);

/// Hard upper bound of selectable dates (December 31, 9999) — matching the
/// 4-digit year the `m/d/Y` format and the calendar's year input can
/// express. User-supplied min/max bounds are intersected with these.
final DateTime carbonMaxDate = DateTime(9999, 12, 31);

/// The effective lower bound: [min] clamped into the hard range (so a
/// lower bound beyond [carbonMaxDate] can never invert the range).
DateTime effectiveMinDate(DateTime? min) =>
    min == null ? carbonMinDate : clampDate(min, carbonMinDate, carbonMaxDate);

/// The effective upper bound: [max] clamped into the hard range.
DateTime effectiveMaxDate(DateTime? max) =>
    max == null ? carbonMaxDate : clampDate(max, carbonMinDate, carbonMaxDate);

/// Strips the time component.
DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// Whether [a] and [b] fall on the same calendar day.
///
/// Follows the `DateUtils.isSameDay` convention: comparing two nulls is
/// true, one null is false. In practice callers compare a concrete cell
/// day against a possibly-null selection.
bool isSameDay(DateTime? a, DateTime? b) =>
    a?.year == b?.year && a?.month == b?.month && a?.day == b?.day;

/// Whether [a]'s calendar day is strictly before [b]'s.
bool isBeforeDay(DateTime a, DateTime b) => dateOnly(a).isBefore(dateOnly(b));

/// Number of days in [month] of [year] (leap-safe: day 0 of the next month
/// is this month's last day).
int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

/// Grid offset of the month's first day: how many leading cells the day
/// grid shows before day 1.
///
/// [firstDayOfWeek] uses the 0 = Sunday … 6 = Saturday convention.
int firstDayOffset(int year, int month, int firstDayOfWeek) {
  // DateTime.weekday: Monday = 1 … Sunday = 7 → Sunday-based 0…6.
  final sundayBased = DateTime(year, month, 1).weekday % 7;
  return (sundayBased - firstDayOfWeek + 7) % 7;
}

/// Moves [date] by [months] whole months, clamping the day to the target
/// month's length (Jan 31 + 1 month → Feb 28/29).
DateTime addMonthsClamped(DateTime date, int months) {
  final totalMonths = date.year * 12 + (date.month - 1) + months;
  // Floor division (Dart's ~/ truncates toward zero, wrong for negatives).
  final year = (totalMonths / 12).floor();
  final month = totalMonths - year * 12 + 1;
  final day = date.day <= daysInMonth(year, month)
      ? date.day
      : daysInMonth(year, month);
  return DateTime(year, month, day);
}

/// Clamps [date] (date-only) into the inclusive `[min, max]` range.
///
/// Callers must ensure `min <= max` when both are set (the picker asserts
/// this at its API boundary); with an inverted range the min bound wins.
DateTime clampDate(DateTime date, DateTime? min, DateTime? max) {
  final day = dateOnly(date);
  if (min != null && day.isBefore(dateOnly(min))) return dateOnly(min);
  if (max != null && day.isAfter(dateOnly(max))) return dateOnly(max);
  return day;
}

/// Formats [date] as zero-padded `m/d/Y` — `07/04/2026` (the Carbon
/// date-picker default format).
String formatMDY(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final year = date.year.toString().padLeft(4, '0');
  return '$month/$day/$year';
}

final RegExp _mdyPattern = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$');

/// Parses `m/d/Y` input (padding optional, year must be 4 digits).
///
/// Returns null instead of normalizing out-of-range parts — `2/30/2021`
/// is a rejection, not March 2nd. The accepted domain is exactly the hard
/// selection range: years 1–9999 (the regex admits no sign, and `0000` is
/// rejected explicitly).
DateTime? parseMDY(String text) {
  final match = _mdyPattern.firstMatch(text.trim());
  if (match == null) return null;
  final month = int.parse(match.group(1)!);
  final day = int.parse(match.group(2)!);
  final year = int.parse(match.group(3)!);
  if (year < 1) return null; // ≤ 9999 is guaranteed by the 4-digit match
  if (month < 1 || month > 12) return null;
  if (day < 1 || day > daysInMonth(year, month)) return null;
  return DateTime(year, month, day);
}
