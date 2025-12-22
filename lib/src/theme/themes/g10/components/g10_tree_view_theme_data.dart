import '../../../component_themes/tree_view_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G10 theme for Carbon tree view.
class G10TreeViewThemeData extends CarbonTreeViewThemeData {
  const G10TreeViewThemeData()
      : super(
          background: CarbonPalette.white,
          nodeHover: CarbonPalette.whiteHover,
          nodeSelected: CarbonPalette.gray20,
          nodeTextColor: CarbonPalette.gray100,
          iconColor: CarbonPalette.gray100,
          borderColor: CarbonPalette.gray30,
          lineColor: CarbonPalette.gray30,
        );
}
