import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Floating Menu using Carbon's CarbonFloatingMenu.
class FloatingMenuDemoPage extends StatelessWidget {
  const FloatingMenuDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Floating Menu',
      description:
          'Floating action menu that expands to show multiple action items. Based on SpeedDial pattern with Carbon styling.',
      sections: [
        DemoSection(
          title: 'Basic Floating Menu',
          description: 'Click the FAB to expand menu items.',
          builder: (context) => const SizedBox(
            height: 400,
            child: Stack(
              children: [
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: CarbonFloatingMenu(
                    heroTag: 'fab1',
                    icon: Icons.add,
                    items: [
                      CarbonFloatingMenuItem(
                        icon: Icons.create,
                        label: 'Create new',
                        onTap: _showSnackBar,
                      ),
                      CarbonFloatingMenuItem(
                        icon: Icons.upload,
                        label: 'Upload file',
                        onTap: _showSnackBar,
                      ),
                      CarbonFloatingMenuItem(
                        icon: Icons.folder,
                        label: 'New folder',
                        onTap: _showSnackBar,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'With Custom Icons',
          description: 'Floating menu with custom open/close icons.',
          builder: (context) => const SizedBox(
            height: 400,
            child: Stack(
              children: [
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: CarbonFloatingMenu(
                    heroTag: 'fab2',
                    icon: Icons.menu,
                    openIcon: Icons.close,
                    items: [
                      CarbonFloatingMenuItem(
                        icon: Icons.edit,
                        label: 'Edit',
                        onTap: _showSnackBar,
                      ),
                      CarbonFloatingMenuItem(
                        icon: Icons.share,
                        label: 'Share',
                        onTap: _showSnackBar,
                      ),
                      CarbonFloatingMenuItem(
                        icon: Icons.delete,
                        label: 'Delete',
                        onTap: _showSnackBar,
                      ),
                      CarbonFloatingMenuItem(
                        icon: Icons.archive,
                        label: 'Archive',
                        onTap: _showSnackBar,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static void _showSnackBar() {
    // This will be called from context, but we're using const, so leaving as placeholder
  }
}
