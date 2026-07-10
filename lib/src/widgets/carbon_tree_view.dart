import 'package:flutter/widgets.dart';

import '../base/carbon_pressable.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';

/// Carbon Design System tree view (hierarchical tree with expand/collapse).
///
/// A tree view that follows Carbon Design System specifications with:
/// - Hierarchical structure with expand/collapse
/// - Selection support
/// - Sharp corners (zero border radius)
///
/// Selection is value-based: give selectable nodes a [CarbonTreeNode.value]
/// and control the tree with [selectedValue], mirroring the id-based
/// selection of Carbon's TreeView. Values also key the expand/collapse
/// state, so it survives rebuilding the [nodes] list; nodes without a value
/// fall back to instance identity (keep those instances stable across
/// builds if they can expand).
///
/// Example:
/// ```dart
/// CarbonTreeView<String>(
///   selectable: true,
///   selectedValue: _selected,
///   onNodeSelected: (node) => setState(() => _selected = node.value),
///   nodes: [
///     CarbonTreeNode(
///       label: 'Parent 1',
///       value: 'parent-1',
///       children: [
///         CarbonTreeNode(label: 'Child 1', value: 'child-1'),
///         CarbonTreeNode(label: 'Child 2', value: 'child-2'),
///       ],
///     ),
///   ],
/// )
/// ```
class CarbonTreeView<T> extends StatefulWidget {
  /// The root nodes of the tree.
  final List<CarbonTreeNode<T>> nodes;

  /// Whether nodes are selectable.
  final bool selectable;

  /// Value of the currently selected node.
  ///
  /// A node is selected when its [CarbonTreeNode.value] equals this.
  final T? selectedValue;

  /// Called when a node is selected.
  final ValueChanged<CarbonTreeNode<T>>? onNodeSelected;

  /// Whether to show borders.
  final bool showBorder;

  const CarbonTreeView({
    super.key,
    required this.nodes,
    this.selectable = false,
    this.selectedValue,
    this.onNodeSelected,
    this.showBorder = true,
  });

  @override
  State<CarbonTreeView<T>> createState() => _CarbonTreeViewState<T>();
}

class _CarbonTreeViewState<T> extends State<CarbonTreeView<T>> {
  /// Keyed by [CarbonTreeNode.value] when present, node identity otherwise.
  final Set<Object> _expandedKeys = {};
  Object? _hoveredKey;

  Object _keyOf(CarbonTreeNode<T> node) => node.value ?? node;

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    final theme = carbon.treeView;

    return Container(
      decoration: BoxDecoration(
        color: theme.background,
        border: widget.showBorder
            ? Border.all(color: theme.borderColor, width: 1)
            : null,
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        shrinkWrap: true,
        children: widget.nodes.map((node) => _buildNode(node, 0)).toList(),
      ),
    );
  }

  Widget _buildNode(CarbonTreeNode<T> node, int depth) {
    final carbon = context.carbon;
    final theme = carbon.treeView;
    final key = _keyOf(node);
    final hasChildren = node.children != null && node.children!.isNotEmpty;
    final isExpanded = _expandedKeys.contains(key);
    final isSelected =
        node.value != null && node.value == widget.selectedValue;
    final isHovered = _hoveredKey == key;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hoveredKey = key),
          onExit: (_) => setState(() => _hoveredKey = null),
          child: CarbonPressable(
            onTap: () {
              if (hasChildren) {
                setState(() {
                  if (isExpanded) {
                    _expandedKeys.remove(key);
                  } else {
                    _expandedKeys.add(key);
                  }
                });
              }
              if (widget.selectable && widget.onNodeSelected != null) {
                widget.onNodeSelected!(node);
              }
            },
            builder: (context, _) => Container(
              padding: EdgeInsets.only(
                left: 16.0 + (depth * 24.0),
                right: 16.0,
                top: 12.0,
                bottom: 12.0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.nodeSelected
                    : (isHovered ? theme.nodeHover : null),
              ),
              child: Row(
                children: [
                  if (hasChildren)
                    Icon(
                      isExpanded
                          ? CarbonIcons.chevronDown
                          : CarbonIcons.chevronRight,
                      size: 20,
                      color: theme.iconColor,
                    )
                  else
                    const SizedBox(width: 20),
                  const SizedBox(width: 8),
                  if (node.icon != null) ...[
                    Icon(node.icon, size: 16, color: theme.iconColor),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      node.label,
                      style: TextStyle(
                        color: theme.nodeTextColor,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasChildren && isExpanded)
          ...node.children!.map((child) => _buildNode(child, depth + 1)),
      ],
    );
  }
}

/// A node in a [CarbonTreeView].
class CarbonTreeNode<T> {
  /// The label text for the node.
  final String label;

  /// Optional icon for the node.
  final IconData? icon;

  /// Child nodes.
  final List<CarbonTreeNode<T>>? children;

  /// The value this node represents.
  ///
  /// Used for selection (compared against [CarbonTreeView.selectedValue])
  /// and as the key for the node's expand/collapse state. Should be unique
  /// within the tree.
  final T? value;

  const CarbonTreeNode({
    required this.label,
    this.icon,
    this.children,
    this.value,
  });
}
