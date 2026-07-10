import '../../../component_themes/code_snippet_theme_data.dart';
import '../../../../foundation/colors.dart';

/// Gray 100 theme for Carbon code snippet.
class G100CodeSnippetThemeData extends CarbonCodeSnippetThemeData {
  const G100CodeSnippetThemeData()
      : super(
          background: CarbonPalette.gray90,
          codeText: CarbonPalette.gray10,
          copyButtonBackground: CarbonPalette.gray90,
          copyButtonBackgroundHover: CarbonPalette.gray90Hover,
          copyButtonBackgroundActive: CarbonPalette.gray70,
          copyButtonIcon: CarbonPalette.gray10,
        );
}
