import '../../../component_themes/structured_list_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G10 theme for Carbon structured list.
class G10StructuredListThemeData extends CarbonStructuredListThemeData {
  const G10StructuredListThemeData()
      : super(
          background: CarbonPalette.white,
          rowHover: CarbonPalette.whiteHover,
          rowSelected: CarbonPalette.gray20,
          borderColor: CarbonPalette.gray30,
          headerBorderColor: CarbonPalette.gray50,
          headerTextColor: CarbonPalette.gray100,
          rowTextColor: CarbonPalette.gray100,
          helperTextColor: CarbonPalette.gray60,
          headerBackground: CarbonPalette.gray10,
        );
}
