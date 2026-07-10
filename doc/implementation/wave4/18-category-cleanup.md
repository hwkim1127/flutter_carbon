# Step 18 — Category cleanup & release checks

## Example app restructure

- `example/lib/routes.dart`:
  - Move `accordion` / `search` / `select` route consts out of the Material
    block; add `slider`.
  - `componentCategories`: Search, Select, Slider → **Forms**; Accordion →
    **Content**; "Material Theming" keeps Tooltip + Selection Controls, with
    the Selection Controls description updated to "Checkbox, Radio, Switch
    with Carbon theme".
- `example/lib/main.dart`: add the `AppRoutes.slider` case.

## Docs & changelog

- `CHANGELOG.md`: the unpublished `2.0.0-dev.1`/`-dev.2` entries were merged
  into a single `## 2.0.0 (Unreleased)` (maintainer decision — neither dev
  version was ever deployed; `pubspec.yaml` bumped to `2.0.0` to match).
  Wave-4 additions under it:
  - **New Features (Phase 3, wave 4)** — CarbonSearch (sizes, expandable,
    clear, Escape semantics), CarbonSelect (form states, Carbon menu),
    CarbonSlider (single + range, number input, keyboard), CarbonAccordion
    (sizes, align, flush, controlled).
  - **Changes** — CarbonToolbarSearch now wraps CarbonSearch (2px focus fix,
    clear-vs-collapse behavior, `$icon-secondary` magnifier); CarbonMenuPanel
    selection support (internal).
  - No Breaking section — everything is additive.
- `doc/V2_ROADMAP.md`: mark the four Phase-3 components ✅ (date/time
  pickers remain the outstanding Phase-3 item).
- Flip this wave's README status table to ✅.

## Release checks

- `flutter analyze` — zero issues, root and `example/`.
- `flutter test` — full suite green.
- `dart pub publish --dry-run` — clean.
- Example smoke checklist in the wave README.
