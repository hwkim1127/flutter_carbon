# Step 32 — CarbonTextArea scrollbar + release sweep

## Goal

Multiline text areas indicate their overflow like a native `<textarea>`,
and the wave's bookkeeping lands.

## CarbonTextArea

`CarbonEditableCore` already forwards `scrollController` to
`EditableText`. Changes:

- `_CarbonTextAreaState` owns a `ScrollController`, passes it through
  the core, and wraps the editable area in a vertical `CarbonScrollbar`
  (`controller:` form).
- The wrap must sit INSIDE the field chrome (border/background) so the
  thumb hugs the field's content box.

Tests (`test/widgets/carbon_text_input_test.dart` additions):

- Content within `maxLines` → no thumb; more lines than fit → thumb.
- Selection still works: tap positions the caret, long-press selects.
- Thumb drag scrolls the editable (offset changes).

## Release sweep

- Example: no new pages — existing demos already overflow (dropdown long
  list, data table `minWidth`, snippet demos, tearsheet, text area demo).
  Smoke suite re-run covers them.
- CHANGELOG (2.0.0, New Features): Carbon-styled scrollbars — always
  visible while content overflows — across menus (dropdown, select,
  multi-select, combo box), data table horizontal scrolling, tearsheet
  content, tree view, UI shell side nav, multiline text areas, and the
  code snippet; replaces the reliance on native browser scrollbars that
  Flutter doesn't have. Deviations: tabs skipped, no new theme token.
- Wave README status table → ✅.
- Full battery: root+example analyzers, full test suites,
  `dart pub publish --dry-run`.
