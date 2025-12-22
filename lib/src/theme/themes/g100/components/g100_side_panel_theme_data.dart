import '../../../component_themes/side_panel_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G100 theme for Carbon side panel.
class G100SidePanelThemeData extends CarbonSidePanelThemeData {
  const G100SidePanelThemeData()
    : super(
        background: CarbonPalette.gray100,
        overlayColor: CarbonPalette.overlay, // rgba(0,0,0,0.6)
        titleColor: CarbonPalette.gray10,
        subtitleColor: CarbonPalette.gray30,
        labelColor: CarbonPalette.gray30,
        borderColor: CarbonPalette.gray60,
        iconColor: CarbonPalette.gray10,
        dividerColor: CarbonPalette.gray60,
      );
}
