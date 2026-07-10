# Step 26 — Languages batch 1: Bash, JSON(C), Python, JS, TS

## Goal

First five language configs on the step-25 engine, exercising every
engine feature that batch 2 relies on: `variablePattern` (Bash),
lookahead string forms (JSON keys), `braces` islands (Python
f-strings), multi-line template literals with `dollarBraces` islands
(JS/TS), and word-map composition/extension (TS extends JS).

All live in `lib/src/widgets/carbon_syntax_languages.dart` (one file of
declarative tables — split only if it exceeds ~1500 lines), exported
from `lib/flutter_carbon.dart`. Each language = one
`CarbonSyntaxLanguage` config + one `const`-constructible public
wrapper class holding a `static final` engine.

## Language configs

### `CarbonBashHighlighter`
- Comments: `#` (shebang included).
- Strings: `'…'` (multi-line, no interpolation); `"…"` with `dollar`
  islands.
- `variablePattern`: `\$\{[^}]*\}|\$[A-Za-z_]\w*|\$[0-9@#?*!$-]`
  → variableName.
- `attributePattern` (best-effort flags): `(?<=\s|^)-{1,2}[A-Za-z][\w-]*\b`
  → attributeName.
- Words — control: if/then/elif/else/fi/for/while/until/do/done/case/
  esac/in/select/break/continue/return; definition: function/local/
  declare/typeset/readonly; module: source/export; booleans.

### `CarbonJsonHighlighter`
- Key lookahead form first: `"(?:\\.|[^"\\\n])*"(?=\s*:)` →
  propertyName; then the plain string form.
- true/false → boolean; null → nullLiteral; numbers.
- Carries `//` + `/* */` comments so the same class serves `jsonc`
  (harmless for strict JSON).

### `CarbonPythonHighlighter`
- Comments: `#` only (no block).
- Strings (order): f/r/b-prefixed triple `"""…"""`/`'''…'''` with
  fallback; f-strings `f"…"`/`f'…'` with **`braces`** islands
  (`{expr}`, not `{{`); raw/bytes `r/b/rb` prefixes; plain
  `"…"`/`'…'`. Triple-quoted strings classify as string, not
  docString (CodeMirror convention — noted).
- `@decorator` → attributeName.
- Words — control: if/elif/else/for/while/break/continue/return/try/
  except/finally/raise/with/pass/yield/await/match/case; definition:
  def/class/lambda/global/nonlocal/async; module: import/from/as;
  operator: and/or/not/in/is/del/assert; True/False → boolean;
  None → nullLiteral; self/cls → self; builtin types int/float/str/
  bool/bytes/list/dict/set/tuple/frozenset/complex/object/type → type
  (builtins, not keywords — best-effort, documented). Uppercase
  heuristic on.

### `CarbonJsHighlighter`
- Comments: doc `/**…*/`; `//`; block.
- Strings: `'…'`, `"…"` (no interpolation); template literals
  `` `…` `` multi-line + fallback with `dollarBraces` islands.
- Regex literals SKIPPED (ambiguous with division — documented).
- Words — control: if/else/for/while/do/switch/case/default/break/
  continue/return/throw/try/catch/finally/yield/await; definition:
  function/class/const/let/var/static/get/set/async/extends;
  module: import/export/from; operator: typeof/instanceof/in/new/
  void/delete; atoms: undefined/NaN/Infinity; self: this/super;
  booleans; null. Uppercase heuristic on.

### `CarbonTsHighlighter`
- JS config + decorators `@[A-Za-z_][\w.]*` → attributeName.
- Words = `{..._jsWords}` + definition: type/interface/enum/namespace/
  declare/abstract/readonly/public/private/protected/implements/
  override; operator: as/satisfies/keyof/infer/is; types: string/
  number/boolean/any/unknown/never/void/object/symbol/bigint.

## Tests

One group per language in
`test/widgets/carbon_syntax_languages_test.dart` (shared `spanAt`
helper), ~10-line idiomatic fixture each:

- Bash: `#` comment; both string forms; `$VAR` + `${VAR}` →
  variableName; island inside `"…"`; if/fi → control; function →
  definition; `--flag` → attributeName.
- JSON: key before `:` → propertyName; value string → string; true →
  boolean; null → nullLiteral; number; jsonc `//` comment.
- Python: `#` comment; f-string `{expr}` island → escape (and `{{`
  not split); triple-quoted string; `@decorator` → attributeName;
  def/class → definition; None → nullLiteral; self → self;
  int/str → type.
- JS: `/** */` → docComment; template literal pieces → string with
  `${x}` → escape; undefined → atom; const → definition; typeof →
  operator; class-name heuristic.
- TS: interface → definition; string/number → type; keyof → operator;
  decorator → attributeName.

## Example

None this step (gallery lands in step 29).
