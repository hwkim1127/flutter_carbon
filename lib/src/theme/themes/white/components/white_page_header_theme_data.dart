import '../../../../foundation/colors.dart';
import '../../../component_themes/page_header_theme_data.dart';

class WhitePageHeaderThemeData extends CarbonPageHeaderThemeData {
  const WhitePageHeaderThemeData()
      : super(
          background: CarbonPalette.white,
          titleText: CarbonPalette.gray100,
          subtitleText: CarbonPalette.gray70,
          descriptionText: CarbonPalette.gray70,
          icon: CarbonPalette.gray70,
          border: CarbonPalette.gray30,
          breadcrumbBackground: CarbonPalette.white,
          actionText: CarbonPalette.blue60,
          actionTextHover: CarbonPalette.blue70,
        );
}
