# Step 21 — CarbonDatePicker

## Goal

The public date picker: simple / single / range variants over the step-20
calendar panel, replacing `showDatePicker`/`showDateRangePicker` in the
demo.

## Spec digest (Carbon v11.96, rem→px@16)

- Input: `code-02` type (IBM Plex Mono 14px), padding-inline start 16 /
  end 48 when the trailing icon is present, bg `$field`, 1px bottom
  `$border-strong`, heights sm 32 / md 40 / lg 48 (default md);
  calendar icon 16px `$icon-primary` at inset-end 16, pointer-events none;
  invalid → `warningFilled` `$support-error` replaces the calendar icon;
  warn → `warningAltFilled` `$support-warning`; disabled: transparent
  bottom border + `$text-disabled`; readOnly: transparent bg,
  `$border-subtle` bottom, icon `$icon-disabled`, the calendar never
  opens; focus 2px `$focus`.
- Widths: simple 120 (152 when invalid/warn; no icon otherwise),
  single 288, range 143.5 per input + 1px gap (288 total).
- Defaults: dateFormat `m/d/Y`, allowInput true, closeOnSelect true.
- Keyboard: Escape on the input closes; the calendar grid handles day
  navigation (step 20).
- Range: two inputs share ONE calendar anchored to the START input;
  clicking start then end fills both; closing never wipes the start.

## API

```dart
enum CarbonDatePickerVariant { simple, single, range }
enum CarbonDatePickerSize { sm(32), md(40), lg(48) }

CarbonDatePicker({
  CarbonDatePickerVariant variant = single,
  required String labelText,
  String? endLabelText,                 // range: required (assert)
  bool hideLabel = false,
  DateTime? value,                      // start date in range mode
  DateTime? endValue,                   // range only
  ValueChanged<DateTime?>? onChanged,   // simple/single (assert null in range)
  void Function(DateTime? start, DateTime? end)? onRangeChanged, // range
  String? placeholder,                  // default 'mm/dd/yyyy'
  String? helperText,
  bool invalid = false, String? invalidText,
  bool warn = false, String? warnText,
  bool disabled = false, bool readOnly = false,
  CarbonDatePickerSize size = md,
  DateTime? minDate, DateTime? maxDate, // date-only compared
  bool closeOnSelect = true,
  bool allowInput = true,
  int firstDayOfWeek = 0,               // 0 = Sunday
  CarbonDatePickerLabels? labels,       // → .en()
  String Function(DateTime)? formatDate,
  DateTime? Function(String)? parseDate,
  double? width,                        // overrides the spec default width
})
```

No range value class — `DateTimeRange` is Material-only; flat
`value`/`endValue` + `onRangeChanged(start, end)` keep the API small.

Constructor asserts: `minDate <= maxDate` when both set; `value` /
`endValue` (when set) fall within the hard year 1–9999 cap (`carbonMinDate`
… `carbonMaxDate` from step 19); range: `endLabelText` non-null,
`onChanged` null, `value <= endValue` when both set.

## Implementation notes

- Field chrome: private copy of the `_FieldChrome` pattern (the
  CarbonSelect precedent) with ONE trailing icon slot (calendar OR status
  icon — they replace each other, unlike select's two slots).
- Overlay: the CarbonSelect skeleton verbatim —
  `CarbonAnchoredOverlay(bottomStart, spacing: 1, maxWidth: 288)` →
  `CarbonOverlaySurface` → panel; reentry guards; dispose removes the
  entry directly; `didUpdateWidget` closes when non-interactive and
  `markNeedsBuild`s on value/min/max changes.
- Focus story (deliberate deviation, see wave README): the calendar icon
  is pointer-transparent per spec, so ANY tap on the field opens the
  calendar — with `grabFocusOnOpen: false` when `allowInput` (typing
  continues; ArrowDown then moves focus into the grid) and `true` when
  typing is off (nothing to type). ArrowDown on the closed field opens
  with grid focus; Enter commits the text and closes; Escape closes. The
  guarded restore returns focus to the input.
- Typing (allowInput): formatter `[\d/]` + maxLength 10; commit on
  Enter/blur via `parseDate ?? parseMDY`; success → reject outside
  min/max (no change), fire the callback, re-format; failure → leave the
  text, fire nothing (React parity — the consumer drives `invalid`).
  `allowInput: false` → readOnly editable, but the field still opens the
  calendar. Widget-level readOnly: swallow value keys, never open.
- Range selection semantics (picker-side): no start or both set →
  restart `(day, null)`; day before start → restart `(day, null)`;
  else `(start, day)` + close when closeOnSelect. Dismissal never mutates
  values.

## Tests

`test/widgets/carbon_date_picker_test.dart`:

- simple: width 120, no calendar icon; type `07/04/2026` + Enter →
  `onChanged(DateTime(2026, 7, 4))`; garbage + Enter → no callback, text
  preserved; invalid → width 152 + warningFilled + invalidText in
  textError.
- single: icon opens; day tap → onChanged + formatted input text +
  closed (closeOnSelect); `closeOnSelect: false` stays open; value change
  while open repaints the selection.
- keyboard grid: ArrowDown on the field opens + focuses the grid; arrows
  move the focus outline (month-crossing at edges); PageDown/Shift+PageDown;
  Home/End; Enter selects + closes; Escape closes and focus returns to
  the input.
- min/max: out-of-range day is textDisabled and inert; prev chevron
  disabled at minDate's month.
- today: 4×4 linkPrimary dot; hidden when today is selected.
- readOnly (focusable, keys swallowed, never opens), disabled
  (not focusable); dispose-while-open is clean.
- range: two labeled inputs; pick → `(start, null)`; pick later →
  `(start, end)` + closed; a between-cell's bg == `carbon.layer.highlight`;
  pick before start → restart; barrier tap preserves the start text; the
  end input's icon opens the same overlay.
- year input: type + Enter jumps the displayed year; spinner tap ±1.
- pure-CarbonApp smoke.

## Example

Date sections of the rewritten demo page (step 23 finishes the page):
Simple, Single (default + min/max + closeOnSelect:false), Range, States,
Sizes.
