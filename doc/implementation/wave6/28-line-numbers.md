# Step 28 — Line numbers gutter

## Goal

Optional `showLineNumbers` on the multi variant: a non-selectable
gutter column beside the code, sharing the 16px row metrics, that copy
and selection can never grab.

## API

```dart
CarbonCodeSnippet({
  // ...
  bool showLineNumbers = false,   // multi only; ignored by inline/single
})
```

## Implementation notes

- The gutter slots into the `Row` first-slot seam reserved in step 24
  (inside the horizontal scroll in no-wrap mode, inside the
  `LayoutBuilder` width in wrap mode).
- Structure: `IgnorePointer` + `ExcludeSemantics` → `Column` of
  right-aligned `Text` rows in `code-01` (color `textSecondary`),
  end-padding 16 before the code. Identical type style + 16px rows ⇒
  baselines align with the editable by construction; no per-row
  positioning.
- Width: digits of the line total × the measured advance of `'9'`
  (one small `TextPainter` layout, cached per digit count / text
  scaler) + padding. 10 → 100 lines widens the gutter by one digit.
- Numbers are OUTSIDE the editable, so selection/copy exclude them by
  construction — no clipboard filtering needed.
- **wrapText mode**: logical lines can span multiple visual rows. Use
  the step-24 measuring `TextPainter`'s `computeLineMetrics()` grouped
  by hard line breaks to get per-logical-line visual row counts; the
  number renders on the first visual row of each logical line with
  blank 16px rows beneath it.
- Gutter scrolls WITH the code vertically (same scroll view child);
  in no-wrap mode it must NOT scroll horizontally away — place it
  outside the horizontal `SingleChildScrollView`, pinned, with the
  code area `Expanded` beside it.

## Tests

- Numbers 1…N rendered; tap/drag selection over the gutter selects no
  text; clipboard copy returns code only (no digits).
- Row alignment: gutter row N's `Text` top == editable line N top
  (16px multiples).
- wrapText: a line wrapping to 3 visual rows shows its number once,
  next number 3 rows later.
- Width grows at the 10th/100th line.
- `showLineNumbers` on inline/single is a no-op (or debug-asserted —
  decide at impl time; prefer silent no-op like React ignoring
  irrelevant props).

## Example

Line-numbers section on the code snippet demo page (step 29).
