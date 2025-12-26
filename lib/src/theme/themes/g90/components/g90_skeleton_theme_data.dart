import '../../../../foundation/colors.dart';
import '../../../component_themes/skeleton_theme_data.dart';

/// Gray 90 Theme implementation of [CarbonSkeletonThemeData].
class G90SkeletonThemeData extends CarbonSkeletonThemeData {
  const G90SkeletonThemeData()
      : super(
          skeletonBackground: CarbonPalette.gray90Hover,
          skeletonElement: CarbonPalette.gray70,
        );
}
