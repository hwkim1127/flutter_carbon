import '../../../../foundation/colors.dart';
import '../../../component_themes/page_header_theme_data.dart';

class G90PageHeaderThemeData extends CarbonPageHeaderThemeData {
  const G90PageHeaderThemeData()
      : super(
          background: CarbonPalette.gray90,
          titleText: CarbonPalette.gray10,
          subtitleText: CarbonPalette.gray30,
          descriptionText: CarbonPalette.gray30,
          icon: CarbonPalette.gray30,
          border: CarbonPalette.gray70,
          breadcrumbBackground: CarbonPalette.gray90,
          actionText: CarbonPalette.blue40,
          actionTextHover: CarbonPalette.blue30,
        );
}
