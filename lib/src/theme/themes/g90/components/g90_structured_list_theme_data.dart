import '../../../component_themes/structured_list_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G90 theme for Carbon structured list.
class G90StructuredListThemeData extends CarbonStructuredListThemeData {
  const G90StructuredListThemeData()
      : super(
          background: CarbonPalette.gray90,
          rowHover: CarbonPalette.gray80Hover,
          rowSelected: CarbonPalette.gray70,
          borderColor: CarbonPalette.gray60,
          headerBorderColor: CarbonPalette.gray50,
          headerTextColor: CarbonPalette.gray10,
          rowTextColor: CarbonPalette.gray10,
          helperTextColor: CarbonPalette.gray60,
          headerBackground: CarbonPalette.gray80,
        );
}
