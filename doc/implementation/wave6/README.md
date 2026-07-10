# Wave 6 — Code snippet to spec + syntax highlighting v2

`CarbonCodeSnippet` shipped Material-free in 2.0.0 with a Dart-only
highlighter (v1 of `../../proposals/syntax-highlighting.md`), but it
predates the wave-era spec rigor: it deviates from Carbon v11 in
typography (14px vs `code-01` 12/16), copy-button geometry (48px vs
40/32), inline behavior (Carbon's inline snippet IS a click-to-copy
button), and it lacks the show-more row model, overflow fades,
`wrapText`, `disabled`, skeleton, localized labels, and a real feedback
tooltip. This wave brings the widget to spec and ships the syntax
proposal's v2: a shared regex engine, twelve new languages, string
interpolation islands, and a line-numbers gutter.

Everything lands in the still-unreleased 2.0.0, so API breaking changes
are allowed (documented in CHANGELOG + MIGRATION).

Maintainer decisions baked in:

- **Scope**: spec-completeness pass + syntax v2 part A (engine +
  languages) + part B extras (interpolation islands, line numbers).
  Diff highlighting and `CarbonCodeEditor` stay deferred.
- **Languages**: Bash, JSON(C), Python, JS, TS, Rust, Go, C, C++, PHP,
  Java, C# — 12 new; 13 with Dart.
- **Typography**: spec `code-01` (12px / 16px line height) for every
  variant; all row math is rows × 16px.
- **Inline click-to-copy**: the whole inline chip is the copy trigger
  per spec; `hideCopyButton` renders a plain span.
- **API break to spec names** inside the 2.0.0 window
  (`hideCopyButton`, row-count props, labels class; `useMonospace`
  removed).
- **Flutter-aware Dart highlighter**: named-argument labels
  (`child:`, `padding:`) color as `propertyName`; the keyword table is
  audited for modern Dart (`required`, `late`, `sealed`, …).
- The legacy hand-rolled `syntax_highlighting_demo_page` is rewritten
  as the language gallery on the real highlighters.

## Execution order & status

| Step | Doc | Status |
| --- | --- | --- |
| 24 | [CarbonCodeSnippet to spec](24-code-snippet-spec.md) | ✅ |
| 25 | [Syntax engine extraction](25-syntax-engine.md) | ✅ |
| 26 | [Languages batch 1](26-languages-batch-1.md) | ✅ |
| 27 | [Languages batch 2](27-languages-batch-2.md) | ✅ |
| 28 | [Line numbers gutter](28-line-numbers.md) | ✅ |
| 29 | [Cleanup & release](29-cleanup-release.md) | ✅ |

`flutter analyze` and both test suites stay green between steps.

## Global verification (after step 29)

- `flutter analyze` — zero issues (root and `example/`).
- `flutter test` — full suite green; `example/` smoke suite green
  (all demo routes + the new wave-6 interaction group).
- `test/widgets/carbon_syntax_test.dart` (v1 suite) stays green after
  the engine migration — hard gate for step 25.
- Guard test auto-covers the new files (Material-free enforced).
- `dart pub publish --dry-run` passes.
- Example manual smoke: inline click-copy feedback, single/multi
  fades + focus, Show more/less animation, wrapText, line numbers,
  the 13-language gallery.

## Deliberate deviations (spec fidelity notes)

- **`light` variant skipped** — deprecated in Carbon in favor of the
  Layer model.
- **Tooltip `align`/`autoAlign` props skipped** — the feedback bubble
  uses the repo's anchored-overlay flip/clamp delegate instead.
- **CSS `mask-image` fades → foreground gradient overlays**
  (transparent → background). Equivalent over the opaque `$layer`
  background and far cheaper than `ShaderMask`.
- **Feedback tooltip is overlay-based** — Carbon nests it in the DOM;
  in Flutter the multi variant's `ClipRect` (and the 40px single-line
  row) would clip an in-Stack bubble.
- **Row heights scale with the ambient text scaler** — the spec is
  fixed px; accessibility wins.
- **Regex lookbehind** (interpolation islands, Dart named-arg labels) —
  on Flutter web this requires a browser with lookbehind support
  (Safari ≥ 16.4; all evergreen browsers).
- **Highlighter limits** (documented per class): JS/TS regex literals
  skipped (division ambiguity); Rust nested block comments and
  `r##"…"##` (N ≥ 2) unsupported; C++ raw strings delimiter-less form
  only; PHP heredoc and `{$var}` unmatched; C# attribute detection is
  line-anchored; `#include <path>` path stays base-colored; JSX/TSX
  tags not highlighted; escape sequences (`\n`, `\x41`) deferred
  (interpolation islands only).
