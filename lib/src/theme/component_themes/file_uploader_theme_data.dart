import 'package:flutter/material.dart';

/// Theme data for Carbon file uploader components.
@immutable
class CarbonFileUploaderThemeData
    extends ThemeExtension<CarbonFileUploaderThemeData> {
  /// Background color for drop zone.
  final Color dropZoneBackground;

  /// Border color for drop zone.
  final Color dropZoneBorder;

  /// Background color when dragging over drop zone.
  final Color dropZoneDragBackground;

  /// Border color when dragging over drop zone.
  final Color dropZoneDragBorder;

  /// Text color for drop zone label.
  final Color dropZoneLabelColor;

  /// Text color for file uploader label.
  final Color labelColor;

  /// Text color for file uploader description.
  final Color descriptionColor;

  /// Text color for filename.
  final Color filenameColor;

  /// Icon color for file item actions.
  final Color fileItemIconColor;

  /// Background color for file item on hover.
  final Color fileItemHoverBackground;

  /// Color for complete/success state.
  final Color completeColor;

  /// Color for error/invalid state.
  final Color errorColor;

  /// Text color for error messages.
  final Color errorTextColor;

  const CarbonFileUploaderThemeData({
    required this.dropZoneBackground,
    required this.dropZoneBorder,
    required this.dropZoneDragBackground,
    required this.dropZoneDragBorder,
    required this.dropZoneLabelColor,
    required this.labelColor,
    required this.descriptionColor,
    required this.filenameColor,
    required this.fileItemIconColor,
    required this.fileItemHoverBackground,
    required this.completeColor,
    required this.errorColor,
    required this.errorTextColor,
  });

  @override
  CarbonFileUploaderThemeData copyWith({
    Color? dropZoneBackground,
    Color? dropZoneBorder,
    Color? dropZoneDragBackground,
    Color? dropZoneDragBorder,
    Color? dropZoneLabelColor,
    Color? labelColor,
    Color? descriptionColor,
    Color? filenameColor,
    Color? fileItemIconColor,
    Color? fileItemHoverBackground,
    Color? completeColor,
    Color? errorColor,
    Color? errorTextColor,
  }) {
    return CarbonFileUploaderThemeData(
      dropZoneBackground: dropZoneBackground ?? this.dropZoneBackground,
      dropZoneBorder: dropZoneBorder ?? this.dropZoneBorder,
      dropZoneDragBackground:
          dropZoneDragBackground ?? this.dropZoneDragBackground,
      dropZoneDragBorder: dropZoneDragBorder ?? this.dropZoneDragBorder,
      dropZoneLabelColor: dropZoneLabelColor ?? this.dropZoneLabelColor,
      labelColor: labelColor ?? this.labelColor,
      descriptionColor: descriptionColor ?? this.descriptionColor,
      filenameColor: filenameColor ?? this.filenameColor,
      fileItemIconColor: fileItemIconColor ?? this.fileItemIconColor,
      fileItemHoverBackground:
          fileItemHoverBackground ?? this.fileItemHoverBackground,
      completeColor: completeColor ?? this.completeColor,
      errorColor: errorColor ?? this.errorColor,
      errorTextColor: errorTextColor ?? this.errorTextColor,
    );
  }

  @override
  CarbonFileUploaderThemeData lerp(
      ThemeExtension<CarbonFileUploaderThemeData>? other, double t) {
    if (other is! CarbonFileUploaderThemeData) return this;
    return CarbonFileUploaderThemeData(
      dropZoneBackground:
          Color.lerp(dropZoneBackground, other.dropZoneBackground, t)!,
      dropZoneBorder: Color.lerp(dropZoneBorder, other.dropZoneBorder, t)!,
      dropZoneDragBackground:
          Color.lerp(dropZoneDragBackground, other.dropZoneDragBackground, t)!,
      dropZoneDragBorder:
          Color.lerp(dropZoneDragBorder, other.dropZoneDragBorder, t)!,
      dropZoneLabelColor:
          Color.lerp(dropZoneLabelColor, other.dropZoneLabelColor, t)!,
      labelColor: Color.lerp(labelColor, other.labelColor, t)!,
      descriptionColor:
          Color.lerp(descriptionColor, other.descriptionColor, t)!,
      filenameColor: Color.lerp(filenameColor, other.filenameColor, t)!,
      fileItemIconColor:
          Color.lerp(fileItemIconColor, other.fileItemIconColor, t)!,
      fileItemHoverBackground: Color.lerp(
          fileItemHoverBackground, other.fileItemHoverBackground, t)!,
      completeColor: Color.lerp(completeColor, other.completeColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      errorTextColor: Color.lerp(errorTextColor, other.errorTextColor, t)!,
    );
  }
}
