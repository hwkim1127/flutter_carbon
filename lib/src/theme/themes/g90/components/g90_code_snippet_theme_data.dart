import '../../../component_themes/code_snippet_theme_data.dart';
import '../../../../foundation/colors.dart';

/// Gray 90 theme for Carbon code snippet.
class G90CodeSnippetThemeData extends CarbonCodeSnippetThemeData {
  const G90CodeSnippetThemeData()
      : super(
          background: CarbonPalette.gray80,
          codeText: CarbonPalette.gray10,
          border: CarbonPalette.gray70,
          copyButtonBackground: CarbonPalette.gray80,
          copyButtonBackgroundHover: CarbonPalette.gray80Hover,
          copyButtonIcon: CarbonPalette.gray10,
        );
}
