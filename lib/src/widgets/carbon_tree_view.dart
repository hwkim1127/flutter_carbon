import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Carbon Design System tree view (hierarchical tree with expand/collapse).
///
/// A tree view that follows Carbon Design System specifications with:
/// - Hierarchical structure with expand/collapse
/// - Selection support
/// - Sharp corners (zero border radius)
///
/// Example:
/// ```dart
/// CarbonTreeView(
///   nodes: [
///     CarbonTreeNode(
///       label: 'Parent 1',
///       children: [
///         CarbonTreeNode(label: 'Child 1'),
///         CarbonTreeNode(label: 'Child 2'),
///       ],
///     ),
///   ],
/// )
/// ```
class CarbonTreeView extends StatefulWidget {
  /// The root nodes of the tree.
  final List<CarbonTreeNode> nodes;

  /// Whether nodes are selectable.
  final bool selectable;

  /// Currently selected node.
  final CarbonTreeNode? selectedNode;

  /// Called when a node is selected.
  final ValueChanged<CarbonTreeNode>? onNodeSelected;

  /// Whether to show borders.
  final bool showBorder;

  const CarbonTreeView({
    super.key,
    required this.nodes,
    this.selectable = false,
    this.selectedNode,
    this.onNodeSelected,
    this.showBorder = true,
  });

  @override
  State<CarbonTreeView> createState() => _CarbonTreeViewState();
}

class _CarbonTreeViewState extends State<CarbonTreeView> {
  final Set<CarbonTreeNode> _expandedNodes = {};
  CarbonTreeNode? _hoveredNode;

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

  Widget _buildNode(CarbonTreeNode node, int depth) {
    final carbon = context.carbon;
    final theme = carbon.treeView;
    final hasChildren = node.children != null && node.children!.isNotEmpty;
    final isExpanded = _expandedNodes.contains(node);
    final isSelected = widget.selectedNode == node;
    final isHovered = _hoveredNode == node;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hoveredNode = node),
          onExit: (_) => setState(() => _hoveredNode = null),
          child: InkWell(
            onTap: () {
              if (hasChildren) {
                setState(() {
                  if (isExpanded) {
                    _expandedNodes.remove(node);
                  } else {
                    _expandedNodes.add(node);
                  }
                });
              }
              if (widget.selectable && widget.onNodeSelected != null) {
                widget.onNodeSelected!(node);
              }
            },
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
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
                      isExpanded ? Icons.expand_more : Icons.chevron_right,
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
class CarbonTreeNode {
  /// The label text for the node.
  final String label;

  /// Optional icon for the node.
  final IconData? icon;

  /// Child nodes.
  final List<CarbonTreeNode>? children;

  /// Optional data associated with this node.
  final dynamic data;

  const CarbonTreeNode({
    required this.label,
    this.icon,
    this.children,
    this.data,
  });
}
