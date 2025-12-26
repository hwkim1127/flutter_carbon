import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import 'pages/home_page.dart';
import 'pages/all_components_page.dart';
import 'pages/foundation/colors_page.dart';
import 'pages/foundation/typography_page.dart';
import 'pages/foundation/icons_page.dart';
import 'pages/foundation/layering_page.dart';
import 'pages/breadcrumb_demo_page.dart';
import 'pages/buttons_demo_page.dart';
import 'pages/code_snippet_demo_page.dart';
import 'pages/combo_box_demo_page.dart';
import 'pages/content_switcher_demo_page.dart';
import 'pages/dropdown_demo_page.dart';
import 'pages/loading_demo_page.dart';
import 'pages/modal_demo_page.dart';
import 'pages/notifications_demo_page.dart';
import 'pages/number_input_demo_page.dart';
import 'pages/overflow_menu_demo_page.dart';
import 'pages/pagination_demo_page.dart';
import 'pages/popover_demo_page.dart';
import 'pages/side_panel_demo_page.dart';
import 'pages/skeleton_demo_page.dart';
import 'pages/tearsheet_demo_page.dart';
import 'pages/toggle_demo_page.dart';
import 'pages/toggle_tip_demo_page.dart';
import 'pages/ui_shell_demo_page.dart';
import 'pages/page_header_demo_page.dart';
import 'pages/structured_list_demo_page.dart';
import 'pages/tree_view_demo_page.dart';
import 'pages/combo_button_demo_page.dart';
import 'pages/file_uploader_demo_page.dart';
import 'pages/link_demo_page.dart';
import 'pages/copy_button_demo_page.dart';
import 'pages/ai_label_demo_page.dart';
import 'pages/chat_button_demo_page.dart';
import 'pages/date_time_picker_demo_page.dart';
import 'pages/text_input_demo_page.dart';
import 'pages/status_demo_page.dart';
import 'pages/syntax_highlighting_demo_page.dart';
import 'pages/accordion_demo_page.dart';
import 'pages/tabs_demo_page.dart';
import 'pages/tag_demo_page.dart';
import 'pages/tooltip_demo_page.dart';
import 'pages/search_demo_page.dart';
import 'pages/select_demo_page.dart';
import 'pages/data_table_demo_page.dart';
import 'pages/tile_demo_page.dart';
import 'pages/material_selection_demo_page.dart';
import 'pages/multi_select_demo_page.dart';
import 'pages/contained_list_demo_page.dart';
import 'pages/floating_menu_demo_page.dart';
import 'routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ---------------------------------------------------------
  // FONTS LICENSE INITIALIZATION
  // ---------------------------------------------------------
  LicenseRegistry.addLicense(() async* {
    // 1. Load the license text once
    final license = await rootBundle.loadString('fonts/OFL.txt');

    // 2. Apply it to all 3 font families
    yield LicenseEntryWithLineBreaks([
      'IBM Plex Sans',
      'IBM Plex Mono',
      'IBM Plex Serif',
    ], license);
  });
  // ---------------------------------------------------------

  runApp(const CarbonExampleApp());
}

/// The main application widget for the Carbon example app.
class CarbonExampleApp extends StatefulWidget {
  const CarbonExampleApp({super.key});

  @override
  State<CarbonExampleApp> createState() => _CarbonExampleAppState();
}

/// Helper enum to define available themes.
enum CarbonThemeMode { white, g10, g90, g100 }

class _CarbonExampleAppState extends State<CarbonExampleApp> {
  CarbonThemeMode _currentMode = CarbonThemeMode.white;

  /// Returns the corresponding [CarbonThemeData] for a given mode.
  CarbonThemeData getThemeData(CarbonThemeMode mode) {
    switch (mode) {
      case CarbonThemeMode.white:
        return WhiteTheme.theme;
      case CarbonThemeMode.g10:
        return G10Theme.theme;
      case CarbonThemeMode.g90:
        return G90Theme.theme;
      case CarbonThemeMode.g100:
        return G100Theme.theme;
    }
  }

  @override
  Widget build(BuildContext context) {
    final carbon = getThemeData(_currentMode);

    return MaterialApp(
      title: 'Carbon Flutter Theme',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.trackpad,
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.invertedStylus,
          PointerDeviceKind.unknown,
        },
      ),
      theme: carbonTheme(carbon: carbon),
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        // Theme switcher wrapper for all pages
        Widget Function(BuildContext) builder;

        switch (settings.name) {
          case AppRoutes.home:
            builder = (_) => const HomePage();
            break;
          case AppRoutes.allComponents:
            builder = (_) => const AllComponentsPage();
            break;

          // Foundation
          case AppRoutes.colors:
            builder = (_) => const ColorsPage();
            break;
          case AppRoutes.typography:
            builder = (_) => const TypographyPage();
            break;
          case AppRoutes.icons:
            builder = (_) => const IconsPage();
            break;
          case AppRoutes.layering:
            builder = (_) => const LayeringPage();
            break;

          // Buttons
          case AppRoutes.buttons:
            builder = (_) => const ButtonsDemoPage();
            break;
          case AppRoutes.comboButton:
            builder = (_) => const ComboButtonDemoPage();
            break;
          case AppRoutes.copyButton:
            builder = (_) => const CopyButtonDemoPage();
            break;
          case AppRoutes.chatButton:
            builder = (_) => const ChatButtonDemoPage();
            break;

          // Forms
          case AppRoutes.textInput:
            builder = (_) => const TextInputDemoPage();
            break;
          case AppRoutes.numberInput:
            builder = (_) => const NumberInputDemoPage();
            break;
          case AppRoutes.dropdown:
            builder = (_) => const DropdownDemoPage();
            break;
          case AppRoutes.comboBox:
            builder = (_) => const ComboBoxDemoPage();
            break;
          case AppRoutes.dateTimePicker:
            builder = (_) => const DateTimePickerDemoPage();
            break;
          case AppRoutes.toggle:
            builder = (_) => const ToggleDemoPage();
            break;
          case AppRoutes.fileUploader:
            builder = (_) => const FileUploaderDemoPage();
            break;

          // Notifications
          case AppRoutes.notifications:
            builder = (_) => const NotificationsDemoPage();
            break;
          case AppRoutes.status:
            builder = (_) => const StatusDemoPage();
            break;

          // Content
          case AppRoutes.contentSwitcher:
            builder = (_) => const ContentSwitcherDemoPage();
            break;
          case AppRoutes.skeleton:
            builder = (_) => const SkeletonDemoPage();
            break;
          case AppRoutes.codeSnippet:
            builder = (_) => const CodeSnippetDemoPage();
            break;
          case AppRoutes.structuredList:
            builder = (_) => const StructuredListDemoPage();
            break;
          case AppRoutes.treeView:
            builder = (_) => const TreeViewDemoPage();
            break;

          // Navigation
          case AppRoutes.breadcrumb:
            builder = (_) => const BreadcrumbDemoPage();
            break;
          case AppRoutes.pagination:
            builder = (_) => const PaginationDemoPage();
            break;
          case AppRoutes.uiShell:
            builder = (_) => const UIShellDemoPage();
            break;

          // Data Display
          case AppRoutes.loading:
            builder = (_) => const LoadingDemoPage();
            break;
          case AppRoutes.link:
            builder = (_) => const LinkDemoPage();
            break;

          // Overlays
          case AppRoutes.modal:
            builder = (_) => const ModalDemoPage();
            break;
          case AppRoutes.sidePanel:
            builder = (_) => const SidePanelDemoPage();
            break;
          case AppRoutes.tearsheet:
            builder = (_) => const TearsheetDemoPage();
            break;
          case AppRoutes.popover:
            builder = (_) => const PopoverDemoPage();
            break;
          case AppRoutes.toggleTip:
            builder = (_) => const ToggleTipDemoPage();
            break;

          // AI & Syntax
          case AppRoutes.aiLabel:
            builder = (_) => const AILabelDemoPage();
            break;
          case AppRoutes.syntaxHighlighting:
            builder = (_) => const SyntaxHighlightingDemoPage();
            break;

          // Other
          case AppRoutes.overflowMenu:
            builder = (_) => const OverflowMenuDemoPage();
            break;
          case AppRoutes.pageHeader:
            builder = (_) => const PageHeaderDemoPage();
            break;

          // Material Equivalents
          case AppRoutes.accordion:
            builder = (_) => const AccordionDemoPage();
            break;
          case AppRoutes.tabs:
            builder = (_) => const TabsDemoPage();
            break;
          case AppRoutes.tag:
            builder = (_) => const TagDemoPage();
            break;
          case AppRoutes.tooltip:
            builder = (_) => const TooltipDemoPage();
            break;
          case AppRoutes.search:
            builder = (_) => const SearchDemoPage();
            break;
          case AppRoutes.select:
            builder = (_) => const SelectDemoPage();
            break;
          case AppRoutes.dataTable:
            builder = (_) => const DataTableDemoPage();
            break;
          case AppRoutes.tile:
            builder = (_) => const TileDemoPage();
            break;
          case AppRoutes.selectionControls:
            builder = (_) => const MaterialSelectionDemoPage();
            break;
          case AppRoutes.multiSelect:
            builder = (_) => const MultiSelectDemoPage();
            break;
          case AppRoutes.containedList:
            builder = (_) => const ContainedListDemoPage();
            break;
          case AppRoutes.floatingMenu:
            builder = (_) => const FloatingMenuDemoPage();
            break;

          // Add more routes here as you create demo pages
          // For now, show a placeholder for unimplemented routes
          default:
            builder = (_) => PlaceholderPage(route: settings.name ?? 'unknown');
        }

        return MaterialPageRoute(
          builder: (context) => ThemeSwitcherWrapper(
            currentMode: _currentMode,
            onThemeChanged: (mode) {
              setState(() {
                _currentMode = mode;
              });
            },
            child: builder(context),
          ),
          settings: settings,
        );
      },
    );
  }
}

/// Wrapper that adds theme switcher FAB to all pages.
class ThemeSwitcherWrapper extends StatelessWidget {
  final CarbonThemeMode currentMode;
  final ValueChanged<CarbonThemeMode> onThemeChanged;
  final Widget child;

  const ThemeSwitcherWrapper({
    super.key,
    required this.currentMode,
    required this.onThemeChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Stack(
      children: [
        child,
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: carbon.button.buttonPrimary,
            foregroundColor: carbon.text.textOnColor,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: carbon.layer.layer01,
                builder: (context) => _ThemeSwitcherSheet(
                  currentMode: currentMode,
                  onThemeChanged: (mode) {
                    onThemeChanged(mode);
                    Navigator.pop(context);
                  },
                ),
              );
            },
            child: const Icon(Icons.palette),
          ),
        ),
      ],
    );
  }
}

/// Bottom sheet for theme selection.
class _ThemeSwitcherSheet extends StatelessWidget {
  final CarbonThemeMode currentMode;
  final ValueChanged<CarbonThemeMode> onThemeChanged;

  const _ThemeSwitcherSheet({
    required this.currentMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Theme',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: carbon.text.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          RadioGroup<CarbonThemeMode>(
            groupValue: currentMode,
            onChanged: (value) {
              if (value != null) onThemeChanged(value);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: CarbonThemeMode.values.map((mode) {
                final isSelected = mode == currentMode;
                return ListTile(
                  title: Text(
                    mode.toString().split('.').last.toUpperCase(),
                    style: TextStyle(
                      color: carbon.text.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  leading: Radio<CarbonThemeMode>(value: mode),
                  onTap: () => onThemeChanged(mode),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Placeholder page for routes that don't have demo pages yet.
class PlaceholderPage extends StatelessWidget {
  final String route;

  const PlaceholderPage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Scaffold(
      appBar: AppBar(
        title: Text(route),
        elevation: 0,
        backgroundColor: carbon.layer.layer01,
        foregroundColor: carbon.text.textPrimary,
      ),
      backgroundColor: carbon.layer.layer01,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: carbon.text.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: carbon.text.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Demo page for $route is not yet implemented',
              style: TextStyle(fontSize: 14, color: carbon.text.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
