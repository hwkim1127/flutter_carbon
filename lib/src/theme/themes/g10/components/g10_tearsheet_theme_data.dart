import '../../../component_themes/tearsheet_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G10 theme for Carbon tearsheet.
class G10TearsheetThemeData extends CarbonTearsheetThemeData {
  const G10TearsheetThemeData()
    : super(
        background: CarbonPalette.gray10,
        overlayColor: CarbonPalette.overlay, // rgba(0,0,0,0.6)
        titleColor: CarbonPalette.gray100,
        subtitleColor: CarbonPalette.gray70,
        labelColor: CarbonPalette.gray70,
        borderColor: CarbonPalette.gray30,
        iconColor: CarbonPalette.gray100,
        dividerColor: CarbonPalette.gray30,
        influencerBackground: CarbonPalette.white,
      );
}
