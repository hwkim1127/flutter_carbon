import 'package:flutter/widgets.dart';

/// Labels for the text-selection context menu shown by Carbon text fields.
///
/// English defaults; pass a customized instance to [CarbonTextInput] (or any
/// Carbon field widget) to localize the menu.
class CarbonTextSelectionLabels {
  const CarbonTextSelectionLabels({
    this.cut = 'Cut',
    this.copy = 'Copy',
    this.paste = 'Paste',
    this.selectAll = 'Select all',
    this.delete = 'Delete',
    this.share = 'Share',
    this.lookUp = 'Look up',
    this.searchWeb = 'Search web',
  });

  /// Default English labels.
  factory CarbonTextSelectionLabels.en() => const CarbonTextSelectionLabels();

  /// Label for the cut action.
  final String cut;

  /// Label for the copy action.
  final String copy;

  /// Label for the paste action.
  final String paste;

  /// Label for the select-all action.
  final String selectAll;

  /// Label for the delete action.
  final String delete;

  /// Label for the share action.
  final String share;

  /// Label for the look-up action.
  final String lookUp;

  /// Label for the search-web action.
  final String searchWeb;

  /// Resolves the label for a framework-provided context menu item.
  ///
  /// Returns the item's own label for custom/live-text items (may be null,
  /// in which case the item is dropped from the menu).
  String? labelFor(ContextMenuButtonItem item) {
    switch (item.type) {
      case ContextMenuButtonType.cut:
        return cut;
      case ContextMenuButtonType.copy:
        return copy;
      case ContextMenuButtonType.paste:
        return paste;
      case ContextMenuButtonType.selectAll:
        return selectAll;
      case ContextMenuButtonType.delete:
        return delete;
      case ContextMenuButtonType.share:
        return share;
      case ContextMenuButtonType.lookUp:
        return lookUp;
      case ContextMenuButtonType.searchWeb:
        return searchWeb;
      case ContextMenuButtonType.liveTextInput:
      case ContextMenuButtonType.custom:
        return item.label;
    }
  }
}
