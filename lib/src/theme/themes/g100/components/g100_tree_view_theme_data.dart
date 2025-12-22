import '../../../component_themes/tree_view_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G100 theme for Carbon tree view.
class G100TreeViewThemeData extends CarbonTreeViewThemeData {
  const G100TreeViewThemeData()
      : super(
          background: CarbonPalette.gray100,
          nodeHover: CarbonPalette.gray90Hover,
          nodeSelected: CarbonPalette.gray80,
          nodeTextColor: CarbonPalette.gray10,
          iconColor: CarbonPalette.gray10,
          borderColor: CarbonPalette.gray60,
          lineColor: CarbonPalette.gray60,
        );
}
