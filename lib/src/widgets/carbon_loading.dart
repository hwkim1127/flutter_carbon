import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../foundation/colors.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// Loading size variants.
enum CarbonLoadingSize { small, medium, large }

/// Carbon Design System loading spinner.
///
/// Full-page or large loading indicator with circular spinner, drawn to the
/// Carbon spec (no Material dependency): a `$interactive`-colored arc —
/// 81% of the circle (48% for small, over a `$layer-accent` track) —
/// rotating at 690ms per turn.
///
/// Example:
/// ```dart
/// CarbonLoading(
///   size: CarbonLoadingSize.large,
///   withOverlay: true,
/// )
/// ```
class CarbonLoading extends StatelessWidget {
  /// The size of the loading spinner.
  final CarbonLoadingSize size;

  /// Whether to show a semi-transparent overlay behind the spinner.
  final bool withOverlay;

  /// Optional description text below the spinner.
  final String? description;

  const CarbonLoading({
    super.key,
    this.size = CarbonLoadingSize.large,
    this.withOverlay = false,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    final spinner = CarbonSpinner(
      size: _getSize(),
      small: size == CarbonLoadingSize.small,
      semanticsLabel: description ?? 'Loading',
    );

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        spinner,
        if (description != null) ...[
          const SizedBox(height: 16),
          Text(
            description!,
            style: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
          ),
        ],
      ],
    );

    if (withOverlay) {
      return Container(
        // $overlay already encodes its alpha (black @ 0.6).
        color: carbon.layer.overlay,
        child: Center(child: content),
      );
    }

    return content;
  }

  double _getSize() {
    switch (size) {
      case CarbonLoadingSize.small:
        return 16;
      case CarbonLoadingSize.medium:
        return 48;
      case CarbonLoadingSize.large:
        return 88;
    }
  }
}

/// Carbon Design System inline loading.
///
/// Small inline loading indicator used within buttons or other UI elements.
///
/// Example:
/// ```dart
/// CarbonInlineLoading(
///   status: CarbonInlineLoadingStatus.active,
///   description: 'Loading...',
/// )
/// ```
class CarbonInlineLoading extends StatelessWidget {
  /// The current loading status.
  final CarbonInlineLoadingStatus status;

  /// Optional description text.
  final String? description;

  const CarbonInlineLoading({
    super.key,
    required this.status,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatusIndicator(carbon),
        if (description != null) ...[
          const SizedBox(width: 8),
          Text(
            description!,
            style: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusIndicator(CarbonThemeData carbon) {
    switch (status) {
      case CarbonInlineLoadingStatus.inactive:
        return const SizedBox.shrink();

      case CarbonInlineLoadingStatus.active:
        return CarbonSpinner(
          size: 16,
          small: true,
          semanticsLabel: description ?? 'Loading',
        );

      case CarbonInlineLoadingStatus.finished:
        return Icon(
          CarbonIcons.checkmarkFilled,
          size: 16,
          color: carbon.status.statusGreen,
        );

      case CarbonInlineLoadingStatus.error:
        return Icon(
          CarbonIcons.errorFilled,
          size: 16,
          color: carbon.status.statusRed,
        );
    }
  }
}

/// Inline loading status states.
enum CarbonInlineLoadingStatus {
  /// Not loading, indicator hidden.
  inactive,

  /// Currently loading, showing spinner.
  active,

  /// Loading completed successfully, showing checkmark.
  finished,

  /// Loading failed, showing error icon.
  error,
}

/// The bare Carbon spinner: a rotating arc drawn to the Carbon loading spec.
///
/// Used by [CarbonLoading], [CarbonInlineLoading], and any widget that needs
/// an indeterminate spinner (e.g. file uploader items). Prefer [CarbonLoading]
/// for page-level loading states.
class CarbonSpinner extends StatefulWidget {
  /// Diameter of the spinner.
  final double size;

  /// Small variant: shorter arc (48% vs 81% of the circle), thicker relative
  /// stroke, and a `$layer-accent` background track — per the Carbon spec for
  /// the 16px loading indicator.
  final bool small;

  /// Accessibility label announced for the spinner.
  final String semanticsLabel;

  /// Arc color override. Defaults to the theme's `$interactive` token.
  final Color? color;

  const CarbonSpinner({
    super.key,
    required this.size,
    this.small = false,
    this.semanticsLabel = 'Loading',
    this.color,
  });

  @override
  State<CarbonSpinner> createState() => _CarbonSpinnerState();
}

class _CarbonSpinnerState extends State<CarbonSpinner>
    with SingleTickerProviderStateMixin {
  // Carbon `animation.spin`: one full rotation every 690ms, linear.
  static const _rotationDuration = Duration(milliseconds: 690);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _rotationDuration,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Semantics(
      label: widget.semanticsLabel,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: RotationTransition(
          turns: _controller,
          child: CustomPaint(
            painter: _SpinnerPainter(
              color: widget.color ?? carbon.layer.interactive,
              trackColor: widget.small ? carbon.layer.layerAccent01 : null,
              // Spec: stroke-width 10 (16 for small) in a 100-unit viewBox.
              strokeFraction: widget.small ? 0.16 : 0.10,
              // Spec: arc covers 81% of the circle (48% for small).
              sweepFraction: widget.small ? 0.48 : 0.81,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final Color color;
  final Color? trackColor;
  final double strokeFraction;
  final double sweepFraction;

  const _SpinnerPainter({
    required this.color,
    required this.trackColor,
    required this.strokeFraction,
    required this.sweepFraction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * strokeFraction;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(strokeWidth / 2);

    if (trackColor != null && trackColor != CarbonPalette.transparent) {
      final trackPaint = Paint()
        ..color = trackColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawArc(arcRect, 0, 2 * math.pi, false, trackPaint);
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;
    // Start at 12 o'clock; the RotationTransition supplies the motion.
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      2 * math.pi * sweepFraction,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) =>
      color != oldDelegate.color ||
      trackColor != oldDelegate.trackColor ||
      strokeFraction != oldDelegate.strokeFraction ||
      sweepFraction != oldDelegate.sweepFraction;
}
