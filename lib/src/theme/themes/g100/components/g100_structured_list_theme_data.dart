import '../../../component_themes/structured_list_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G100 theme for Carbon structured list.
class G100StructuredListThemeData extends CarbonStructuredListThemeData {
  const G100StructuredListThemeData()
      : super(
          background: CarbonPalette.gray100,
          rowHover: CarbonPalette.gray90Hover,
          rowSelected: CarbonPalette.gray80,
          borderColor: CarbonPalette.gray60,
          headerBorderColor: CarbonPalette.gray50,
          headerTextColor: CarbonPalette.gray10,
          rowTextColor: CarbonPalette.gray10,
          helperTextColor: CarbonPalette.gray60,
          headerBackground: CarbonPalette.gray90,
        );
}
