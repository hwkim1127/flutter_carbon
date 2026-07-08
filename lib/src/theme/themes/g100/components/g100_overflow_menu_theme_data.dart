import '../../../../foundation/colors.dart';
import '../../../component_themes/overflow_menu_theme_data.dart';

class G100OverflowMenuThemeData extends CarbonOverflowMenuThemeData {
  const G100OverflowMenuThemeData()
      : super(
          triggerBackground: CarbonPalette.transparent,
          triggerBackgroundHover: CarbonPalette.gray80Hover,
          triggerIcon: CarbonPalette.gray10,
          menuBackground: CarbonPalette.gray90,
          menuBorder: CarbonPalette.gray70,
          menuShadow: CarbonPalette.black,
          itemBackground: CarbonPalette.transparent,
          itemBackgroundHover: CarbonPalette.gray80Hover,
          itemText: CarbonPalette.gray10,
          itemTextHover: CarbonPalette.gray10,
          itemDangerText: CarbonPalette.red40,
          itemDangerTextHover: CarbonPalette.red30,
          divider: CarbonPalette.gray70,
        );
}
