import '../../../../foundation/colors.dart';
import '../../../component_themes/page_header_theme_data.dart';

class G100PageHeaderThemeData extends CarbonPageHeaderThemeData {
  const G100PageHeaderThemeData()
      : super(
          background: CarbonPalette.gray100,
          titleText: CarbonPalette.gray10,
          subtitleText: CarbonPalette.gray30,
          descriptionText: CarbonPalette.gray30,
          icon: CarbonPalette.gray30,
          border: CarbonPalette.gray80,
          breadcrumbBackground: CarbonPalette.gray100,
          actionText: CarbonPalette.blue40,
          actionTextHover: CarbonPalette.blue30,
        );
}
