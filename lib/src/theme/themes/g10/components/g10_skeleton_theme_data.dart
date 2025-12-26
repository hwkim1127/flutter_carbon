import '../../../../foundation/colors.dart';
import '../../../component_themes/skeleton_theme_data.dart';

/// Gray 10 Theme implementation of [CarbonSkeletonThemeData].
class G10SkeletonThemeData extends CarbonSkeletonThemeData {
  const G10SkeletonThemeData()
      : super(
          skeletonBackground:
              CarbonPalette.gray10Hover, // Changed from White (whiteHover)
          skeletonElement: CarbonPalette.gray30,
        );
}
