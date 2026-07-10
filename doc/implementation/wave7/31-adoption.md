# Step 31 — Adoption across the library

## Goal

Every library-owned scrollable indicates its extent. Tabs deliberately
skipped (spec = chevron scroll buttons; deviation note).

## Adopters

| Adopter | Controller | Edit |
| --- | --- | --- |
| CarbonMenu (menu panel) | existing `_scrollController` | wrap only the `maxHeight != null` branch; `_revealHighlight` keeps working (same controller) |
| CarbonDropdown | NEW state field (persists across OverlayEntry rebuilds), disposed | wrap the menu ListView (keep `shrinkWrap` — bounded by the 300 maxHeight container) |
| CarbonMultiSelect | NEW state field | `Flexible > CarbonScrollbar > ListView.builder(controller)` |
| CarbonComboBox | existing `_scrollController` | wrap ONLY the non-empty ListView branch |
| CarbonDataTable | NEW single `_horizontalScrollController` | `axis: horizontal`; the two scroll sites are the real table vs the skeleton variant — mutually exclusive on `widget.skeleton`, one shared controller. Header+body live in ONE horizontally-scrolled SizedBox, so no linked controllers. |
| CarbonTearsheet | stateless → builder form owns them | content (no-influencer) and content (with-influencer) are mutually exclusive; the influencer panel coexists — three independent wraps |
| CarbonTreeView | NEW state field | wrap the shrinkWrap ListView — unbounded parent ⇒ no overflow ⇒ hidden; bounded ⇒ thumb; no special casing |
| CarbonUIShell side nav | stateless `_SideNav` → builder form | `Expanded > CarbonScrollbar > ListView.builder(controller)` |

## Code snippet (nested 2D)

Unified on the primitive's notification gating — the analytic row math
keeps only its viewport-height job. `_buildMultiContent` restructure:

```
outer Stack [
  Padding(16) > SizedBox(w) > AnimatedContainer(h: viewportHeight) >
    CarbonScrollbar(vertical, controller: _verticalScroll,
      CarbonScrollbar(horizontal, controller: _horizontalScroll,   // only when !wrapText
          notificationPredicate: (n) => n.metrics.axis == horizontal,
          // depth 1 — the notifications cross the vertical Scrollable
          padding: EdgeInsetsDirectional.only(start: gutterWidth),
        ClipRect > inner Stack [
          vertical SCSV(controller) > _withGutter > horizontal SCSV(controller) > editable,
          right _EdgeFade, bottom _EdgeFade,
          // fades moved INSIDE — RawScrollbar paints via foregroundPainter
          // above its child subtree, so the thumbs sit above the fades
        ])),
  copy button, expand button,   // unchanged, outer stack
]
```

- Single variant: `_horizontalScroll` wired into its scroll view; its
  Stack (scroll + end fade) wrapped in a horizontal `CarbonScrollbar` —
  fade below the thumb.
- wrapText: no horizontal wrapper (no horizontal scrollable exists).
- Cosmetic limit (documented): with line numbers, the horizontal track
  ends `gutterWidth` short of the trailing edge.

## Tests

Per-adopter presence tests in the existing widget test files: overflow →
`RawScrollbar` thumb painted; few items → not painted. Snippet-specific:
vertical thumb in a collapsed 20-row multi; horizontal thumb on long
no-wrap lines; none when content fits or `wrapText`; horizontal thumb
inset ≥ gutterWidth with line numbers; thumb paints full-opacity
`borderStrong01` (not washed out by fades).
