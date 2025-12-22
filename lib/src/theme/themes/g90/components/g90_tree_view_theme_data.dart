import '../../../component_themes/tree_view_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G90 theme for Carbon tree view.
class G90TreeViewThemeData extends CarbonTreeViewThemeData {
  const G90TreeViewThemeData()
      : super(
          background: CarbonPalette.gray90,
          nodeHover: CarbonPalette.gray80Hover,
          nodeSelected: CarbonPalette.gray70,
          nodeTextColor: CarbonPalette.gray10,
          iconColor: CarbonPalette.gray10,
          borderColor: CarbonPalette.gray60,
          lineColor: CarbonPalette.gray60,
        );
}
