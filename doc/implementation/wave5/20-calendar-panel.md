# Step 20 — Calendar panel

## Goal

`CarbonCalendarPanel` — the internal calendar popup (flatpickr-equivalent)
that `CarbonDatePicker` places in an overlay. Internal like
`CarbonMenuPanel` (not exported).

## Spec digest (Carbon v11.96, rem→px@16)

- Container 288 wide, bg `$layer-01`, Carbon box-shadow, padding 8/8/16/8,
  nominal height 336.
- Header row 40h: prev/next month buttons 40×40 (16px chevrons,
  `$icon-primary`, hover `$layer-hover`, disabled `$icon-disabled`);
  month name `heading-compact-01`; year number-input 60 wide, weight 600,
  bg `$field-01`, custom hover-revealed 12px spinner triangles
  (`$icon-primary`, hover `$button-primary`).
- Weekday row 40h, `body-compact-01`, single/two-letter labels.
- Day grid 7×6 (fixed 42 cells), cells 40×40 `body-compact-01`:
  hover `$layer-hover`; keyboard focus 2px `$button-primary` outline;
  today `$link-primary` w600 + 4×4 `$link-primary` dot at bottom 7px
  (hidden when selected); selected bg `$button-primary` /
  `$text-on-color`; in-range bg `$highlight` / `$text-primary`;
  disabled `$text-disabled`; outside-month `$text-helper`.

## API (internal)

```dart
CarbonCalendarPanel({
  required DateTime? selectedStart,
  DateTime? selectedEnd,               // range only
  bool isRange = false,
  required ValueChanged<DateTime> onSelectDay, // picker owns selection semantics
  required VoidCallback onClose,
  DateTime? minDate, DateTime? maxDate,
  int firstDayOfWeek = 0,
  required CarbonDatePickerLabels labels,
  DateTime? initialFocusedDay,         // seeds displayedMonth + keyboard focus
  bool grabFocusOnOpen = true,         // false when opened by tapping the text
})
```

The panel owns `_displayedMonth` and `_focusedDay` (seeded from
`initialFocusedDay ?? selectedStart ?? today`, clamped to min/max); the
picker owns the selected values (fully controlled — `markNeedsBuild`
re-plumbs new selections while the panel State survives).

All navigation and selection clamps to `effectiveMinDate(minDate)` /
`effectiveMaxDate(maxDate)` — the user bounds intersected with the hard
year 1–9999 cap (step 19), so the panel never needs null-bound checks and
can never navigate past Dec 31, 9999.

## Implementation notes

- **Year input**: `CarbonEditableCore`, digits-only ×4, centered; commit on
  Enter and blur (parse → clamp to 1–9999 ∩ min/max years → update
  `_displayedMonth` → re-format). Spinner column is an always-laid-out
  fixed-width slot with `Visibility(visible: hovered)` so hover doesn't
  reflow the header; taps step ±1 year (clamped).
- **Day cells**: Container 40×40 + Stack for the today-dot + always-present
  transparent `foregroundDecoration` for the keyboard-focus outline.
  Outside-month days are tappable (select + the month follows).
  `Semantics(button, label: 'July 4, 2026', selected:)` per cell.
- **2D keyboard — ONE Focus node on the grid** (KeyDownEvent only):
  - Arrows ±1 / ±7 days, **crossing month boundaries** (the displayed
    month follows the focused day) — flatpickr parity.
  - PageUp/PageDown ±month via `addMonthsClamped`; Shift+PageUp/PageDown
    ±year (day clamped to the target month's length).
  - Home/End = first/last day of the focused week row (deliberate: W3C APG).
  - Enter/Space select the focused day when enabled; Escape → `onClose`.
  - Tab is NOT intercepted — normal traversal cycles year → chevrons →
    grid inside the panel's `FocusScope`.
- **Focus lifecycle**: the menu-panel pattern — capture
  `FocusManager.instance.primaryFocus` in `initState`, post-frame
  `requestFocus()` on the grid (skipped when `grabFocusOnOpen: false`),
  guarded restore in `dispose` (the own-node check widened to all
  panel-owned nodes: grid, year input, chevron pressables).

## Tests

Panel-level tests live in `carbon_date_picker_test.dart` (the panel is
internal): grid geometry (42 cells, weekday rotation), month-crossing
arrows, PageUp/Shift+PageUp, Home/End week bounds, today dot, min/max
disabling + chevron disabling, year commit + spinner steps.

## Example

None directly (exercised through the date picker demo in step 21).
