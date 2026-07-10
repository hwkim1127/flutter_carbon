# Step 12 — UI shell, floating menu, code snippet

The three mechanical migrations.

## carbon_ui_shell.dart

- `Scaffold(body: ...)` → `ColoredBox(carbon.layer.background)` (spec: shell
  base surface is `$background`) + `Padding(bottom:
  MediaQuery.viewInsetsOf(context).bottom)` (Scaffold's
  `resizeToAvoidBottomInset` equivalent — the shell hosts forms) +
  `MediaQuery.removeViewInsets(removeBottom: true, ...)` so inner
  scrollables don't double-handle.
- `_MenuButton`'s `IconButton` → 48×48 `CarbonPressable(focusable: true)` +
  `Semantics(button, label: 'Menu')`, hover `headerNavItemBackgroundHover`,
  20px menu icon (pagination icon-button pattern).
- Behavioral (CHANGELOG): the shell no longer provides a Material ancestor
  for its `child`.
- Test: add "no Scaffold inside CarbonUIShell".

## carbon_floating_menu.dart (BREAKING: heroTag removed)

Carbon has no FAB spec — this is a custom widget, restyled natively:

- Remove the `heroTag` field/param (existed only for Material's FAB Hero).
- `FloatingActionButton` → `Semantics(button)` → `CarbonPressable(focusable:
  true)` → `Container(56×56, color: pressed → buttonPrimaryActive / hovered
  → buttonPrimaryHover / theme.fabBackground, BoxShadow black@0.3 blur 6
  offset (0,2))` → `Center(AnimatedRotation(existing turns/duration,
  Icon 24 fabForeground))`. Gains hover/pressed feedback the FAB variant
  never had.
- Tests: replace the four `find.byType(FloatingActionButton)` with icon /
  semantics finders; drop `heroTag:` args (Material `Icons.*` stay — plain
  `IconData`). Example: remove any `heroTag:` usage.

## carbon_code_snippet.dart

- The single `SelectableText` (multi-line variant) →
  `CarbonEditableCore(controller: _controller, readOnly: true, maxLines:
  null, style: <current mono style>)` — read-only selection with the Carbon
  context menu (Copy/Select all) for free.
- Controller lifecycle: created in `initState` from `_displayedLines`;
  updated in the expand-toggle `setState` and in `didUpdateWidget` when
  `code`/`maxCollapsedLines`/`type` change; never assigned in `build`;
  disposed.
- **Width risk**: multiline `EditableText` asserts on unbounded width inside
  the horizontal `SingleChildScrollView`. Bound it with a
  `TextPainter`-measured `SizedBox(width: longestLineWidth + 1)`.
- `code01`/`code02` typography adoption noted as follow-up (mono family not
  bundled); current font values kept.
- Test: multi snippet contains a `readOnly` `EditableText`; expand toggle
  updates the visible text; copy button still writes the clipboard.
