import '../../../../foundation/colors.dart';
import '../../../component_themes/skeleton_theme_data.dart';

/// White Theme implementation of [CarbonSkeletonThemeData].
class WhiteSkeletonThemeData extends CarbonSkeletonThemeData {
  const WhiteSkeletonThemeData()
    : super(
        skeletonBackground: CarbonPalette.whiteHover,
        skeletonElement: CarbonPalette.gray30,
      );
}
