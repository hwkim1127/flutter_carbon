import 'package:flutter/services.dart' show KeyDownEvent, LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../base/carbon_anchored_overlay.dart';
import '../base/carbon_overlay_surface.dart';
import '../foundation/colors.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// Size variants for [CarbonDropdown].
enum CarbonDropdownSize {
  /// Small size (32px / 2rem) - Use when space is constricted.
  small,

  /// Medium size (40px / 2.5rem) - Default size, most commonly used.
  medium,

  /// Large size (48px / 3rem) - Use when there is a lot of space.
  large,
}

/// Extension to get height from size.
extension CarbonDropdownSizeExtension on CarbonDropdownSize {
  double get height {
    switch (this) {
      case CarbonDropdownSize.small:
        return 32;
      case CarbonDropdownSize.medium:
        return 40;
      case CarbonDropdownSize.large:
        return 48;
    }
  }
}

/// Carbon Design System dropdown/select widget.
///
/// A custom dropdown implementation that follows Carbon Design System specifications:
/// - Sharp corners (zero border radius)
/// - 1px border that changes on focus
/// - Chevron down icon
/// - Proper Carbon colors and states
/// - No forced padding (precise control)
///
/// Example:
/// ```dart
/// CarbonDropdown<String>(
///   value: selectedValue,
///   label: 'Select option',
///   items: ['Option 1', 'Option 2', 'Option 3']
///       .map((value) => CarbonDropdownItem(
///             value: value,
///             child: Text(value),
///           ))
///       .toList(),
///   onChanged: (value) {
///     setState(() => selectedValue = value);
///   },
/// )
/// ```
class CarbonDropdown<T> extends StatefulWidget {
  /// The currently selected value.
  final T? value;

  /// Called when the user selects an item.
  final ValueChanged<T?>? onChanged;

  /// The list of items to display in the dropdown.
  final List<CarbonDropdownItem<T>> items;

  /// Optional label text displayed above the dropdown.
  final String? label;

  /// Optional helper text displayed below the dropdown.
  final String? helperText;

  /// Optional error text displayed below the dropdown.
  final String? errorText;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// Hint text when no value is selected.
  final String? hint;

  /// Custom icon for the dropdown (defaults to chevron down).
  final Widget? icon;

  /// Whether to show border around the dropdown.
  final bool showBorder;

  /// Size of the dropdown (default: medium).
  final CarbonDropdownSize size;

  /// Optional fixed width for the dropdown.
  final double? width;

  const CarbonDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    this.hint,
    this.icon,
    this.showBorder = true,
    this.size = CarbonDropdownSize.medium,
    this.width,
  });

  @override
  State<CarbonDropdown<T>> createState() => _CarbonDropdownState<T>();
}

class _CarbonDropdownState<T> extends State<CarbonDropdown<T>> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _triggerKey = GlobalKey();
  final FocusNode _menuFocusNode = FocusNode(debugLabel: 'CarbonDropdownMenu');

  /// Whatever held focus before the menu opened; restored on close.
  FocusNode? _previousFocus;

  bool _isOpen = false;
  T? _highlightedValue;

  @override
  void dispose() {
    // Remove overlay without calling setState since widget is being disposed
    _overlayEntry?.remove();
    _overlayEntry = null;
    _menuFocusNode.dispose();
    super.dispose();
  }

  void _restorePreviousFocus() {
    final current = FocusManager.instance.primaryFocus;
    final previous = _previousFocus;
    _previousFocus = null;
    if (previous != null &&
        previous.context != null &&
        (current == null ||
            current == _menuFocusNode ||
            current is FocusScopeNode)) {
      previous.requestFocus();
    }
  }

  /// Keyboard for the open menu: Escape closes, arrows move the highlight
  /// through enabled items, Enter/Space selects.
  KeyEventResult _handleMenuKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _closeDropdown();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _moveHighlight(1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _moveHighlight(-1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      final highlighted = _highlightedValue;
      if (highlighted != null) {
        _selectItem(highlighted);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  void _moveHighlight(int direction) {
    final items = widget.items;
    if (items.isEmpty) return;
    var index = items.indexWhere((item) => item.value == _highlightedValue);
    if (index < 0) index = direction > 0 ? -1 : items.length;
    for (var step = 0; step < items.length; step++) {
      index += direction;
      if (index < 0 || index >= items.length) return; // no wrap-around
      if (items[index].enabled) {
        setState(() => _highlightedValue = items[index].value);
        _overlayEntry?.markNeedsBuild();
        return;
      }
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (!widget.enabled || _isOpen) return;

    _previousFocus = FocusManager.instance.primaryFocus;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    // Take focus so arrows/Enter/Escape drive the menu instead of the app's
    // focus traversal (`autofocus` would be ignored while anything is
    // focused).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isOpen && mounted) _menuFocusNode.requestFocus();
    });
    if (mounted) {
      setState(() {
        _isOpen = true;
        _highlightedValue = widget.value;
      });
    }
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _restorePreviousFocus();
    if (mounted) {
      setState(() {
        _isOpen = false;
        _highlightedValue = null;
      });
    }
  }

  void _selectItem(T value) {
    widget.onChanged?.call(value);
    _closeDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    // Anchor to the trigger specifically, not the whole widget with its
    // label/helper text — the menu must sit flush to the field.
    final anchorRect = CarbonAnchoredOverlay.anchorRectGetterFor(
      _triggerKey.currentContext ?? context,
    );

    return OverlayEntry(
      // Flip above / clamp to screen / match trigger width are all handled
      // by the shared positioner using the menu's real laid-out height.
      builder: (context) => CarbonAnchoredOverlay(
        anchorRect: anchorRect,
        alignment: CarbonPopoverAlignment.bottomStart,
        matchAnchorWidth: true,
        spacing: 1,
        onDismiss: _closeDropdown,
        contentBuilder: (context, _) => Focus(
          focusNode: _menuFocusNode,
          onKeyEvent: _handleMenuKey,
          child: CarbonOverlaySurface(
            // Read value/highlight live (not captured) so hover and
            // selection changes render via markNeedsBuild.
            child: _buildDropdownMenu(
              carbon: context.carbon,
              items: widget.items,
              currentValue: widget.value,
              highlightedValue: _highlightedValue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownMenu({
    required CarbonThemeData carbon,
    required List<CarbonDropdownItem<T>> items,
    required T? currentValue,
    required T? highlightedValue,
  }) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: carbon.layer.layer01,
        border: Border.all(color: carbon.layer.borderSubtle01, width: 1),
        borderRadius: BorderRadius.zero,
        boxShadow: [
          // Replaces the Material elevation the menu previously relied on.
          BoxShadow(
            color: CarbonPalette.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: items.map((item) {
          final isSelected = item.value == currentValue;
          final isHighlighted = item.value == highlightedValue;

          return _buildMenuItem(
            carbon: carbon,
            item: item,
            isSelected: isSelected,
            isHighlighted: isHighlighted,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem({
    required CarbonThemeData carbon,
    required CarbonDropdownItem<T> item,
    required bool isSelected,
    required bool isHighlighted,
  }) {
    return MouseRegion(
      onEnter: (_) {
        if (item.enabled && mounted) {
          setState(() => _highlightedValue = item.value);
          // The menu lives in an OverlayEntry — it only repaints the
          // highlight when the entry itself is rebuilt.
          _overlayEntry?.markNeedsBuild();
        }
      },
      child: GestureDetector(
        onTap: item.enabled ? () => _selectItem(item.value) : null,
        child: Container(
          height: widget.size == CarbonDropdownSize.small
              ? 32
              : widget.size == CarbonDropdownSize.large
              ? 48
              : 40,
          decoration: BoxDecoration(
            color: isHighlighted
                ? carbon.layer.layerHover01
                : isSelected
                ? carbon.layer.layerSelected01
                : CarbonPalette.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              if (widget.width != null)
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: item.enabled
                          ? carbon.text.textPrimary
                          : carbon.text.textDisabled,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    child: item.child,
                  ),
                )
              else
                DefaultTextStyle(
                  style: TextStyle(
                    color: item.enabled
                        ? carbon.text.textPrimary
                        : carbon.text.textDisabled,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  child: item.child,
                ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    CarbonIcons.checkmark,
                    size: 16,
                    color: carbon.text.iconInteractive,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    // Find the selected item to display
    final selectedItem = widget.items
        .where((item) => item.value == widget.value)
        .firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              color: widget.enabled
                  ? carbon.text.textSecondary
                  : carbon.text.textDisabled,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Dropdown trigger
        GestureDetector(
          key: _triggerKey,
          onTap: _toggleDropdown,
          child: Container(
            width: widget.width,
            height: widget.size.height,
            decoration: BoxDecoration(
              color: widget.enabled
                  ? carbon.layer.field01
                  : carbon.layer.layerSelectedDisabled,
              border: widget.showBorder
                  ? Border.all(
                      color: hasError
                          ? carbon.layer.supportError
                          : _isOpen
                          ? carbon.button.buttonPrimary
                          : carbon.layer.borderStrong01,
                      width: hasError || _isOpen ? 2 : 1,
                    )
                  : null,
              borderRadius: BorderRadius.zero,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final textWidget = selectedItem != null
                    ? DefaultTextStyle(
                        style: TextStyle(
                          color: widget.enabled
                              ? carbon.text.textPrimary
                              : carbon.text.textDisabled,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        child: selectedItem.child,
                      )
                    : widget.hint != null
                    ? Text(
                        widget.hint!,
                        style: TextStyle(
                          color: widget.enabled
                              ? carbon.text.textPlaceholder
                              : carbon.text.textInverse,
                          fontSize: 14,
                        ),
                      )
                    : const SizedBox.shrink();
                return Row(
                  children: [
                    if (constraints.hasBoundedWidth)
                      Expanded(child: textWidget)
                    else
                      textWidget,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child:
                          widget.icon ??
                          Icon(
                            _isOpen
                                ? CarbonIcons.chevronUp
                                : CarbonIcons.chevronDown,
                            color: widget.enabled
                                ? carbon.text.iconPrimary
                                : carbon.text.iconDisabled,
                            size: 16,
                          ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Helper or error text
        if (widget.helperText != null || widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText ?? widget.helperText!,
            style: TextStyle(
              color: hasError
                  ? carbon.layer.supportError
                  : carbon.text.textHelper,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

/// A menu item for use in a [CarbonDropdown].
class CarbonDropdownItem<T> {
  /// The value this item represents.
  final T value;

  /// The widget to display for this item.
  final Widget child;

  /// Whether this item is enabled.
  final bool enabled;

  const CarbonDropdownItem({
    required this.value,
    required this.child,
    this.enabled = true,
  });
}
