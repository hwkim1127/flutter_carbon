import '../../../../foundation/colors.dart';
import '../../../component_themes/content_switcher_theme_data.dart';

/// White Theme implementation of [CarbonContentSwitcherThemeData].
///
/// According to Carbon Design System:
/// - Selected state: gray-20 background with gray-100 text
/// - Unselected state: white/transparent background with gray-100 text
/// - Hover state: gray-10 background
/// - Divider: border-subtle-01 (gray-30)
class WhiteContentSwitcherThemeData extends CarbonContentSwitcherThemeData {
  const WhiteContentSwitcherThemeData()
      : super(
          contentSwitcherSelected: CarbonPalette.gray20,
          contentSwitcherBackground: CarbonPalette.white,
          contentSwitcherBackgroundHover: CarbonPalette.gray10,
          contentSwitcherDivider: CarbonPalette.gray30,
          contentSwitcherTextOnColor: CarbonPalette.gray100,
        );
}
