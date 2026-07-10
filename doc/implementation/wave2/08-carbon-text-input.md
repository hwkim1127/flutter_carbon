# Step 08 — CarbonTextInput / CarbonTextArea (Phase 2, wave 2)

Phase 2 item 4 of `doc/../V2_ROADMAP.md` — the flagged **risk item**: a
Material-free text input built on `EditableText`, with full selection UX
(handles + context menu) hand-built on the widgets layer. Unblocks and
migrates all five `TextField` dependents in the same wave.

## Goal

- New exported widgets: `CarbonTextInput`, `CarbonTextArea`,
  `CarbonTextSelectionLabels`.
- New package-private text-editing core under `lib/src/text/`.
- Remove `package:flutter/material.dart` from `carbon_multi_select.dart`,
  `carbon_number_input.dart`, `carbon_combo_box.dart`, `carbon_toolbar.dart`;
  shrink `carbon_modal.dart` (TextField swap only — Scaffold/buttons are
  wave 3).
- Material import count in `lib/src/widgets/`: **9 → 5** (survivors:
  ui_shell, modal, floating_menu, combo_button, code_snippet).

## Deferred (documented in dartdoc)

Password visibility toggle, character counter (`enableCounter`/`maxCount` —
`maxLength` still enforces the limit via `LengthLimitingTextInputFormatter`),
`inline` layout, fluid variant, skeleton state, decorator/slug/light,
text magnifier, restoration of internally-owned controllers.

## Core architecture (`lib/src/text/`, not exported except labels)

Verified against the local Flutter 3.44.5 SDK — key facts the implementation
depends on:

1. **`TextSelectionHandleControls` mixin is mandatory.** `EditableText` only
   honors `contextMenuBuilder` when
   `selectionControls is TextSelectionHandleControls`. Our controls class is
   `extends TextSelectionControls with TextSelectionHandleControls` and never
   overrides the deprecated `buildToolbar`.
2. **`TextSelectionGestureDetectorBuilder`** (widgets-layer) already contains
   the complete platform gesture matrix (tap caret + shift-extend, double-tap
   word, long-press + haptics, mouse drag, secondary-tap toolbar). We subclass
   and override only `onUserTap` — exactly what Material's TextField does.
3. Toolbar/handle overlay entries are auto-wrapped in `TextFieldTapRegion`;
   hide-on-scroll and dismissal are framework-owned. Toolbar positioning uses
   the SDK `TextSelectionToolbarLayoutDelegate` (NOT `CarbonAnchoredOverlay`).
4. `WidgetsApp` installs `DefaultTextEditingShortcuts` — clipboard/nav
   shortcuts work identically under `CarbonApp` and the Material bridge.
5. Colors resolve: explicit param → `DefaultSelectionStyle.of(context)` →
   `carbon.button.buttonPrimary` (selection at 0.3 alpha, gated on focus).
6. Handle visibility replicates TextField's state machine: touch/stylus
   gestures only, never keyboard-caused, never disabled, not
   readOnly+collapsed, always on long-press, else only when text non-empty.
7. `magnifierConfiguration` left at its disabled default. Web keeps the
   browser context menu (documented).

| File | Contents |
| --- | --- |
| `carbon_editable_core.dart` | `CarbonEditableCore` — EditableText wrapper: own-if-null controller/focusNode, full param passthrough incl. `onTap`, 1px sharp cursor, gesture builder, handle state machine. `enabled: false` ⇒ no gestures/focus/cursor/menu |
| `carbon_text_selection_controls.dart` | 22×22 hit box, painted 12×12 sharp square handle in cursor color |
| `carbon_text_selection_toolbar.dart` | Carbon-styled context menu: `layer01` bg, 1px `borderSubtle01`, sharp corners; `CarbonPressable` buttons 32px; Row on mobile, vertical menu on desktop |
| `carbon_text_selection_labels.dart` | `CarbonTextSelectionLabels` — overridable English strings (exported; `CarbonPaginationLabels` precedent) |

## Public widgets (`lib/src/widgets/carbon_text_input.dart`)

`CarbonTextInputSize { xs(24), sm(32), md(40), lg(48) }`.

`CarbonTextInput(labelText*, hideLabel, controller, focusNode, onChanged,
onSubmitted, placeholder, helperText, size=md, disabled, readOnly,
invalid+invalidText, warn+warnText, obscureText, autofocus, keyboardType,
inputFormatters, maxLength, selectionLabels)`.

`CarbonTextArea` — same minus size/obscure/onSubmitted; `minLines=4`,
`maxLines` (null = grows), min-height 40.

State precedence: `readOnly > disabled > invalid > warn`. Focus outline wins
over the invalid outline while focused; icon and status text stay visible.

Spec values (Carbon v11.96 SCSS):

| Role | Value / token |
| --- | --- |
| Field bg / hover / read-only | `layer.field01` / `layer.fieldHover01` / transparent |
| Bottom border (only border) | 1px `borderStrong01`; read-only `borderSubtle01`; disabled transparent |
| Focus / invalid outline | 2px inset, `layer.focus` / `layer.supportError` (foregroundDecoration) |
| Validation icons | `warningFilled`@16 `supportError`; `warningAltFilled`@16 `layer.supportWarning`; right inset 16, reserve 40px |
| Label / helper / error text | label01 12px `textSecondary` (8px gap) / helperText01 `textHelper` (4px gap) / `textError` |
| Input text / placeholder | bodyCompact01 `textPrimary` / `textPlaceholder`; TextArea uses body01 (lh 20), padding 16/11, icon top-anchored |
| Transition | 70ms `CarbonMotion.fast01`, standardProductive |

No new component-theme class — core semantic tokens only.

## Migrations (smallest-risk first; analyze green between each)

| # | File | Change | Risk notes |
| --- | --- | --- | --- |
| 1 | carbon_multi_select.dart | Filter TextField → `CarbonEditableCore`; delete `Material(transparency)` wrapper; material → widgets | Core-inside-OverlayEntry acceptance test |
| 2 | carbon_number_input.dart | TextField → core (same formatters/keyboardType); **fix**: focus listener so the 1→2px border repaints; material → widgets | — |
| 3 | carbon_combo_box.dart | TextField → core in existing field chrome; `onTap` opens menu | Shared `_focusNode.onKeyEvent` (arrows/enter/esc) must keep precedence — core must not overwrite the node's handler |
| 4 | carbon_modal.dart | TextField → `CarbonTextInput` / `CarbonTextArea` (maxLines>1); file keeps material (wave 3) | `maxLength` loses Material's counter UI — CHANGELOG note |
| 5 | carbon_toolbar.dart | Search TextField → core + explicit chrome; `CarbonPressable` clear button; replace 2 `TextButton`s; **fix**: controller listener so clear button appears while typing; material → widgets | Focus border stays 1px (current visual; spec 2px flagged as follow-up). Collapse-when-empty choreography regression-checked |

## Exports

`lib/flutter_carbon.dart`: `carbon_text_input.dart` (widgets block) and
`src/text/carbon_text_selection_labels.dart`.

## Tests

- `test/widgets/carbon_text_input_test.dart` — render/label/placeholder/
  helper; hideLabel semantics; enterText→onChanged; controller round-trip;
  onSubmitted; focus outline; invalid/warn/precedence; disabled/readOnly;
  sizes 24/32/40/48; maxLength; obscure; **pure CarbonApp selection smoke**
  (long-press → word selected + Carbon toolbar); 4-theme sweep.
- `test/widgets/carbon_text_area_test.dart` — grows with content, maxLines
  cap, min-height, top-right icon, state parity, CarbonApp.
- Updates: modal (`find.byType(TextField)` → `CarbonTextInput`),
  number_input enterText target, multi_select (`find.byType(EditableText)`).
  New regressions: number-input focus border repaint; toolbar clear button.
- Guard: extend `test/theme/no_material_import_test.dart` to `lib/src/text/`.

## Verification

- `flutter analyze` — zero issues; full `flutter test` green.
- Material imports in `lib/src/widgets/` == 5.
- Example smoke: text input demo page (all states + selection toolbar via
  long-press / right-click), combo box typing/filtering, toolbar search
  expand/type/clear, input modal, multi-select filter.

## Deferred to wave 3

ui_shell (Scaffold), modal remainder (Scaffold/buttons), floating_menu (FAB),
combo_button (PopupMenu API redesign), code_snippet (SelectableText).
