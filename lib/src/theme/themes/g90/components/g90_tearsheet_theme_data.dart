import '../../../component_themes/tearsheet_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G90 theme for Carbon tearsheet.
class G90TearsheetThemeData extends CarbonTearsheetThemeData {
  const G90TearsheetThemeData()
    : super(
        background: CarbonPalette.gray90,
        overlayColor: CarbonPalette.overlay, // rgba(0,0,0,0.6)
        titleColor: CarbonPalette.gray10,
        subtitleColor: CarbonPalette.gray30,
        labelColor: CarbonPalette.gray30,
        borderColor: CarbonPalette.gray70,
        iconColor: CarbonPalette.gray10,
        dividerColor: CarbonPalette.gray70,
        influencerBackground: CarbonPalette.gray80,
      );
}
