import '../../../component_themes/structured_list_theme_data.dart';
import '../../../../foundation/colors.dart';

/// White theme for Carbon structured list.
class WhiteStructuredListThemeData extends CarbonStructuredListThemeData {
  const WhiteStructuredListThemeData()
      : super(
          background: CarbonPalette.white,
          rowHover: CarbonPalette.gray10Hover,
          rowSelected: CarbonPalette.gray20,
          borderColor: CarbonPalette.gray30,
          headerBorderColor: CarbonPalette.gray50,
          headerTextColor: CarbonPalette.gray100,
          rowTextColor: CarbonPalette.gray100,
          helperTextColor: CarbonPalette.gray60,
          headerBackground: CarbonPalette.gray10,
        );
}
