# Step 13 — Guard & release

Runs LAST (earlier steps must land first or the guard fails).

## Guard extension

`test/theme/no_material_import_test.dart` `guardedDirs` gains:

- `lib/src/widgets`
- `lib/src/icons` (already clean — cheap insurance)

End state: `grep -rl "flutter/material" lib/src` returns only
`lib/src/material/*`; the bridge (`lib/material.dart` +
`lib/src/material/`) is the sole intentional Material surface in the
package.

## CHANGELOG (Unreleased)

- **Breaking**: `CarbonComboButton` → generic `CarbonComboButton<T>`;
  `menuItems: List<CarbonMenuEntry<T>>` (was `List<PopupMenuEntry<dynamic>>`);
  `onMenuItemSelected: ValueChanged<T>` (was `void Function(dynamic)`).
  Migration: `PopupMenuItem(value: 'x', child: Text('X'))` →
  `CarbonMenuItem(value: 'x', label: 'X')`; `PopupMenuDivider()` →
  `CarbonMenuItemDivider()`.
- **Breaking**: `CarbonFloatingMenu.heroTag` removed.
- **Breaking (behavioral)**: `CarbonUIShell`/`CarbonModal` no longer create
  `Scaffold`/`Material` ancestors.
- New: `CarbonMenuItem`/`CarbonMenuItemDivider` model (Carbon Menu spec,
  keyboard navigation, danger kind).
- Changed: modal spec footer/danger/motion/overlay token; code snippet uses
  Carbon-native selection.

## Docs

- Roadmap: mark Phase 2 item 5 ✅ pointing to `doc/implementation/wave3/`.
- Wave-3 README status table: all ✅.

## Verification

- `flutter analyze` (root + example) — zero issues.
- `flutter test` — full suite green, guard test proves the invariant.
- `dart pub publish --dry-run` passes.
