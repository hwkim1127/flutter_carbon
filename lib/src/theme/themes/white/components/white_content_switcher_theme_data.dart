import '../../../../foundation/colors.dart';
import '../../../component_themes/content_switcher_theme_data.dart';

/// White Theme implementation of [CarbonContentSwitcherThemeData].
///
/// According to Carbon Design System (v11 component tokens):
/// - Container background: gray-20
/// - Selected state: white with gray-100 text
/// - Hover state: gray-20-hover
/// - Divider: border-subtle-01 (gray-30)
class WhiteContentSwitcherThemeData extends CarbonContentSwitcherThemeData {
  const WhiteContentSwitcherThemeData()
      : super(
          contentSwitcherSelected: CarbonPalette.white,
          contentSwitcherBackground: CarbonPalette.gray20,
          contentSwitcherBackgroundHover: CarbonPalette.gray20Hover,
          contentSwitcherDivider: CarbonPalette.gray30,
          contentSwitcherTextOnColor: CarbonPalette.gray100,
        );
}
