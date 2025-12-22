import '../../../component_themes/combo_box_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G100 theme for Carbon combo box.
class G100ComboBoxThemeData extends CarbonComboBoxThemeData {
  const G100ComboBoxThemeData()
      : super(
          fieldBackground: CarbonPalette.gray90,
          fieldBackgroundHover: CarbonPalette.gray90Hover,
          fieldBorder: CarbonPalette.gray50,
          fieldBorderFocus: CarbonPalette.blue40,
          fieldBorderError: CarbonPalette.red50,
          textColor: CarbonPalette.gray10,
          textColorDisabled: CarbonPalette.gray50,
          placeholderColor: CarbonPalette.gray60,
          iconColor: CarbonPalette.gray10,
          iconColorDisabled: CarbonPalette.gray50,
          menuBackground: CarbonPalette.gray90,
          menuItemHover: CarbonPalette.gray90Hover,
          menuItemSelected: CarbonPalette.gray80,
          menuItemText: CarbonPalette.gray10,
          menuItemTextDisabled: CarbonPalette.gray50,
          dividerColor: CarbonPalette.gray60,
        );
}
