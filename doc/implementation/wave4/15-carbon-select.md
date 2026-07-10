# Step 15 — CarbonSelect (+ CarbonMenuPanel selection support)

## Goal

Native Carbon Select (v11.96 `packages/styles/scss/components/select`) as a
**separate widget** from `CarbonDropdown` (maintainer decision): native-select
form semantics — invalid/warn/readOnly, xs–lg sizes — over the shared menu
machinery.

## CarbonMenuPanel additive params (the one shared-file edit)

`lib/src/widgets/carbon_menu.dart` (panel is internal; all defaults preserve
current behavior — combo button unaffected):

1. `T? selectedValue` — the matching item renders dropdown-style:
   `$layer-selected` bg (`$layer-selected-hover` when highlighted),
   `$text-primary`, trailing 16px checkmark.
2. Initial keyboard highlight lands on the selected item (ArrowDown continues
   from the selection, not the top).
3. `double? maxHeight` — constrains + scrolls the panel (previously an
   unscrollable Column).

## Spec digest (field)

- Like a text input: bg `$field` (hover `$field-hover`), 1px bottom border
  `$border-strong`, `body-compact-01`, heights xs 24 / sm 32 / md 40 / lg 48.
- Padding-inline: start 16, end 48 (chevron at inset-end 16, pointer-events
  none); invalid/warn: end 64 with status icon at inset-end 40
  (`warningFilled` `$support-error` / `warningAltFilled` `$support-warning`).
- Focus: 2px `$focus` outline, 70ms (only the outline transitions).
- Disabled: transparent border, `$text-disabled`, not focusable.
- ReadOnly: transparent bg, `$border-subtle` bottom, `$icon-disabled`
  chevron, focusable but the menu does not open.
- Label/helper/status: shared form styles (label-01 / helper-text-01,
  precedence readOnly > disabled > invalid > warn).

## API

```dart
enum CarbonSelectSize { xs(24), sm(32), md(40), lg(48) }

class CarbonSelectItem<T> {
  const CarbonSelectItem({required this.value, required this.label,
    this.disabled = false});
}

CarbonSelect<T>({
  required String labelText,
  bool hideLabel = false,
  required List<CarbonSelectItem<T>> items,
  required T? value,
  ValueChanged<T?>? onChanged,
  String? placeholder,               // shown while value == null
  String? helperText,
  bool invalid = false, String? invalidText,
  bool warn = false, String? warnText,
  bool disabled = false,
  bool readOnly = false,
  CarbonSelectSize size = md,
  double? width,
  double menuMaxHeight = 300,
})
```

Deferred (documented in the widget doc comment): `SelectItemGroup`
(non-selectable headers), the `inline` variant, typeahead.

## Implementation notes

- Field chrome replicates the `_FieldChrome`/`_FieldColumn` pattern from
  `carbon_text_input.dart` as a private copy (that one assumes an editable
  child; extraction to a shared internal is a follow-up).
- Trigger = own `FocusNode` + `Focus(onKeyEvent)` + `MouseRegion` +
  `GestureDetector` (not `CarbonPressable` — Arrow keys must open the menu).
  Enter/Space/ArrowDown/ArrowUp open. `Semantics(button, label, value)`.
- Menu = the dropdown overlay skeleton: `CarbonAnchoredOverlay(
  matchAnchorWidth: true, spacing: 1, bottomStart)` → `CarbonOverlaySurface`
  → `CarbonMenuPanel<T>(selectedValue, maxHeight, size)`. The panel owns
  focus capture/restore and keyboard. Reentry guards; `dispose` removes the
  entry directly (no setState).
- The popup is a Carbon menu with dropdown-style selected rendering —
  native `<select>` has no styled popup, so this is the documented
  interpretation.

## Tests

`test/widgets/carbon_select_test.dart`: open/select/close; selected checkmark
+ bg; open highlights selection, arrows/Enter; Escape restores field focus;
Enter/Space/ArrowDown on the closed field opens; readOnly focusable-but-inert
with readonly visuals; disabled; invalid icon at end-40 + `invalidText` in
`$text-error`; invalid wins over warn; dispose-while-open is clean.
`carbon_menu_test.dart` gets a group for the new params (defaults unchanged).

## Example

Rewrite `select_demo_page.dart`: default, sizes, invalid/warn,
readOnly/disabled, placeholder.
