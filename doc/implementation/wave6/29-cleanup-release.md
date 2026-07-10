# Step 29 — Example, docs & release sweep

## Goal

Demo pages on the new APIs, the 13-language gallery, smoke coverage,
and the release bookkeeping for everything wave 6 shipped.

## Example

- `example/lib/pages/code_snippet_demo_page.dart`: migrate to the new
  API; add sections — wrapText, disabled, skeleton, line numbers,
  custom row props (maxCollapsed/minExpanded), custom labels.
- `example/lib/pages/syntax_highlighting_demo_page.dart`: **rewrite as
  the language gallery** — one
  `CarbonCodeSnippet(type: multi, highlighter: carbonHighlighterFor(tag))`
  per language (13 fixtures; the Dart fixture is a realistic Flutter
  `build()` method showcasing named-argument coloring). The token
  swatch reference section stays; the hand-rolled `_Span` machinery is
  deleted.
- `example/lib/pages/copy_button_demo_page.dart`: migrate to the
  reworked icon-only `CarbonCopyButton` (sizes, feedback, disabled).
- Smoke suite: all routes auto-covered; add a **wave-6 interaction
  group** — tap copy → feedback bubble appears (and times out); tap
  Show more → viewport height grows; language gallery renders colored
  spans (assert at least one non-default-colored TextSpan per
  fixture).

## Docs & bookkeeping

- `doc/proposals/syntax-highlighting.md`: mark part A + B-1
  (interpolation) + B-2 (line numbers) shipped; diff highlighting and
  `CarbonCodeEditor` remain proposed.
- `CHANGELOG.md` under `## 2.0.0 (Unreleased)`:
  - Breaking: `CarbonCodeSnippet` API table
    (`showCopyButton` → `hideCopyButton` inverted,
    `feedbackMessage` → `labels.copied`,
    `maxCollapsedLines` → row-count props with the viewport-rows
    semantics change, `useMonospace` removed); `CarbonCopyButton`
    rework (icon-only, drops `label`/`successLabel`/`successDuration`);
    `CarbonCodeSnippetThemeData.border` removed +
    `copyButtonBackgroundActive` added.
  - New: 12 language highlighters + `carbonHighlighterFor`, string
    interpolation islands, `showLineNumbers`, `wrapText`, `disabled`,
    `CarbonCodeSnippetSkeleton`, `copyText`/`onCopy`/`feedbackTimeout`,
    `CarbonCodeSnippetLabels`, spec geometry/typography (code-01,
    fades, spec copy buttons, inline click-to-copy).
- `MIGRATION.md`: Widget API changes entries for both widgets with the
  old→new mapping.
- `README.md`: mention the highlighter language set where syntax
  highlighting is described.
- Wave README status table all ✅.

## Verification

- `flutter analyze` — zero issues (root + example).
- Full `flutter test` + example smoke suite green.
- `dart pub publish --dry-run` clean (modulo git-state warnings).
- Manual smoke: inline click-copy, fades on scroll + focus removal,
  Show more/less animation, wrapText, line numbers incl. wrap mode,
  every gallery language renders sensibly in light + dark themes.
