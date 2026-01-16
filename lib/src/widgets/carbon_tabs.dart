import 'package:flutter/material.dart';
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

  const CarbonTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.type = CarbonTabsType.line,
    this.scrollable = true,
  });

  @override
  State<CarbonTabs> createState() => _CarbonTabsState();
}

class _CarbonTabsState extends State<CarbonTabs> {
  late int _selectedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(CarbonTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex &&
        widget.initialIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = widget.initialIndex;
      });
    }
  }

  void _handleTabTap(int index) {
    if (widget.tabs[index].disabled) return;

    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      widget.onTabChanged?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(widget.tabs.length, (index) {
            final tab = widget.tabs[index];
            final isSelected = index == _selectedIndex;

            return _CarbonTabItem(
              label: tab.label,
              icon: tab.icon,
              disabled: tab.disabled,
              selected: isSelected,
              type: widget.type,
              onTap: () => _handleTabTap(index),
            );
          }),
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
  final VoidCallback onTap;

  const _CarbonTabItem({
    required this.label,
    required this.icon,
    required this.disabled,
    required this.selected,
    required this.type,
    required this.onTap,
  });

  @override
  State<_CarbonTabItem> createState() => _CarbonTabItemState();
}

class _CarbonTabItemState extends State<_CarbonTabItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    // Define colors based on type and state
    Color backgroundColor = Colors.transparent;
    Color textColor = carbon.text.textSecondary;
    Color borderColor = carbon.layer.borderSubtle01; // Default underline
    double borderThickness = 1.0;

    if (widget.type == CarbonTabsType.contained) {
      // Contained Tabs
      backgroundColor = carbon.layer.layerAccent01; // Default background
      borderColor = Colors.transparent; // No bottom border by default

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
        borderColor = carbon.text.textDisabled; // Or specific disabled border
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
                ? Border(
                    bottom: BorderSide(
                      color: borderColor,
                      width: borderThickness,
                    ),
                  )
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
