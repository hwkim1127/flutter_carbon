import '../../../component_themes/tree_view_theme_data.dart';
import '../../../../foundation/colors.dart';

/// White theme for Carbon tree view.
class WhiteTreeViewThemeData extends CarbonTreeViewThemeData {
  const WhiteTreeViewThemeData()
      : super(
          background: CarbonPalette.white,
          nodeHover: CarbonPalette.gray10Hover,
          nodeSelected: CarbonPalette.gray20,
          nodeTextColor: CarbonPalette.gray100,
          iconColor: CarbonPalette.gray100,
          borderColor: CarbonPalette.gray30,
          lineColor: CarbonPalette.gray30,
        );
}
