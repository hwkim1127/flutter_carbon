import 'package:flutter/material.dart';

@immutable
class CarbonSyntaxThemeData extends ThemeExtension<CarbonSyntaxThemeData> {
  final Color syntaxComment;
  final Color syntaxLineComment;
  final Color syntaxBlockComment;
  final Color syntaxDocComment;
  final Color syntaxString;
  final Color syntaxDocString;
  final Color syntaxKeyword;
  final Color syntaxOperatorKeyword;
  final Color syntaxControlKeyword;
  final Color syntaxDefinitionKeyword;
  final Color syntaxModuleKeyword;
  final Color syntaxVariable;
  final Color syntaxName;
  final Color syntaxVariableName;
  final Color syntaxLabelName;
  final Color syntaxAttribute;
  final Color syntaxAttributeName;
  final Color syntaxPropertyName;
  final Color syntaxTag;
  final Color syntaxTagName;
  final Color syntaxType;
  final Color syntaxTypeName;
  final Color syntaxClassName;
  final Color syntaxNamespace;
  final Color syntaxMacroName;
  final Color syntaxAtom;
  final Color syntaxLiteral;
  final Color syntaxBool;
  final Color syntaxNull;
  final Color syntaxSelf;
  final Color syntaxNumber;
  final Color syntaxInteger;
  final Color syntaxFloat;
  final Color syntaxUnit;
  final Color syntaxCharacter;
  final Color syntaxAttributeValue;
  final Color syntaxSpecialString;
  final Color syntaxRegexp;
  final Color syntaxEscape;
  final Color syntaxUrl;
  final Color syntaxColor;

  const CarbonSyntaxThemeData({
    required this.syntaxComment,
    required this.syntaxLineComment,
    required this.syntaxBlockComment,
    required this.syntaxDocComment,
    required this.syntaxString,
    required this.syntaxDocString,
    required this.syntaxKeyword,
    required this.syntaxOperatorKeyword,
    required this.syntaxControlKeyword,
    required this.syntaxDefinitionKeyword,
    required this.syntaxModuleKeyword,
    required this.syntaxVariable,
    required this.syntaxName,
    required this.syntaxVariableName,
    required this.syntaxLabelName,
    required this.syntaxAttribute,
    required this.syntaxAttributeName,
    required this.syntaxPropertyName,
    required this.syntaxTag,
    required this.syntaxTagName,
    required this.syntaxType,
    required this.syntaxTypeName,
    required this.syntaxClassName,
    required this.syntaxNamespace,
    required this.syntaxMacroName,
    required this.syntaxAtom,
    required this.syntaxLiteral,
    required this.syntaxBool,
    required this.syntaxNull,
    required this.syntaxSelf,
    required this.syntaxNumber,
    required this.syntaxInteger,
    required this.syntaxFloat,
    required this.syntaxUnit,
    required this.syntaxCharacter,
    required this.syntaxAttributeValue,
    required this.syntaxSpecialString,
    required this.syntaxRegexp,
    required this.syntaxEscape,
    required this.syntaxUrl,
    required this.syntaxColor,
  });

  @override
  CarbonSyntaxThemeData copyWith({
    Color? syntaxComment,
    Color? syntaxLineComment,
    Color? syntaxBlockComment,
    Color? syntaxDocComment,
    Color? syntaxString,
    Color? syntaxDocString,
    Color? syntaxKeyword,
    Color? syntaxOperatorKeyword,
    Color? syntaxControlKeyword,
    Color? syntaxDefinitionKeyword,
    Color? syntaxModuleKeyword,
    Color? syntaxVariable,
    Color? syntaxName,
    Color? syntaxVariableName,
    Color? syntaxLabelName,
    Color? syntaxAttribute,
    Color? syntaxAttributeName,
    Color? syntaxPropertyName,
    Color? syntaxTag,
    Color? syntaxTagName,
    Color? syntaxType,
    Color? syntaxTypeName,
    Color? syntaxClassName,
    Color? syntaxNamespace,
    Color? syntaxMacroName,
    Color? syntaxAtom,
    Color? syntaxLiteral,
    Color? syntaxBool,
    Color? syntaxNull,
    Color? syntaxSelf,
    Color? syntaxNumber,
    Color? syntaxInteger,
    Color? syntaxFloat,
    Color? syntaxUnit,
    Color? syntaxCharacter,
    Color? syntaxAttributeValue,
    Color? syntaxSpecialString,
    Color? syntaxRegexp,
    Color? syntaxEscape,
    Color? syntaxUrl,
    Color? syntaxColor,
  }) {
    return CarbonSyntaxThemeData(
      syntaxComment: syntaxComment ?? this.syntaxComment,
      syntaxLineComment: syntaxLineComment ?? this.syntaxLineComment,
      syntaxBlockComment: syntaxBlockComment ?? this.syntaxBlockComment,
      syntaxDocComment: syntaxDocComment ?? this.syntaxDocComment,
      syntaxString: syntaxString ?? this.syntaxString,
      syntaxDocString: syntaxDocString ?? this.syntaxDocString,
      syntaxKeyword: syntaxKeyword ?? this.syntaxKeyword,
      syntaxOperatorKeyword:
          syntaxOperatorKeyword ?? this.syntaxOperatorKeyword,
      syntaxControlKeyword: syntaxControlKeyword ?? this.syntaxControlKeyword,
      syntaxDefinitionKeyword:
          syntaxDefinitionKeyword ?? this.syntaxDefinitionKeyword,
      syntaxModuleKeyword: syntaxModuleKeyword ?? this.syntaxModuleKeyword,
      syntaxVariable: syntaxVariable ?? this.syntaxVariable,
      syntaxName: syntaxName ?? this.syntaxName,
      syntaxVariableName: syntaxVariableName ?? this.syntaxVariableName,
      syntaxLabelName: syntaxLabelName ?? this.syntaxLabelName,
      syntaxAttribute: syntaxAttribute ?? this.syntaxAttribute,
      syntaxAttributeName: syntaxAttributeName ?? this.syntaxAttributeName,
      syntaxPropertyName: syntaxPropertyName ?? this.syntaxPropertyName,
      syntaxTag: syntaxTag ?? this.syntaxTag,
      syntaxTagName: syntaxTagName ?? this.syntaxTagName,
      syntaxType: syntaxType ?? this.syntaxType,
      syntaxTypeName: syntaxTypeName ?? this.syntaxTypeName,
      syntaxClassName: syntaxClassName ?? this.syntaxClassName,
      syntaxNamespace: syntaxNamespace ?? this.syntaxNamespace,
      syntaxMacroName: syntaxMacroName ?? this.syntaxMacroName,
      syntaxAtom: syntaxAtom ?? this.syntaxAtom,
      syntaxLiteral: syntaxLiteral ?? this.syntaxLiteral,
      syntaxBool: syntaxBool ?? this.syntaxBool,
      syntaxNull: syntaxNull ?? this.syntaxNull,
      syntaxSelf: syntaxSelf ?? this.syntaxSelf,
      syntaxNumber: syntaxNumber ?? this.syntaxNumber,
      syntaxInteger: syntaxInteger ?? this.syntaxInteger,
      syntaxFloat: syntaxFloat ?? this.syntaxFloat,
      syntaxUnit: syntaxUnit ?? this.syntaxUnit,
      syntaxCharacter: syntaxCharacter ?? this.syntaxCharacter,
      syntaxAttributeValue: syntaxAttributeValue ?? this.syntaxAttributeValue,
      syntaxSpecialString: syntaxSpecialString ?? this.syntaxSpecialString,
      syntaxRegexp: syntaxRegexp ?? this.syntaxRegexp,
      syntaxEscape: syntaxEscape ?? this.syntaxEscape,
      syntaxUrl: syntaxUrl ?? this.syntaxUrl,
      syntaxColor: syntaxColor ?? this.syntaxColor,
    );
  }

  @override
  CarbonSyntaxThemeData lerp(
    ThemeExtension<CarbonSyntaxThemeData>? other,
    double t,
  ) {
    if (other is! CarbonSyntaxThemeData) return this;
    return CarbonSyntaxThemeData(
      syntaxComment: Color.lerp(syntaxComment, other.syntaxComment, t)!,
      syntaxLineComment: Color.lerp(
        syntaxLineComment,
        other.syntaxLineComment,
        t,
      )!,
      syntaxBlockComment: Color.lerp(
        syntaxBlockComment,
        other.syntaxBlockComment,
        t,
      )!,
      syntaxDocComment: Color.lerp(
        syntaxDocComment,
        other.syntaxDocComment,
        t,
      )!,
      syntaxString: Color.lerp(syntaxString, other.syntaxString, t)!,
      syntaxDocString: Color.lerp(syntaxDocString, other.syntaxDocString, t)!,
      syntaxKeyword: Color.lerp(syntaxKeyword, other.syntaxKeyword, t)!,
      syntaxOperatorKeyword: Color.lerp(
        syntaxOperatorKeyword,
        other.syntaxOperatorKeyword,
        t,
      )!,
      syntaxControlKeyword: Color.lerp(
        syntaxControlKeyword,
        other.syntaxControlKeyword,
        t,
      )!,
      syntaxDefinitionKeyword: Color.lerp(
        syntaxDefinitionKeyword,
        other.syntaxDefinitionKeyword,
        t,
      )!,
      syntaxModuleKeyword: Color.lerp(
        syntaxModuleKeyword,
        other.syntaxModuleKeyword,
        t,
      )!,
      syntaxVariable: Color.lerp(syntaxVariable, other.syntaxVariable, t)!,
      syntaxName: Color.lerp(syntaxName, other.syntaxName, t)!,
      syntaxVariableName: Color.lerp(
        syntaxVariableName,
        other.syntaxVariableName,
        t,
      )!,
      syntaxLabelName: Color.lerp(syntaxLabelName, other.syntaxLabelName, t)!,
      syntaxAttribute: Color.lerp(syntaxAttribute, other.syntaxAttribute, t)!,
      syntaxAttributeName: Color.lerp(
        syntaxAttributeName,
        other.syntaxAttributeName,
        t,
      )!,
      syntaxPropertyName: Color.lerp(
        syntaxPropertyName,
        other.syntaxPropertyName,
        t,
      )!,
      syntaxTag: Color.lerp(syntaxTag, other.syntaxTag, t)!,
      syntaxTagName: Color.lerp(syntaxTagName, other.syntaxTagName, t)!,
      syntaxType: Color.lerp(syntaxType, other.syntaxType, t)!,
      syntaxTypeName: Color.lerp(syntaxTypeName, other.syntaxTypeName, t)!,
      syntaxClassName: Color.lerp(syntaxClassName, other.syntaxClassName, t)!,
      syntaxNamespace: Color.lerp(syntaxNamespace, other.syntaxNamespace, t)!,
      syntaxMacroName: Color.lerp(syntaxMacroName, other.syntaxMacroName, t)!,
      syntaxAtom: Color.lerp(syntaxAtom, other.syntaxAtom, t)!,
      syntaxLiteral: Color.lerp(syntaxLiteral, other.syntaxLiteral, t)!,
      syntaxBool: Color.lerp(syntaxBool, other.syntaxBool, t)!,
      syntaxNull: Color.lerp(syntaxNull, other.syntaxNull, t)!,
      syntaxSelf: Color.lerp(syntaxSelf, other.syntaxSelf, t)!,
      syntaxNumber: Color.lerp(syntaxNumber, other.syntaxNumber, t)!,
      syntaxInteger: Color.lerp(syntaxInteger, other.syntaxInteger, t)!,
      syntaxFloat: Color.lerp(syntaxFloat, other.syntaxFloat, t)!,
      syntaxUnit: Color.lerp(syntaxUnit, other.syntaxUnit, t)!,
      syntaxCharacter: Color.lerp(syntaxCharacter, other.syntaxCharacter, t)!,
      syntaxAttributeValue: Color.lerp(
        syntaxAttributeValue,
        other.syntaxAttributeValue,
        t,
      )!,
      syntaxSpecialString: Color.lerp(
        syntaxSpecialString,
        other.syntaxSpecialString,
        t,
      )!,
      syntaxRegexp: Color.lerp(syntaxRegexp, other.syntaxRegexp, t)!,
      syntaxEscape: Color.lerp(syntaxEscape, other.syntaxEscape, t)!,
      syntaxUrl: Color.lerp(syntaxUrl, other.syntaxUrl, t)!,
      syntaxColor: Color.lerp(syntaxColor, other.syntaxColor, t)!,
    );
  }
}
