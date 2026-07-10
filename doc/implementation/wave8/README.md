# Wave 8 — Tabs overflow scroll buttons

Wave 7 gave every library scrollable a visible indicator — except tabs,
whose spec mechanism is different: an overflowing tab bar gets **chevron
scroll buttons** at its edges, not a scrollbar. This wave closes that
last overflow blind spot; `CarbonTabs` previously supported drag/swipe
scrolling with no visual affordance at all.

## Execution order & status

| Step | Doc | Status |
| --- | --- | --- |
| 33 | [Tabs overflow nav buttons](33-tabs-overflow-buttons.md) | ✅ |

## Global verification

- `flutter analyze` — zero issues (root and `example/`).
- `flutter test` — full suite green; `example/` smoke suite green.
- Manual smoke: a tab bar with many tabs in a narrow window — buttons
  appear/hide with scroll position, click steps ~1.5 tabs, press-and-hold
  scrolls continuously; line variant shows the 8px edge fade; contained
  variant shows `$layer-accent` buttons with hover/active.

## Deliberate deviations

- Click-step scrolling animates (150ms productive motion); React jumps
  the scroll position and lets CSS smooth it.
- Buttons hide entirely at the ends (spec `display: none`), so the tab
  list width changes by 40/48px when a button appears — same as web.
