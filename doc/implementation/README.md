# V2.0 Implementation — Theming Rearchitecture + Token Audit

Execution guide for flutter_carbon v2.0 Phase 1 (see `../V2_ROADMAP.md`).
Work happens on the `V2` branch. Each step is a separate document with its own
verification; `flutter analyze` stays green between steps. Step 04 is the one
atomic breaking commit.

## Goal

Make the theming core Material-free:

- `CarbonTheme` InheritedWidget replaces the `ThemeExtension` mechanism;
  `context.carbon` no longer touches `Theme.of`.
- `carbonTheme()` and all Material component mappings move to an explicit
  bridge library: `package:flutter_carbon/material.dart`.
- New `CarbonApp` (built on `WidgetsApp`) lets pure-Carbon apps skip
  `MaterialApp` entirely.
- Theme token values audited against the Carbon v11.96 source checked out at
  `carbon/`.

The enforced v2.0 invariant: **no `material.dart`/`cupertino.dart` imports
under `lib/src/{theme,foundation,base,app}`** (guard test in step 05). Full
package-wide Material freedom waits for the native primitives in later phases —
13 exported widgets still import Material for TextField/Checkbox/etc.

## Execution order & status

| Step | Doc | Status |
| --- | --- | --- |
| 01 | [Token audit](01-token-audit.md) | ✅ |
| 02 | [Import sweep](02-import-sweep.md) | ✅ |
| 03 | [Material bridge (additive)](03-material-bridge.md) | ✅ |
| 04 | [Theming core (atomic breaking change)](04-theming-core.md) | ✅ |
| 05 | [CarbonApp](05-carbon-app.md) | ✅ |
| 06 | [Docs & release](06-docs-and-release.md) | ✅ |

Update this table (⬜ → ✅) as steps complete.

## Global verification (after step 06)

- `flutter analyze` — zero issues (root and `example/`).
- `flutter test` — all existing (394) + new tests pass.
- `grep -rl "flutter/material" lib/src/theme lib/src/foundation lib/src/base lib/src/app`
  returns nothing.
- Example app runs; theme switcher live-switches all 4 themes through the
  bridge; overlay widgets work; `context.carbon` never throws.
- `dart pub publish --dry-run` passes with the new `lib/material.dart`.
