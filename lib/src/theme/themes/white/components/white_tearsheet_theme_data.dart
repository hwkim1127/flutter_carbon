import '../../../component_themes/tearsheet_theme_data.dart';
import '../../../../foundation/colors.dart';

/// White theme for Carbon tearsheet.
class WhiteTearsheetThemeData extends CarbonTearsheetThemeData {
  const WhiteTearsheetThemeData()
      : super(
          background: CarbonPalette.white,
          overlayColor: CarbonPalette.overlay, // rgba(0,0,0,0.6)
          titleColor: CarbonPalette.gray100,
          subtitleColor: CarbonPalette.gray70,
          labelColor: CarbonPalette.gray70,
          borderColor: CarbonPalette.gray30,
          iconColor: CarbonPalette.gray100,
          dividerColor: CarbonPalette.gray30,
          influencerBackground: CarbonPalette.gray10,
        );
}
