import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonTreeView component.
class TreeViewDemoPage extends StatefulWidget {
  const TreeViewDemoPage({super.key});

  @override
  State<TreeViewDemoPage> createState() => _TreeViewDemoPageState();
}

class _TreeViewDemoPageState extends State<TreeViewDemoPage> {
  CarbonTreeNode? _selectedNode1;
  CarbonTreeNode? _selectedNode2;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Tree View',
      description:
          'Hierarchical tree structure with expand/collapse functionality.',
      sections: [
        DemoSection(
          title: 'Basic Tree View',
          description: 'Simple tree with expandable nodes',
          builder: (context) => CarbonTreeView(
            nodes: [
              const CarbonTreeNode(
                label: 'Root',
                children: [
                  CarbonTreeNode(label: 'Child 1'),
                  CarbonTreeNode(label: 'Child 2'),
                  CarbonTreeNode(label: 'Child 3'),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Multi-Level Tree',
          description: 'Tree with multiple levels of nesting',
          builder: (context) => CarbonTreeView(
            nodes: [
              const CarbonTreeNode(
                label: 'Documents',
                children: [
                  CarbonTreeNode(
                    label: 'Work',
                    children: [
                      CarbonTreeNode(label: 'Reports'),
                      CarbonTreeNode(label: 'Presentations'),
                    ],
                  ),
                  CarbonTreeNode(
                    label: 'Personal',
                    children: [
                      CarbonTreeNode(label: 'Photos'),
                      CarbonTreeNode(label: 'Videos'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'With Icons',
          description: 'Tree nodes with icons',
          builder: (context) => CarbonTreeView(
            nodes: [
              const CarbonTreeNode(
                label: 'src',
                icon: Icons.folder,
                children: [
                  CarbonTreeNode(
                    label: 'components',
                    icon: Icons.folder,
                    children: [
                      CarbonTreeNode(
                        label: 'Button.tsx',
                        icon: Icons.description,
                      ),
                      CarbonTreeNode(
                        label: 'Input.tsx',
                        icon: Icons.description,
                      ),
                    ],
                  ),
                  CarbonTreeNode(
                    label: 'utils',
                    icon: Icons.folder,
                    children: [
                      CarbonTreeNode(
                        label: 'helpers.ts',
                        icon: Icons.description,
                      ),
                      CarbonTreeNode(
                        label: 'constants.ts',
                        icon: Icons.description,
                      ),
                    ],
                  ),
                  CarbonTreeNode(label: 'index.ts', icon: Icons.description),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Selectable Tree',
          description: 'Tree with selectable nodes',
          builder: (context) {
            final node1 = const CarbonTreeNode(label: 'Item 1');
            final node2 = const CarbonTreeNode(label: 'Item 2');
            final node3 = const CarbonTreeNode(label: 'Item 3');
            final parent = CarbonTreeNode(
              label: 'Parent',
              children: [node1, node2, node3],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarbonTreeView(
                  selectable: true,
                  selectedNode: _selectedNode1,
                  onNodeSelected: (node) {
                    setState(() => _selectedNode1 = node);
                  },
                  nodes: [parent],
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedNode1 != null
                      ? 'Selected: ${_selectedNode1!.label}'
                      : 'No selection',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.carbon.text.textSecondary,
                  ),
                ),
              ],
            );
          },
        ),
        DemoSection(
          title: 'Without Border',
          description: 'Tree view without border',
          builder: (context) => CarbonTreeView(
            showBorder: false,
            nodes: [
              const CarbonTreeNode(
                label: 'Level 1',
                children: [
                  CarbonTreeNode(
                    label: 'Level 2',
                    children: [CarbonTreeNode(label: 'Level 3')],
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'File System Example',
          description: 'Complete file system tree',
          builder: (context) {
            final readme = const CarbonTreeNode(
              label: 'README.md',
              icon: Icons.description,
            );
            final package = const CarbonTreeNode(
              label: 'package.json',
              icon: Icons.description,
            );
            final index = const CarbonTreeNode(
              label: 'index.html',
              icon: Icons.description,
            );
            final app = const CarbonTreeNode(
              label: 'App.tsx',
              icon: Icons.description,
            );
            final main = const CarbonTreeNode(
              label: 'main.tsx',
              icon: Icons.description,
            );
            final style = const CarbonTreeNode(
              label: 'style.css',
              icon: Icons.description,
            );

            final srcFolder = CarbonTreeNode(
              label: 'src',
              icon: Icons.folder,
              children: [app, main, style],
            );

            final publicFolder = const CarbonTreeNode(
              label: 'public',
              icon: Icons.folder,
              children: [
                CarbonTreeNode(label: 'favicon.ico', icon: Icons.image),
              ],
            );

            final root = CarbonTreeNode(
              label: 'my-project',
              icon: Icons.folder_open,
              children: [readme, package, srcFolder, publicFolder, index],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarbonTreeView(
                  selectable: true,
                  selectedNode: _selectedNode2,
                  onNodeSelected: (node) {
                    setState(() => _selectedNode2 = node);
                  },
                  nodes: [root],
                ),
                const SizedBox(height: 16),
                if (_selectedNode2 != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.carbon.layer.layer02,
                      border: Border.all(
                        color: context.carbon.layer.borderSubtle01,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected File',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: context.carbon.text.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedNode2!.label,
                          style: TextStyle(
                            fontSize: 14,
                            color: context.carbon.text.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        DemoSection(
          title: 'Organization Hierarchy',
          description: 'Organizational structure tree',
          builder: (context) => CarbonTreeView(
            selectable: true,
            nodes: [
              const CarbonTreeNode(
                label: 'CEO',
                icon: Icons.person,
                children: [
                  CarbonTreeNode(
                    label: 'VP Engineering',
                    icon: Icons.engineering,
                    children: [
                      CarbonTreeNode(
                        label: 'Backend Team',
                        icon: Icons.code,
                        children: [
                          CarbonTreeNode(
                            label: 'Lead Developer',
                            icon: Icons.person,
                          ),
                          CarbonTreeNode(
                            label: 'Senior Developer',
                            icon: Icons.person,
                          ),
                          CarbonTreeNode(
                            label: 'Junior Developer',
                            icon: Icons.person,
                          ),
                        ],
                      ),
                      CarbonTreeNode(
                        label: 'Frontend Team',
                        icon: Icons.code,
                        children: [
                          CarbonTreeNode(
                            label: 'Lead Developer',
                            icon: Icons.person,
                          ),
                          CarbonTreeNode(
                            label: 'UI Developer',
                            icon: Icons.person,
                          ),
                        ],
                      ),
                    ],
                  ),
                  CarbonTreeNode(
                    label: 'VP Marketing',
                    icon: Icons.campaign,
                    children: [
                      CarbonTreeNode(
                        label: 'Marketing Manager',
                        icon: Icons.person,
                      ),
                      CarbonTreeNode(
                        label: 'Content Writer',
                        icon: Icons.person,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
