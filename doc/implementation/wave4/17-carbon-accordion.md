# Step 17 — CarbonAccordion

## Goal

Native Carbon Accordion (v11.96 `packages/styles/scss/components/accordion`)
replacing the `ExpansionTile` demo.

## Spec digest

- Heading min-heights: sm 32 / md 40 / lg 48 (default md); title `body-01`
  padding-inline-start 16; heading padding-inline-end 16; hover
  `$layer-hover`; focus 2px `$focus` inset ring; disabled
  `$text-disabled`/`$icon-disabled`.
- 1px `$border-subtle` above each item + below the last. `isFlush` insets
  the borders 16px each side (align end only).
- Chevron 16px `$icon-primary` at the end (default `align: end`; `start`
  puts it before the title); rotates 180° over 110ms.
- Open/close: 110ms height+opacity, entrance-productive.
- Content padding: start 16, top 8, bottom 24; end is responsive —
  25% of width at ≥640px, 48 at ≥480px, else 16.

## API (config objects — repo convention)

```dart
enum CarbonAccordionAlign { start, end }
enum CarbonAccordionSize { sm(32), md(40), lg(48) }

class CarbonAccordionItem {
  const CarbonAccordionItem({
    this.key,                       // preserves state across list mutations
    required this.title, required this.child,
    this.open,                      // non-null ⇒ controlled
    this.initiallyOpen = false,
    this.disabled = false,
    this.onHeadingClick,            // ValueChanged<bool> — the target isOpen
  });
}

CarbonAccordion({
  required List<CarbonAccordionItem> items,
  CarbonAccordionAlign align = end,
  CarbonAccordionSize size = md,
  bool isFlush = false,             // assert(!isFlush || align == end)
  bool disabled = false,            // disables every item
})
```

## Implementation notes

- Stateless `Column` of private `_AccordionTile`s
  (`key: item.key ?? ValueKey(index)`) with `CarbonDivider` framing; flush
  pads the dividers 16px horizontally.
- `_AccordionTile`: `AnimationController(110ms)` **seeded 1.0 when initially
  open** — no first-frame animation; expansion via
  `ClipRect(Align(heightFactor)) + FadeTransition`; content built only while
  `value > 0`; `ExcludeFocus` while closed so collapsed panels are not
  tab-reachable.
- Controlled mode: heading tap only fires `onHeadingClick(target)`; the
  parent rebuilds with the new `open`, `didUpdateWidget` drives the
  animation. Uncontrolled toggles internal state (and still fires the
  callback).
- Heading = `CarbonPressable(focusable)` (Enter/Space activation for free)
  with always-present 2px focus border and `Semantics(expanded)`.
- Items without explicit keys reset uncontrolled open state when the list
  is reordered (documented on `CarbonAccordionItem.key`).

## Tests

`test/widgets/carbon_accordion_test.dart`: render; closed content absent;
tap opens; mid-animation frame has intermediate height; `initiallyOpen`
instant with no pending timers; controlled fires `onHeadingClick` without
opening until the parent rebuilds; disabled inert; Enter/Space toggle;
align-start ordering; divider count = items + 1.

## Example

Rewrite `accordion_demo_page.dart`: basic, sizes, align start, flush,
disabled items, controlled single-open.
