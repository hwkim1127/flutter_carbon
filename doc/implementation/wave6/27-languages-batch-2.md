# Step 27 — Languages batch 2: C, C++, Java, C#, Rust, Go, PHP (+ lookup)

## Goal

The remaining seven languages plus the `carbonHighlighterFor` fence-tag
lookup and the engine-invariant test sweep.

Shared constant `_cNumber` (hex/binary with `_` separators + suffix
swallowing `u64`, `UL`, `f`, `n`) used by the C-family/Rust/Go/JS/TS;
Dart keeps `dartNumberPattern` verbatim for v1 parity.

**Preprocessor decision**: `#include`/`#define`/`#ifdef` (C/C++) and
`#region`/`#if`/`#pragma`/`#nullable` (C#) map to **macroName** via
`directivePattern` `#\s*[A-Za-z]+` — not moduleKeyword. Rationale: the
C preprocessor is macro machinery (Lezer/CodeMirror tag it that way);
`moduleKeyword` is reserved for identifier-shaped words flowing through
the word table; `#region` has nothing module-ish. `#include <path>`
path stays base-colored (documented).

## Language configs

### `CarbonCHighlighter`
- `//` + block comments; strings `(?:u8|[uUL])?"…"`; char
  `'(?:\\.|[^'\\\n])+'` → character; directives → macroName.
- Words — control: if/else/for/while/do/switch/case/default/break/
  continue/return/goto; definition: struct/union/enum/typedef/static/
  extern/const/volatile/inline/register/restrict; operator: sizeof;
  types: void/char/short/int/long/float/double/signed/unsigned/_Bool/
  bool/size_t/int8_t…uint64_t/intptr_t/wchar_t; NULL → nullLiteral;
  booleans. Uppercase heuristic on (ALL_CAPS macros render typeName —
  accepted).

### `CarbonCppHighlighter`
- C + doc `/**…*/` + `R"(...)"` raw strings (delimiter-less form only,
  documented).
- Words = C + control: try/catch/throw/co_return/co_await/co_yield;
  definition: class/template/typename/virtual/explicit/friend/mutable/
  constexpr/consteval/public/private/protected/operator/auto/
  namespace; module: using/import/module/export; operator: new/delete/
  static_cast/dynamic_cast/const_cast/reinterpret_cast/decltype/and/
  or/not; types + wchar_t/char8_t/char16_t/char32_t; self: this;
  nullptr + NULL → nullLiteral.

### `CarbonJavaHighlighter`
- doc `/**…*/`; `//`; block; text blocks `"""[\s\S]*?"""` + fallback;
  `"…"`; char → character; `@Anno` → attributeName.
- Words — control: if/else/for/while/do/switch/case/default/break/
  continue/return/throw/throws/try/catch/finally/yield/assert;
  definition: class/interface/enum/record/abstract/final/static/
  public/private/protected/synchronized/native/transient/volatile/
  sealed/permits/var; module: import/package/module/exports/requires/
  opens; operator: new/instanceof/extends/implements; types: boolean/
  byte/char/short/int/long/float/double/void; self: this/super;
  booleans; null.

### `CarbonCSharpHighlighter`
- doc `///`; `//`; block. Strings (order): `(?:@\$|\$@)"(?:[^"]|"")*"`
  (`braces` islands), `@"(?:[^"]|"")*"` verbatim, `\$"…"` (`braces`),
  `"…"`, char → character.
- `[Attr]` line-anchored `(?<=(?:^|\n)[ \t]*)\[[A-Za-z_][^\]\n]*\]`
  (dodges indexers; best-effort, documented) → attributeName;
  directives → macroName.
- Words — control: if/else/for/foreach/while/do/switch/case/default/
  break/continue/return/throw/try/catch/finally/yield/when/goto/
  await; definition: class/struct/interface/enum/record/delegate/
  abstract/sealed/static/readonly/const/virtual/override/partial/
  public/private/protected/internal/event/async/var/required/init/
  get/set; module: using/namespace/extern; operator: new/is/as/
  typeof/sizeof/nameof/in/out/ref/checked/unchecked/stackalloc;
  types: bool/byte/sbyte/char/short/ushort/int/uint/long/ulong/float/
  double/decimal/string/object/void/dynamic/nint/nuint; self:
  this/base; booleans; null.

### `CarbonRustHighlighter`
- doc `///` + `//!` + `/**…*/`; `//`; block (nesting unsupported —
  noted). Strings: `r#"…"#`/`r"…"` (0–1 `#` only), `b?"…"`, char
  `'(?:\\.|[^'\\\n])'` → character.
- `#!?\[[^\]\n]*\]` → attributeName. Extra rules: macro
  `[A-Za-z_]\w*!(?!=)` → macroName (the `(?!=)` guard stops `a != b`),
  lifetime `'[A-Za-z_]\w*` → labelName (naturally loses to the char
  form).
- Words — control: if/else/match/loop/while/for/break/continue/
  return/await/yield; definition: fn/struct/enum/trait/impl/type/let/
  const/static/mut/pub/union/async/unsafe; module: mod/use/crate/
  extern; operator: as/in/ref/dyn/move/where; types: i8…i128/u8…u128/
  isize/usize/f32/f64/bool/char/str; self: self/Self; booleans.

### `CarbonGoHighlighter`
- `//` + block; backtick raw strings `` `[^`]*` `` multi-line +
  fallback; `"…"`; rune → character.
- Words — control: if/else/for/range/switch/case/default/break/
  continue/return/goto/select/fallthrough/defer/go; definition: func/
  var/const/type/struct/interface/map/chan; module: package/import;
  types: int/int8…64/uint…/uintptr/float32/64/complex64/128/string/
  bool/byte/rune/error/any; atoms: iota; nil → nullLiteral; booleans
  (builtins make/len/append… stay base-colored — noted).

### `CarbonPhpHighlighter`
- doc `/**…*/`; `//` AND `#` line comments; block. Strings: `'…'` (no
  interpolation), `"…"` with `dollar` islands; heredoc skipped
  (documented).
- `#\[[^\]\n]*\]` → attributeName (works because attr precedes line
  comments in the alternation); `\$[A-Za-z_]\w*` → variableName (so
  `$this` → variableName, noted). Extra rule:
  `<\?php\b|<\?=|\?>` → **tag**.
- Words — control: if/else/elseif/while/do/for/foreach/switch/case/
  default/break/continue/return/throw/try/catch/finally/match/yield;
  definition: function/fn/class/abstract/final/interface/trait/enum/
  const/static/public/private/protected/var/readonly/global; module:
  namespace/use/require/require_once/include/include_once/declare;
  operator: new/instanceof/insteadof/as/and/or/xor/clone; types:
  int/float/string/bool/array/object/callable/iterable/mixed/void/
  never; self: self/parent; booleans + null/NULL.

## `carbonHighlighterFor`

```dart
CarbonSyntaxHighlighter? carbonHighlighterFor(String language) =>
  switch (language.toLowerCase()) {
    'dart' => const CarbonDartHighlighter(),
    'sh' || 'bash' || 'shell' || 'zsh' => const CarbonBashHighlighter(),
    'json' || 'jsonc' => const CarbonJsonHighlighter(),
    'py' || 'python' || 'python3' => const CarbonPythonHighlighter(),
    'js' || 'javascript' || 'mjs' || 'cjs' || 'jsx' => const CarbonJsHighlighter(),
    'ts' || 'typescript' || 'tsx' => const CarbonTsHighlighter(),
    'rs' || 'rust' => const CarbonRustHighlighter(),
    'go' || 'golang' => const CarbonGoHighlighter(),
    'c' || 'h' => const CarbonCHighlighter(),
    'cpp' || 'c++' || 'cc' || 'cxx' || 'hpp' || 'hh' || 'hxx' => const CarbonCppHighlighter(),
    'php' => const CarbonPhpHighlighter(),
    'java' => const CarbonJavaHighlighter(),
    'cs' || 'csharp' || 'c#' => const CarbonCSharpHighlighter(),
    _ => null,
  };
```

jsx/tsx map to plain JS/TS with NO JSX tag grammar (beyond single-pass
regex; uppercase components still get typeName — degrades gracefully,
documented in the dartdoc).

Kind coverage note in the file header: the kinds still intentionally
unemitted stay for theme parity / third-party adapters; `escape`,
`character`, `propertyName`, `tag`, `macroName`, `labelName`,
`variableName`, `atom`, `type` become live in v2.

## Tests

Per-language groups (same fixture pattern as step 26):

- C: `#include` → macroName; `'a'` → character; NULL → nullLiteral;
  int/void → type; struct → definition.
- C++: nullptr → nullLiteral; template/namespace → definition;
  static_cast → operator; `::` stays base-colored.
- Java: `@Override` → attributeName; text block → string; `'c'` →
  character; boolean/int → type; record → definition.
- C#: `[Fact]` at line start → attributeName; `@"C:\x"` → string (not
  split); `$"a{x}b"` → braces island; `#region` → macroName.
- Rust: `#[derive(Debug)]` → attributeName; `println!` → macroName;
  **`a != b` emits NO macro span**; `'a` lifetime → labelName; `'a'`
  char → character; `r#"…"#` → string; i32 → type; fn → definition.
- Go: multi-line backtick string; nil → nullLiteral; func →
  definition; int/error → type; rune → character; iota → atom.
- PHP: `<?php`/`?>` → tag; `$var` → variableName; `#` comment vs
  `#[Attr]` → attributeName; `"$var"` island; foreach → control.

Engine sweep: all fixtures × all highlighters → sorted, non-overlapping,
in-bounds. Lookup: every tag → expected type; unknown (`'cobol'`) →
null; case-insensitive.

## Example

None this step (gallery lands in step 29).
