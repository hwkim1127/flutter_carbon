# Step 24 — CarbonCodeSnippet to spec (+ CarbonCopyButton rework)

## Goal

Bring `CarbonCodeSnippet` fully to the Carbon v11 spec — geometry,
typography, row model, fades, states, skeleton, a11y — and rework
`CarbonCopyButton` into the spec icon-only copy button so both share a
single feedback-tooltip implementation.

## Spec digest (Carbon v11, rem→px@16)

Base (all variants): `code-01` type (IBM Plex Mono 12px, 16px line
height — `CarbonTypography.code01` is exactly 16.0px), bg `$layer`,
max-inline-size 768. Row height = 16px drives all multi row math.

- **inline**: 20px high, code padding 0/8, border-radius **4px** (the
  only radius in Carbon), 1px transparent border → `$focus` on focus.
  The whole chip is the copy trigger: hover `$layer-hover`, active
  `$layer-active`, click copies and shows the feedback tooltip below.
  `hideCopyButton` → plain non-interactive span. No disabled state.
- **single**: 40px high, padding-inline-start 16, content end padding
  32; copy button **md 40×40**; right-edge fade 32px wide, removed
  while focused; horizontal scroll, never wraps; container is a
  focusable read-only textbox with a 2px `$focus` outline.
- **multi**: padding 16 all; content end/bottom padding 24; copy
  button **sm 32×32** absolutely at top-end 8,8; collapsed max-height
  = `maxCollapsedNumberOfRows` × 16 (default 15 → 240), min-height =
  `minCollapsedNumberOfRows` × 16 (default 3 → 48); expanded
  min-height = `minExpandedNumberOfRows` × 16 (default 16 → 256),
  max-height = `maxExpandedNumberOfRows` × 16 (default 0 = unbounded);
  height transition `duration-moderate-01` standard-productive.
  Show more/less: ghost sm (32px) button, `body-compact-01` label +
  16px chevron rotating 0→180°, absolutely at bottom-end, over a
  `$layer` background; appears iff contentRows > maxCollapsedRows AND
  (maxExpandedRows == 0 OR maxExpandedRows > maxCollapsedRows);
  auto-collapses when the content shrinks to ≤ minExpandedRows while
  expanded. Bottom fade 16px + right fade 32px, both removed on
  focus-within. `wrapText` → soft-wrap, no horizontal scroll, no right
  fade. `disabled` → `$text-disabled`/`$icon-disabled`, buttons inert.
- **Copy button** (spec CopyButton): icon-only square sm 32 / md 40 /
  lg 48, copy icon 16px `$icon-primary`, bg `$layer`, hover
  `$layer-hover`, active `$layer-active`, focus 2px `$focus`.
  Feedback: 'Copied!' tooltip, fade in/out `duration-fast-02`
  productive, auto-hide after `feedbackTimeout` (default 2000ms).
- **Skeleton**: single = 56px container, one 16px shimmer bar;
  multi = 98px, three bars (100% / 85% / 95% width), 16px tall,
  8px apart.
- **a11y**: single/multi container = read-only textbox semantics with
  label (default 'code-snippet'); copy trigger = button with 'Copy to
  clipboard'; feedback announced (live region).

## API

```dart
class CarbonCodeSnippetLabels {              // CarbonDatePickerLabels shape
  const CarbonCodeSnippetLabels({
    this.copyToClipboard = 'Copy to clipboard',
    this.copied = 'Copied!',
    this.showMore = 'Show more',
    this.showLess = 'Show less',
    this.codeSnippet = 'code-snippet',
  });
  factory CarbonCodeSnippetLabels.en();
}

const CarbonCodeSnippet({
  required String code,
  CarbonCodeSnippetType type = single,       // inline | single | multi
  bool hideCopyButton = false,               // was showCopyButton (inverted)
  String? copyText,                          // overrides what is copied
  Duration feedbackTimeout = const Duration(milliseconds: 2000),
  VoidCallback? onCopy,
  bool wrapText = false,                     // multi only
  bool disabled = false,                     // single + multi only
  int maxCollapsedNumberOfRows = 15,
  int minCollapsedNumberOfRows = 3,
  int maxExpandedNumberOfRows = 0,           // 0 = unbounded
  int minExpandedNumberOfRows = 16,
  CarbonSyntaxHighlighter? highlighter,
  CarbonCodeSnippetLabels labels = const CarbonCodeSnippetLabels(),
})

class CarbonCodeSnippetSkeleton {
  const CarbonCodeSnippetSkeleton({ CarbonCodeSnippetType type = single });
}

enum CarbonCopyButtonSize { sm(32), md(40), lg(48) }
const CarbonCopyButton({
  required String textToCopy,
  VoidCallback? onCopied,
  CarbonCopyButtonSize size = md,
  String feedback = 'Copied!',
  Duration feedbackTimeout = const Duration(milliseconds: 2000),
  String iconDescription = 'Copy to clipboard',
  bool enabled = true,
})
```

Removed (breaking, 2.0.0 window): `useMonospace` (spec is always
`code-01` mono), `feedbackMessage` (→ `labels.copied`),
`maxCollapsedLines` (→ row props; **semantics change** — rows are 16px
viewport rows clipped by height, not lines removed from the text).
`CarbonCopyButton` drops `label`/`successLabel` visible text and
`successDuration` (→ `feedbackTimeout`).

## Implementation notes

### Shared feedback infrastructure

- `lib/src/base/carbon_tooltip_bubble.dart` (new): extract the private
  bubble + caret painter from `carbon_tooltip.dart` into a
  public-in-src `CarbonTooltipBubble`; `CarbonTooltip` consumes it —
  zero visual change, one bubble implementation.
- `lib/src/base/carbon_copy_feedback.dart` (new):
  `CarbonCopyFeedback{visible, message, alignment, child}` — an
  overlay-based click-triggered bubble (`CarbonAnchoredOverlay` +
  `CarbonOverlaySurface` + `FadeTransition` fast-02, wrapped in
  `Semantics(liveRegion: true)` and `IgnorePointer`). The parent owns
  the show state and a cancellable `Timer` (replaces the current
  uncancellable `Future.delayed`). Overlay — NOT an in-Stack
  `Positioned` — because the multi `ClipRect` and the 40px single row
  would clip it. All overlay lifecycle conventions apply: reentry
  guards, dispose removes the entry directly, `didUpdateWidget`
  changes deferred post-frame.

### Variant structure

- **inline**: `CarbonPressable(focusable: true)` chip, 20px high,
  h-padding 8, `BorderRadius.circular(4)`, rest bg
  `codeSnippet.background`, hover `layerHover01`, active
  `layerActive01`, focus = 1px `layer.focus` border (transparent
  otherwise — always-present border keeps tree shape stable);
  `Semantics(button, label: labels.copyToClipboard)`; feedback bubble
  anchored below. `hideCopyButton` → plain `Container` + `Text`.
- **single**: `Focus` container (textbox `Semantics(readOnly,
  textField, label: labels.codeSnippet)`), 40px high, focus = 2px
  `layer.focus` `foregroundDecoration`; `Row` = `Expanded(Stack[`
  horizontal scroll (start 16 / end 32 padding) + right `_EdgeFade`
  32px when unfocused `])` + `CarbonCopyButton(md)`. The old border
  and copy-button divider are removed (both off-spec).
- **multi — core rewrite**: the controller always holds the FULL code;
  collapse is a clipped, animated viewport height (no more text
  swapping → selection survives expand/collapse, copy naturally gets
  full text, `wrapText` works). Row math is synchronous in `build`:
  `rowHeight = 16 × textScaler`; `contentRows` = line count (or a
  wrap-aware `TextPainter` at the `LayoutBuilder` width when
  `wrapText`); heights per the spec digest above.
  `AnimatedContainer(height, moderate-01, standard-productive)` →
  `ClipRect` → scrollables → `CarbonEditableCore` (the TextPainter
  width measurement and `_HighlightingController` stay verbatim).
  Auto-collapse in `didUpdateWidget` only (mirrors React's effect;
  verify `<=` vs `<` against React `CodeSnippet.tsx` at impl time).
  Stack layers (bottom→top): code area (selectable) → `IgnorePointer`
  fades (right 32px iff `!wrapText && !focusWithin`; bottom 16px iff
  collapsed && canExpand && `!focusWithin`) → `CarbonCopyButton(sm)`
  `PositionedDirectional(top: 8, end: 8)` → Show more/less =
  `ColoredBox(bg)` > `CarbonButton(ghost, sm)` with `AnimatedRotation`
  chevron, `PositionedDirectional` bottom-end. `_focusWithin` via
  `Focus(canRequestFocus: false, onFocusChange)`.
- **`_EdgeFade`**: `IgnorePointer` + `DecoratedBox` with a
  `LinearGradient` (transparent → background) on `AlignmentDirectional`
  axes so RTL mirrors for free.
- **wrapText**: skip the horizontal scroll and width measurement; the
  editable soft-wraps at the `LayoutBuilder` width; no right fade.
- **disabled**: disabled text/icon colors, editable `enabled: false`,
  copy + show-more inert, single's container not focusable.
- **Line-number seam** (step 28): the innermost code child is a `Row`
  whose first slot is reserved for the gutter; the measuring
  `TextPainter` stays accessible to the state.

### Theme tokens

`CarbonCodeSnippetThemeData`: add `copyButtonBackgroundActive`
(`$layer-active` per theme); remove `border` (nothing draws it
post-rewrite). Update `copyWith`/`lerp` and all four theme variant
files (white/g10/g90/g100).

## Tests

Rewrite/extend `test/widgets/carbon_code_snippet_test.dart`:

- Row math: N-line multi viewport = `clamp(N, minC, maxC) × 16`
  collapsed; expanded = `max(N, minE) × 16`; bounded = `maxE × 16`.
- Show-more visibility rules + auto-collapse when `code` shrinks.
- Controller keeps full text while collapsed (height-clipped).
- wrapText: no horizontal scrollable, wrapped height; no-wrap keeps
  the never-soft-wraps pixel assert (adjusted to 16px rows).
- Fades present when unfocused/collapsed; gone on focus.
- Clipboard mock: copy writes `copyText ?? code`; `onCopy` fires;
  feedback bubble shows `labels.copied`, gone after
  `feedbackTimeout` + fade.
- Inline: tap-the-chip copies; 20px height, 4px radius, focus border.
- Geometry: single 40px + copy 40×40; multi copy 32×32 at top-end 8,8.
- Disabled: taps do nothing (clipboard channel untouched), text is
  `textDisabled`.
- Skeleton: 56 / 98 heights, bar count/sizes.
- Semantics: button labels, live-region feedback, textbox container.
- RTL: copy button at physical top-left, fade mirrors.
- CarbonCopyButton: sizes, copy + feedback, `enabled: false`.

## Example

Migrate `code_snippet_demo_page.dart` and `copy_button_demo_page.dart`
to the new APIs (full sweep with new sections lands in step 29).
