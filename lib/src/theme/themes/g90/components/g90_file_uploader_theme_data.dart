import '../../../component_themes/file_uploader_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G90 theme for Carbon file uploader.
class G90FileUploaderThemeData extends CarbonFileUploaderThemeData {
  const G90FileUploaderThemeData()
      : super(
          dropZoneBackground: CarbonPalette.gray90,
          dropZoneBorder: CarbonPalette.gray60,
          dropZoneDragBackground: CarbonPalette.gray80,
          dropZoneDragBorder: CarbonPalette.blue40,
          dropZoneLabelColor: CarbonPalette.gray30,
          labelColor: CarbonPalette.gray10,
          descriptionColor: CarbonPalette.gray30,
          filenameColor: CarbonPalette.gray10,
          fileItemIconColor: CarbonPalette.gray10,
          fileItemHoverBackground: CarbonPalette.gray80Hover,
          completeColor: CarbonPalette.green40,
          errorColor: CarbonPalette.red40,
          errorTextColor: CarbonPalette.red40,
        );
}
