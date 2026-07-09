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

### Phase 1 — Theming rearchitecture (v2.0, breaking) — ✅ shipped in 2.0.0-dev.1

Executed per `doc/implementation/` (steps 01–06):

1. ✅ `CarbonThemeData` (and all component theme data classes) dropped
   `ThemeExtension`; `CarbonTheme` inherited widget + `AnimatedCarbonTheme`;
   `context.carbon` re-pointed.
2. ✅ `CarbonApp` on `WidgetsApp` + `CarbonPageRoute`.
3. ✅ Bridge decision: **library file** `package:flutter_carbon/material.dart`
   (not a separate package) — `carbonTheme()`, `CarbonMaterialBridge`,
   `CarbonMaterialThemeExtension`.
4. ✅ Migration guide in `MIGRATION.md` ("1.x → 2.0.0").
5. ✅ Bonus: theme token audit against Carbon v11.96 sources in `carbon/`
   (see `doc/implementation/01-token-audit.md` findings).

**TODO: token codegen pipeline** — generate `lib/src/theme/themes/**` from the
`carbon/packages/themes` TS sources (theme files + component tokens) so future
Carbon releases sync mechanically instead of via one-off audits. Script specs
in `doc/implementation/01-token-audit.md`; deferred past 2.0.

### Phase 2 — Native primitives (v2.x)

In dependency order (1–3 ✅ shipped as wave 1, see
`doc/implementation/07-native-primitives.md` — Material import count in
`lib/src/widgets/` dropped 13 → 9):

1. ✅ `CarbonSpinner` (unblocked `carbon_loading`, `carbon_file_uploader`).
2. ✅ `CarbonCheckbox`, `CarbonRadio` (unblocked `carbon_data_table`,
   `carbon_multi_select`'s checkbox) — Carbon spec differs visibly from
   Material so this is also a fidelity win.
3. ✅ `CarbonTooltip` (unblocked `carbon_pagination`) — built on the shared
   `CarbonAnchoredOverlay`; `carbon_combo_button` still needs its menu API
   redesign.
4. `CarbonTextInput` on `EditableText` — **the risk item**, see below. Unblocks
   `carbon_combo_box`, `carbon_number_input`, `carbon_toolbar`,
   `carbon_multi_select`, `carbon_modal`. Ship it standalone first (it's also
   a missing Carbon component in its own right — today text input is
   Material-themed only), let it bake, then migrate dependents.
5. Replace `FloatingActionButton` and the remaining `Scaffold` usages.

### Phase 3 — Retire the "Material Theming" category

Native `CarbonAccordion`, `CarbonSearch`, `CarbonSelect`, `CarbonSlider`, then
`CarbonDatePicker` / `CarbonTimePicker` last (largest scope: calendar grid,
range selection, keyboard navigation, localization). The example app's
"Material Theming" section moves to the bridge package's docs.

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
| 1 | ✅ 2.0.0-dev.1 | Yes | `CarbonTheme` + `CarbonApp`; Material becomes an explicit bridge |
| 2 | 2.1–2.x | No | Native checkbox/radio/spinner/tooltip/text input |
| 3 | 2.x | No | Native accordion/search/select/slider/date picker; `import material.dart` count in `lib/` reaches 0 |
