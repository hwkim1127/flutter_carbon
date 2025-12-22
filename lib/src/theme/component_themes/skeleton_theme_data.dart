import 'package:flutter/material.dart';

@immutable
class CarbonSkeletonThemeData extends ThemeExtension<CarbonSkeletonThemeData> {
  final Color skeletonBackground;
  final Color skeletonElement;

  const CarbonSkeletonThemeData({
    required this.skeletonBackground,
    required this.skeletonElement,
  });

  @override
  CarbonSkeletonThemeData copyWith({
    Color? skeletonBackground,
    Color? skeletonElement,
  }) {
    return CarbonSkeletonThemeData(
      skeletonBackground: skeletonBackground ?? this.skeletonBackground,
      skeletonElement: skeletonElement ?? this.skeletonElement,
    );
  }

  @override
  CarbonSkeletonThemeData lerp(
    ThemeExtension<CarbonSkeletonThemeData>? other,
    double t,
  ) {
    if (other is! CarbonSkeletonThemeData) return this;
    return CarbonSkeletonThemeData(
      skeletonBackground: Color.lerp(
        skeletonBackground,
        other.skeletonBackground,
        t,
      )!,
      skeletonElement: Color.lerp(skeletonElement, other.skeletonElement, t)!,
    );
  }
}
