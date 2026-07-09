# Step 07 — Native primitives, wave 1 (Phase 2)

First wave of `doc/../V2_ROADMAP.md` Phase 2: replace Material controls with
spec-accurate Carbon-native implementations, in dependency order. This wave
covers the roadmap's items 1–3 (spinner, checkbox/radio, tooltip) and migrates
the widgets they unblock. `CarbonTextInput` (item 4, the risk item) is **not**
in this wave.

## Goal

Remove `package:flutter/material.dart` from:

- `carbon_loading.dart` (CircularProgressIndicator → native spinner painter)
- `carbon_data_table.dart` (Checkbox/Radio → CarbonCheckbox/CarbonRadio)
- `carbon_pagination.dart` (IconButton+tooltip → CarbonTooltip + pressable)

and shrink the Material surface of:

- `carbon_file_uploader.dart` (CircularProgressIndicator → CarbonLoading;
  FilledButton/IconButton replaced natively if nothing else blocks)
- `carbon_multi_select.dart` (Checkbox → CarbonCheckbox; TextField remains —
  blocked on CarbonTextInput)

## New widgets (all read core semantic tokens directly — no new component
theme classes; `carbon.layer.*` / `carbon.text.*` already carry every token
these specs need)

### `lib/src/widgets/carbon_checkbox.dart` — `CarbonCheckbox`

Spec (from `carbon/packages/styles/scss/components/checkbox/_checkbox.scss`):

- Box 16×16, border-radius 2, unchecked: 1px border `$icon-primary`,
  transparent fill.
- Checked: fill `$icon-primary`, no border; checkmark drawn 1.5px-stroke
  `$icon-inverse` (9×5 angled check).
- Indeterminate (`tristate`): fill `$icon-primary`, 8×2 horizontal dash
  `$icon-inverse`.
- Disabled: border/fill `$icon-disabled`; label `$text-disabled`.
- Invalid: 1px border `$support-error`.
- Focus: 2px `$focus` outline (1px offset), matching CarbonToggle's ring
  pattern.
- Label: body-compact-01 `$text-primary`, 8px gap (spec: 20px inline padding
  from box edge − 16px box ≈ 4px + visual margin; we standardize on 8 to match
  the library's other controls), min row height 20.

API: `CarbonCheckbox({required bool? value, required ValueChanged<bool?>?
onChanged, String? label, bool tristate = false, bool invalid = false, String?
invalidText})`. `value == null` (tristate) renders the dash. Keyboard: Space
toggles. `Semantics(checked: …, enabled: …)` + `MouseRegion` cursor. Pattern
copy: `carbon_toggle.dart` (Focus/keyboard/focus-ring conventions).

### `lib/src/widgets/carbon_radio.dart` — `CarbonRadio<T>`

Spec (`radio-button/_radio-button.scss`): 18×18 circle, 1px border
`$icon-primary`; selected: 8px inner dot `$icon-primary`; disabled: border
`$icon-disabled`, dot `$text-disabled`; invalid: border `$support-error`;
focus ring as checkbox. Label body-compact-01, 8px gap.

API mirrors Material for drop-in migration: `CarbonRadio<T>({required T value,
required T? groupValue, required ValueChanged<T?>? onChanged, String? label,
bool invalid = false})`. Selected ⇔ `value == groupValue`. No group widget in
this wave (the data table manages its own selection state).

### `carbon_loading.dart` — native spinner (public API unchanged)

Spec (`loading/_loading.scss`): rotating arc, `stroke: $interactive`
(`carbon.layer.interactive` — today's code uses `buttonPrimary`, same hex in
stock themes but wrong token). Arc coverage: large/medium 81% of the circle,
small 48%; small additionally draws a full background ring `$layer-accent`
(`layerAccent01`). Stroke width: 10/100 of diameter (16/100 for small).
Rotation: 690ms linear, infinite (Carbon `animation.spin`).

Implementation: `_SpinnerPainter` (arc via `canvas.drawArc`, sweep =
`2π × coverage`) driven by an `AnimationController` in a new private
`_CarbonSpinner` StatefulWidget used by both `CarbonLoading` and
`CarbonInlineLoading`. `Semantics(label: 'loading')` on the spinner.

### `lib/src/widgets/carbon_tooltip.dart` — `CarbonTooltip`

Spec (`tooltip/_tooltip.scss` + popover high-contrast): background
`$background-inverse`, text `$text-inverse` body-compact-01, max-width 288,
padding 2px 16px (min height 24), border-radius 2, caret. Behavior: show on
hover (enter delay 100ms, leave delay 300ms) and on focus of the child;
Escape hides. Positioning: `CarbonAnchoredOverlay` (alignment `top` default,
auto-flip). Caret reuses the popover's `_CaretPainter` geometry — duplicated
locally (16×8 triangle) rather than exporting popover internals.

API: `CarbonTooltip({required Widget child, required String message,
CarbonPopoverAlignment alignment = .top, Duration enterDelay = 100ms,
Duration leaveDelay = 300ms})`. Timers cancelled in dispose; overlay removed
in dispose (no setState — the established lifecycle pattern).

## Migrations

| File | Change |
| --- | --- |
| `carbon_data_table.dart` | `Checkbox(...)` → `CarbonCheckbox` (tristate header select-all keeps null state), `Radio<int>` → `CarbonRadio<int>`; drop material import if nothing else remains |
| `carbon_multi_select.dart` | `Checkbox` → `CarbonCheckbox`, drop `InkWell` for the library's hover pattern; material import stays (TextField) |
| `carbon_pagination.dart` | `IconButton(tooltip:)` → `CarbonTooltip(child: CarbonPressable(...))` 32×32 hit target; drop material import |
| `carbon_file_uploader.dart` | `CircularProgressIndicator` → `CarbonLoading(small)`; `FilledButton` → `CarbonButton`; `IconButton` → pressable icon; drop material import if clean |

## Exports

`lib/flutter_carbon.dart`: add `carbon_checkbox.dart`, `carbon_radio.dart`,
`carbon_tooltip.dart`.

## Tests

- `test/widgets/carbon_checkbox_test.dart` — renders, toggles on tap/Space,
  tristate cycle, disabled ignores tap, invalid border, works in all themes.
- `test/widgets/carbon_radio_test.dart` — select via tap, groupValue drives
  state, disabled, works in all themes.
- `test/widgets/carbon_tooltip_test.dart` — shows on hover after delay, hides
  on exit after delay, overlay removed on unmount, no Material dependency
  (pump under CarbonApp).
- Existing loading/data-table/pagination/file-uploader/multi-select suites
  must stay green (checkbox finders change from `find.byType(Checkbox)` to
  `find.byType(CarbonCheckbox)` where used).

## Verification

- `flutter analyze` — zero issues.
- `flutter test` — full suite green.
- Material import count in `lib/src/widgets/` drops from 13 to ≤ 10
  (loading, data_table, pagination out; file_uploader if clean).
- Example app smoke: data table selection, pagination tooltips, loading page,
  multi-select checkboxes.

## Deferred (later waves)

- `CarbonTextInput` on EditableText → unblocks combo_box, number_input,
  toolbar, multi_select (fully), modal.
- `carbon_combo_button` menu API redesign (PopupMenuEntry in public API).
- `carbon_floating_menu` (FAB), `carbon_ui_shell` (Scaffold),
  `carbon_code_snippet` (SelectableText).
