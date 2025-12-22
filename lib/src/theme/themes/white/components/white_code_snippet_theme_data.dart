import '../../../component_themes/code_snippet_theme_data.dart';
import '../../../../foundation/colors.dart';

/// White theme for Carbon code snippet.
class WhiteCodeSnippetThemeData extends CarbonCodeSnippetThemeData {
  const WhiteCodeSnippetThemeData()
      : super(
          background: CarbonPalette.gray10,
          codeText: CarbonPalette.gray100,
          border: CarbonPalette.gray30,
          copyButtonBackground: CarbonPalette.gray10,
          copyButtonBackgroundHover: CarbonPalette.gray10Hover,
          copyButtonIcon: CarbonPalette.gray100,
        );
}
