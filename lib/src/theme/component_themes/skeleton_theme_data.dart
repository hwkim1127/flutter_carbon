import 'package:flutter/widgets.dart';

@immutable
class CarbonSkeletonThemeData {
  final Color skeletonBackground;
  final Color skeletonElement;

  const CarbonSkeletonThemeData({
    required this.skeletonBackground,
    required this.skeletonElement,
  });

  CarbonSkeletonThemeData copyWith({
    Color? skeletonBackground,
    Color? skeletonElement,
  }) {
    return CarbonSkeletonThemeData(
      skeletonBackground: skeletonBackground ?? this.skeletonBackground,
      skeletonElement: skeletonElement ?? this.skeletonElement,
    );
  }

  CarbonSkeletonThemeData lerp(
    CarbonSkeletonThemeData? other,
    double t,
  ) {
    if (other == null) return this;
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
