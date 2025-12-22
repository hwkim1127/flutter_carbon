import 'package:flutter/material.dart';

/// Theme data for Carbon tree view (hierarchical tree with expand/collapse).
@immutable
class CarbonTreeViewThemeData extends ThemeExtension<CarbonTreeViewThemeData> {
  /// Background color for the tree.
  final Color background;

  /// Background color for node on hover.
  final Color nodeHover;

  /// Background color for selected node.
  final Color nodeSelected;

  /// Text color for node labels.
  final Color nodeTextColor;

  /// Icon color for expand/collapse icons.
  final Color iconColor;

  /// Border color for the tree.
  final Color borderColor;

  /// Color for connecting lines between nodes.
  final Color lineColor;

  const CarbonTreeViewThemeData({
    required this.background,
    required this.nodeHover,
    required this.nodeSelected,
    required this.nodeTextColor,
    required this.iconColor,
    required this.borderColor,
    required this.lineColor,
  });

  @override
  CarbonTreeViewThemeData copyWith({
    Color? background,
    Color? nodeHover,
    Color? nodeSelected,
    Color? nodeTextColor,
    Color? iconColor,
    Color? borderColor,
    Color? lineColor,
  }) {
    return CarbonTreeViewThemeData(
      background: background ?? this.background,
      nodeHover: nodeHover ?? this.nodeHover,
      nodeSelected: nodeSelected ?? this.nodeSelected,
      nodeTextColor: nodeTextColor ?? this.nodeTextColor,
      iconColor: iconColor ?? this.iconColor,
      borderColor: borderColor ?? this.borderColor,
      lineColor: lineColor ?? this.lineColor,
    );
  }

  @override
  CarbonTreeViewThemeData lerp(
      ThemeExtension<CarbonTreeViewThemeData>? other, double t) {
    if (other is! CarbonTreeViewThemeData) return this;
    return CarbonTreeViewThemeData(
      background: Color.lerp(background, other.background, t)!,
      nodeHover: Color.lerp(nodeHover, other.nodeHover, t)!,
      nodeSelected: Color.lerp(nodeSelected, other.nodeSelected, t)!,
      nodeTextColor: Color.lerp(nodeTextColor, other.nodeTextColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      lineColor: Color.lerp(lineColor, other.lineColor, t)!,
    );
  }
}
