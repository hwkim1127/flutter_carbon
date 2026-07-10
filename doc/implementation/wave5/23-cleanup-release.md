# Step 23 — Cleanup & release sweep

## Example app

- Rewrite `example/lib/pages/date_time_picker_demo_page.dart`: drop
  `showDatePicker`/`showDateRangePicker`/`showTimePicker` and the
  `FilledButton` triggers entirely. Sections: Simple, Single (default,
  min/max, closeOnSelect: false), Range, States (invalid/warn/readOnly/
  disabled), Sizes, Time picker (input + AM/PM select + timezone select,
  invalid example).
- Route stays `/forms/date-time-picker`; update the `ComponentItem`
  description in `example/lib/routes.dart` to
  `'CarbonDatePicker & CarbonTimePicker — native calendar'`.
- Smoke suite: route coverage is automatic; add a
  **`wave-5 demo interactions`** group to
  `example/test/demo_pages_smoke_test.dart` — open the single picker's
  calendar and tap a day (input fills), type into the time picker.

## Bookkeeping

- `README.md`: custom-widget count 46 → 48 everywhere (header, coverage
  bullets, components heading, compliance, project structure); component
  list gains `CarbonDatePicker` and `CarbonTimePicker` under Forms &
  Input; Not-Yet-Implemented count 24 → 22 and the `date-picker` /
  `time-picker` rows are deleted (the `fluid-*` row stays).
- `pubspec.yaml` description: 46 → 48 components.
- `CHANGELOG.md` under `## 2.0.0 (Unreleased)`: New Features bullets for
  `CarbonDatePicker` (three variants, calendar keyboard grid, year input,
  min/max, localizable labels) and `CarbonTimePicker` +
  `CarbonTimePickerSelect`; Changes bullet for the demo retirement.
- `doc/V2_ROADMAP.md`: Phase 3 item 2 → ✅ — **Phase 3 complete**; update
  the sequencing table row.
- Wave README status table → all ✅.
- Material bridge (`datePickerTheme`/`timePickerTheme` in
  `lib/src/material/carbon_material_theme.dart`) stays untouched — it
  still themes Material pickers for bridge users.

## Release checks

- `flutter analyze` — zero issues, root and `example/`.
- `flutter test` — full package suite green.
- `cd example && flutter test` — smoke suite green.
- `dart pub publish --dry-run` — clean (modulo uncommitted-git warnings).
- Manual example smoke per the wave README checklist.
