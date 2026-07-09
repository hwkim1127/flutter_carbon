import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/widgets.dart';

import '../base/carbon_overlay_surface.dart';
import '../base/carbon_pressable.dart';
import '../foundation/colors.dart';
import '../foundation/typography.dart';
import '../theme/carbon_theme.dart';
import 'carbon_text_selection_labels.dart';

/// Carbon-styled text-selection context menu (Cut / Copy / Paste / …).
///
/// Built for `EditableText.contextMenuBuilder`: the framework owns the
/// overlay entry, dismissal, hide-on-scroll, and tap-region grouping — this
/// widget only lays out and styles the buttons. Positioning uses the SDK's
/// widgets-layer [TextSelectionToolbarLayoutDelegate].
///
/// Note: on web this never appears while the browser's native context menu
/// is enabled (the framework skips `contextMenuBuilder`); apps can opt in
/// with `BrowserContextMenu.disableContextMenu()`.
class CarbonTextSelectionToolbar extends StatelessWidget {
  const CarbonTextSelectionToolbar({
    super.key,
    required this.anchors,
    required this.buttonItems,
    required this.labels,
  });

  /// Convenience for `EditableText.contextMenuBuilder`.
  factory CarbonTextSelectionToolbar.editable({
    Key? key,
    required EditableTextState editableTextState,
    required CarbonTextSelectionLabels labels,
  }) {
    return CarbonTextSelectionToolbar(
      key: key,
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: editableTextState.contextMenuButtonItems,
      labels: labels,
    );
  }

  /// Anchor points (global coordinates) from the framework.
  final TextSelectionToolbarAnchors anchors;

  /// Platform-appropriate items (clipboard status already wired).
  final List<ContextMenuButtonItem> buttonItems;

  /// Button labels.
  final CarbonTextSelectionLabels labels;

  /// Gap between the toolbar and the selection when shown above.
  static const double _contentDistanceAbove = 8.0;

  /// Gap below the selection — clears the 22px handle boxes.
  static const double _contentDistanceBelow = 20.0;

  static const double _screenPadding = 8.0;

  bool get _isMobile {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return true;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = <({String label, VoidCallback onPressed})>[
      for (final item in buttonItems)
        if (item.onPressed != null && labels.labelFor(item) != null)
          (label: labels.labelFor(item)!, onPressed: item.onPressed!),
    ];
    if (entries.isEmpty) return const SizedBox.shrink();

    // The layout delegate works in local coordinates; the anchors are
    // global. Subtract the padding offset (same pattern as the SDK's
    // Material toolbar).
    final paddingAbove = MediaQuery.paddingOf(context).top + _screenPadding;
    final localAdjustment = Offset(_screenPadding, paddingAbove);
    final anchorAbove =
        anchors.primaryAnchor - const Offset(0, _contentDistanceAbove);
    final anchorBelow =
        (anchors.secondaryAnchor ?? anchors.primaryAnchor) +
        const Offset(0, _contentDistanceBelow);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _screenPadding,
        paddingAbove,
        _screenPadding,
        _screenPadding,
      ),
      child: CustomSingleChildLayout(
        delegate: TextSelectionToolbarLayoutDelegate(
          anchorAbove: anchorAbove - localAdjustment,
          anchorBelow: anchorBelow - localAdjustment,
        ),
        child: _CarbonToolbarContainer(entries: entries, vertical: !_isMobile),
      ),
    );
  }
}

class _CarbonToolbarContainer extends StatelessWidget {
  const _CarbonToolbarContainer({
    required this.entries,
    required this.vertical,
  });

  final List<({String label, VoidCallback onPressed})> entries;

  /// Horizontal row on mobile (above the selection), vertical menu on
  /// desktop (right-click convention, matching Carbon's menu component).
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    final buttons = [
      for (final entry in entries)
        _CarbonToolbarButton(
          label: entry.label,
          onPressed: entry.onPressed,
          vertical: vertical,
        ),
    ];

    return CarbonOverlaySurface(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: carbon.layer.layer01,
          border: Border.all(color: carbon.layer.borderSubtle01),
          boxShadow: [
            BoxShadow(
              color: CarbonPalette.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: vertical
            ? IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buttons,
                ),
              )
            : Row(mainAxisSize: MainAxisSize.min, children: buttons),
      ),
    );
  }
}

class _CarbonToolbarButton extends StatelessWidget {
  const _CarbonToolbarButton({
    required this.label,
    required this.onPressed,
    required this.vertical,
  });

  final String label;
  final VoidCallback onPressed;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return CarbonPressable(
      onTap: onPressed,
      builder: (context, state) => Container(
        height: 32,
        constraints: vertical ? const BoxConstraints(minWidth: 128) : null,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: vertical
            ? AlignmentDirectional.centerStart
            : Alignment.center,
        color: state.hovered || state.pressed
            ? carbon.layer.layerHover01
            : null,
        child: Text(
          label,
          style: CarbonTypography.bodyCompact01.copyWith(
            color: state.hovered || state.pressed
                ? carbon.text.textPrimary
                : carbon.text.textSecondary,
          ),
        ),
      ),
    );
  }
}
