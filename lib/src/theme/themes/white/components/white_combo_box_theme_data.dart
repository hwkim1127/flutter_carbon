import '../../../component_themes/combo_box_theme_data.dart';
import '../../../../foundation/colors.dart';

/// White theme for Carbon combo box.
class WhiteComboBoxThemeData extends CarbonComboBoxThemeData {
  const WhiteComboBoxThemeData()
      : super(
          fieldBackground: CarbonPalette.gray10,
          fieldBackgroundHover: CarbonPalette.gray10Hover,
          fieldBorder: CarbonPalette.gray50,
          fieldBorderFocus: CarbonPalette.blue60,
          fieldBorderError: CarbonPalette.red60,
          textColor: CarbonPalette.gray100,
          textColorDisabled: CarbonPalette.gray50,
          placeholderColor: CarbonPalette.gray60,
          iconColor: CarbonPalette.gray100,
          iconColorDisabled: CarbonPalette.gray50,
          menuBackground: CarbonPalette.gray10,
          menuItemHover: CarbonPalette.gray10Hover,
          menuItemSelected: CarbonPalette.gray20,
          menuItemText: CarbonPalette.gray100,
          menuItemTextDisabled: CarbonPalette.gray50,
          dividerColor: CarbonPalette.gray30,
        );
}
