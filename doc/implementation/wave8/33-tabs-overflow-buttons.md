# Step 33 — CarbonTabs overflow nav buttons

## Goal

Carbon's spec affordance for an overflowing tab bar: chevron scroll
buttons flanking the tab list, appearing exactly while scrolling in that
direction is possible.

## Spec digest (React `Tabs.tsx` + `_tabs.scss`)

- Buttons are flex SIBLINGS of the tab list (`flex-shrink: 0`), not
  overlays: previous at inline-start, next at inline-end.
- Line variant: width `$spacing-08` (40px), background `$background`,
  no hover/active states. Contained variant: width `$spacing-09` (48px),
  background `$layer-accent`, hover `$layer-accent-hover`, active
  `$layer-accent-active`.
- Icon: `chevron--left` / `chevron--right`, 16px, `$icon-primary`.
- Visibility (hidden, not disabled): previous iff `scrollLeft > 0`; next
  iff `scrollLeft + clientWidth < scrollWidth` (±1px tolerance).
- Click: scroll by `(scrollWidth / tabCount) × 1.5` (≈1.5 average tab
  widths), clamped to the range.
- Press-and-hold: continuous scrolling at 5px per animation frame until
  release.
- An 8px gradient strip (`transparent → $background`) sits at each
  button's inner edge over the list — line variant only.
- a11y: the buttons are `aria-hidden` with `tabIndex={-1}` — keyboard
  users traverse tabs with arrow keys, so the buttons are pointer-only.

## Implementation notes (`lib/src/widgets/carbon_tabs.dart`)

- State: `_canScrollPrev` / `_canScrollNext`, updated from
  `NotificationListener<ScrollNotification>` +
  `NotificationListener<ScrollMetricsNotification>` around the existing
  horizontal scroll view (`_scrollController` already exists) — setState
  only when a flag flips. Metrics notifications cover content/viewport
  changes; scroll notifications cover position changes.
- Layout: the plain scroll view stays THE default. Only while either
  flag is true does the bar become
  `Row(crossAxisAlignment: stretch, [prevButton?, Expanded(Stack[scroll
  view, fade strips]), nextButton?])` — flags can only be true when the
  width is bounded, so the `Expanded` never meets unbounded constraints.
- `_OverflowNavButton`: `GestureDetector` + `MouseRegion` (pointer-only,
  wrapped in `ExcludeSemantics` per aria-hidden; no focus node). onTap →
  `animateTo(offset ± avgTab × 1.5, 150ms, standard-productive)`; long
  press start/end → `Timer.periodic` stepping `jumpTo(±5px)` per ~16ms,
  cancelled on release/cancel and in dispose.
- Fade strips: 8px `PositionedDirectional` gradients over the list's
  inner edges (line variant only), `IgnorePointer`.
- Backward button icon points toward the reading start: `chevronLeft`
  in LTR, `chevronRight` in RTL (row order flips automatically).

## Tests

- Tabs fit → no buttons.
- Overflowing at offset 0 → next visible, previous hidden.
- Tap next → offset grows ~1.5 average tab widths; at the end → next
  hidden, previous visible.
- Contained variant button uses `layerAccent01`.
- Buttons are semantics-excluded and not focus-traversable.
- Long-press scrolls continuously until release.
