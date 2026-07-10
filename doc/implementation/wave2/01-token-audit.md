# 01 — Token Audit vs Carbon v11.96

## Goal

Compare every color token value in `lib/src/theme/themes/{white,g10,g90,g100}/`
against the Carbon v11.96 source of truth in `carbon/`, and fix confirmed
drift. One-time audit — a repeatable codegen pipeline is deferred (TODO in
`../V2_ROADMAP.md`).

## Sources of truth (all TypeScript, no JSON)

| What | Path |
| --- | --- |
| Palette | `carbon/packages/colors/src/colors.ts` — `export const gray100 = '#161616'` style |
| Theme tokens | `carbon/packages/themes/src/{white,g10,g90,g100}.ts` — flat `tokenName = colorBinding` (camelCase names, e.g. `borderSubtle00 = gray20`); some use `adjustAlpha(color, a)` |
| Component tokens | `carbon/packages/themes/src/component-tokens/{button,notification,tag,status,content-switcher}/tokens.ts` — objects keyed per theme: `buttonSecondary = { whiteTheme:'#393939', g10:'#393939', g90:'#6f6f6f', g100:'#6f6f6f' }` |
| Type styles | `carbon/packages/type/src/styles.ts` (v11 names are aliases at the bottom: `bodyCompact01 = bodyShort01`) — spot-check only |
| Motion | `carbon/packages/motion/src/index.ts` — already verified correct this session |

## Method

Two throwaway scripts in the session scratchpad (never committed):

1. **`extract_carbon_tokens.js`** (node):
   - Regex-parse `colors.ts` into `{identifier: hex}` (handle `white`/`black`/hover variants).
   - Parse each theme TS file: `const <name> = <binding>;` where binding is a color
     identifier, a literal `'#hex'`/`rgba(...)`, or `adjustAlpha(color, a)`
     (resolve to `#AARRGGBB`).
   - Parse the 5 component-token files (per-theme object maps).
   - Emit `carbon_tokens.json`: `{ white: {token: value}, g10: {...}, g90: {...}, g100: {...} }`.
2. **`compare_tokens.js`** (node):
   - Regex-extract `fieldName: Color(0x...)` (and `Color.fromRGBO`/`withValues`
     if present) from `lib/src/theme/themes/**/*.dart`, tagged by theme folder.
   - Leaf field names in flutter_carbon match Carbon camelCase token names
     (`textPrimary`, `borderSubtle01`, `buttonPrimaryHover`, `supportError`, …).
   - Join and print three lists per theme: **mismatches** (name matched, value
     differs), **dart-only names** (no Carbon counterpart — expect some, e.g.
     widget-specific additions), **carbon-only names** (tokens we don't model).

## Where fixes land

- Confirmed value drift → edit the `Color(0x...)` literal in
  `lib/src/theme/themes/<theme>/…` (value-only edits, no structural changes).
- Judgment calls (e.g. our token intentionally deviates): document the decision
  in this file under "Findings" rather than silently changing.
- Any test expectations asserting old hex values (search `test/` for the old
  literal) get updated in the same commit.

## Acceptance criteria

- Comparison report reviewed; every mismatch either fixed or documented below.
- `flutter test` passes immediately after the fixes (isolates token fallout
  from the later architecture change).
- Findings summary added below + CHANGELOG "Fixed" note listing corrected
  tokens.

## Findings

Audited against Carbon v11.96 (`@carbon/themes` 11.x TS sources). Palette
(`CarbonPalette`, 248 entries): **zero mismatches**. Theme tokens: ~180
name-matched tokens per theme; the following genuine drift was found and
fixed:

| Area | Fix |
| --- | --- |
| Content switcher (white) | 2025 redesign adopted: container `gray-20`, selected `white`, hover `gray-20-hover` (was inverted: white container / gray-20 selected). g10/g90/g100 already matched. |
| `toggle-off` (all 4 themes) | white/g10: gray-30 → **gray-50**; g90: gray-70 → **gray-50**; g100: gray-70 → **gray-60** |
| Toggle disabled text (all 4) | solid approximations → spec `$text-disabled` (25% text-primary): `0x40161616` light themes, `0x40F4F4F4` dark themes |
| Status (g90) | red40→**red50**, purple40→**purple50**, blue40→**blue50**, gray30→**gray50** (g90 uses 50-level, g100 40-level — previously copied) |
| Notification backgrounds (g90) | colored dark backgrounds (red90/green90/blue90/yellow90) → **gray-80** for all four kinds (dark themes use neutral layer + colored border/icon) |

**Documented false positives (not drift):** component-scoped `background`
fields in code_snippet/popover/page_header/side_panel/structured_list/tree_view
theme files collide with the global `background` token name; they are
intentionally set to the theme's `layer-01` (component surfaces sit on
`$layer`) and verified correct for all 4 themes.

**Unresolvable by script (skipped, not audited):** `rgba()`-based and
gradient/shadow tokens (`aiAura*`, `shadow`, `overlay`, `colorScheme`).

Verification: `flutter analyze` clean; all 394 tests pass post-fix.
