import '../../../component_themes/tearsheet_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G100 theme for Carbon tearsheet.
class G100TearsheetThemeData extends CarbonTearsheetThemeData {
  const G100TearsheetThemeData()
      : super(
          background: CarbonPalette.gray100,
          overlayColor: CarbonPalette.overlay, // rgba(0,0,0,0.6)
          titleColor: CarbonPalette.gray10,
          subtitleColor: CarbonPalette.gray30,
          labelColor: CarbonPalette.gray30,
          borderColor: CarbonPalette.gray80,
          iconColor: CarbonPalette.gray10,
          dividerColor: CarbonPalette.gray80,
          influencerBackground: CarbonPalette.gray90,
        );
}
