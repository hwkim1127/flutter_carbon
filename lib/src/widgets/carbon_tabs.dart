import 'dart:async';

import 'package:flutter/widgets.dart';
import '../../flutter_carbon.dart';

enum CarbonTabsType {
  line,
  contained,
}

/// A Carbon Design System Tab.
///
/// Used within [CarbonTabs].
class CarbonTab extends StatelessWidget {
  /// The label to display.
  final String label;

  /// Optional icon to display.
  final Widget? icon;

  /// Whether the tab is disabled.
  final bool disabled;

  /// Optional content to display when this tab is selected.
  /// If provided, [CarbonTabs] can manage the content view.
  final Widget? content;

  const CarbonTab({
    super.key,
    required this.label,
    this.icon,
    this.disabled = false,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    // This widget is primarily a data carrier for CarbonTabs,
    // but can be built independently if needed (though styling relies on parent).
    return Container();
  }
}

/// Carbon Design System Tabs component.
class CarbonTabs extends StatefulWidget {
  /// The list of tabs to display.
  final List<CarbonTab> tabs;

  /// The initially selected index.
  final int initialIndex;

  /// Callback when a tab is selected.
  final ValueChanged<int>? onTabChanged;

  /// The type of tabs to display (Line or Contained).
  final CarbonTabsType type;

  /// Whether to expand tabs to fill the available width.
  final bool scrollable;

  /// Whether to extend the bottom border line to the full width (Line type only).
  final bool extendLine;

  const CarbonTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.type = CarbonTabsType.line,
    this.scrollable = true,
    this.extendLine = false,
  }) : assert(!extendLine || type == CarbonTabsType.line,
            'extendLine can only be used with CarbonTabsType.line');

  @override
  State<CarbonTabs> createState() => _CarbonTabsState();
}

class _CarbonTabsState extends State<CarbonTabs> {
  late int _selectedIndex;
  final ScrollController _scrollController = ScrollController();
  List<GlobalKey> _tabKeys = [];

  /// Spec overflow nav buttons: shown exactly while scrolling that way is
  /// possible (hidden — not disabled — at the ends, like Carbon web).
  bool _canScrollPrev = false;
  bool _canScrollNext = false;

  /// Drives press-and-hold continuous scrolling (5px per ~frame, React
  /// parity).
  Timer? _holdTimer;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _generateKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Guard: the widget can be disposed within its first frame — and
      // _scrollToIndex reads `widget`, which is gone after unmount.
      if (mounted) _scrollToIndex(_selectedIndex);
    });
  }

  @override
  void didUpdateWidget(CarbonTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs.length != oldWidget.tabs.length) {
      _generateKeys();
    }

    if (widget.initialIndex != oldWidget.initialIndex &&
        widget.initialIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = widget.initialIndex;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollToIndex(_selectedIndex);
      });
    }
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _generateKeys() {
    _tabKeys = List.generate(widget.tabs.length, (_) => GlobalKey());
  }

  /// Flips the nav-button visibility flags from the latest metrics —
  /// setState only on change (scroll/metrics notifications fire often).
  void _updateOverflow(ScrollMetrics metrics) {
    final prev = metrics.pixels > metrics.minScrollExtent + 1;
    final next = metrics.pixels < metrics.maxScrollExtent - 1;
    if (prev != _canScrollPrev || next != _canScrollNext) {
      setState(() {
        _canScrollPrev = prev;
        _canScrollNext = next;
      });
    }
  }

  /// Click: scroll by ~1.5 average tab widths (React parity), clamped.
  void _stepScroll(int direction) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final contentWidth =
        position.maxScrollExtent + position.viewportDimension;
    final step = contentWidth / widget.tabs.length * 1.5;
    _scrollController.animateTo(
      (position.pixels + direction * step)
          .clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: CarbonMotion.durationModerate01,
      curve: CarbonMotion.standardProductive,
    );
  }

  /// Press-and-hold: continuous 5px steps per ~frame until release.
  void _startHold(int direction) {
    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!_scrollController.hasClients) return;
      final position = _scrollController.position;
      final target = (position.pixels + direction * 5.0)
          .clamp(position.minScrollExtent, position.maxScrollExtent);
      if (target == position.pixels) {
        // Hit the end — the button hides (unmounts) here, so its
        // onLongPressEnd can never fire. Stop ourselves.
        _stopHold();
        return;
      }
      _scrollController.jumpTo(target);
    });
  }

  void _stopHold() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  void _handleTabTap(int index) {
    if (widget.tabs[index].disabled) return;

    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      widget.onTabChanged?.call(index);
      _scrollToIndex(index);
    }
  }

  void _scrollToIndex(int index) {
    if (!widget.scrollable || index >= _tabKeys.length) return;

    final key = _tabKeys[index];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5, // Center the item
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    Widget scrollView = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(widget.tabs.length, (index) {
            final tab = widget.tabs[index];
            final isSelected = index == _selectedIndex;

            return _CarbonTabItem(
              key: _tabKeys[index],
              label: tab.label,
              icon: tab.icon,
              disabled: tab.disabled,
              selected: isSelected,
              type: widget.type,
              extendLine: widget.extendLine,
              onTap: () => _handleTabTap(index),
            );
          }),
        ),
      ),
    );

    // Track overflow so the spec nav buttons appear exactly while
    // scrolling that way is possible.
    if (widget.scrollable) {
      scrollView = NotificationListener<ScrollMetricsNotification>(
        onNotification: (n) {
          if (n.metrics.axis == Axis.horizontal && n.depth == 0) {
            _updateOverflow(n.metrics);
          }
          return false;
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.axis == Axis.horizontal && n.depth == 0) {
              _updateOverflow(n.metrics);
            }
            return false;
          },
          child: scrollView,
        ),
      );
    }

    Widget content = scrollView;
    if (_canScrollPrev || _canScrollNext) {
      final isRtl = Directionality.of(context) == TextDirection.rtl;
      final background = carbon.layer.background;
      // IntrinsicHeight: `stretch` must resolve to the tab bar's height,
      // not the incoming constraint (unbounded inside scrollable pages).
      content = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          if (_canScrollPrev)
            _OverflowNavButton(
              type: widget.type,
              icon: isRtl ? CarbonIcons.chevronRight : CarbonIcons.chevronLeft,
              onTap: () => _stepScroll(-1),
              onHoldStart: () => _startHold(-1),
              onHoldEnd: _stopHold,
            ),
          Expanded(
            child: Stack(
              children: [
                scrollView,
                // 8px edge fades over the list (line variant only, spec).
                if (widget.type == CarbonTabsType.line && _canScrollPrev)
                  PositionedDirectional(
                    start: 0,
                    top: 0,
                    bottom: 0,
                    width: 8,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.centerEnd,
                            end: AlignmentDirectional.centerStart,
                            colors: [
                              background.withValues(alpha: 0),
                              background,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.type == CarbonTabsType.line && _canScrollNext)
                  PositionedDirectional(
                    end: 0,
                    top: 0,
                    bottom: 0,
                    width: 8,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.centerStart,
                            end: AlignmentDirectional.centerEnd,
                            colors: [
                              background.withValues(alpha: 0),
                              background,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_canScrollNext)
            _OverflowNavButton(
              type: widget.type,
              icon: isRtl ? CarbonIcons.chevronLeft : CarbonIcons.chevronRight,
              onTap: () => _stepScroll(1),
              onHoldStart: () => _startHold(1),
              onHoldEnd: _stopHold,
            ),
        ],
        ),
      );
    }

    // If extendLine is true and type is line, wrap in a Stack with a bottom border line
    if (widget.extendLine && widget.type == CarbonTabsType.line) {
      content = Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: carbon.layer.borderSubtle01,
              width: 1.0,
            ),
          ),
        ),
        child: content,
      );
    }

    return content;
  }
}

/// Spec overflow nav button: pointer-only (Carbon web renders it
/// `aria-hidden` with `tabIndex={-1}` — keyboard users move between tabs
/// with arrow keys), hidden at the scroll ends by the caller.
class _OverflowNavButton extends StatefulWidget {
  final CarbonTabsType type;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onHoldStart;
  final VoidCallback onHoldEnd;

  const _OverflowNavButton({
    required this.type,
    required this.icon,
    required this.onTap,
    required this.onHoldStart,
    required this.onHoldEnd,
  });

  @override
  State<_OverflowNavButton> createState() => _OverflowNavButtonState();
}

class _OverflowNavButtonState extends State<_OverflowNavButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final contained = widget.type == CarbonTabsType.contained;

    // Line: 40px on $background, no hover/active states (spec).
    // Contained: 48px on $layer-accent with hover/active.
    final Color background;
    if (contained) {
      background = _pressed
          ? carbon.layer.layerAccentActive01
          : _hovered
              ? carbon.layer.layerAccentHover01
              : carbon.layer.layerAccent01;
    } else {
      background = carbon.layer.background;
    }

    return ExcludeSemantics(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onLongPressStart: (_) => widget.onHoldStart(),
          onLongPressEnd: (_) => widget.onHoldEnd(),
          onLongPressCancel: widget.onHoldEnd,
          child: Container(
            width: contained ? 48 : 40,
            color: background,
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              size: 16,
              color: carbon.text.iconPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _CarbonTabItem extends StatefulWidget {
  final String label;
  final Widget? icon;
  final bool disabled;
  final bool selected;
  final CarbonTabsType type;
  final bool extendLine;
  final VoidCallback onTap;

  const _CarbonTabItem({
    super.key,
    required this.label,
    required this.icon,
    required this.disabled,
    required this.selected,
    required this.type,
    this.extendLine = false,
    required this.onTap,
  }) : assert(!extendLine || type == CarbonTabsType.line,
            'extendLine can only be used with CarbonTabsType.line');

  @override
  State<_CarbonTabItem> createState() => _CarbonTabItemState();
}

class _CarbonTabItemState extends State<_CarbonTabItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    // Define colors based on type and state
    Color backgroundColor = CarbonPalette.transparent;
    Color textColor = carbon.text.textSecondary;
    Color borderColor = carbon.layer.borderSubtle01; // Default underline
    double borderThickness = 1.0;

    if (widget.type == CarbonTabsType.contained) {
      // Contained Tabs
      backgroundColor = carbon.layer.layerAccent01; // Default background
      borderColor = CarbonPalette.transparent; // No bottom border by default

      if (widget.disabled) {
        backgroundColor =
            carbon.button.buttonDisabled; // Or specific disabled bg
        textColor = carbon.text.textDisabled;
      } else if (widget.selected) {
        backgroundColor = carbon.layer.layer01; // Selected background
        textColor = carbon.text.textPrimary;
        // Inset top border is handled via decoration or custom painting usually,
        // but here we might simulate it or just use top border if feasible in Row.
        // For simplicity, we'll use a top border on container.
      } else {
        // Idle
        if (_isHovered) {
          backgroundColor =
              carbon.layer.layerAccent01; // Hover bg (check token)
          // Actually layer-accent-hover
        }
      }
    } else {
      // Line Tabs (Default)
      if (widget.disabled) {
        textColor = carbon.text.textDisabled;
        if (!widget.extendLine) {
          borderColor = carbon.text.textDisabled; // Or specific disabled border
        }
      } else if (widget.selected) {
        textColor = carbon.text.textPrimary;
        borderColor = carbon.button.buttonPrimary;
        borderThickness = 2.0;
      } else {
        // Idle
        if (_isHovered) {
          textColor = carbon.text.textPrimary;
          borderColor = carbon.text.textSecondary; // Darker border on hover
          backgroundColor = carbon.layer.backgroundHover;
        }
      }
    }

    // Contained tabs have an inset top border when selected
    final showTopBorder =
        widget.type == CarbonTabsType.contained && widget.selected;

    return MouseRegion(
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 100), // Min width
          decoration: BoxDecoration(
            color: backgroundColor,
            border: widget.type == CarbonTabsType.line
                ? (widget.selected || !widget.extendLine)
                    ? Border(
                        bottom: BorderSide(
                          color: borderColor,
                          width: borderThickness,
                        ),
                      )
                    : null
                : null, // Contained styles handled differently if complex
          ),
          child: Stack(
            children: [
              if (showTopBorder)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    color: carbon.button.buttonPrimary,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12, // Adjusted padding
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      IconTheme(
                        data: IconThemeData(
                          color: textColor,
                          size: 16,
                        ),
                        child: widget.icon!,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.label,
                      style: (widget.selected
                              ? CarbonTypography.headingCompact01
                              : CarbonTypography.bodyCompact01)
                          .copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
