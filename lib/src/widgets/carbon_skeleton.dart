import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Carbon Design System skeleton loader widget with shimmer animation.
///
/// Skeleton loaders are used to show that content is loading.
/// They provide a low-fidelity representation of the content that will appear.
///
/// Example:
/// ```dart
/// CarbonSkeleton.rectangle(
///   width: 200,
///   height: 24,
/// )
///
/// CarbonSkeleton.text(
///   lines: 3,
/// )
/// ```
class CarbonSkeleton extends StatefulWidget {
  /// The width of the skeleton. If null, takes full available width.
  final double? width;

  /// The height of the skeleton.
  final double height;

  /// The border radius of the skeleton. Defaults to 0 (Carbon style).
  final BorderRadius? borderRadius;

  /// Whether to show the shimmer animation. Defaults to true.
  final bool animate;

  const CarbonSkeleton({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
    this.animate = true,
  });

  /// Creates a rectangular skeleton loader.
  ///
  /// Use this for content placeholders like images, avatars, or custom shapes.
  const CarbonSkeleton.rectangle({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
    this.animate = true,
  });

  /// Creates a text skeleton loader with multiple lines.
  ///
  /// This returns a Widget (not CarbonSkeleton) that contains multiple skeleton lines.
  ///
  /// [lines] - Number of text lines to show
  /// [lineHeight] - Height of each line (defaults to 16)
  /// [spacing] - Spacing between lines (defaults to 8)
  /// [lastLineWidth] - Width of the last line as fraction of full width (defaults to 0.7)
  static Widget text({
    Key? key,
    int lines = 3,
    double lineHeight = 16,
    double spacing = 8,
    double lastLineWidth = 0.7,
    bool animate = true,
  }) {
    return _CarbonSkeletonText(
      key: key,
      lines: lines,
      lineHeight: lineHeight,
      spacing: spacing,
      lastLineWidth: lastLineWidth,
      animate: animate,
    );
  }

  /// Creates a circular skeleton loader.
  ///
  /// Use this for avatars or circular placeholders.
  const CarbonSkeleton.circle({
    super.key,
    required double size,
    bool animateCircle = true,
  })  : width = size,
        height = size,
        borderRadius = const BorderRadius.all(Radius.circular(1000)),
        animate = animateCircle;

  @override
  State<CarbonSkeleton> createState() => _CarbonSkeletonState();
}

class _CarbonSkeletonState extends State<CarbonSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1250),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(CarbonSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final baseColor = carbon.skeleton.skeletonBackground;
    final highlightColor = carbon.skeleton.skeletonElement;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
      ),
      child: widget.animate
          ? AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: widget.borderRadius ?? BorderRadius.zero,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [baseColor, highlightColor, baseColor],
                      stops: [
                        _animation.value - 0.3,
                        _animation.value,
                        _animation.value + 0.3,
                      ].map((e) => e.clamp(0.0, 1.0)).toList(),
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}

/// Text variant of skeleton loader - internal implementation
class _CarbonSkeletonText extends StatelessWidget {
  final int lines;
  final double lineHeight;
  final double spacing;
  final double lastLineWidth;
  final bool animate;

  const _CarbonSkeletonText({
    super.key,
    required this.lines,
    required this.lineHeight,
    required this.spacing,
    required this.lastLineWidth,
    required this.animate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lines, (index) {
        final isLastLine = index == lines - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? spacing : 0),
          child: CarbonSkeleton(
            width: isLastLine ? null : null,
            height: lineHeight,
            animate: animate,
            // Make last line shorter to look more natural
            key: ValueKey('line_$index'),
          ),
        );
      }).map((skeleton) {
        // Wrap last line with FractionallySizedBox
        if (skeleton.key == ValueKey('line_${lines - 1}')) {
          return FractionallySizedBox(
            widthFactor: lastLineWidth,
            alignment: Alignment.centerLeft,
            child: skeleton,
          );
        }
        return skeleton;
      }).toList(),
    );
  }
}
