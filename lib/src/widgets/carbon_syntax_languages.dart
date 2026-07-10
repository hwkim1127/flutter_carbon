/// Built-in language highlighters for `CarbonCodeSnippet`, each a small
/// declarative configuration on the shared single-pass regex engine.
///
/// Every highlighter is a pragmatic tokenizer, not a parser — good-enough
/// coloring in the tradition of most highlighters. Per-language limits are
/// documented on each class.
///
/// Several `CarbonSyntaxKind` values are intentionally never emitted by the
/// built-in highlighters (`comment`, `docString`, `variable`, `name`,
/// `attribute`, `tagName`, `className`, `namespace`, `literal`, `integer`,
/// `float`, `unit`, `attributeValue`, `specialString`, `regexp`, `url`,
/// `color`) — they exist for theme parity and third-party
/// `CarbonSyntaxHighlighter` adapters.
library;

import 'carbon_syntax.dart';
import 'carbon_syntax_engine.dart';

// ---------------------------------------------------------------------- Dart

/// Dart/Flutter tokenizer: comments, strings with `$name`/`${expr}`
/// interpolation islands, annotations, numbers, keyword classes, Flutter
/// named-argument labels (`child:` → propertyName), and a leading-uppercase
/// type heuristic.
class CarbonDartHighlighter extends CarbonSyntaxHighlighter {
  const CarbonDartHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_dartLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// ---------------------------------------------------------------------- Bash

/// Bash/shell tokenizer: `#` comments (shebang included), single/double
/// quoted strings with `$VAR`/`${VAR}` islands in double quotes, variables,
/// best-effort `-x`/`--flag` coloring, and the shell keyword set.
class CarbonBashHighlighter extends CarbonSyntaxHighlighter {
  const CarbonBashHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_bashLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// ---------------------------------------------------------------------- JSON

/// JSON/JSONC tokenizer: object keys → propertyName, strings, numbers,
/// `true`/`false`/`null`. Also colors `//` and `/* */` comments so the same
/// highlighter serves JSONC (harmless for strict JSON).
class CarbonJsonHighlighter extends CarbonSyntaxHighlighter {
  const CarbonJsonHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_jsonLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// -------------------------------------------------------------------- Python

/// Python tokenizer: `#` comments, plain/raw/bytes and triple-quoted
/// strings, f-strings with `{expr}` islands, `@decorator`s, keywords, and
/// builtin type names (best effort — they are builtins, not keywords).
/// Triple-quoted strings classify as strings, not doc strings (the
/// CodeMirror convention).
class CarbonPythonHighlighter extends CarbonSyntaxHighlighter {
  const CarbonPythonHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_pythonLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// ------------------------------------------------------------------------ JS

/// JavaScript tokenizer: doc/line/block comments, strings, template
/// literals with `${expr}` islands, keywords, and `undefined`/`NaN`/
/// `Infinity` atoms. Regex literals are NOT highlighted — they are
/// ambiguous with division in a single-pass tokenizer. JSX tags are not
/// highlighted either (uppercase components still color via the type
/// heuristic).
class CarbonJsHighlighter extends CarbonSyntaxHighlighter {
  const CarbonJsHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_jsLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// ------------------------------------------------------------------------ TS

/// TypeScript tokenizer: everything [CarbonJsHighlighter] does, plus
/// `@decorator`s, the TS keyword set (`interface`, `satisfies`, `keyof`, …)
/// and primitive type names. TSX tags are not highlighted.
class CarbonTsHighlighter extends CarbonSyntaxHighlighter {
  const CarbonTsHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_tsLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// ------------------------------------------------------------------------- C

/// C tokenizer: comments, strings, char literals, preprocessor directives
/// (`#include`, `#define` → macro color; the `<path>` after an include
/// stays base-colored), keywords and standard typedef names. ALL_CAPS
/// macros render as types via the uppercase heuristic — accepted.
class CarbonCHighlighter extends CarbonSyntaxHighlighter {
  const CarbonCHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_cLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// ----------------------------------------------------------------------- C++

/// C++ tokenizer: everything [CarbonCHighlighter] does, plus doc comments,
/// `R"(...)"` raw strings (the delimiter-less form only), casts, and the
/// C++ keyword set through C++20.
class CarbonCppHighlighter extends CarbonSyntaxHighlighter {
  const CarbonCppHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_cppLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// ---------------------------------------------------------------------- Java

/// Java tokenizer: doc comments, text blocks, char literals,
/// `@Annotation`s, keywords through records/sealed classes, and primitive
/// types.
class CarbonJavaHighlighter extends CarbonSyntaxHighlighter {
  const CarbonJavaHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_javaLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// ------------------------------------------------------------------------ C#

/// C# tokenizer: `///` doc comments, verbatim (`@"…"`) and interpolated
/// (`$"…"`, `$@"…"`) strings with `{expr}` islands, `[Attribute]`s
/// (line-anchored heuristic, so indexers don't match), preprocessor
/// directives (`#region`, `#if`), and the C# keyword set.
class CarbonCSharpHighlighter extends CarbonSyntaxHighlighter {
  const CarbonCSharpHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_csharpLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// ---------------------------------------------------------------------- Rust

/// Rust tokenizer: `///`/`//!` doc comments (nested block comments
/// unsupported), `r"…"`/`r#"…"#` raw strings (one `#` at most), char
/// literals vs `'a` lifetimes, `#[attr]`s, `name!` macros, and the Rust
/// keyword/primitive-type set.
class CarbonRustHighlighter extends CarbonSyntaxHighlighter {
  const CarbonRustHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_rustLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// ------------------------------------------------------------------------ Go

/// Go tokenizer: comments, backtick raw strings, rune literals, keywords,
/// builtin type names, `nil` and `iota`. Builtin functions (`make`, `len`,
/// `append`, …) stay base-colored.
class CarbonGoHighlighter extends CarbonSyntaxHighlighter {
  const CarbonGoHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_goLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// ----------------------------------------------------------------------- PHP

/// PHP tokenizer: `//` AND `#` comments, `#[Attribute]`s, `$variables`
/// (`$this` included), `<?php`/`?>` tags, strings with `$var` islands in
/// double quotes, and the PHP keyword set. Heredoc/nowdoc and `{$var}`
/// interpolation are not matched.
class CarbonPhpHighlighter extends CarbonSyntaxHighlighter {
  const CarbonPhpHighlighter();

  static final CarbonRegexHighlighter _engine =
      CarbonRegexHighlighter(_phpLanguage);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _engine.highlight(code);
}

// -------------------------------------------------------------------- lookup

/// Returns the built-in highlighter for a Markdown fence tag / file
/// extension, or null when the language isn't supported.
///
/// Supported tags (case-insensitive): dart; sh/bash/shell/zsh; json/jsonc;
/// py/python/python3; js/javascript/mjs/cjs/jsx; ts/typescript/tsx;
/// rs/rust; go/golang; c/h; cpp/c++/cc/cxx/hpp/hh/hxx; php; java;
/// cs/csharp/c#.
///
/// `jsx`/`tsx` map to plain JS/TS — JSX element grammar is beyond a
/// single-pass tokenizer; uppercase components still color via the type
/// heuristic.
CarbonSyntaxHighlighter? carbonHighlighterFor(String language) =>
    switch (language.toLowerCase()) {
      'dart' => const CarbonDartHighlighter(),
      'sh' || 'bash' || 'shell' || 'zsh' => const CarbonBashHighlighter(),
      'json' || 'jsonc' => const CarbonJsonHighlighter(),
      'py' || 'python' || 'python3' => const CarbonPythonHighlighter(),
      'js' || 'javascript' || 'mjs' || 'cjs' || 'jsx' =>
        const CarbonJsHighlighter(),
      'ts' || 'typescript' || 'tsx' => const CarbonTsHighlighter(),
      'rs' || 'rust' => const CarbonRustHighlighter(),
      'go' || 'golang' => const CarbonGoHighlighter(),
      'c' || 'h' => const CarbonCHighlighter(),
      'cpp' || 'c++' || 'cc' || 'cxx' || 'hpp' || 'hh' || 'hxx' =>
        const CarbonCppHighlighter(),
      'php' => const CarbonPhpHighlighter(),
      'java' => const CarbonJavaHighlighter(),
      'cs' || 'csharp' || 'c#' => const CarbonCSharpHighlighter(),
      _ => null,
    };

// ------------------------------------------------------------- configurations

final CarbonSyntaxLanguage _dartLanguage = CarbonSyntaxLanguage(
  id: 'dart',
  docCommentPattern: r'///[^\n]*',
  lineCommentMarkers: const ['//'],
  hasBlockComments: true,
  stringForms: const [
    // Raw forms first — at `r'''` the raw form matches from the `r`; a plain
    // form would start inside and leave `r` as an identifier. Raw strings
    // never interpolate.
    CarbonSyntaxStringForm(
      "r'''[\\s\\S]*?'''|"
      'r"""[\\s\\S]*?"""',
    ),
    CarbonSyntaxStringForm(
      "'''[\\s\\S]*?'''|"
      '"""[\\s\\S]*?"""|'
      "'''[\\s\\S]*\$|"
      '"""[\\s\\S]*\$',
      interpolation: CarbonSyntaxInterpolation.dollar,
    ),
    CarbonSyntaxStringForm(
      "r'(?:\\\\.|[^'\\\\\\n])*'|"
      'r"(?:\\\\.|[^"\\\\\\n])*"',
    ),
    CarbonSyntaxStringForm(
      "'(?:\\\\.|[^'\\\\\\n])*'|"
      '"(?:\\\\.|[^"\\\\\\n])*"',
      interpolation: CarbonSyntaxInterpolation.dollar,
    ),
  ],
  attributePattern: r'@[A-Za-z_][A-Za-z0-9_.]*',
  extraRules: const [
    // Flutter named-argument labels (and map keys): an identifier after
    // `(`/`,`/`{` and before `:`. Excludes ternary `a ? b : c` and
    // `case x:` by construction (best effort — statement labels after `{`
    // also match; rare enough to accept).
    CarbonSyntaxRule(
      r'(?<=[(,{]\s*)[a-z_][A-Za-z0-9_$]*(?=\s*:)',
      CarbonSyntaxKind.propertyName,
    ),
  ],
  words: carbonSyntaxWords(
    control: const [
      'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default',
      'break', 'continue', 'return', 'throw', 'rethrow', 'try', 'catch',
      'finally', 'yield', 'await', 'assert', 'when',
    ],
    definition: const [
      'class', 'enum', 'typedef', 'mixin', 'extension', 'abstract',
      'interface', 'base', 'sealed', 'final', 'const', 'var', 'late',
      'static', 'covariant', 'factory', 'get', 'set', 'operator',
      'external', 'required',
    ],
    module: const [
      'import', 'export', 'library', 'part', 'show', 'hide', 'deferred',
    ],
    operators: const ['is', 'as', 'in', 'new'],
    other: const [
      'void', 'dynamic', 'with', 'implements', 'extends', 'on', 'async',
      'sync', 'of',
    ],
    booleans: const ['true', 'false'],
    nulls: const ['null'],
    selves: const ['this', 'super'],
  ),
  uppercaseTypeHeuristic: true,
);

final CarbonSyntaxLanguage _bashLanguage = CarbonSyntaxLanguage(
  id: 'bash',
  lineCommentMarkers: const ['#'],
  stringForms: const [
    // POSIX single quotes: no escapes, may span lines.
    CarbonSyntaxStringForm("'[^']*'|'[^']*\$"),
    CarbonSyntaxStringForm(
      '"(?:\\\\.|[^"\\\\])*"|"(?:\\\\.|[^"\\\\])*\$',
      interpolation: CarbonSyntaxInterpolation.shellDollar,
    ),
  ],
  // Command flags (best effort): -x / --long-flag after whitespace.
  attributePattern: r'(?<=\s|^)-{1,2}[A-Za-z][A-Za-z0-9_-]*',
  variablePattern: r'\$\{[^}]*\}|\$[A-Za-z_][A-Za-z0-9_]*|\$[0-9@#?*!$-]',
  words: carbonSyntaxWords(
    control: const [
      'if', 'then', 'elif', 'else', 'fi', 'for', 'while', 'until', 'do',
      'done', 'case', 'esac', 'in', 'select', 'break', 'continue', 'return',
    ],
    definition: const [
      'function', 'local', 'declare', 'typeset', 'readonly',
    ],
    module: const ['source', 'export'],
    booleans: const ['true', 'false'],
  ),
);

final CarbonSyntaxLanguage _jsonLanguage = CarbonSyntaxLanguage(
  id: 'json',
  lineCommentMarkers: const ['//'],
  hasBlockComments: true,
  stringForms: const [
    // Keys first: a string directly followed by a colon.
    CarbonSyntaxStringForm(
      '"(?:\\\\.|[^"\\\\\\n])*"(?=\\s*:)',
      kind: CarbonSyntaxKind.propertyName,
    ),
    CarbonSyntaxStringForm('"(?:\\\\.|[^"\\\\\\n])*"'),
  ],
  words: carbonSyntaxWords(
    booleans: const ['true', 'false'],
    nulls: const ['null'],
  ),
);

final CarbonSyntaxLanguage _pythonLanguage = CarbonSyntaxLanguage(
  id: 'python',
  lineCommentMarkers: const ['#'],
  stringForms: const [
    // f-strings first (f, F, fr, rf, …) — raw f-strings still interpolate.
    CarbonSyntaxStringForm(
      "(?:[fF][rR]?|[rR][fF])(?:'''[\\s\\S]*?'''|\"\"\"[\\s\\S]*?\"\"\""
      "|'''[\\s\\S]*\$|\"\"\"[\\s\\S]*\$)",
      interpolation: CarbonSyntaxInterpolation.braces,
    ),
    CarbonSyntaxStringForm(
      "[rRbB]{0,2}(?:'''[\\s\\S]*?'''|\"\"\"[\\s\\S]*?\"\"\""
      "|'''[\\s\\S]*\$|\"\"\"[\\s\\S]*\$)",
    ),
    CarbonSyntaxStringForm(
      "(?:[fF][rR]?|[rR][fF])(?:'(?:\\\\.|[^'\\\\\\n])*'"
      '|"(?:\\\\.|[^"\\\\\\n])*")',
      interpolation: CarbonSyntaxInterpolation.braces,
    ),
    CarbonSyntaxStringForm(
      "[rRbB]{0,2}(?:'(?:\\\\.|[^'\\\\\\n])*'"
      '|"(?:\\\\.|[^"\\\\\\n])*")',
    ),
  ],
  attributePattern: r'@[A-Za-z_][A-Za-z0-9_.]*',
  words: carbonSyntaxWords(
    control: const [
      'if', 'elif', 'else', 'for', 'while', 'break', 'continue', 'return',
      'try', 'except', 'finally', 'raise', 'with', 'pass', 'yield', 'await',
      'match', 'case',
    ],
    definition: const [
      'def', 'class', 'lambda', 'global', 'nonlocal', 'async',
    ],
    module: const ['import', 'from', 'as'],
    operators: const ['and', 'or', 'not', 'in', 'is', 'del', 'assert'],
    types: const [
      'int', 'float', 'str', 'bool', 'bytes', 'list', 'dict', 'set',
      'tuple', 'frozenset', 'complex', 'object', 'type',
    ],
    booleans: const ['True', 'False'],
    nulls: const ['None'],
    selves: const ['self', 'cls'],
  ),
  uppercaseTypeHeuristic: true,
);

/// Shared JS/TS string forms — template literals interpolate `${expr}`.
const List<CarbonSyntaxStringForm> _jsStringForms = [
  CarbonSyntaxStringForm(
    "'(?:\\\\.|[^'\\\\\\n])*'|"
    '"(?:\\\\.|[^"\\\\\\n])*"',
  ),
  CarbonSyntaxStringForm(
    '`(?:\\\\.|[^`\\\\])*`|`(?:\\\\.|[^`\\\\])*\$',
    interpolation: CarbonSyntaxInterpolation.dollarBraces,
  ),
];

final Map<String, CarbonSyntaxKind> _jsWords = carbonSyntaxWords(
  control: const [
    'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default',
    'break', 'continue', 'return', 'throw', 'try', 'catch', 'finally',
    'yield', 'await',
  ],
  definition: const [
    'function', 'class', 'const', 'let', 'var', 'static', 'get', 'set',
    'async', 'extends',
  ],
  module: const ['import', 'export', 'from'],
  operators: const ['typeof', 'instanceof', 'in', 'new', 'void', 'delete'],
  other: const ['implements', 'with', 'debugger'],
  atoms: const ['undefined', 'NaN', 'Infinity'],
  booleans: const ['true', 'false'],
  nulls: const ['null'],
  selves: const ['this', 'super'],
);

final CarbonSyntaxLanguage _jsLanguage = CarbonSyntaxLanguage(
  id: 'js',
  // (?!/) keeps the empty block comment /**/ from starting a doc match
  // that would lazily swallow code up to some LATER */.
  docCommentPattern: r'/\*\*(?!/)[\s\S]*?\*/',
  lineCommentMarkers: const ['//'],
  hasBlockComments: true,
  stringForms: _jsStringForms,
  numberPattern: _cNumber,
  words: _jsWords,
  uppercaseTypeHeuristic: true,
);

final CarbonSyntaxLanguage _tsLanguage = CarbonSyntaxLanguage(
  id: 'ts',
  // (?!/) keeps the empty block comment /**/ from starting a doc match
  // that would lazily swallow code up to some LATER */.
  docCommentPattern: r'/\*\*(?!/)[\s\S]*?\*/',
  lineCommentMarkers: const ['//'],
  hasBlockComments: true,
  stringForms: _jsStringForms,
  attributePattern: r'@[A-Za-z_][A-Za-z0-9_.]*',
  numberPattern: _cNumber,
  words: {
    ..._jsWords,
    ...carbonSyntaxWords(
      definition: const [
        'type', 'interface', 'enum', 'namespace', 'declare', 'abstract',
        'readonly', 'public', 'private', 'protected', 'implements',
        'override',
      ],
      operators: const ['as', 'satisfies', 'keyof', 'infer', 'is'],
      types: const [
        'string', 'number', 'boolean', 'any', 'unknown', 'never', 'void',
        'object', 'symbol', 'bigint',
      ],
    ),
  },
  uppercaseTypeHeuristic: true,
);

/// Shared C-family number pattern: hex/binary with `_` separators, decimals
/// with fraction/exponent, and any alphanumeric suffix swallowed (`10u64`,
/// `1.5f`, `100L`, `10n`) so suffixes don't leak as identifiers.
const String _cNumber = r'\b0[xX][0-9a-fA-F_]+\w*'
    r'|\b0[bB][01_]+\w*'
    r'|\b\d[\d_]*(?:\.\d[\d_]*)?(?:[eE][+-]?\d+)?\w*';

const List<String> _cControl = [
  'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default',
  'break', 'continue', 'return', 'goto',
];

const List<String> _cDefinition = [
  'struct', 'union', 'enum', 'typedef', 'static', 'extern', 'const',
  'volatile', 'inline', 'register', 'restrict',
];

const List<String> _cTypes = [
  'void', 'char', 'short', 'int', 'long', 'float', 'double', 'signed',
  'unsigned', '_Bool', 'bool', 'size_t', 'ssize_t', 'ptrdiff_t',
  'int8_t', 'int16_t', 'int32_t', 'int64_t',
  'uint8_t', 'uint16_t', 'uint32_t', 'uint64_t',
  'intptr_t', 'uintptr_t', 'wchar_t',
];

final CarbonSyntaxLanguage _cLanguage = CarbonSyntaxLanguage(
  id: 'c',
  lineCommentMarkers: const ['//'],
  hasBlockComments: true,
  stringForms: const [
    CarbonSyntaxStringForm('(?:u8|[uUL])?"(?:\\\\.|[^"\\\\\\n])*"'),
    CarbonSyntaxStringForm(
      "'(?:\\\\.|[^'\\\\\\n])+'",
      kind: CarbonSyntaxKind.character,
    ),
  ],
  directivePattern: r'#\s*[A-Za-z]+',
  numberPattern: _cNumber,
  words: carbonSyntaxWords(
    control: _cControl,
    definition: _cDefinition,
    operators: const ['sizeof'],
    types: _cTypes,
    booleans: const ['true', 'false'],
    nulls: const ['NULL'],
  ),
  uppercaseTypeHeuristic: true,
);

final CarbonSyntaxLanguage _cppLanguage = CarbonSyntaxLanguage(
  id: 'cpp',
  docCommentPattern: r'///[^\n]*|/\*\*(?!/)[\s\S]*?\*/',
  lineCommentMarkers: const ['//'],
  hasBlockComments: true,
  stringForms: const [
    // Raw strings: delimiter-less R"(...)" form only.
    CarbonSyntaxStringForm(r'R"\([\s\S]*?\)"'),
    CarbonSyntaxStringForm('(?:u8|[uUL])?"(?:\\\\.|[^"\\\\\\n])*"'),
    CarbonSyntaxStringForm(
      "'(?:\\\\.|[^'\\\\\\n])+'",
      kind: CarbonSyntaxKind.character,
    ),
  ],
  directivePattern: r'#\s*[A-Za-z]+',
  numberPattern: _cNumber,
  words: carbonSyntaxWords(
    control: const [..._cControl, 'try', 'catch', 'throw', 'co_return',
        'co_await', 'co_yield'],
    definition: const [
      ..._cDefinition, 'class', 'template', 'typename', 'virtual',
      'explicit', 'friend', 'mutable', 'constexpr', 'consteval',
      'constinit', 'public', 'private', 'protected', 'operator', 'auto',
      'namespace', 'final',
    ],
    module: const ['using', 'import', 'module', 'export'],
    operators: const [
      'sizeof', 'new', 'delete', 'static_cast', 'dynamic_cast',
      'const_cast', 'reinterpret_cast', 'decltype', 'noexcept', 'and',
      'or', 'not',
    ],
    types: const [..._cTypes, 'char8_t', 'char16_t', 'char32_t'],
    booleans: const ['true', 'false'],
    nulls: const ['nullptr', 'NULL'],
    selves: const ['this'],
  ),
  uppercaseTypeHeuristic: true,
);

final CarbonSyntaxLanguage _javaLanguage = CarbonSyntaxLanguage(
  id: 'java',
  docCommentPattern: r'/\*\*(?!/)[\s\S]*?\*/',
  lineCommentMarkers: const ['//'],
  hasBlockComments: true,
  stringForms: const [
    // Text blocks first, with an unterminated fallback.
    CarbonSyntaxStringForm('"""[\\s\\S]*?"""|"""[\\s\\S]*\$'),
    CarbonSyntaxStringForm('"(?:\\\\.|[^"\\\\\\n])*"'),
    CarbonSyntaxStringForm(
      "'(?:\\\\.|[^'\\\\\\n])+'",
      kind: CarbonSyntaxKind.character,
    ),
  ],
  attributePattern: r'@[A-Za-z_][A-Za-z0-9_.]*',
  numberPattern: _cNumber,
  words: carbonSyntaxWords(
    control: const [
      'if', 'else', 'for', 'while', 'do', 'switch', 'case', 'default',
      'break', 'continue', 'return', 'throw', 'throws', 'try', 'catch',
      'finally', 'yield', 'assert',
    ],
    definition: const [
      'class', 'interface', 'enum', 'record', 'abstract', 'final',
      'static', 'public', 'private', 'protected', 'synchronized',
      'native', 'transient', 'volatile', 'strictfp', 'sealed', 'permits',
      'var', 'default',
    ],
    module: const [
      'import', 'package', 'module', 'exports', 'requires', 'opens',
    ],
    operators: const ['new', 'instanceof', 'extends', 'implements'],
    types: const [
      'boolean', 'byte', 'char', 'short', 'int', 'long', 'float',
      'double', 'void',
    ],
    booleans: const ['true', 'false'],
    nulls: const ['null'],
    selves: const ['this', 'super'],
  ),
  uppercaseTypeHeuristic: true,
);

final CarbonSyntaxLanguage _csharpLanguage = CarbonSyntaxLanguage(
  id: 'csharp',
  docCommentPattern: r'///[^\n]*',
  lineCommentMarkers: const ['//'],
  hasBlockComments: true,
  stringForms: const [
    // Interpolated + verbatim combos first ($@ / @$), then verbatim, then
    // interpolated, then plain. Verbatim strings escape quotes as "".
    CarbonSyntaxStringForm(
      '(?:@\\\$|\\\$@)"(?:[^"]|"")*"',
      interpolation: CarbonSyntaxInterpolation.braces,
    ),
    CarbonSyntaxStringForm('@"(?:[^"]|"")*"'),
    CarbonSyntaxStringForm(
      '\\\$"(?:\\\\.|[^"\\\\\\n])*"',
      interpolation: CarbonSyntaxInterpolation.braces,
    ),
    CarbonSyntaxStringForm('"(?:\\\\.|[^"\\\\\\n])*"'),
    CarbonSyntaxStringForm(
      "'(?:\\\\.|[^'\\\\\\n])+'",
      kind: CarbonSyntaxKind.character,
    ),
  ],
  // Line-anchored attribute heuristic — dodges indexers `a[i]`.
  attributePattern: r'(?<=(?:^|\n)[ \t]*)\[[A-Za-z_][^\]\n]*\]',
  directivePattern: r'#\s*[A-Za-z]+',
  numberPattern: _cNumber,
  words: carbonSyntaxWords(
    control: const [
      'if', 'else', 'for', 'foreach', 'while', 'do', 'switch', 'case',
      'default', 'break', 'continue', 'return', 'throw', 'try', 'catch',
      'finally', 'yield', 'when', 'goto', 'await',
    ],
    definition: const [
      'class', 'struct', 'interface', 'enum', 'record', 'delegate',
      'abstract', 'sealed', 'static', 'readonly', 'const', 'virtual',
      'override', 'partial', 'public', 'private', 'protected', 'internal',
      'event', 'async', 'var', 'required', 'init', 'get', 'set', 'where',
    ],
    module: const ['using', 'namespace', 'extern'],
    operators: const [
      'new', 'is', 'as', 'typeof', 'sizeof', 'nameof', 'in', 'out', 'ref',
      'checked', 'unchecked', 'stackalloc', 'default',
    ],
    types: const [
      'bool', 'byte', 'sbyte', 'char', 'short', 'ushort', 'int', 'uint',
      'long', 'ulong', 'float', 'double', 'decimal', 'string', 'object',
      'void', 'dynamic', 'nint', 'nuint',
    ],
    booleans: const ['true', 'false'],
    nulls: const ['null'],
    selves: const ['this', 'base'],
  ),
  uppercaseTypeHeuristic: true,
);

final CarbonSyntaxLanguage _rustLanguage = CarbonSyntaxLanguage(
  id: 'rust',
  // /// and //! doc comments; nested block comments unsupported.
  docCommentPattern: r'//[/!][^\n]*',
  lineCommentMarkers: const ['//'],
  hasBlockComments: true,
  stringForms: const [
    // Raw strings: r"…" and r#"…"# (a single # at most).
    CarbonSyntaxStringForm('r#"[\\s\\S]*?"#|r"[^"]*"'),
    CarbonSyntaxStringForm('b?"(?:\\\\.|[^"\\\\])*"'),
    // Exactly one char — `'a` (no closing quote) falls through to the
    // lifetime rule below.
    CarbonSyntaxStringForm(
      "'(?:\\\\.|[^'\\\\\\n])'",
      kind: CarbonSyntaxKind.character,
    ),
  ],
  attributePattern: r'#!?\[[^\]\n]*\]',
  extraRules: const [
    // Macros — (?!=) keeps `a != b` from emitting `a!`.
    CarbonSyntaxRule(
      r'[A-Za-z_][A-Za-z0-9_]*!(?!=)',
      CarbonSyntaxKind.macroName,
    ),
    // Lifetimes.
    CarbonSyntaxRule(
      r"'[A-Za-z_][A-Za-z0-9_]*",
      CarbonSyntaxKind.labelName,
    ),
  ],
  numberPattern: _cNumber,
  words: carbonSyntaxWords(
    control: const [
      'if', 'else', 'match', 'loop', 'while', 'for', 'break', 'continue',
      'return', 'await', 'yield',
    ],
    definition: const [
      'fn', 'struct', 'enum', 'trait', 'impl', 'type', 'let', 'const',
      'static', 'mut', 'pub', 'union', 'async', 'unsafe',
    ],
    module: const ['mod', 'use', 'crate', 'extern'],
    operators: const ['as', 'in', 'ref', 'dyn', 'move', 'where'],
    types: const [
      'i8', 'i16', 'i32', 'i64', 'i128', 'u8', 'u16', 'u32', 'u64',
      'u128', 'isize', 'usize', 'f32', 'f64', 'bool', 'char', 'str',
    ],
    booleans: const ['true', 'false'],
    selves: const ['self', 'Self'],
  ),
  uppercaseTypeHeuristic: true,
);

final CarbonSyntaxLanguage _goLanguage = CarbonSyntaxLanguage(
  id: 'go',
  lineCommentMarkers: const ['//'],
  hasBlockComments: true,
  stringForms: const [
    // Backtick raw strings (multi-line, no escapes) with EOF fallback.
    CarbonSyntaxStringForm('`[^`]*`|`[^`]*\$'),
    CarbonSyntaxStringForm('"(?:\\\\.|[^"\\\\\\n])*"'),
    CarbonSyntaxStringForm(
      "'(?:\\\\.|[^'\\\\\\n])+'",
      kind: CarbonSyntaxKind.character,
    ),
  ],
  numberPattern: _cNumber,
  words: carbonSyntaxWords(
    control: const [
      'if', 'else', 'for', 'range', 'switch', 'case', 'default', 'break',
      'continue', 'return', 'goto', 'select', 'fallthrough', 'defer', 'go',
    ],
    definition: const [
      'func', 'var', 'const', 'type', 'struct', 'interface', 'map', 'chan',
    ],
    module: const ['package', 'import'],
    types: const [
      'int', 'int8', 'int16', 'int32', 'int64', 'uint', 'uint8', 'uint16',
      'uint32', 'uint64', 'uintptr', 'float32', 'float64', 'complex64',
      'complex128', 'string', 'bool', 'byte', 'rune', 'error', 'any',
    ],
    atoms: const ['iota'],
    booleans: const ['true', 'false'],
    nulls: const ['nil'],
  ),
  uppercaseTypeHeuristic: true,
);

final CarbonSyntaxLanguage _phpLanguage = CarbonSyntaxLanguage(
  id: 'php',
  docCommentPattern: r'/\*\*(?!/)[\s\S]*?\*/',
  // Both // and # line comments; #[Attr] wins over # because attributes
  // precede line comments in the engine's alternation.
  lineCommentMarkers: const ['//', '#'],
  hasBlockComments: true,
  stringForms: const [
    // PHP strings span lines. Single quotes never interpolate.
    CarbonSyntaxStringForm("'(?:\\\\.|[^'\\\\])*'"),
    CarbonSyntaxStringForm(
      '"(?:\\\\.|[^"\\\\])*"',
      interpolation: CarbonSyntaxInterpolation.dollar,
    ),
  ],
  attributePattern: r'#\[[^\]\n]*\]',
  variablePattern: r'\$[A-Za-z_][A-Za-z0-9_]*',
  extraRules: const [
    CarbonSyntaxRule(r'<\?php\b|<\?=|\?>', CarbonSyntaxKind.tag),
  ],
  numberPattern: _cNumber,
  words: carbonSyntaxWords(
    control: const [
      'if', 'else', 'elseif', 'while', 'do', 'for', 'foreach', 'switch',
      'case', 'default', 'break', 'continue', 'return', 'throw', 'try',
      'catch', 'finally', 'match', 'yield',
    ],
    definition: const [
      'function', 'fn', 'class', 'abstract', 'final', 'interface',
      'trait', 'enum', 'const', 'static', 'public', 'private',
      'protected', 'var', 'readonly', 'global',
    ],
    module: const [
      'namespace', 'use', 'require', 'require_once', 'include',
      'include_once', 'declare',
    ],
    operators: const [
      'new', 'instanceof', 'insteadof', 'as', 'and', 'or', 'xor', 'clone',
    ],
    types: const [
      'int', 'float', 'string', 'bool', 'array', 'object', 'callable',
      'iterable', 'mixed', 'void', 'never',
    ],
    booleans: const ['true', 'false', 'TRUE', 'FALSE', 'True', 'False'],
    nulls: const ['null', 'NULL', 'Null'],
    selves: const ['self', 'parent'],
  ),
  uppercaseTypeHeuristic: true,
);
