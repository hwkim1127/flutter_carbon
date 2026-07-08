import 'package:flutter/widgets.dart';
import '../../flutter_carbon.dart';

// ── Enums ──────────────────────────────────────────────────────────────────────

/// Visual state of a single progress step.
enum CarbonProgressStepState {
  /// Step has been completed. Shows CheckmarkOutline icon ($interactive).
  complete,

  /// Step is currently active. Shows Incomplete icon ($interactive).
  current,

  /// Step is not yet reached. Shows CircleDash icon ($icon-primary).
  incomplete,

  /// Step has an error. Shows Warning icon ($support-error).
  invalid,
}

// ── Step data ──────────────────────────────────────────────────────────────────

/// Data descriptor for a single step in [CarbonProgressIndicator].
class CarbonProgressStep {
  final String label;

  /// Optional helper text shown below the label (`label-01` style).
  final String? secondaryLabel;

  /// Override the automatically-computed state.
  final CarbonProgressStepState? state;

  final bool disabled;

  const CarbonProgressStep({
    required this.label,
    this.secondaryLabel,
    this.state,
    this.disabled = false,
  });
}

// ── Main widget ────────────────────────────────────────────────────────────────

/// Carbon Design System Progress Indicator.
class CarbonProgressIndicator extends StatelessWidget {
  final List<CarbonProgressStep> steps;
  final int currentIndex;
  final bool vertical;

  /// (Horizontal only) Each step takes equal width via [Expanded].
  final bool spaceEqually;

  final ValueChanged<int>? onStepTap;

  const CarbonProgressIndicator({
    super.key,
    required this.steps,
    this.currentIndex = 0,
    this.vertical = false,
    this.spaceEqually = true,
    this.onStepTap,
  });

  CarbonProgressStepState _effectiveState(int i) {
    final s = steps[i].state;
    if (s != null) return s;
    if (i < currentIndex) return CarbonProgressStepState.complete;
    if (i == currentIndex) return CarbonProgressStepState.current;
    return CarbonProgressStepState.incomplete;
  }

  bool _canTap(int i) {
    if (onStepTap == null) return false;
    if (steps[i].disabled) return false;
    return _effectiveState(i) != CarbonProgressStepState.current;
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    if (vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (i) {
          return _VerticalStep(
            step: steps[i],
            state: _effectiveState(i),
            isLast: i == steps.length - 1,
            carbon: carbon,
            onTap: _canTap(i) ? () => onStepTap!(i) : null,
          );
        }),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (i) {
        final step = _HorizontalStep(
          step: steps[i],
          state: _effectiveState(i),
          carbon: carbon,
          onTap: _canTap(i) ? () => onStepTap!(i) : null,
        );
        if (spaceEqually) return Expanded(child: step);
        return step;
      }),
    );
  }
}

// ── Horizontal step ────────────────────────────────────────────────────────────
// Layout: 2px top border = progress line; icon + label below with padding.
// Label: body-compact-01 — single line, nowrap, letter-spacing 0.16px.
// Optional label: label-01 — 12px, letter-spacing 0.32px, $text-secondary.
// Hover (tappable only): label color → $link-primary-hover + underline.

class _HorizontalStep extends StatefulWidget {
  final CarbonProgressStep step;
  final CarbonProgressStepState state;
  final CarbonThemeData carbon;
  final VoidCallback? onTap;

  const _HorizontalStep({
    required this.step,
    required this.state,
    required this.carbon,
    this.onTap,
  });

  @override
  State<_HorizontalStep> createState() => _HorizontalStepState();
}

class _HorizontalStepState extends State<_HorizontalStep> {
  bool _hovered = false;

  Color get _lineColor {
    final s = widget.state;
    if (s == CarbonProgressStepState.complete ||
        s == CarbonProgressStepState.current) {
      return widget.carbon.layer.interactive;
    }
    return widget.carbon.layer.borderSubtle01;
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    final carbon = widget.carbon;
    final tappable = widget.onTap != null;

    // Label hover only applies when the step is tappable.
    final labelColor = step.disabled
        ? carbon.text.textDisabled
        : (tappable && _hovered)
            ? carbon.text.linkPrimaryHover
            : carbon.text.textPrimary;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: tappable ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 2, color: _lineColor),
            ),
          ),
          // 10px matches Carbon's svg margin-block-start: 10px
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StepIcon(
                  state: widget.state,
                  disabled: step.disabled,
                  carbon: carbon),
              const SizedBox(height: 8),
              // body-compact-01: 14px, 400, letter-spacing 0.16px,
              // line-height 1.45, white-space nowrap (single line)
              Text(
                step.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                  letterSpacing: 0.16,
                  color: labelColor,
                  decoration: (tappable && _hovered && !step.disabled)
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: carbon.text.linkPrimaryHover,
                ),
              ),
              // label-01: 12px, 400, letter-spacing 0.32px, line-height 16/12
              if (step.secondaryLabel != null)
                Text(
                  step.secondaryLabel!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                    letterSpacing: 0.32,
                    color: step.disabled
                        ? carbon.text.textDisabled
                        : carbon.text.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Vertical step ──────────────────────────────────────────────────────────────
// Layout: 1px left border = progress line; icon + label to the right.
// Label: white-space initial (can wrap), letter-spacing 0.16px.
// Optional label: pushed to bottom of the step column (margin: 0 0 auto equivalent).
// Hover (tappable only): label color → $link-primary-hover + underline.

class _VerticalStep extends StatefulWidget {
  final CarbonProgressStep step;
  final CarbonProgressStepState state;
  final bool isLast;
  final CarbonThemeData carbon;
  final VoidCallback? onTap;

  const _VerticalStep({
    required this.step,
    required this.state,
    required this.isLast,
    required this.carbon,
    this.onTap,
  });

  @override
  State<_VerticalStep> createState() => _VerticalStepState();
}

class _VerticalStepState extends State<_VerticalStep> {
  bool _hovered = false;

  // Carbon spec: min-block-size: 3.625rem ≈ 58px (non-last steps)
  static const double _minStepHeight = 58.0;

  Color get _lineColor {
    final s = widget.state;
    if (s == CarbonProgressStepState.complete ||
        s == CarbonProgressStepState.current) {
      return widget.carbon.layer.interactive;
    }
    return widget.carbon.layer.borderSubtle01;
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    final carbon = widget.carbon;
    final tappable = widget.onTap != null;

    final labelColor = step.disabled
        ? carbon.text.textDisabled
        : (tappable && _hovered)
            ? carbon.text.linkPrimaryHover
            : carbon.text.textPrimary;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: tappable ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: widget.isLast ? 0 : _minStepHeight),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 1,
                  color:
                      widget.isLast ? CarbonPalette.transparent : _lineColor,
                ),
              ),
            ),
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1px top matches Carbon's svg margin: 1px 8px 0
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: _StepIcon(
                      state: widget.state,
                      disabled: step.disabled,
                      carbon: carbon),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // body-compact-01: wrapping allowed in vertical
                      Text(
                        step.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                          letterSpacing: 0.16,
                          color: labelColor,
                          decoration:
                              (tappable && _hovered && !step.disabled)
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                          decorationColor: carbon.text.linkPrimaryHover,
                        ),
                      ),
                      // label-01: appears directly below the label.
                      // CSS uses margin-block-start: auto to push to the bottom
                      // of the step's allocated min-height, but in Flutter we
                      // keep it adjacent to the label for simplicity.
                      if (step.secondaryLabel != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          step.secondaryLabel!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                            letterSpacing: 0.32,
                            color: step.disabled
                                ? carbon.text.textDisabled
                                : carbon.text.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Step icon ──────────────────────────────────────────────────────────────────

/// Carbon icon mapping (matches web-component progress-step.ts):
/// - complete   → CheckmarkOutline  fill: $interactive
/// - current    → Incomplete        fill: $interactive
/// - incomplete → CircleDash        fill: $icon-primary
/// - invalid    → Warning           fill: $support-error
/// - disabled   → same icon         fill: $icon-disabled
class _StepIcon extends StatelessWidget {
  final CarbonProgressStepState state;
  final bool disabled;
  final CarbonThemeData carbon;

  const _StepIcon({
    required this.state,
    required this.disabled,
    required this.carbon,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (disabled) {
      color = carbon.text.iconDisabled;
    } else {
      switch (state) {
        case CarbonProgressStepState.complete:
        case CarbonProgressStepState.current:
          color = carbon.layer.interactive;
        case CarbonProgressStepState.incomplete:
          color = carbon.text.iconPrimary;
        case CarbonProgressStepState.invalid:
          color = carbon.layer.supportError;
      }
    }

    final IconData iconData = switch (state) {
      CarbonProgressStepState.complete => CarbonIcons.checkmarkOutline,
      CarbonProgressStepState.current => CarbonIcons.incomplete,
      CarbonProgressStepState.incomplete => CarbonIcons.circleDash,
      CarbonProgressStepState.invalid => CarbonIcons.warning,
    };

    return Icon(iconData, size: 16, color: color);
  }
}
