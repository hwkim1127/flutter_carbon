import '../../carbon_theme_data.dart';
import '../../themes/g10/components/g10_ai_theme_data.dart';
import '../../themes/g10/components/g10_breadcrumb_theme_data.dart';
import '../../themes/g10/components/g10_button_theme_data.dart';
import '../../themes/g10/components/g10_chat_theme_data.dart';
import '../../themes/g10/components/g10_code_snippet_theme_data.dart';
import '../../themes/g10/components/g10_combo_box_theme_data.dart';
import '../../themes/g10/components/g10_file_uploader_theme_data.dart';
import '../../themes/g10/components/g10_side_panel_theme_data.dart';
import '../../themes/g10/components/g10_structured_list_theme_data.dart';
import '../../themes/g10/components/g10_tearsheet_theme_data.dart';
import '../../themes/g10/components/g10_toggle_theme_data.dart';
import '../../themes/g10/components/g10_tree_view_theme_data.dart';
import '../../themes/g10/components/g10_content_switcher_theme_data.dart';
import '../../themes/g10/components/g10_notification_theme_data.dart';
import '../../themes/g10/components/g10_number_input_theme_data.dart';
import '../../themes/g10/components/g10_overflow_menu_theme_data.dart';
import '../../themes/g10/components/g10_popover_theme_data.dart';
import '../../themes/g10/components/g10_skeleton_theme_data.dart';
import '../../themes/g10/components/g10_toggle_tip_theme_data.dart';
import '../../themes/g10/components/g10_status_theme_data.dart';
import '../../themes/g10/components/g10_syntax_theme_data.dart';
import '../../themes/g10/components/g10_ui_shell_theme_data.dart';
import '../../themes/g10/components/g10_page_header_theme_data.dart';
import 'g10_layer_theme_data.dart';
import 'g10_text_theme_data.dart';

/// Carbon Gray 10 Theme.
class G10Theme {
  const G10Theme._();

  static const CarbonThemeData theme = CarbonThemeData(
    text: G10TextThemeData(),
    layer: G10LayerThemeData(),
    button: G10ButtonThemeData(),
    notification: G10NotificationThemeData(),
    contentSwitcher: G10ContentSwitcherThemeData(),
    status: G10StatusThemeData(),
    skeleton: G10SkeletonThemeData(),
    chat: G10ChatThemeData(),
    ai: G10AIThemeData(),
    syntax: G10SyntaxThemeData(),
    breadcrumb: G10BreadcrumbThemeData(),
    numberInput: G10NumberInputThemeData(),
    codeSnippet: G10CodeSnippetThemeData(),
    comboBox: G10ComboBoxThemeData(),
    structuredList: G10StructuredListThemeData(),
    sidePanel: G10SidePanelThemeData(),
    tearsheet: G10TearsheetThemeData(),
    toggle: G10ToggleThemeData(),
    treeView: G10TreeViewThemeData(),
    fileUploader: G10FileUploaderThemeData(),
    popover: G10PopoverThemeData(),
    toggleTip: G10ToggleTipThemeData(),
    overflowMenu: G10OverflowMenuThemeData(),
    uiShell: G10UIShellThemeData(),
    pageHeader: G10PageHeaderThemeData(),
  );
}
