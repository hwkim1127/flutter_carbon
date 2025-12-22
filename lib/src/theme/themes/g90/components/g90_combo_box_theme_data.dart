import '../../../component_themes/combo_box_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G90 theme for Carbon combo box.
class G90ComboBoxThemeData extends CarbonComboBoxThemeData {
  const G90ComboBoxThemeData()
      : super(
          fieldBackground: CarbonPalette.gray80,
          fieldBackgroundHover: CarbonPalette.gray80Hover,
          fieldBorder: CarbonPalette.gray50,
          fieldBorderFocus: CarbonPalette.blue40,
          fieldBorderError: CarbonPalette.red50,
          textColor: CarbonPalette.gray10,
          textColorDisabled: CarbonPalette.gray50,
          placeholderColor: CarbonPalette.gray60,
          iconColor: CarbonPalette.gray10,
          iconColorDisabled: CarbonPalette.gray50,
          menuBackground: CarbonPalette.gray80,
          menuItemHover: CarbonPalette.gray80Hover,
          menuItemSelected: CarbonPalette.gray70,
          menuItemText: CarbonPalette.gray10,
          menuItemTextDisabled: CarbonPalette.gray50,
          dividerColor: CarbonPalette.gray60,
        );
}
