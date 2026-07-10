import 'package:flutter/widgets.dart';

import '../theme/component_themes/syntax_theme_data.dart';

/// Classification of a source-code region, mapping 1:1 onto the
/// `carbon.syntax` theme tokens ([CarbonSyntaxThemeData]).
enum CarbonSyntaxKind {
  comment,
  lineComment,
  blockComment,
  docComment,
  string,
  docString,
  keyword,
  operatorKeyword,
  controlKeyword,
  definitionKeyword,
  moduleKeyword,
  variable,
  name,
  variableName,
  labelName,
  attribute,
  attributeName,
  propertyName,
  tag,
  tagName,
  type,
  typeName,
  className,
  namespace,
  macroName,
  atom,
  literal,
  boolean,
  nullLiteral,
  self,
  number,
  integer,
  float,
  unit,
  character,
  attributeValue,
  specialString,
  regexp,
  escape,
  url,
  color;

  /// Resolves this kind's color from the theme's syntax tokens.
  Color colorOf(CarbonSyntaxThemeData syntax) {
    switch (this) {
      case CarbonSyntaxKind.comment:
        return syntax.syntaxComment;
      case CarbonSyntaxKind.lineComment:
        return syntax.syntaxLineComment;
      case CarbonSyntaxKind.blockComment:
        return syntax.syntaxBlockComment;
      case CarbonSyntaxKind.docComment:
        return syntax.syntaxDocComment;
      case CarbonSyntaxKind.string:
        return syntax.syntaxString;
      case CarbonSyntaxKind.docString:
        return syntax.syntaxDocString;
      case CarbonSyntaxKind.keyword:
        return syntax.syntaxKeyword;
      case CarbonSyntaxKind.operatorKeyword:
        return syntax.syntaxOperatorKeyword;
      case CarbonSyntaxKind.controlKeyword:
        return syntax.syntaxControlKeyword;
      case CarbonSyntaxKind.definitionKeyword:
        return syntax.syntaxDefinitionKeyword;
      case CarbonSyntaxKind.moduleKeyword:
        return syntax.syntaxModuleKeyword;
      case CarbonSyntaxKind.variable:
        return syntax.syntaxVariable;
      case CarbonSyntaxKind.name:
        return syntax.syntaxName;
      case CarbonSyntaxKind.variableName:
        return syntax.syntaxVariableName;
      case CarbonSyntaxKind.labelName:
        return syntax.syntaxLabelName;
      case CarbonSyntaxKind.attribute:
        return syntax.syntaxAttribute;
      case CarbonSyntaxKind.attributeName:
        return syntax.syntaxAttributeName;
      case CarbonSyntaxKind.propertyName:
        return syntax.syntaxPropertyName;
      case CarbonSyntaxKind.tag:
        return syntax.syntaxTag;
      case CarbonSyntaxKind.tagName:
        return syntax.syntaxTagName;
      case CarbonSyntaxKind.type:
        return syntax.syntaxType;
      case CarbonSyntaxKind.typeName:
        return syntax.syntaxTypeName;
      case CarbonSyntaxKind.className:
        return syntax.syntaxClassName;
      case CarbonSyntaxKind.namespace:
        return syntax.syntaxNamespace;
      case CarbonSyntaxKind.macroName:
        return syntax.syntaxMacroName;
      case CarbonSyntaxKind.atom:
        return syntax.syntaxAtom;
      case CarbonSyntaxKind.literal:
        return syntax.syntaxLiteral;
      case CarbonSyntaxKind.boolean:
        return syntax.syntaxBool;
      case CarbonSyntaxKind.nullLiteral:
        return syntax.syntaxNull;
      case CarbonSyntaxKind.self:
        return syntax.syntaxSelf;
      case CarbonSyntaxKind.number:
        return syntax.syntaxNumber;
      case CarbonSyntaxKind.integer:
        return syntax.syntaxInteger;
      case CarbonSyntaxKind.float:
        return syntax.syntaxFloat;
      case CarbonSyntaxKind.unit:
        return syntax.syntaxUnit;
      case CarbonSyntaxKind.character:
        return syntax.syntaxCharacter;
      case CarbonSyntaxKind.attributeValue:
        return syntax.syntaxAttributeValue;
      case CarbonSyntaxKind.specialString:
        return syntax.syntaxSpecialString;
      case CarbonSyntaxKind.regexp:
        return syntax.syntaxRegexp;
      case CarbonSyntaxKind.escape:
        return syntax.syntaxEscape;
      case CarbonSyntaxKind.url:
        return syntax.syntaxUrl;
      case CarbonSyntaxKind.color:
        return syntax.syntaxColor;
    }
  }
}

/// A classified region of source code.
///
/// [start] (inclusive) and [end] (exclusive) are offsets into the code
/// string. Unclassified gaps render in the base code color.
class CarbonSyntaxSpan {
  const CarbonSyntaxSpan(this.start, this.end, this.kind);

  final int start;
  final int end;
  final CarbonSyntaxKind kind;
}

/// Tokenizes source code for [CarbonCodeSnippet] highlighting.
///
/// Implementations must be pure — same input, same spans — so results can
/// be cached, and must return sorted, non-overlapping spans.
abstract class CarbonSyntaxHighlighter {
  const CarbonSyntaxHighlighter();

  List<CarbonSyntaxSpan> highlight(String code);
}

/// A pragmatic regex-based Dart tokenizer: comments, strings, annotations,
/// numbers, keyword classes, and a leading-uppercase type heuristic. Not a
/// compiler — good-enough coloring in the tradition of most highlighters.
class CarbonDartHighlighter extends CarbonSyntaxHighlighter {
  const CarbonDartHighlighter();

  static final RegExp _pattern = RegExp(
    // Doc comment before line comment (/// vs //).
    r'(?<doc>///[^\n]*)'
    r'|(?<line>//[^\n]*)'
    r'|(?<block>/\*[\s\S]*?\*/)'
    // Triple-quoted (optionally raw) strings before single-line strings.
    r"|(?<triple>r?'''[\s\S]*?'''|"
    r'r?"""[\s\S]*?""")'
    r"|(?<string>r?'(?:\\.|[^'\\\n])*'|"
    r'r?"(?:\\.|[^"\\\n])*")'
    r'|(?<annotation>@[A-Za-z_][A-Za-z0-9_.]*)'
    r'|(?<number>\b0[xX][0-9a-fA-F]+\b'
    r'|\b\d+\.\d+(?:[eE][+-]?\d+)?\b'
    r'|\b\d+(?:[eE][+-]?\d+)?\b)'
    r'|(?<identifier>[A-Za-z_$][A-Za-z0-9_$]*)',
  );

  static const Set<String> _controlKeywords = {
    'if',
    'else',
    'for',
    'while',
    'do',
    'switch',
    'case',
    'default',
    'break',
    'continue',
    'return',
    'throw',
    'rethrow',
    'try',
    'catch',
    'finally',
    'yield',
    'await',
    'assert',
    'when',
  };

  static const Set<String> _definitionKeywords = {
    'class',
    'enum',
    'typedef',
    'mixin',
    'extension',
    'abstract',
    'interface',
    'base',
    'sealed',
    'final',
    'const',
    'var',
    'late',
    'static',
    'covariant',
    'factory',
    'get',
    'set',
    'operator',
    'external',
    'required',
  };

  static const Set<String> _moduleKeywords = {
    'import',
    'export',
    'library',
    'part',
    'show',
    'hide',
    'deferred',
  };

  static const Set<String> _operatorKeywords = {'is', 'as', 'in', 'new'};

  static const Set<String> _otherKeywords = {
    'void',
    'dynamic',
    'with',
    'implements',
    'extends',
    'on',
    'async',
    'sync',
    'of',
  };

  @override
  List<CarbonSyntaxSpan> highlight(String code) {
    final spans = <CarbonSyntaxSpan>[];

    for (final match in _pattern.allMatches(code)) {
      final kind = _classify(match);
      if (kind != null) {
        spans.add(CarbonSyntaxSpan(match.start, match.end, kind));
      }
    }
    return spans;
  }

  CarbonSyntaxKind? _classify(RegExpMatch match) {
    if (match.namedGroup('doc') != null) return CarbonSyntaxKind.docComment;
    if (match.namedGroup('line') != null) return CarbonSyntaxKind.lineComment;
    if (match.namedGroup('block') != null) {
      return CarbonSyntaxKind.blockComment;
    }
    if (match.namedGroup('triple') != null ||
        match.namedGroup('string') != null) {
      return CarbonSyntaxKind.string;
    }
    if (match.namedGroup('annotation') != null) {
      return CarbonSyntaxKind.attributeName;
    }
    if (match.namedGroup('number') != null) return CarbonSyntaxKind.number;

    final identifier = match.namedGroup('identifier');
    if (identifier != null) {
      if (identifier == 'true' || identifier == 'false') {
        return CarbonSyntaxKind.boolean;
      }
      if (identifier == 'null') return CarbonSyntaxKind.nullLiteral;
      if (identifier == 'this' || identifier == 'super') {
        return CarbonSyntaxKind.self;
      }
      if (_controlKeywords.contains(identifier)) {
        return CarbonSyntaxKind.controlKeyword;
      }
      if (_definitionKeywords.contains(identifier)) {
        return CarbonSyntaxKind.definitionKeyword;
      }
      if (_moduleKeywords.contains(identifier)) {
        return CarbonSyntaxKind.moduleKeyword;
      }
      if (_operatorKeywords.contains(identifier)) {
        return CarbonSyntaxKind.operatorKeyword;
      }
      if (_otherKeywords.contains(identifier)) {
        return CarbonSyntaxKind.keyword;
      }
      // Leading-uppercase heuristic: types/classes.
      final first = identifier.codeUnitAt(0);
      if (first >= 0x41 && first <= 0x5A) {
        return CarbonSyntaxKind.typeName;
      }
      return null; // plain identifier — base code color
    }
    return null;
  }
}

/// Builds the colored [TextSpan] children for [code] from highlighter
/// [spans], filling unclassified gaps with [baseStyle]. Shared by the
/// snippet's editable controller and its plain-text variants.
List<TextSpan> carbonSyntaxTextSpans({
  required String code,
  required List<CarbonSyntaxSpan> spans,
  required TextStyle? baseStyle,
  required CarbonSyntaxThemeData syntax,
}) {
  final children = <TextSpan>[];
  var cursor = 0;

  for (final span in spans) {
    // Defensive: skip malformed/overlapping spans instead of throwing.
    if (span.start < cursor ||
        span.end > code.length ||
        span.start >= span.end) {
      continue;
    }
    if (span.start > cursor) {
      children.add(TextSpan(text: code.substring(cursor, span.start)));
    }
    children.add(
      TextSpan(
        text: code.substring(span.start, span.end),
        style: TextStyle(color: span.kind.colorOf(syntax)),
      ),
    );
    cursor = span.end;
  }
  if (cursor < code.length) {
    children.add(TextSpan(text: code.substring(cursor)));
  }
  return children;
}
