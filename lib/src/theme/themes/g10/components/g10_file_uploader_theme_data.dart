import '../../../component_themes/file_uploader_theme_data.dart';
import '../../../../foundation/colors.dart';

/// G10 theme for Carbon file uploader.
class G10FileUploaderThemeData extends CarbonFileUploaderThemeData {
  const G10FileUploaderThemeData()
      : super(
          dropZoneBackground: CarbonPalette.gray10,
          dropZoneBorder: CarbonPalette.gray40,
          dropZoneDragBackground: CarbonPalette.blue10,
          dropZoneDragBorder: CarbonPalette.blue60,
          dropZoneLabelColor: CarbonPalette.gray70,
          labelColor: CarbonPalette.gray100,
          descriptionColor: CarbonPalette.gray70,
          filenameColor: CarbonPalette.gray100,
          fileItemIconColor: CarbonPalette.gray100,
          fileItemHoverBackground: CarbonPalette.gray10Hover,
          completeColor: CarbonPalette.green60,
          errorColor: CarbonPalette.red60,
          errorTextColor: CarbonPalette.red60,
        );
}
