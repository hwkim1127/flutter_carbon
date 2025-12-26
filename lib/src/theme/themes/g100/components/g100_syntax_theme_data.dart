import '../../../../foundation/colors.dart';
import '../../../component_themes/syntax_theme_data.dart';

/// Gray 100 Theme implementation of [CarbonSyntaxThemeData].
class G100SyntaxThemeData extends CarbonSyntaxThemeData {
  const G100SyntaxThemeData()
      : super(
          syntaxComment: CarbonPalette.green40,
          syntaxLineComment: CarbonPalette.green40,
          syntaxBlockComment: CarbonPalette.green40,
          syntaxDocComment: CarbonPalette.green40,
          syntaxString: CarbonPalette.gray10, // textPrimary
          syntaxDocString: CarbonPalette.gray10,
          syntaxKeyword: CarbonPalette.blue50,
          syntaxOperatorKeyword: CarbonPalette.blue50,
          syntaxControlKeyword: CarbonPalette.purple40,
          syntaxDefinitionKeyword: CarbonPalette.cyan40,
          syntaxModuleKeyword: CarbonPalette.purple40,
          syntaxVariable: CarbonPalette.blue30,
          syntaxName: CarbonPalette.blue30,
          syntaxVariableName: CarbonPalette.blue30,
          syntaxLabelName: CarbonPalette.blue30,
          syntaxAttribute: CarbonPalette.cyan40,
          syntaxAttributeName: CarbonPalette.cyan40,
          syntaxPropertyName: CarbonPalette.cyan40,
          syntaxTag: CarbonPalette.teal30,
          syntaxTagName: CarbonPalette.teal30,
          syntaxType: CarbonPalette.teal30,
          syntaxTypeName: CarbonPalette.teal30,
          syntaxClassName: CarbonPalette.teal30,
          syntaxNamespace: CarbonPalette.teal30,
          syntaxMacroName: CarbonPalette.gray10, // textPrimary
          syntaxAtom: CarbonPalette.gray10,
          syntaxLiteral: CarbonPalette.gray10,
          syntaxBool: CarbonPalette.gray10,
          syntaxNull: CarbonPalette.gray10,
          syntaxSelf: CarbonPalette.teal30,
          syntaxNumber: CarbonPalette.green30,
          syntaxInteger: CarbonPalette.green30,
          syntaxFloat: CarbonPalette.green30,
          syntaxUnit: CarbonPalette.green30,
          syntaxCharacter: CarbonPalette.gray10,
          syntaxAttributeValue: CarbonPalette.gray10,
          syntaxSpecialString: CarbonPalette.purple40,
          syntaxRegexp: CarbonPalette.purple40,
          syntaxEscape: CarbonPalette.gray20,
          syntaxUrl: CarbonPalette.gray20,
          syntaxColor: CarbonPalette.gray10,
        );
}
