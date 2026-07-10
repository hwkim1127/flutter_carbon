# Wave 3 — De-materialize the last 5 widgets

Finishes Phase 2 of `../../V2_ROADMAP.md`: after this wave, **no file under
`lib/src/widgets/` imports `package:flutter/material.dart`** — the only
Material left in `lib/` is the intentional bridge (`lib/src/material/` +
`lib/material.dart`), enforced by extending the no-material guard test to
`lib/src/widgets`.

This wave is **breaking**:

- `CarbonComboButton` becomes generic `CarbonComboButton<T>`; `menuItems`
  changes from Material's `List<PopupMenuEntry<dynamic>>` to the new
  `List<CarbonMenuEntry<T>>`; `onMenuItemSelected` becomes `ValueChanged<T>`.
- `CarbonFloatingMenu.heroTag` is removed (only existed for Material's FAB
  Hero animation).
- Behavioral: `CarbonUIShell` and `CarbonModal` no longer provide a
  `Scaffold`/`Material` ancestor — Material descendants passed as content
  need their own `Material`.

## Execution order & status

| Step | Doc | Status |
| --- | --- | --- |
| 09 | [CarbonMenu primitive](09-carbon-menu.md) | ✅ |
| 10 | [CarbonComboButton rewrite](10-combo-button.md) | ✅ |
| 11 | [Modal restructure](11-modal.md) | ✅ |
| 12 | [Shell, floating menu, code snippet](12-shell-fab-snippet.md) | ✅ |
| 13 | [Guard & release](13-guard-and-release.md) | ✅ |

`flutter analyze` and the full test suite stay green between steps.

## Global verification (after step 13)

- `flutter analyze` — zero issues (root and `example/`).
- `flutter test` — full suite green.
- Guard test covers `lib/src/widgets` (+ `lib/src/icons`);
  `grep -rl "flutter/material" lib/src` returns only `lib/src/material/*`.
- `dart pub publish --dry-run` passes.
- Example smoke: combo button menus (values, danger items, keyboard
  Escape/arrows), modal set (spec footer, danger kind, input + keyboard),
  UI shell navigation, floating menu, code snippet select/copy/expand.

## Deliberate visual changes (spec fidelity, eyeball during smoke)

- Modal: 64px flush half-width footer buttons; `secondary`-kind cancel;
  danger modal loses the non-spec red header band (danger button instead);
  title weight per `heading-03`; passive content left-aligned; 240ms
  entrance motion; `$overlay` barrier token.
- Menu: danger items look standard at rest (red only on hover/focus, per
  the Carbon Menu spec).
