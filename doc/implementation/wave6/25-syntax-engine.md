# Step 25 — Syntax engine extraction (+ interpolation machinery)

## Goal

Extract v1's Dart tokenizer into a configurable, package-private regex
engine so each language is a small declarative config, and build the
string-interpolation island machinery into it. `CarbonDartHighlighter`
becomes a thin wrapper (public API unchanged) and gains Flutter-aware
classification.

## Design

**New `lib/src/widgets/carbon_syntax_engine.dart` — NOT exported**
(package-privacy by non-export, so the languages file can import it):

```dart
enum CarbonSyntaxInterpolation {
  none,
  dollar,        // $name and ${expr} — Dart, Bash "…", PHP "…"
  dollarBraces,  // ${expr} only — JS/TS template literals
  braces,        // {expr}, not {{ — C# $"…", Python f-strings
}

class CarbonSyntaxStringForm {
  const CarbonSyntaxStringForm(String pattern, {
    CarbonSyntaxKind kind = CarbonSyntaxKind.string, // or character/propertyName
    CarbonSyntaxInterpolation interpolation = none,
  });
}

class CarbonSyntaxRule {                    // Rust macros/lifetimes, PHP tags…
  const CarbonSyntaxRule(String pattern, CarbonSyntaxKind kind);
}

class CarbonSyntaxLanguage {
  const CarbonSyntaxLanguage({
    required String id,
    String? docCommentPattern,              // r'///[^\n]*' / r'/\*\*[\s\S]*?\*/'
    List<String> lineCommentMarkers = const [],
    bool hasBlockComments = false,
    List<CarbonSyntaxStringForm> stringForms = const [],  // ORDER MATTERS
    String? attributePattern,               // → attributeName
    String? directivePattern,               // → macroName (preprocessor)
    String? variablePattern,                // → variableName
    List<CarbonSyntaxRule> extraRules = const [],
    String numberPattern = dartNumberPattern,   // v1's exact pattern
    String identifierPattern = r'[A-Za-z_$][A-Za-z0-9_$]*',
    Map<String, CarbonSyntaxKind> words = const {},
    bool uppercaseTypeHeuristic = false,
  });
}

class CarbonRegexHighlighter extends CarbonSyntaxHighlighter {
  CarbonRegexHighlighter(CarbonSyntaxLanguage config);
  // late final _CompiledLanguage — compiled once per instance; public
  // wrappers hold one `static final` engine each = the per-language cache.
}

Map<String, CarbonSyntaxKind> carbonSyntaxWords({
  control, definition, module, operators, other,
  types, atoms, booleans, nulls, selves,
});
```

- One alternation `RegExp` per language, named groups in semantic order
  (documented in a code comment):
  `doc → attr → line → block → s0…sN → dir → vr → x0…xN → num → id`.
  `attr` precedes `line` so PHP `#[Attr]` beats its `#` comments; doc
  precedes line/block so `///` and `/** */` win; extraRules precede
  num/id so Rust `vec!` beats the identifier `vec`. String forms match
  in config order (raw/verbatim/triple before plain).
- Debug assert rejects capturing groups in config patterns (only
  `(?:…)` allowed) — they would shift named-group semantics.
- Unterminated-construct fallbacks: block comments and multi-line
  string forms get an `|…[\s\S]*$` alternative so an unterminated
  `/*` or template literal colors to EOF instead of leaking keywords.
  No nested unbounded quantifiers anywhere (Dart RegExp has no atomic
  groups; use lazy `[\s\S]*?` + anchored terminators and negated
  character classes).
- `id` classification: `words` map lookup (replaces v1's five keyword
  sets — composed via `carbonSyntaxWords` so category intent stays
  visible) → uppercase heuristic (`typeName`) → null (base color).
  `true/false → boolean`, `null → nullLiteral`, `this/super → self`
  are just map entries now.
- **Interpolation islands**: a post-pass in `highlight()` on string
  matches whose form has `interpolation != none` — a cached per-enum
  island regex splits the string span into a FLAT
  `string / escape / string / …` sequence. `carbonSyntaxTextSpans`
  never sees nesting; sorted/non-overlapping holds by construction.
  Island patterns:
  - `dollar`: `(?<!\\)\$\{[^}]*\}|(?<!\\)\$[A-Za-z_][A-Za-z0-9_]*`
  - `dollarBraces`: `(?<!\\)\$\{[^}]*\}`
  - `braces`: `\{(?!\{)[^{}\n]*\}`
  Known limits (documented): nested braces end at the first `}`;
  `\\$x` missed; PHP `{$var}` unmatched. Escape sequences (`\n`,
  `\x41`) are DEFERRED — door open via a future per-form
  `escapePattern` OR-ed into the island regex.

## Dart migration (Flutter-aware)

`CarbonDartHighlighter` moves to `carbon_syntax_languages.dart`
(created this step with only Dart in it) as a `const` thin wrapper over
a `static final CarbonRegexHighlighter`; `carbon_syntax.dart` shrinks
to the core (Kind / Span / Highlighter / `carbonSyntaxTextSpans`).

Flutter is the dominant Dart the snippet renders, so the Dart config
additionally classifies:

- **Named-argument labels → propertyName**: extra rule
  `(?<=[(,{]\s*)[a-z_]\w*(?=\s*:)` (after `(`/`,`/`{`, before `:`) —
  colors `child:`, `padding:`, `onPressed:` and map keys; deliberately
  misses ternary `a ? b : c` and case labels by construction
  (best-effort, documented).
- **Keyword table audit** vs v1: required, late, covariant, sealed,
  base, interface (class modifiers), mixin, on, extension, typedef,
  part, show, hide, deferred, external, factory, operator, get, set,
  async, await, sync, yield, when, is, as — anything missing from
  v1's sets is added. Additions only; v1 classifications and the
  number pattern stay byte-exact.
- Widget class names already color via the uppercase heuristic;
  `@override` via the annotation rule; `$name`/`${expr}` interpolation
  islands now emit `escape` (raw strings excluded).

**Hard gate: `test/widgets/carbon_syntax_test.dart` must stay green
before any other language is added** (verified at design time: all v1
assertions survive, including with interpolation enabled).

## Tests

- v1 suite green (the gate).
- Engine-level: unterminated `/*` and template literal color to EOF
  without crashing; empty `/**/` classifies blockComment (not doc);
  capturing-group assert fires in debug; interpolation output sorted /
  non-overlapping / in-bounds.
- Dart/Flutter fixture: a realistic `build()` method (StatelessWidget,
  const constructors, `@override`, named args, interpolation) —
  asserts named-arg `propertyName` spans, `$name`/`${a.b}` → escape
  islands with string pieces around them, raw `r'$x'` NOT split, and
  that a ternary `:` is not classified.

## Example

None this step (gallery lands in step 29).
