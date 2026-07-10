# Wave 7 — Carbon scrollbar foundation

Carbon web relies on native browser scrollbars: every `overflow: auto`
surface gets a position indicator for free. Flutter draws none by
default, so every scrollable Carbon widget in this library silently hid
its extent — you couldn't tell how long the content was or where you
were. This wave ships a shared `CarbonScrollbar` base primitive (the
`CarbonPressable` convention: internal, not exported) and adopts it
across the library's scrollables.

Maintainer decisions baked in:

- **All library scrollables adopt it**, including `CarbonTextArea`
  (multiline editable). Only tabs are skipped — the Carbon spec scrolls
  tab bars with chevron buttons, not a scrollbar (deviation note; spec
  scroll buttons are a future item).
- **Thumb always visible while the content overflows**, hidden entirely
  when it fits — visibility answers "how long / where am I" before any
  scrolling happens.
- **No new theme token** — Carbon v11 has no scrollbar token (web is
  native); the thumb reuses `$border-strong-01`.

## Execution order & status

| Step | Doc | Status |
| --- | --- | --- |
| 30 | [CarbonScrollbar primitive](30-scrollbar.md) | ✅ |
| 31 | [Adoption across the library](31-adoption.md) | ✅ |
| 32 | [CarbonTextArea + release sweep](32-text-area.md) | ✅ |

`flutter analyze` and both test suites stay green between steps.

## Global verification (after step 32)

- `flutter analyze` — zero issues (root and `example/`).
- `flutter test` — full suite green; `example/` smoke suite green.
- `dart pub publish --dry-run` passes.
- Manual smoke: dropdown/select long menus, data table horizontal thumb
  drag, tearsheet long content, code snippet collapsed multi + long
  lines, text area overflow — light + dark themes; desktop shows exactly
  ONE scrollbar per axis (the framework's default desktop scrollbar is
  suppressed).

## Deliberate deviations

- **Tabs keep no scrollbar** — the spec mechanism is chevron scroll
  buttons; a bar under the tab bar is off-spec. (The buttons shipped
  right after this wave — see `../wave8/`.)
- **No scrollbar theme token** — reuses `border-strong-01`; the native
  hover-darkening nicety is skipped.
- **Code snippet with line numbers**: the horizontal track ends
  `gutterWidth` short of the trailing edge (the scrollbar painter derives
  track length from viewport − padding); position/drag math stays
  self-consistent.
- Consumer-provided content (modal/side panel/tearsheet `builder`
  children) keeps whatever scrollbars the app's own ScrollBehavior
  provides — the primitive is internal and only wraps library-owned
  scrollables.
