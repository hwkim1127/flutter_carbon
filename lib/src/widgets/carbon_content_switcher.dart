import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Content switcher size variants.
enum CarbonContentSwitcherSize {
  small,
  medium,
  large,
}

/// Carbon Design System content switcher item.
class CarbonContentSwitcherItem {
  /// The text label or icon to display.
  final String? label;

  /// Optional icon widget (for icon-only mode).
  final Widget? icon;

  /// The value associated with this item.
  final String value;

  /// Whether this item is disabled.
  final bool disabled;

  const CarbonContentSwitcherItem({
    this.label,
    this.icon,
    required this.value,
    this.disabled = false,
  }) : assert(
          label != null || icon != null,
          'Either label or icon must be provided',
        );

  /// Whether this is an icon-only item.
  bool get isIconOnly => icon != null && label == null;
}

/// Carbon Design System content switcher.
///
/// Content switcher allows users to toggle between two or more content sections
/// within the same space on screen. Only one section can be shown at a time.
///
/// Example:
/// ```dart
/// CarbonContentSwitcher(
///   items: [
///     CarbonContentSwitcherItem(label: 'Option 1', value: '1'),
///     CarbonContentSwitcherItem(label: 'Option 2', value: '2'),
///     CarbonContentSwitcherItem(label: 'Option 3', value: '3'),
///   ],
///   selectedValue: '1',
///   onChanged: (value) => print('Selected: $value'),
/// )
/// ```
class CarbonContentSwitcher extends StatefulWidget {
  /// The list of items in the content switcher.
  final List<CarbonContentSwitcherItem> items;

  /// The currently selected value.
  final String selectedValue;

  /// Called when the selection changes.
  final ValueChanged<String>? onChanged;

  /// The size of the content switcher.
  final CarbonContentSwitcherSize size;

  /// Whether the content switcher should take full width.
  final bool fullWidth;

  const CarbonContentSwitcher({
    super.key,
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.size = CarbonContentSwitcherSize.medium,
    this.fullWidth = false,
  }) : assert(items.length >= 2, 'Content switcher must have at least 2 items');

  @override
  State<CarbonContentSwitcher> createState() => _CarbonContentSwitcherState();
}

class _CarbonContentSwitcherState extends State<CarbonContentSwitcher> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final isIconOnly = widget.items.every((item) => item.isIconOnly);

    return Container(
      height: _getHeight(),
      decoration: BoxDecoration(
        border: Border.all(
          color: carbon.contentSwitcher.contentSwitcherDivider,
          width: 1,
        ),
        borderRadius: BorderRadius.zero,
      ),
      child: Row(
        mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: List.generate(widget.items.length, (index) {
          final item = widget.items[index];
          final isSelected = item.value == widget.selectedValue;
          final isHovered = _hoveredIndex == index;
          final showLeftDivider = index > 0 &&
              !isSelected &&
              widget.items[index - 1].value != widget.selectedValue &&
              !isHovered &&
              (_hoveredIndex == null || _hoveredIndex != index - 1);

          return Expanded(
            flex: widget.fullWidth ? 1 : 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showLeftDivider)
                  Container(
                    width: 1,
                    height: _getHeight() - 2,
                    color: carbon.contentSwitcher.contentSwitcherDivider,
                  ),
                Expanded(
                  flex: widget.fullWidth ? 1 : 0,
                  child: _ContentSwitcherButton(
                    item: item,
                    isSelected: isSelected,
                    isIconOnly: isIconOnly,
                    size: widget.size,
                    onTap: () {
                      if (!item.disabled && widget.onChanged != null) {
                        widget.onChanged!(item.value);
                      }
                    },
                    onHover: (hovered) {
                      setState(() {
                        _hoveredIndex = hovered ? index : null;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  double _getHeight() {
    switch (widget.size) {
      case CarbonContentSwitcherSize.small:
        return 32;
      case CarbonContentSwitcherSize.medium:
        return 40;
      case CarbonContentSwitcherSize.large:
        return 48;
    }
  }
}

/// Internal button widget for content switcher items.
class _ContentSwitcherButton extends StatefulWidget {
  final CarbonContentSwitcherItem item;
  final bool isSelected;
  final bool isIconOnly;
  final CarbonContentSwitcherSize size;
  final VoidCallback onTap;
  final ValueChanged<bool> onHover;

  const _ContentSwitcherButton({
    required this.item,
    required this.isSelected,
    required this.isIconOnly,
    required this.size,
    required this.onTap,
    required this.onHover,
  });

  @override
  State<_ContentSwitcherButton> createState() => _ContentSwitcherButtonState();
}

class _ContentSwitcherButtonState extends State<_ContentSwitcherButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    final backgroundColor = widget.isSelected
        ? carbon.contentSwitcher.contentSwitcherSelected
        : _isHovered && !widget.item.disabled
            ? carbon.contentSwitcher.contentSwitcherBackgroundHover
            : carbon.contentSwitcher.contentSwitcherBackground;

    final textColor = widget.isSelected
        ? carbon.contentSwitcher.contentSwitcherTextOnColor
        : widget.item.disabled
            ? carbon.text.textDisabled
            : carbon.text.textPrimary;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        widget.onHover(true);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        widget.onHover(false);
      },
      child: InkWell(
        onTap: widget.item.disabled ? null : widget.onTap,
        child: Container(
          padding: _getPadding(),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.zero,
          ),
          child: widget.isIconOnly && widget.item.icon != null
              ? IconTheme(
                  data: IconThemeData(
                    color: textColor,
                    size: 16,
                  ),
                  child: widget.item.icon!,
                )
              : Text(
                  widget.item.label ?? '',
                  style: TextStyle(
                    color: textColor,
                    fontSize: _getFontSize(),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    if (widget.isIconOnly) {
      switch (widget.size) {
        case CarbonContentSwitcherSize.small:
          return const EdgeInsets.all(7);
        case CarbonContentSwitcherSize.medium:
          return const EdgeInsets.all(11);
        case CarbonContentSwitcherSize.large:
          return const EdgeInsets.all(15);
      }
    } else {
      return const EdgeInsets.symmetric(horizontal: 16, vertical: 11);
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case CarbonContentSwitcherSize.small:
        return 12;
      case CarbonContentSwitcherSize.medium:
      case CarbonContentSwitcherSize.large:
        return 14;
    }
  }
}
