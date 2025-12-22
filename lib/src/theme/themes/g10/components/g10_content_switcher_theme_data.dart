import '../../../../foundation/colors.dart';
import '../../../component_themes/content_switcher_theme_data.dart';

/// Gray 10 Theme implementation of [CarbonContentSwitcherThemeData].
class G10ContentSwitcherThemeData extends CarbonContentSwitcherThemeData {
  const G10ContentSwitcherThemeData()
    : super(
        contentSwitcherSelected: CarbonPalette.white,
        contentSwitcherDivider: CarbonPalette.white,
        contentSwitcherTextOnColor: CarbonPalette.white,
        contentSwitcherBackground: CarbonPalette.gray20,
        contentSwitcherBackgroundHover: CarbonPalette.gray20Hover,
      );
}
