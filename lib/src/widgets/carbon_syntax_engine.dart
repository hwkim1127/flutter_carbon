import 'carbon_syntax.dart';

/// How interpolation islands are found inside a string form. Islands render
/// in the `escape` syntax color, splitting the string span around them.
enum CarbonSyntaxInterpolation {
  /// No interpolation — the whole match is one string span.
  none,

  /// `$name` and `${expr}` — Dart, PHP `"…"`.
  dollar,

  /// `$name`, `${expr}`, and special parameters (`$1`, `$@`, `$?`) —
  /// Bash `"…"`.
  shellDollar,

  /// `${expr}` only — JS/TS template literals.
  dollarBraces,

  /// `{expr}` (but not `{{`) — C# `$"…"`, Python f-strings.
  braces,
}

/// One string-literal form of a language.
///
/// [pattern] is a regex *source*; it must contain only non-capturing groups
/// (`(?:…)`) — capturing groups would break the engine's named-group
/// dispatch. Multi-line forms should carry their own unterminated-to-EOF
/// fallback alternative (`|…[\s\S]*$`) so a missing terminator colors to the
/// end instead of leaking keywords.
class CarbonSyntaxStringForm {
  const CarbonSyntaxStringForm(
    this.pattern, {
    this.kind = CarbonSyntaxKind.string,
    this.interpolation = CarbonSyntaxInterpolation.none,
  });

  final String pattern;

  /// Usually [CarbonSyntaxKind.string]; `character` for char literals,
  /// `propertyName` for JSON keys.
  final CarbonSyntaxKind kind;

  final CarbonSyntaxInterpolation interpolation;
}

/// A language-specific pattern → kind rule (Rust macros/lifetimes, PHP tags,
/// Dart named-argument labels…). Matched after comments/strings/variables
/// and before numbers/identifiers.
class CarbonSyntaxRule {
  const CarbonSyntaxRule(this.pattern, this.kind);

  final String pattern;
  final CarbonSyntaxKind kind;
}

/// The Dart number pattern from the v1 highlighter — hex, decimals with
/// optional fraction/exponent. The default for [CarbonSyntaxLanguage].
const String carbonDartNumberPattern = r'\b0[xX][0-9a-fA-F]+\b'
    r'|\b\d+\.\d+(?:[eE][+-]?\d+)?\b'
    r'|\b\d+(?:[eE][+-]?\d+)?\b';

/// Declarative configuration for one language on [CarbonRegexHighlighter].
///
/// All patterns are regex sources with non-capturing groups only.
class CarbonSyntaxLanguage {
  const CarbonSyntaxLanguage({
    required this.id,
    this.docCommentPattern,
    this.lineCommentMarkers = const <String>[],
    this.hasBlockComments = false,
    this.stringForms = const <CarbonSyntaxStringForm>[],
    this.attributePattern,
    this.directivePattern,
    this.variablePattern,
    this.extraRules = const <CarbonSyntaxRule>[],
    this.numberPattern = carbonDartNumberPattern,
    this.identifierPattern = r'[A-Za-z_$][A-Za-z0-9_$]*',
    this.words = const <String, CarbonSyntaxKind>{},
    this.uppercaseTypeHeuristic = false,
  });

  /// Debug identifier ('dart', 'rust', …).
  final String id;

  /// Doc comments (`///…`, `/**…*/`) → [CarbonSyntaxKind.docComment].
  final String? docCommentPattern;

  /// Literal line-comment markers (`//`, `#`); each colors to end of line.
  final List<String> lineCommentMarkers;

  /// `/* … */` (with built-in unterminated-to-EOF fallback).
  final bool hasBlockComments;

  /// String-literal forms, tried in order — list raw/verbatim/triple forms
  /// before the plain forms they'd otherwise partially match.
  final List<CarbonSyntaxStringForm> stringForms;

  /// Annotations/attributes (`@Name`, `#[derive]`) →
  /// [CarbonSyntaxKind.attributeName].
  final String? attributePattern;

  /// Preprocessor directives (`#include`, `#region`) →
  /// [CarbonSyntaxKind.macroName].
  final String? directivePattern;

  /// Variables (`$VAR`, `$var`) → [CarbonSyntaxKind.variableName].
  final String? variablePattern;

  /// Language-specific rules, matched before numbers and identifiers.
  final List<CarbonSyntaxRule> extraRules;

  /// Number literals → [CarbonSyntaxKind.number].
  final String numberPattern;

  /// Identifier shape; classified via [words] then the uppercase heuristic.
  final String identifierPattern;

  /// Flat keyword → kind map; compose with [carbonSyntaxWords] so the
  /// category intent stays visible at the call site.
  final Map<String, CarbonSyntaxKind> words;

  /// Classify unknown leading-uppercase identifiers as
  /// [CarbonSyntaxKind.typeName].
  final bool uppercaseTypeHeuristic;
}

/// Composes a [CarbonSyntaxLanguage.words] map from keyword categories.
Map<String, CarbonSyntaxKind> carbonSyntaxWords({
  List<String> control = const [],
  List<String> definition = const [],
  List<String> module = const [],
  List<String> operators = const [],
  List<String> other = const [],
  List<String> types = const [],
  List<String> atoms = const [],
  List<String> booleans = const [],
  List<String> nulls = const [],
  List<String> selves = const [],
}) {
  return {
    for (final w in control) w: CarbonSyntaxKind.controlKeyword,
    for (final w in definition) w: CarbonSyntaxKind.definitionKeyword,
    for (final w in module) w: CarbonSyntaxKind.moduleKeyword,
    for (final w in operators) w: CarbonSyntaxKind.operatorKeyword,
    for (final w in other) w: CarbonSyntaxKind.keyword,
    for (final w in types) w: CarbonSyntaxKind.type,
    for (final w in atoms) w: CarbonSyntaxKind.atom,
    for (final w in booleans) w: CarbonSyntaxKind.boolean,
    for (final w in nulls) w: CarbonSyntaxKind.nullLiteral,
    for (final w in selves) w: CarbonSyntaxKind.self,
  };
}

/// The configurable single-pass regex tokenizer behind every built-in
/// language highlighter.
///
/// One alternation [RegExp] is compiled per instance (public wrappers hold
/// one `static final` engine each, so each language compiles exactly once).
/// The alternation order is semantic — see [_CompiledLanguage].
class CarbonRegexHighlighter extends CarbonSyntaxHighlighter {
  CarbonRegexHighlighter(this.config);

  final CarbonSyntaxLanguage config;

  late final _CompiledLanguage _compiled = _CompiledLanguage(config);

  @override
  List<CarbonSyntaxSpan> highlight(String code) => _compiled.highlight(code);
}

/// The compiled alternation + classifier for one language.
///
/// Group order is SEMANTIC (leftmost alternative wins at a given position):
///
///   doc → attr → line → block → s0…sN → dir → vr → x0…xN → num → id
///
/// - `doc` before `line`/`block`: `///` beats `//`, `/**…*/` beats `/*…*/`.
/// - `attr` before `line`: PHP's `#[Attr]` must beat its `#` line comment
///   (the attribute requires `[` right after `#`, so `# comment` still
///   falls through). Harmless everywhere else — no other language has an
///   attribute starting like a comment.
/// - String forms in config order (raw/verbatim/triple before plain).
/// - `x0…xN` before `num`/`id`: Rust `vec!` must beat the identifier `vec`.
class _CompiledLanguage {
  _CompiledLanguage(this.config) : pattern = _compile(config);

  final CarbonSyntaxLanguage config;
  final RegExp pattern;

  static RegExp _compile(CarbonSyntaxLanguage config) {
    final parts = <String>[];

    void add(String group, String source) {
      assert(
        // Strip character classes (a `(` inside `[…]` is literal), then
        // escaped characters, before looking for capturing groups.
        !RegExp(r'\((?!\?)').hasMatch(
          source
              .replaceAll(RegExp(r'\[(?:\\.|[^\]\\])*\]'), '')
              .replaceAll(RegExp(r'\\.'), ''),
        ),
        'Capturing group in "${config.id}" pattern "$source" — use (?:…).',
      );
      parts.add('(?<$group>$source)');
    }

    if (config.docCommentPattern != null) {
      add('doc', config.docCommentPattern!);
    }
    if (config.attributePattern != null) {
      add('attr', config.attributePattern!);
    }
    if (config.lineCommentMarkers.isNotEmpty) {
      add(
        'line',
        config.lineCommentMarkers
            .map((m) => '${RegExp.escape(m)}[^\\n]*')
            .join('|'),
      );
    }
    if (config.hasBlockComments) {
      // Unterminated fallback: color to EOF instead of leaking keywords.
      add('block', r'/\*[\s\S]*?\*/|/\*[\s\S]*$');
    }
    for (var i = 0; i < config.stringForms.length; i++) {
      add('s$i', config.stringForms[i].pattern);
    }
    if (config.directivePattern != null) {
      add('dir', config.directivePattern!);
    }
    if (config.variablePattern != null) {
      add('vr', config.variablePattern!);
    }
    for (var i = 0; i < config.extraRules.length; i++) {
      add('x$i', config.extraRules[i].pattern);
    }
    add('num', config.numberPattern);
    add('id', config.identifierPattern);

    return RegExp(parts.join('|'));
  }

  /// Cached island matchers per interpolation style.
  static final Map<CarbonSyntaxInterpolation, RegExp> _islands = {
    CarbonSyntaxInterpolation.dollar: RegExp(
      r'(?<!\\)\$\{[^}]*\}|(?<!\\)\$[A-Za-z_][A-Za-z0-9_]*',
    ),
    CarbonSyntaxInterpolation.shellDollar: RegExp(
      r'(?<!\\)\$\{[^}]*\}'
      r'|(?<!\\)\$[A-Za-z_][A-Za-z0-9_]*'
      r'|(?<!\\)\$[0-9@#?*!$-]',
    ),
    CarbonSyntaxInterpolation.dollarBraces: RegExp(r'(?<!\\)\$\{[^}]*\}'),
    // (?<!\{)…(?!\{) skips escaped {{literal}} braces entirely.
    CarbonSyntaxInterpolation.braces: RegExp(r'(?<!\{)\{(?!\{)[^{}\n]*\}'),
  };

  List<CarbonSyntaxSpan> highlight(String code) {
    final spans = <CarbonSyntaxSpan>[];

    final hasDoc = config.docCommentPattern != null;
    final hasAttr = config.attributePattern != null;
    final hasLine = config.lineCommentMarkers.isNotEmpty;
    final hasDir = config.directivePattern != null;
    final hasVar = config.variablePattern != null;

    for (final match in pattern.allMatches(code)) {
      if (hasDoc && match.namedGroup('doc') != null) {
        spans.add(
          CarbonSyntaxSpan(match.start, match.end, CarbonSyntaxKind.docComment),
        );
        continue;
      }
      if (hasAttr && match.namedGroup('attr') != null) {
        spans.add(
          CarbonSyntaxSpan(
            match.start,
            match.end,
            CarbonSyntaxKind.attributeName,
          ),
        );
        continue;
      }
      if (hasLine && match.namedGroup('line') != null) {
        spans.add(
          CarbonSyntaxSpan(
            match.start,
            match.end,
            CarbonSyntaxKind.lineComment,
          ),
        );
        continue;
      }
      if (config.hasBlockComments && match.namedGroup('block') != null) {
        spans.add(
          CarbonSyntaxSpan(
            match.start,
            match.end,
            CarbonSyntaxKind.blockComment,
          ),
        );
        continue;
      }

      var handled = false;
      for (var i = 0; i < config.stringForms.length; i++) {
        if (match.namedGroup('s$i') != null) {
          _addStringSpans(spans, code, match.start, match.end,
              config.stringForms[i]);
          handled = true;
          break;
        }
      }
      if (handled) continue;

      if (hasDir && match.namedGroup('dir') != null) {
        spans.add(
          CarbonSyntaxSpan(match.start, match.end, CarbonSyntaxKind.macroName),
        );
        continue;
      }
      if (hasVar && match.namedGroup('vr') != null) {
        spans.add(
          CarbonSyntaxSpan(
            match.start,
            match.end,
            CarbonSyntaxKind.variableName,
          ),
        );
        continue;
      }
      for (var i = 0; i < config.extraRules.length; i++) {
        if (match.namedGroup('x$i') != null) {
          spans.add(
            CarbonSyntaxSpan(match.start, match.end, config.extraRules[i].kind),
          );
          handled = true;
          break;
        }
      }
      if (handled) continue;

      if (match.namedGroup('num') != null) {
        spans.add(
          CarbonSyntaxSpan(match.start, match.end, CarbonSyntaxKind.number),
        );
        continue;
      }

      final identifier = match.namedGroup('id');
      if (identifier != null) {
        final kind = _classifyIdentifier(identifier);
        if (kind != null) {
          spans.add(CarbonSyntaxSpan(match.start, match.end, kind));
        }
      }
    }
    return spans;
  }

  CarbonSyntaxKind? _classifyIdentifier(String identifier) {
    final fromWords = config.words[identifier];
    if (fromWords != null) return fromWords;
    if (config.uppercaseTypeHeuristic) {
      final first = identifier.codeUnitAt(0);
      if (first >= 0x41 && first <= 0x5A) return CarbonSyntaxKind.typeName;
    }
    return null; // plain identifier — base code color
  }

  /// Emits a string match as one span, or — when the form interpolates — a
  /// FLAT `string / escape / string / …` sequence. No nesting:
  /// [carbonSyntaxTextSpans] renders adjacent spans only.
  void _addStringSpans(
    List<CarbonSyntaxSpan> spans,
    String code,
    int start,
    int end,
    CarbonSyntaxStringForm form,
  ) {
    if (form.interpolation == CarbonSyntaxInterpolation.none) {
      spans.add(CarbonSyntaxSpan(start, end, form.kind));
      return;
    }
    final island = _islands[form.interpolation]!;
    var cursor = start;
    for (final m in island.allMatches(code.substring(start, end))) {
      final islandStart = start + m.start;
      final islandEnd = start + m.end;
      if (islandStart > cursor) {
        spans.add(CarbonSyntaxSpan(cursor, islandStart, form.kind));
      }
      spans.add(
        CarbonSyntaxSpan(islandStart, islandEnd, CarbonSyntaxKind.escape),
      );
      cursor = islandEnd;
    }
    if (cursor < end) {
      spans.add(CarbonSyntaxSpan(cursor, end, form.kind));
    }
  }
}
