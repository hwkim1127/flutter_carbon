import '../../../../foundation/colors.dart';
import '../../../component_themes/skeleton_theme_data.dart';

/// Gray 100 Theme implementation of [CarbonSkeletonThemeData].
class G100SkeletonThemeData extends CarbonSkeletonThemeData {
  const G100SkeletonThemeData()
    : super(
        skeletonBackground:
            CarbonPalette.gray90, // adjusted lightness of gray100
        skeletonElement: CarbonPalette.gray80,
      );
}
