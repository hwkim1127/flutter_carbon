# Proposal — Syntax highlighting: more languages & advanced features

Status: **v1 shipped** (2.0.0); this document now proposes **v2**.

## What shipped in v1 (for reference)

- `lib/src/widgets/carbon_syntax.dart`: `CarbonSyntaxKind` (41 values, 1:1
  with the `carbon.syntax` theme tokens, `colorOf(syntax)` resolver),
  `CarbonSyntaxSpan`, the pluggable `CarbonSyntaxHighlighter` interface,
  and `CarbonDartHighlighter` (single-pass regex tokenizer; alternation
  order disambiguates so keywords inside comments/strings are never
  classified).
- `CarbonCodeSnippet.highlighter` (optional; null = single-color as
  before). Multi-line paints via a `TextEditingController.buildTextSpan`
  override — selection/copy/context menu unaffected; spans cached in state,
  recomputed only on text/highlighter change. Single/inline render
  `Text.rich`. Colors resolve at paint time → live theme switching.
- Zero dependencies; adapter pattern documented for third-party grammars.

## v2 part A — more languages via a shared tokenizer engine

The Dart tokenizer's structure (comments → strings → annotations → numbers
→ classified identifiers, leftmost-first alternation) fits the whole
C-family. Don't copy it five times — extract a configurable engine:

```dart
/// Package-private engine; each language is a small configuration.
class CarbonRegexHighlighter extends CarbonSyntaxHighlighter {
  const CarbonRegexHighlighter(this.config);
  final CarbonSyntaxLanguage config;
  // build() compiles one alternation RegExp from the config (cached
  // statically per language), highlight() classifies like v1's Dart impl.
}

class CarbonSyntaxLanguage {
  final List<String> lineCommentMarkers;      // ['//'] or ['#']
  final bool hasBlockComments;                // /* ... */
  final bool hasDocComments;                  // '///' (Dart/Rust)
  final List<StringForm> stringForms;         // quotes, raw prefix, backtick
  final Pattern? attributePattern;            // '@Name', '#[derive]'
  final Map<String, CarbonSyntaxKind> words;  // keyword → kind (flat map)
  final bool uppercaseTypeHeuristic;
  final Pattern? variablePattern;             // '$VAR' (bash), macros 'x!' (rust)
}
```

`CarbonDartHighlighter` becomes a thin wrapper over the engine (public API
unchanged). New public highlighters, each ~a keyword table:

| Class | Notes beyond the shared engine |
| --- | --- |
| `CarbonBashHighlighter` | `#` comments (shebang included); `$VAR`/`${VAR}` → variableName; `-x`/`--flag` → attribute; keywords if/then/else/fi/for/do/done/while/case/esac/function/local/export |
| `CarbonRustHighlighter` | `//`+`///`+`/*`; `#[attr]` → attributeName; `name!` macros → macroName; `'a` lifetimes → labelName; `self`/`Self` → self; primitive types (i8…u128, f32/f64, str, bool) → type; uppercase heuristic for user types |
| `CarbonGoHighlighter` | `//`+`/*`; backtick raw strings; builtin types (int, string, bool, error, float64, byte, rune…) → type; keywords func/var/const/type/struct/interface/map/chan/go/defer/select/package/range |
| `CarbonJsHighlighter` | template literals `` `…` `` as strings (interpolation: see part B); `undefined` → atom; keywords function/const/let/var/class/new/typeof/instanceof/async/await/import/export/default/from/yield. Regex literals: best-effort or skip (ambiguous with division — document) |
| `CarbonTsHighlighter` | JS config + type/interface/enum/namespace/declare/readonly/keyof/infer/satisfies/public/private/protected/abstract; primitives string/number/boolean/any/unknown/never/void → type |
| `CarbonJsonHighlighter` | keys → propertyName, strings, numbers, true/false/null — trivially useful for API docs |

Convenience lookup (optional): `CarbonSyntaxHighlighter? carbonHighlighterFor(String language)`
matching common fence tags ('dart', 'sh'/'bash'/'shell', 'rs'/'rust', 'go',
'js'/'javascript', 'ts'/'typescript', 'json').

Tests: one fixture per language asserting representative spans (comment,
string, keyword class, type, number, language-specific: bash `$VAR`, rust
`#[derive]`/macro, go backtick string, js template literal, ts `interface`).

## v2 part B — the formerly out-of-scope features, prioritized

1. **String interpolation boundaries** (medium value, needs the engine):
   `$name`/`${expr}` in Dart/Bash and `${expr}` in JS/TS render as
   `escape`-colored islands inside the string span. Engine emits nested
   spans; `carbonSyntaxTextSpans` already handles adjacent spans — split
   the string span around interpolations.
2. **Line numbers** (UI, independent of highlighting): optional
   `showLineNumbers` on the multi variant — a non-selectable gutter column
   (textSecondary, right-aligned) beside the editable, sharing line height.
   Must stay outside the selectable text so copy doesn't grab numbers.
3. **Diff highlighting** (needs a token decision): `+`/`-` line prefixes →
   added/removed line backgrounds. `CarbonSyntaxThemeData` has no diff
   tokens — either map to `carbon.notification`/support greens+reds or add
   two tokens (breaking-ish; prefer reusing support tokens).
4. **Editable code editor** (`CarbonCodeEditor`) — the building blocks
   exist (`CarbonEditableCore` + `_HighlightingController` generalized to
   re-highlight on edit, debounced). Substantial new public surface; own
   proposal when wanted.
5. **Not planned**: semantic (resolver-based) highlighting, bracket
   matching, grammar files/TextMate — the zero-dependency regex approach is
   the ceiling; anything beyond belongs in an external adapter package.

## Suggested order

Engine extraction + Bash + JSON (cheapest, high demo value) → JS/TS → Rust
+ Go → interpolation → line numbers. Diff and the editor ride on demand.

## Effort

Engine + six languages + tests: medium (mostly keyword tables). Purely
additive; no breaking changes.
