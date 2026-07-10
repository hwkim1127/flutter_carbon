# V2 Roadmap — Removing the Material Dependency

## Goal

Make `flutter_carbon` a self-contained implementation of Carbon Design System
built on `package:flutter/widgets.dart` only — no `package:flutter/material.dart`
imports in `lib/`.

### Why

- **Fidelity.** Material primitives carry Material behavior that is off-spec for
  Carbon: ripple ink splashes, Material focus/hover overlays, Material state
  layer opacities, M3 shape defaults. A widgets-layer implementation renders
  exactly what the Carbon spec says.
- **Independence.** Users shouldn't need a `MaterialApp` (or a Material
  `ThemeData`) to use Carbon components. Today `context.carbon` resolves through
  `Theme.of(context)`, so the library cannot work without a Material `Theme`
  ancestor.
- **Precedent.** This is the established path for non-Material design systems in
  Flutter: `cupertino` (in the SDK itself), `fluent_ui`, `macos_ui`, `forui` all
  provide their own `*App` / `*Theme` and build on the widgets layer.

### What "removing Material" means (and doesn't)

- The `flutter` SDK dependency stays. We stop importing `material.dart`;
  `widgets.dart`, `painting.dart`, `rendering.dart`, `services.dart` are all fair
  game.
- `uses-material-design` stays off — we already ship our own `CarbonIcons` font.
- Material *interop* is preserved through an explicit bridge (see Phase 1), not
  through the core.
- The pubspec description ("seamless Material Design integration") and README
  positioning change accordingly.

---

## Current dependency inventory

### 1. Theming core (architectural — the real work)

| Site | Dependency | V2 replacement |
| --- | --- | --- |
| `CarbonThemeData` | `extends ThemeExtension<CarbonThemeData>` | Plain immutable data class (keep `lerp` for animated theme switches) |
| `context.carbon` | `Theme.of(this).extension<CarbonThemeData>()` | `CarbonTheme.of(context)` — dedicated `InheritedWidget` |
| `carbonTheme()` | Builds a full Material `ThemeData` (~20 component themes: buttons, checkbox, radio, switch, slider, app bar, nav bars, tabs, chips, inputs, …) | Moves to the Material bridge package; no longer the primary entry point |
| App entry | Requires `MaterialApp(theme: carbonTheme(...))` | `CarbonApp` built on `WidgetsApp` (provides Navigator, Overlay, Directionality, localizations, text selection defaults) |
| ~50 theme data files | `import material.dart` for `Color`/`TextStyle` only | Mechanical: switch to `widgets.dart` / `painting.dart` |

### 2. The "Material Theming" component strategy

An entire category of the library is *themed Material widgets*, not Carbon
widgets. Removing Material means these become native implementations (which is
also what the Carbon spec actually defines):

| Today (themed Material) | V2 (native Carbon) |
| --- | --- |
| Accordion → `ExpansionTile` | `CarbonAccordion` |
| Tooltip → Material `Tooltip` | `CarbonTooltip` |
| Search → `SearchBar` | `CarbonSearch` |
| Select → `DropdownMenu` | `CarbonSelect` (or fold into `CarbonDropdown`) |
| Checkbox / Radio / Switch / Slider | `CarbonCheckbox`, `CarbonRadio`, (toggle exists), `CarbonSlider` |
| Date & Time pickers → `showDatePicker` etc. | `CarbonDatePicker` / `CarbonTimePicker` — **largest single item in the roadmap** |

### 3. Remaining Material usage inside `lib/src/widgets/`

As of 1.3.0, 24 of 37 widgets build on the widgets layer only. The 13 widgets
below still import `material.dart` — each for a component that needs a native
Carbon replacement:

**Medium** (one Material component to replace):

| Widget | Material usage | Needs |
| --- | --- | --- |
| `carbon_data_table` | `Checkbox`, `Radio` | `CarbonCheckbox`, `CarbonRadio` |
| `carbon_loading` | `CircularProgressIndicator` | `CarbonSpinner` (custom painter, Carbon spec) |
| `carbon_file_uploader` | `CircularProgressIndicator`, `IconButton` | `CarbonSpinner` |
| `carbon_pagination` | Material `Tooltip`, `IconButton` | `CarbonTooltip` |
| `carbon_combo_button` | `Tooltip`, `FilledButton`, `PopupMenuButton` (exposes `PopupMenuEntry` in its public API) | `CarbonTooltip` + API-breaking menu redesign |
| `carbon_floating_menu` | `FloatingActionButton` | Custom circular button (small) |
| `carbon_ui_shell` | `Scaffold`, `IconButton` | Custom shell layout (already mostly custom) |
| `carbon_code_snippet` | `SelectableText` | Widgets-layer selectable text |

**Hard** (blocked on `CarbonTextInput`; `Scaffold` in modal also stays until
then — it is the Material ancestor the input-modal `TextField` requires):

| Widget | Material usage |
| --- | --- |
| `carbon_combo_box` | `TextField` |
| `carbon_number_input` | `TextField` |
| `carbon_toolbar` | `TextField` (search) |
| `carbon_multi_select` | `TextField`, `Checkbox`, `InkWell` |
| `carbon_modal` | `Scaffold`, `TextField` |

---

## Target architecture

```
CarbonApp                        // WidgetsApp: Navigator, Overlay, locale, shortcuts
└── CarbonTheme (InheritedWidget)
    └── context.carbon           // CarbonTheme.of(context), no Theme.of
        └── Carbon widgets       // widgets.dart only

flutter_carbon_material (separate package or opt-in library file)
├── carbonTheme() → ThemeData    // today's Material component theming, unchanged
└── CarbonMaterialBridge         // injects CarbonTheme under a MaterialApp
```

- `CarbonTheme` mirrors `CupertinoTheme`: `of(context)` (required) and
  `maybeOf(context)`. Animated theme switching via an implicit-animation
  wrapper using the existing `CarbonThemeData.lerp`.
- The bridge keeps today's biggest selling point — dropping Carbon widgets into
  an existing Material app — working with one wrapper widget, without the core
  depending on Material.

## Phases

### Phase 1 — Theming rearchitecture (v2.0, breaking) — ✅ shipped in 2.0.0

Executed per `doc/implementation/wave2/` (steps 01–06):

1. ✅ `CarbonThemeData` (and all component theme data classes) dropped
   `ThemeExtension`; `CarbonTheme` inherited widget + `AnimatedCarbonTheme`;
   `context.carbon` re-pointed.
2. ✅ `CarbonApp` on `WidgetsApp` + `CarbonPageRoute`.
3. ✅ Bridge decision: **library file** `package:flutter_carbon/material.dart`
   (not a separate package) — `carbonTheme()`, `CarbonMaterialBridge`,
   `CarbonMaterialThemeExtension`.
4. ✅ Migration guide in `MIGRATION.md` ("1.x → 2.0.0").
5. ✅ Bonus: theme token audit against Carbon v11.96 sources in `carbon/`
   (see `doc/implementation/wave2/01-token-audit.md` findings).

**TODO: token codegen pipeline** — generate `lib/src/theme/themes/**` from the
`carbon/packages/themes` TS sources (theme files + component tokens) so future
Carbon releases sync mechanically instead of via one-off audits. Script specs
in `doc/implementation/wave2/01-token-audit.md`; deferred past 2.0.

### Phase 2 — Native primitives (v2.x)

In dependency order (1–3 ✅ shipped as wave 1, see
`doc/implementation/wave2/07-native-primitives.md` — Material import count in
`lib/src/widgets/` dropped 13 → 9):

1. ✅ `CarbonSpinner` (unblocked `carbon_loading`, `carbon_file_uploader`).
2. ✅ `CarbonCheckbox`, `CarbonRadio` (unblocked `carbon_data_table`,
   `carbon_multi_select`'s checkbox) — Carbon spec differs visibly from
   Material so this is also a fidelity win.
3. ✅ `CarbonTooltip` (unblocked `carbon_pagination`) — built on the shared
   `CarbonAnchoredOverlay`; `carbon_combo_button` still needs its menu API
   redesign.
4. ✅ `CarbonTextInput` + `CarbonTextArea` on `EditableText` — **the risk
   item**, shipped as wave 2 (`doc/implementation/wave2/08-carbon-text-input.md`)
   with full selection UX (custom handles + Carbon context menu with
   localizable labels). All five dependents migrated in the same wave:
   `carbon_combo_box`, `carbon_number_input`, `carbon_toolbar`,
   `carbon_multi_select` are now Material-free; `carbon_modal` swapped its
   TextField (Scaffold/buttons remain). Material import count in
   `lib/src/widgets/`: 9 → 5.
5. ✅ Wave 3 (`doc/implementation/wave3/`): combo button rebuilt on the new
   `CarbonMenuItem<T>` model (breaking), modal restructured to the spec
   footer, UI shell / floating menu / code snippet de-materialized.
   **Material import count in `lib/src/widgets/`: 0** — the bridge is the
   only Material left in the package (guard-test enforced).

### Phase 3 — Retire the "Material Theming" category

1. ✅ Wave 1 (`doc/implementation/wave4/`): native **`CarbonSearch`**
   (incl. the expandable variant; `CarbonToolbarSearch` is now a thin
   wrapper over it), **`CarbonSelect`** (separate widget with the Select
   form states), **`CarbonSlider`** (incl. two-handle range mode), and
   **`CarbonAccordion`**. The example app's Accordion/Search/Select demos
   are native and left the "Material Theming" category; Slider got its own
   demo under Forms. "Material Theming" now demos Tooltip and the
   checkbox/radio/switch selection controls only.
2. ✅ Wave 2 (`doc/implementation/wave5/`): native **`CarbonDatePicker`**
   (simple/single/range, keyboard-navigable calendar grid, spec year
   input, `CarbonDatePickerLabels` localization — zero dependencies) and
   **`CarbonTimePicker`** + **`CarbonTimePickerSelect`** (masked `hh:mm`
   input + compact selects, per spec). The Date & Time Picker demo is
   native; **Phase 3 is complete** — the example's remaining Material
   usage is the deliberate bridge showcase only.

✅ **Code snippet syntax highlighting** (v1 shipped alongside wave 3; v2
in wave 6) — the 41 `carbon.syntax` tokens drive a pluggable highlighter
with a shared zero-dependency tokenizer engine, **13 built-in languages**
(`carbonHighlighterFor`), string interpolation islands, and a
line-numbers gutter; `CarbonCodeSnippet` itself is fully to spec (row
model, fades, click-to-copy inline, skeleton). See
`doc/implementation/wave6/` and `doc/proposals/syntax-highlighting.md`.

✅ **Carbon scrollbars** (wave 7) — Carbon web relies on native browser
scrollbars; Flutter draws none, so the internal `CarbonScrollbar`
primitive (visible exactly while content overflows) is adopted by every
library scrollable: menus, data table, tearsheet, tree view, UI shell
side nav, text areas, and the code snippet's nested 2D scrolling. Tabs
deliberately keep none (the spec scrolls tab bars with chevron buttons —
a future item). See `doc/implementation/wave7/`.

---

## Risks and open questions

- **Text editing is the hard 20%.** `EditableText` provides the editing core,
  but `TextField` also supplies selection handles, the context menu
  (`AdaptiveTextSelectionToolbar` is Material/Cupertino-flavored), magnifier,
  IME edge cases, and autofill wiring. Plan for a custom
  `TextSelectionControls` implementation and real device testing (iOS IME,
  Android autofill). This is why `CarbonTextInput` ships standalone before any
  dependent migrates.
- **Overlay & localization plumbing.** `WidgetsApp` provides `Overlay` and
  `DefaultWidgetsLocalizations`, but anything currently leaning on
  `MaterialLocalizations` (e.g. tooltips' semantic labels, date formatting in
  pickers) needs Carbon-owned strings with a localization hook.
- **Accessibility parity.** Material controls carry mature semantics
  (checkbox/radio toggle semantics, slider a11y actions). Every native
  replacement needs explicit `Semantics` work and screen-reader testing —
  budget it per widget, not as an afterthought.
- **Ecosystem cost.** Some users chose this package *because* of the Material
  theming layer. The bridge must be first-class, documented, and tested — not
  a deprecation shim.
- **Decide:** bridge as separate pub package vs. `flutter_carbon/material.dart`
  library file (recommend: library file for v2.0, extract to a package only if
  the core ever wants to drop it entirely).

## Sequencing summary

| Phase | Version | Breaking? | Headline |
| --- | --- | --- | --- |
| 1 | ✅ 2.0.0 | Yes | `CarbonTheme` + `CarbonApp`; Material becomes an explicit bridge |
| 2 | ✅ 2.0.0 | Yes (combo button) | Native checkbox/radio/spinner/tooltip/text input/menu; `import material.dart` count in `lib/src/widgets/` reaches 0 |
| 3 | ✅ 2.0.0 | No | Native accordion/search/select/slider + date/time pickers |
