import '../../../../foundation/colors.dart';
import '../../../component_themes/breadcrumb_theme_data.dart';

class WhiteBreadcrumbThemeData extends CarbonBreadcrumbThemeData {
  const WhiteBreadcrumbThemeData()
      : super(
          linkColor: CarbonPalette.blue60,
          currentColor: CarbonPalette.gray100,
          separatorColor: CarbonPalette.gray100,
          linkHoverColor: CarbonPalette.blue70,
        );
}
