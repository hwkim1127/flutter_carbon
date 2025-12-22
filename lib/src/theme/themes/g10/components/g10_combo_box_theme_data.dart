import '../../../component_themes/combo_box_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G10 theme for Carbon combo box.
class G10ComboBoxThemeData extends CarbonComboBoxThemeData {
  const G10ComboBoxThemeData()
      : super(
          fieldBackground: CarbonPalette.white,
          fieldBackgroundHover: CarbonPalette.whiteHover,
          fieldBorder: CarbonPalette.gray50,
          fieldBorderFocus: CarbonPalette.blue60,
          fieldBorderError: CarbonPalette.red60,
          textColor: CarbonPalette.gray100,
          textColorDisabled: CarbonPalette.gray50,
          placeholderColor: CarbonPalette.gray60,
          iconColor: CarbonPalette.gray100,
          iconColorDisabled: CarbonPalette.gray50,
          menuBackground: CarbonPalette.white,
          menuItemHover: CarbonPalette.whiteHover,
          menuItemSelected: CarbonPalette.gray20,
          menuItemText: CarbonPalette.gray100,
          menuItemTextDisabled: CarbonPalette.gray50,
          dividerColor: CarbonPalette.gray30,
        );
}
