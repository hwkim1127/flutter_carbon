import 'package:flutter/services.dart' show KeyDownEvent, LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../base/carbon_scrollbar.dart';

import '../base/carbon_divider.dart';
import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// Visual kind of a [CarbonMenuItem] (mirrors React Menu's `kind`).
enum CarbonMenuItemKind {
  /// Standard menu item.
  standard,

  /// Destructive action: highlighted in `$button-danger-primary`.
  danger,
}

/// Item-height variants for a Carbon menu (24/32/40/48px).
enum CarbonMenuSize {
  xs(24),
  sm(32),
  md(40),
  lg(48);

  const CarbonMenuSize(this.itemHeight);

  /// Menu item height in logical pixels.
  final double itemHeight;
}

/// An entry in a Carbon menu: either a [CarbonMenuItem] or a
/// [CarbonMenuItemDivider].
///
/// The type parameter [T] is the value type reported through the hosting
/// widget's selection callback (e.g. `CarbonComboButton.onMenuItemSelected`).
sealed class CarbonMenuEntry<T> {
  const CarbonMenuEntry();
}

/// A selectable item in a Carbon menu.
///
/// Activation runs [onTap] first, then reports [value] through the host's
/// selection callback when [value] is non-null.
class CarbonMenuItem<T> extends CarbonMenuEntry<T> {
  const CarbonMenuItem({
    required this.label,
    this.value,
    this.icon,
    this.kind = CarbonMenuItemKind.standard,
    this.disabled = false,
    this.onTap,
    this.shortcut,
  });

  /// The text shown for this item.
  final String label;

  /// Optional value reported through the host's selection callback.
  final T? value;

  /// Optional leading icon (rendered at 16px).
  final Widget? icon;

  /// Standard or danger styling.
  final CarbonMenuItemKind kind;

  /// Whether this item is disabled.
  final bool disabled;

  /// Called when this item is activated (before the host's callback).
  final VoidCallback? onTap;

  /// Display-only trailing shortcut hint (not a key binding).
  final String? shortcut;
}

/// A divider between menu items.
class CarbonMenuItemDivider<T> extends CarbonMenuEntry<T> {
  const CarbonMenuItemDivider();
}

/// Renders Carbon Menu content: hosts (combo button, future menu widgets)
/// place this inside a [CarbonOverlaySurface] inside a
/// [CarbonAnchoredOverlay].
///
/// Keyboard: Escape closes; ArrowUp/Down move the highlight (skipping
/// dividers and disabled items); Home/End jump; Enter/Space activate. Hover
/// and keyboard share one highlight.
///
/// Not exported — a building block for Carbon widgets, not public API.
class CarbonMenuPanel<T> extends StatefulWidget {
  const CarbonMenuPanel({
    super.key,
    required this.entries,
    required this.onClose,
    this.onSelected,
    this.selectedValue,
    this.size = CarbonMenuSize.sm,
    this.minWidth = 160,
    this.maxWidth = 288,
    this.maxHeight,
  });

  /// The menu content.
  final List<CarbonMenuEntry<T>> entries;

  /// Called to dismiss the menu (Escape, or after an item activates).
  final VoidCallback onClose;

  /// Called with an activated item's [CarbonMenuItem.value] when non-null.
  final ValueChanged<T>? onSelected;

  /// Marks the item with this value as selected: `$layer-selected`
  /// background, primary text, trailing checkmark. The keyboard highlight
  /// also starts on it, so arrows continue from the selection.
  final T? selectedValue;

  /// Item height variant (Carbon default: sm = 32px).
  final CarbonMenuSize size;

  /// Spec: 160 (192 when icons are present — host's choice).
  final double minWidth;

  /// Spec: 288. Inert when the host anchors with `matchAnchorWidth`.
  final double? maxWidth;

  /// When set the panel scrolls beyond this height (keyboard highlight is
  /// kept in view). Null (default) renders the unconstrained column.
  final double? maxHeight;

  @override
  State<CarbonMenuPanel<T>> createState() => _CarbonMenuPanelState<T>();
}

class _CarbonMenuPanelState<T> extends State<CarbonMenuPanel<T>> {
  final FocusNode _focusNode = FocusNode(debugLabel: 'CarbonMenuPanel');

  /// Whatever held focus before the menu opened (usually the trigger);
  /// restored on close so keyboard users keep their place.
  FocusNode? _previousFocus;

  /// Index into [CarbonMenuPanel.entries]; hover and keyboard share it.
  int? _highlightedIndex;

  /// Only created when [CarbonMenuPanel.maxHeight] makes the panel scroll.
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    if (widget.maxHeight != null) {
      _scrollController = ScrollController();
    }
    // Scroll the selection into view on open; the keyboard highlight itself
    // stays unset until a key moves it (see _moveHighlight's fallback).
    final selected = _selectedIndex();
    if (selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _revealHighlight(selected);
      });
    }
    _previousFocus = FocusManager.instance.primaryFocus;
    // `autofocus` is ignored when the scope already has a focused node
    // (e.g. the trigger button after keyboard interaction) — without primary
    // focus here, arrow keys fall through to the app's directional focus
    // traversal instead of driving the menu. Take focus explicitly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  int? _selectedIndex() {
    final selectedValue = widget.selectedValue;
    if (selectedValue == null) return null;
    for (var i = 0; i < widget.entries.length; i++) {
      final entry = widget.entries[i];
      if (entry is CarbonMenuItem<T> &&
          !entry.disabled &&
          entry.value == selectedValue) {
        return i;
      }
    }
    return null;
  }

  double _entryOffset(int index) {
    var offset = 0.0;
    for (var i = 0; i < index; i++) {
      // Divider: 1px rule + 4px vertical margins.
      offset += widget.entries[i] is CarbonMenuItemDivider<T>
          ? 9.0
          : widget.size.itemHeight;
    }
    return offset;
  }

  void _revealHighlight(int index) {
    final controller = _scrollController;
    if (controller == null || !controller.hasClients) return;
    final top = _entryOffset(index);
    final bottom = top + widget.size.itemHeight;
    final viewTop = controller.offset;
    final viewBottom = viewTop + controller.position.viewportDimension;
    if (top < viewTop) {
      controller.jumpTo(top);
    } else if (bottom > viewBottom) {
      controller.jumpTo(bottom - controller.position.viewportDimension);
    }
  }

  @override
  void dispose() {
    // Restore focus to the pre-menu node — but only when focus fell back to
    // a scope (i.e. nobody else claimed it, e.g. a dialog an item opened).
    final current = FocusManager.instance.primaryFocus;
    final previous = _previousFocus;
    if (previous != null &&
        previous.context != null &&
        (current == null || current == _focusNode || current is FocusScopeNode)) {
      previous.requestFocus();
    }
    _focusNode.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  bool _isEnabledItem(int index) {
    final entry = widget.entries[index];
    return entry is CarbonMenuItem<T> && !entry.disabled;
  }

  void _activate(CarbonMenuItem<T> item) {
    item.onTap?.call();
    final value = item.value;
    if (value != null) {
      widget.onSelected?.call(value);
    }
    widget.onClose();
  }

  void _moveHighlight(int direction) {
    final count = widget.entries.length;
    if (count == 0) return;
    // Without a highlight yet, arrows continue from the selected item.
    var index =
        _highlightedIndex ??
        _selectedIndex() ??
        (direction > 0 ? -1 : count);
    for (var step = 0; step < count; step++) {
      index += direction;
      if (index < 0 || index >= count) return; // no wrap-around
      if (_isEnabledItem(index)) {
        setState(() => _highlightedIndex = index);
        _revealHighlight(index);
        return;
      }
    }
  }

  void _jumpHighlight({required bool toEnd}) {
    final indices = Iterable<int>.generate(widget.entries.length);
    for (final index in toEnd ? indices.toList().reversed : indices) {
      if (_isEnabledItem(index)) {
        setState(() => _highlightedIndex = index);
        _revealHighlight(index);
        return;
      }
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      widget.onClose();
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
    if (event.logicalKey == LogicalKeyboardKey.home) {
      _jumpHighlight(toEnd: false);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.end) {
      _jumpHighlight(toEnd: true);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      final index = _highlightedIndex;
      if (index != null && _isEnabledItem(index)) {
        _activate(widget.entries[index] as CarbonMenuItem<T>);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    Widget list = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.entries.length; i++)
          switch (widget.entries[i]) {
            CarbonMenuItemDivider<T>() => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CarbonDivider(color: carbon.layer.borderSubtle01),
            ),
            final CarbonMenuItem<T> item => _buildItem(carbon, item, i),
          },
      ],
    );
    if (widget.maxHeight != null) {
      final content = list;
      list = CarbonScrollbar(
        controller: _scrollController,
        builder: (context, controller) =>
            SingleChildScrollView(controller: controller, child: content),
      );
    }

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKey,
      child: Container(
        constraints: BoxConstraints(
          minWidth: widget.minWidth,
          maxWidth: widget.maxWidth ?? double.infinity,
          maxHeight: widget.maxHeight ?? double.infinity,
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: carbon.layer.layer01,
          border: Border.all(color: carbon.layer.borderSubtle01),
          boxShadow: [
            BoxShadow(
              // $shadow already encodes its alpha (0.3 light / 0.8 dark).
              color: carbon.layer.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicWidth(child: list),
      ),
    );
  }

  Widget _buildItem(CarbonThemeData carbon, CarbonMenuItem<T> item, int index) {
    final highlighted = _highlightedIndex == index && !item.disabled;
    final danger = item.kind == CarbonMenuItemKind.danger;
    final selected = !item.disabled &&
        widget.selectedValue != null &&
        item.value == widget.selectedValue;

    // Danger items look standard at rest (Menu spec) — red only highlighted.
    final Color background;
    final Color foreground;
    if (item.disabled) {
      background = carbon.layer.layer01;
      foreground = carbon.text.textDisabled;
    } else if (highlighted && danger) {
      background = carbon.button.buttonDangerPrimary;
      foreground = carbon.text.textOnColor;
    } else if (selected) {
      background = highlighted
          ? carbon.layer.layerSelectedHover01
          : carbon.layer.layerSelected01;
      foreground = carbon.text.textPrimary;
    } else if (highlighted) {
      background = carbon.layer.layerHover01;
      foreground = carbon.text.textPrimary;
    } else {
      background = carbon.layer.layer01;
      foreground = carbon.text.textSecondary;
    }

    return MouseRegion(
      onEnter: (_) {
        if (!item.disabled) setState(() => _highlightedIndex = index);
      },
      onExit: (_) {
        if (_highlightedIndex == index) {
          setState(() => _highlightedIndex = null);
        }
      },
      cursor: item.disabled
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: item.disabled ? null : () => _activate(item),
        behavior: HitTestBehavior.opaque,
        child: Semantics(
          button: true,
          enabled: !item.disabled,
          selected: selected,
          child: AnimatedContainer(
            duration: CarbonMotion.fast01,
            curve: CarbonMotion.standardProductive,
            height: widget.size.itemHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: background,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(size: 16, color: foreground),
                    child: item.icon!,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: CarbonTypography.bodyCompact01.copyWith(
                      color: foreground,
                    ),
                  ),
                ),
                if (item.shortcut != null) ...[
                  const SizedBox(width: 16),
                  Text(
                    item.shortcut!,
                    style: CarbonTypography.bodyCompact01.copyWith(
                      color: foreground,
                    ),
                  ),
                ],
                if (selected) ...[
                  const SizedBox(width: 16),
                  Icon(CarbonIcons.checkmark, size: 16, color: foreground),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
