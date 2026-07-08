# 06 — Docs & Release

## Goal

Version, changelog, migration guide, README, roadmap — everything a 2.0.0-dev
consumer needs.

## Changes

1. **`pubspec.yaml`**
   - `version: 2.0.0-dev.1` (bump to `2.0.0` at release).
   - Description: drop "seamless Material Design integration" →
     "…4 theme variants; works with or without Material via CarbonApp or the
     optional Material bridge (package:flutter_carbon/material.dart)."
2. **`CHANGELOG.md`** — `## 2.0.0-dev.1` entry:
   - **Breaking**: `CarbonThemeData` no longer a `ThemeExtension`;
     `context.carbon` resolves via `CarbonTheme` (Material apps must install
     `CarbonMaterialBridge` in `MaterialApp.builder`); `carbonTheme()` and
     `CarbonInputDecorationHelper` moved to
     `package:flutter_carbon/material.dart`; `CarbonThemeData.lerp` signature
     is now `lerp(CarbonThemeData? other, double t)`.
   - **Added**: `CarbonTheme`, `AnimatedCarbonTheme`, `CarbonThemeDataTween`,
     `CarbonApp`, `CarbonPageRoute`, `CarbonMaterialBridge`,
     `CarbonMaterialThemeExtension`, `package:flutter_carbon/material.dart`.
   - **Fixed**: token audit corrections vs Carbon v11.96 (list from step 01).
3. **`MIGRATION.md`** — new "## 1.x → 2.0.0" section at top (keep the 1.1.0
   DataTable guide below):
   - Material apps: import change + before/after `MaterialApp` snippet with
     the `builder:` bridge line.
   - Pure Carbon apps: `MaterialApp` → `CarbonApp` snippet.
   - `Theme.of(context).extension<CarbonThemeData>()` → `context.carbon`.
   - `lerp` signature change.
   - Table of the 13 widgets that still require a Material host.
4. **`README.md`**
   - Quick Start: CarbonApp variant first, Material bridge variant second
     (update both `carbonTheme` snippets, ~lines 202 and 439).
   - "Handled via Material Theming" section: note it requires
     `package:flutter_carbon/material.dart`.
5. **`doc/V2_ROADMAP.md`**
   - Mark Phase 1 items shipped in 2.0.0-dev.1; record the "library file, not
     separate package" bridge decision.
   - Add: `TODO: token codegen pipeline — generate lib/src/theme/themes/**
     from carbon/packages/themes TS sources (see doc/implementation/01) so
     future Carbon releases sync mechanically.`
6. **`doc/implementation/README.md`** — status table all ✅.

## Verification

- `flutter analyze` + `flutter test` green (root + example).
- `dart pub publish --dry-run` — validates package layout incl.
  `lib/material.dart`.
- Example app manual run (theme switching, overlays).
