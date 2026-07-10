import 'package:flutter/widgets.dart';

import '../base/carbon_divider.dart';
import '../base/carbon_pressable.dart';
import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';

/// Which side of the heading carries the chevron.
enum CarbonAccordionAlign {
  /// Chevron before the title.
  start,

  /// Chevron at the far end (Carbon default).
  end,
}

/// Heading heights for [CarbonAccordion].
enum CarbonAccordionSize {
  /// Small: 32px headings.
  sm(32),

  /// Medium: 40px headings (default).
  md(40),

  /// Large: 48px headings.
  lg(48);

  const CarbonAccordionSize(this.headingHeight);

  /// Minimum heading height in logical pixels.
  final double headingHeight;
}

/// One section of a [CarbonAccordion].
///
/// Leave [open] null for an uncontrolled section (the accordion tracks its
/// own state, seeded from [initiallyOpen]). A non-null [open] makes the
/// section controlled: taps only report the requested state through
/// [onHeadingClick], and the section follows whatever the parent passes.
class CarbonAccordionItem {
  const CarbonAccordionItem({
    this.key,
    required this.title,
    required this.child,
    this.open,
    this.initiallyOpen = false,
    this.disabled = false,
    this.onHeadingClick,
  });

  /// Preserves the section's state across list mutations. Without keys,
  /// reordering items resets uncontrolled open state (sections are keyed
  /// by index).
  final Key? key;

  /// The heading text (`body-01`).
  final String title;

  /// The panel content revealed when open.
  final Widget child;

  /// Non-null ⇒ controlled.
  final bool? open;

  /// Initial state of an uncontrolled section.
  final bool initiallyOpen;

  final bool disabled;

  /// Called with the *target* state when the heading is activated
  /// (tap, Enter, or Space).
  final ValueChanged<bool>? onHeadingClick;
}

/// Carbon Design System accordion.
///
/// A vertically stacked list of sections framed by 1px `$border-subtle`
/// rules; each heading toggles its panel with the Carbon 110ms
/// height-and-fade motion. Sections are independent — for the
/// single-open-at-a-time pattern, control them via
/// [CarbonAccordionItem.open].
///
/// [isFlush] insets the rules 16px on each side (only with the default
/// `align: end`, per spec).
///
/// Closed panels are unmounted, so their state resets on reopen (matching
/// the web component, which unmounts collapsed content).
class CarbonAccordion extends StatelessWidget {
  const CarbonAccordion({
    super.key,
    required this.items,
    this.align = CarbonAccordionAlign.end,
    this.size = CarbonAccordionSize.md,
    this.isFlush = false,
    this.disabled = false,
  }) : assert(
         !isFlush || align == CarbonAccordionAlign.end,
         'isFlush is only supported with align: end (Carbon spec)',
       );

  /// The sections, top to bottom.
  final List<CarbonAccordionItem> items;

  /// Chevron placement (Carbon default: end).
  final CarbonAccordionAlign align;

  /// Heading height variant.
  final CarbonAccordionSize size;

  /// Insets the divider rules 16px on each side.
  final bool isFlush;

  /// Disables every section.
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final divider = isFlush
        ? const Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: CarbonDivider(),
          )
        : const CarbonDivider();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          divider,
          _AccordionTile(
            key: items[i].key ?? ValueKey<int>(i),
            item: items[i],
            align: align,
            size: size,
            disabled: disabled || items[i].disabled,
          ),
        ],
        divider,
      ],
    );
  }
}

class _AccordionTile extends StatefulWidget {
  const _AccordionTile({
    super.key,
    required this.item,
    required this.align,
    required this.size,
    required this.disabled,
  });

  final CarbonAccordionItem item;
  final CarbonAccordionAlign align;
  final CarbonAccordionSize size;
  final bool disabled;

  @override
  State<_AccordionTile> createState() => _AccordionTileState();
}

class _AccordionTileState extends State<_AccordionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curved;
  late bool _open;

  @override
  void initState() {
    super.initState();
    _open = widget.item.open ?? widget.item.initiallyOpen;
    // Seeding the value renders an initially-open section without a
    // first-frame animation.
    _controller = AnimationController(
      vsync: this,
      duration: CarbonMotion.fast02,
      value: _open ? 1 : 0,
    );
    _curved = CurvedAnimation(
      parent: _controller,
      curve: CarbonMotion.entranceProductive,
      reverseCurve: CarbonMotion.exitProductive,
    );
  }

  @override
  void didUpdateWidget(_AccordionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controlled = widget.item.open;
    if (controlled != null && controlled != _open) {
      setState(() => _open = controlled);
      _animate();
    }
  }

  @override
  void dispose() {
    _curved.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _animate() {
    if (_open) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _handleTap() {
    final target = !_open;
    widget.item.onHeadingClick?.call(target);
    if (widget.item.open != null) return; // controlled — parent decides
    setState(() => _open = target);
    _animate();
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final disabled = widget.disabled;

    final titleColor = disabled
        ? carbon.text.textDisabled
        : carbon.text.textPrimary;
    final chevron = RotationTransition(
      turns: Tween<double>(begin: 0, end: 0.5).animate(_curved),
      child: Icon(
        CarbonIcons.chevronDown,
        size: 16,
        color: disabled ? carbon.text.iconDisabled : carbon.text.iconPrimary,
      ),
    );
    final title = Text(
      widget.item.title,
      style: CarbonTypography.body01.copyWith(color: titleColor),
    );

    final heading = Semantics(
      // The pressable's detector provides the button/tap semantics; this
      // adds the disclosure state.
      expanded: _open,
      child: CarbonPressable(
        onTap: disabled ? null : _handleTap,
        focusable: true,
        builder: (context, state) => Container(
          constraints: BoxConstraints(minHeight: widget.size.headingHeight),
          color: state.hovered && !disabled
              ? carbon.layer.layerHover01
              : CarbonPalette.transparent,
          // Always-present outline, transparent when unfocused (repo
          // convention for the 2px `$focus` ring).
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              color: state.focused ? carbon.layer.focus : CarbonPalette.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: switch (widget.align) {
              CarbonAccordionAlign.end => [
                const SizedBox(width: 16),
                Expanded(child: title),
                chevron,
                const SizedBox(width: 16),
              ],
              CarbonAccordionAlign.start => [
                const SizedBox(width: 16),
                chevron,
                const SizedBox(width: 16),
                Expanded(child: title),
              ],
            },
          ),
        ),
      ),
    );

    // Spec: content padding-inline-end is responsive — 25% of the width at
    // ≥640px, 48px at ≥480px, 16px below.
    final content = LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final end = width >= 640
            ? width * 0.25
            : width >= 480
            ? 48.0
            : 16.0;
        return Padding(
          padding: EdgeInsetsDirectional.only(
            start: 16,
            end: end,
            top: 8,
            bottom: 24,
          ),
          child: DefaultTextStyle(
            style: CarbonTypography.body01.copyWith(
              color: carbon.text.textPrimary,
            ),
            child: widget.item.child,
          ),
        );
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        heading,
        AnimatedBuilder(
          animation: _controller,
          // The child stays stable across animation ticks; only the clip
          // and height factor rebuild.
          child: FadeTransition(
            opacity: _curved,
            child: ExcludeFocus(excluding: !_open, child: content),
          ),
          builder: (context, child) {
            if (_controller.value == 0) return const SizedBox.shrink();
            return ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _curved.value,
                child: child,
              ),
            );
          },
        ),
      ],
    );
  }
}
