import 'package:flutter/animation.dart';

/// Carbon Design System Motion.
///
/// Contains duration and easing constants.
///
/// See: https://carbondesignsystem.com/guidelines/motion/overview/
class CarbonMotion {
  const CarbonMotion._();

  // Durations
  static const Duration fast01 = Duration(milliseconds: 70);
  static const Duration fast02 = Duration(milliseconds: 110);
  static const Duration moderate01 = Duration(milliseconds: 150);
  static const Duration moderate02 = Duration(milliseconds: 240);
  static const Duration slow01 = Duration(milliseconds: 400);
  static const Duration slow02 = Duration(milliseconds: 700);

  // V11 Token Aliases
  static const Duration durationFast01 = fast01;
  static const Duration durationFast02 = fast02;
  static const Duration durationModerate01 = moderate01;
  static const Duration durationModerate02 = moderate02;
  static const Duration durationSlow01 = slow01;
  static const Duration durationSlow02 = slow02;

  // Easings - Standard
  // productive: cubic-bezier(0.2, 0, 0.38, 0.9)
  static const Curve standardProductive = Cubic(0.2, 0, 0.38, 0.9);
  // expressive: cubic-bezier(0.4, 0.14, 0.3, 1)
  static const Curve standardExpressive = Cubic(0.4, 0.14, 0.3, 1);

  // Easings - Entrance
  // productive: cubic-bezier(0, 0, 0.38, 0.9)
  static const Curve entranceProductive = Cubic(0.0, 0.0, 0.38, 0.9);
  // expressive: cubic-bezier(0, 0, 0.3, 1)
  static const Curve entranceExpressive = Cubic(0.0, 0.0, 0.3, 1.0);

  // Easings - Exit
  // productive: cubic-bezier(0.2, 0, 1, 0.9)
  static const Curve exitProductive = Cubic(0.2, 0.0, 1.0, 0.9);
  // expressive: cubic-bezier(0.4, 0.14, 1, 1)
  static const Curve exitExpressive = Cubic(0.4, 0.14, 1.0, 1.0);
}
