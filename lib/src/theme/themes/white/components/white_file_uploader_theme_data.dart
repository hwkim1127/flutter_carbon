import '../../../component_themes/file_uploader_theme_data.dart';
import '../../../../foundation/colors.dart';

/// White theme for Carbon file uploader.
class WhiteFileUploaderThemeData extends CarbonFileUploaderThemeData {
  const WhiteFileUploaderThemeData()
      : super(
          dropZoneBackground: CarbonPalette.white,
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
