# Step 14 — CarbonSearch + CarbonToolbarSearch refactor

## Goal

Native Carbon Search (v11.96 `packages/styles/scss/components/search`) on
`CarbonEditableCore`, including the expandable variant; then rebuild
`CarbonToolbarSearch` as a thin wrapper over it, preserving its public API.

## Spec digest

- Sizes xs 24 / sm 32 / md 40 / **lg 48 (toolbar)**, default md.
- Input `body-compact-01`, bg `$field`, 1px bottom border `$border-strong`,
  no horizontal text padding beyond the leading/trailing squares.
- Magnifier 16px `$icon-secondary`, centered in a leading height×height
  square, pointer-events none.
- Clear button: trailing height×height square, `close` 16 `$icon-primary`,
  hover `$field-hover` + its own bottom border, **hidden when empty with
  layout retained** (`visibility: hidden` on web).
- Focus: 2px `$focus` outline. Transitions 110ms. Disabled: transparent
  border, `$text-disabled`.
- Escape: clears when the field has a value; when empty and expandable,
  collapses.
- Expandable: collapsed state is a height×height square button (magnifier
  becomes `$icon-primary`); expands on click/focus with a 70ms width
  animation; collapses on blur/Escape while empty; text keeps it expanded.

## API

```dart
enum CarbonSearchSize { xs(24), sm(32), md(40), lg(48) }

CarbonSearch({
  String labelText = 'Search',      // always visually hidden → Semantics only
  String placeholder = 'Search',
  TextEditingController? controller, // owned internally when null
  FocusNode? focusNode,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  VoidCallback? onClear,
  CarbonSearchSize size = md,
  bool disabled = false,
  bool autofocus = false,
  bool expandable = false,
  bool initiallyExpanded = false,
  ValueChanged<bool>? onExpandedChanged,
  String clearButtonLabel = 'Clear search input',
  CarbonTextSelectionLabels? selectionLabels,
})
```

## Implementation notes

- Chrome: one `AnimatedContainer` (fast02) with always-present 2px `$focus`
  `foregroundDecoration` (transparent when unfocused) — decoration presence
  must never toggle (tree-shape stability, see wave 2 lessons).
- Clear button is **always mounted**: `IgnorePointer(ignoring: empty)` +
  `Opacity(empty ? 0 : 1)` — constant tree shape, no width jump. Tap:
  `controller.clear()` + `onClear` + `onChanged('')` + refocus input.
  A controller listener drives the empty/non-empty repaint.
- Escape via `focusNode.onKeyEvent` (the editable core never overwrites an
  owner-installed handler; the focused node's handler runs before ancestor
  `Shortcuts`, so it beats `DismissIntent` — a modal behind the search does
  not close when Escape clears text). Pre-existing handlers on external
  focus nodes are chained.
- Expandable: width animation (70ms fast01) needs a **bounded** max width
  from the parent; unbounded parents get an instant switch (documented).
  Tab-focusing the collapsed button expands (Focus(onFocusChange) wrapper).

## CarbonToolbarSearch

Becomes a wrapper: `CarbonSearch(size: lg, expandable: !persistent,
initiallyExpanded: persistent)` + the existing controller/value sync +
`Expanded`/`SizedBox(width: 300)` sizing quirk. Behavior deltas:

- 2px focus outline (deviation fixed).
- Clear no longer collapses the field (collapse on blur/Escape while empty).
- Expanded magnifier is `$icon-secondary` per spec.

## Tests

`test/widgets/carbon_search_test.dart`: typing → onChanged; clear hidden when
empty (Opacity 0), tap clears + onClear + refocus; Escape-with-text clears
without dismissing an enclosing modal; Escape-empty collapses; blur-empty
collapses, with-text stays; expand on tap and on focus; disabled; size
heights; 2px focus decoration; pure-`CarbonApp` smoke. Update
`carbon_toolbar_test.dart` (existing tests unchanged; add 2px assertion and
persistent-renders-expanded).

## Example

Rewrite `example/lib/pages/search_demo_page.dart`: sizes, expandable in a
toolbar-like row, disabled, onClear/onSubmitted log.
