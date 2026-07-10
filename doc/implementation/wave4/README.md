# Wave 4 — Phase 3 wave 1: native Search, Select, Slider, Accordion

Starts Phase 3 of `../../V2_ROADMAP.md`: retire the example app's "Material
Theming" demo category by shipping native, spec-fidelity (Carbon v11.96)
implementations of the four components it still demos through themed Material
widgets:

| Demo today (themed Material) | This wave (native) |
| --- | --- |
| Accordion → `ExpansionTile` | `CarbonAccordion` |
| Search → `SearchBar` / `SearchAnchor` | `CarbonSearch` |
| Select → `DropdownMenu` | `CarbonSelect` |
| Slider (in Selection Controls page) | `CarbonSlider` (incl. two-handle range) |

This wave is **additive** — no breaking changes. `CarbonToolbarSearch` keeps
its public API but is internally rebuilt as a thin wrapper over `CarbonSearch`
(fixing its long-standing 1px-instead-of-2px focus outline deviation).

Maintainer decisions baked in:

- `CarbonSelect` is a **separate widget** from `CarbonDropdown` (native-select
  form semantics: invalid/warn/readOnly, xs–lg sizes).
- `CarbonSlider` ships the **two-handle range mode now** (`valueUpper`).
- `CarbonToolbarSearch` is refactored onto `CarbonSearch`.

## Execution order & status

| Step | Doc | Status |
| --- | --- | --- |
| 14 | [CarbonSearch + toolbar refactor](14-carbon-search.md) | ✅ |
| 15 | [CarbonSelect + menu panel selection](15-carbon-select.md) | ✅ |
| 16 | [CarbonSlider](16-carbon-slider.md) | ✅ |
| 17 | [CarbonAccordion](17-carbon-accordion.md) | ✅ |
| 18 | [Category cleanup & release](18-category-cleanup.md) | ✅ |

`flutter analyze` and the full test suite stay green between steps.

## Global verification (after step 18)

- `flutter analyze` — zero issues (root and `example/`).
- `flutter test` — full suite green (existing ~498 + new widget suites).
- Guard test already covers `lib/src/widgets` — the four new files are
  automatically Material-free-enforced.
- `dart pub publish --dry-run` passes.
- Example smoke: search sizes/expandable/clear/Escape; toolbar search in the
  data-table page (2px focus ring, collapse-on-blur); select form states +
  menu keyboard; slider drag/keyboard/range/number input; accordion animation,
  flush, controlled mode; "Material Theming" category now only shows Tooltip
  and Selection Controls (checkbox/radio/switch).

## Deliberate changes (spec fidelity, eyeball during smoke)

- Toolbar search: 2px `$focus` outline (was 1px — deviation fixed); expanded
  magnifier icon is `$icon-secondary` per spec (was primary); clearing no
  longer collapses the field — collapse happens on blur/Escape while empty
  (React parity).
- Slider: focused thumb renders a solid `$interactive` fill instead of the
  spec's double inset ring (follow-up); range handles are circles in v1
  (spec's 24×16 directional handles are a visual follow-up); out-of-range
  typed values clamp on commit instead of React's transient invalid flag.
- Select: the popup is a Carbon menu (native `<select>` has no styled popup);
  the selected option gets dropdown-style highlight + checkmark.
