# Wave 5 — Phase 3 wave 2: native date & time pickers

Completes Phase 3 of `../../V2_ROADMAP.md`: the date/time pickers were the
last Carbon components demoed through Material (`showDatePicker`,
`showDateRangePicker`, `showTimePicker`). This wave ships native,
spec-fidelity (Carbon v11.96) implementations and retires that demo.

| Demo today (Material) | This wave (native) |
| --- | --- |
| `showDatePicker` | `CarbonDatePicker` (single variant) |
| `showDateRangePicker` | `CarbonDatePicker` (range variant) |
| `showTimePicker` | `CarbonTimePicker` + `CarbonTimePickerSelect` |

Everything is **additive** — no breaking changes; lands in the unreleased
2.0.0.

Maintainer decisions baked in:

- **All three date variants now**: simple (plain input, no calendar),
  single (input + calendar popup), range (two inputs sharing one calendar).
- **Spec year input** in the calendar header — an editable 4-digit field
  with hover-revealed caret spinners (flatpickr design), not a static
  heading.
- **Time picker = input + companion select**: Carbon's time picker is a
  masked `hh:mm` text input plus consumer-supplied selects (AM/PM,
  timezone) — NOT a clock dial. `CarbonTimePickerSelect` is the label-less
  compact select for that row.
- **Zero dependencies**: no `intl` — hand-rolled `m/d/Y` formatting with
  `formatDate`/`parseDate` escape hatches, and a `CarbonDatePickerLabels`
  class (the `CarbonTextSelectionLabels` shape) for month/weekday names
  and semantic labels.

## Execution order & status

| Step | Doc | Status |
| --- | --- | --- |
| 19 | [Date foundations](19-date-foundations.md) | ✅ |
| 20 | [Calendar panel](20-calendar-panel.md) | ✅ |
| 21 | [CarbonDatePicker](21-carbon-date-picker.md) | ✅ |
| 22 | [CarbonTimePicker](22-carbon-time-picker.md) | ✅ |
| 23 | [Cleanup & release](23-cleanup-release.md) | ✅ |

`flutter analyze` and both test suites stay green between steps.

## Global verification (after step 23)

- `flutter analyze` — zero issues (root and `example/`).
- `flutter test` — full suite green; `example/` smoke suite green
  (all demo routes + interaction tests).
- Guard test auto-covers the new widget files (Material-free enforced).
- `dart pub publish --dry-run` passes.
- Example manual smoke: calendar open/select/keyboard grid navigation,
  range fill + in-range painting, year input + spinners, time picker row
  with AM/PM select.

## Deliberate deviations (spec fidelity notes)

- **Tab-into/out-of-calendar** (Carbon web moves focus from the input into
  the flatpickr calendar with Tab) is replaced by the Flutter overlay focus
  model: opening via the icon or keyboard focuses the day grid; ArrowDown
  from a typing-focused input moves focus into the grid; Tab cycles within
  the panel (year input → chevrons → grid); Escape / outside click /
  selection restore focus to the input.
- **Hover range preview** (flatpickr paints the prospective range between
  the picked start and the hovered day) and the range end-boundary
  "outlined until selected" treatment are deferred — additive panel state
  later.
- **Calendar entrance animation** (110ms fade-in-down) deferred — no
  overlay animation infrastructure exists repo-wide (select/menu/popover
  all pop instantly today).
- **Year spinners are hover-revealed** and therefore unreachable on touch;
  mitigations are the spec's own: type the year directly, use the month
  chevrons, or PageUp/PageDown (±month) and Shift+PageUp/PageDown (±year).
- **Home/End = first/last day of the focused week row** (W3C APG grid
  pattern) — flatpickr does not bind Home/End at all.
