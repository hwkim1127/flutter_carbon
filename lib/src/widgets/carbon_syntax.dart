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
