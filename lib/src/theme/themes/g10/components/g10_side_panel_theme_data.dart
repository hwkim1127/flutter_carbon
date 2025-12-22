import '../../../component_themes/side_panel_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G10 theme for Carbon side panel.
class G10SidePanelThemeData extends CarbonSidePanelThemeData {
  const G10SidePanelThemeData()
    : super(
        background: CarbonPalette.white,
        overlayColor: CarbonPalette.overlay, // rgba(0,0,0,0.6)
        titleColor: CarbonPalette.gray100,
        subtitleColor: CarbonPalette.gray70,
        labelColor: CarbonPalette.gray70,
        borderColor: CarbonPalette.gray30,
        iconColor: CarbonPalette.gray100,
        dividerColor: CarbonPalette.gray30,
      );
}
