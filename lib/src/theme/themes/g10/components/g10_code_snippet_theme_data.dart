import '../../../component_themes/code_snippet_theme_data.dart';
import '../../../../foundation/colors.dart';

/// Gray 10 theme for Carbon code snippet.
class G10CodeSnippetThemeData extends CarbonCodeSnippetThemeData {
  const G10CodeSnippetThemeData()
      : super(
          background: CarbonPalette.white,
          codeText: CarbonPalette.gray100,
          border: CarbonPalette.gray30,
          copyButtonBackground: CarbonPalette.white,
          copyButtonBackgroundHover: CarbonPalette.gray10Hover,
          copyButtonIcon: CarbonPalette.gray100,
        );
}
