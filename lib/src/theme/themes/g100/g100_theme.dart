import '../../carbon_theme_data.dart';
import 'g100_layer_theme_data.dart';
import 'g100_text_theme_data.dart';
import 'components/g100_ai_theme_data.dart';
import 'components/g100_breadcrumb_theme_data.dart';
import 'components/g100_button_theme_data.dart';
import 'components/g100_chat_theme_data.dart';
import 'components/g100_code_snippet_theme_data.dart';
import 'components/g100_combo_box_theme_data.dart';
import 'components/g100_file_uploader_theme_data.dart';
import 'components/g100_side_panel_theme_data.dart';
import 'components/g100_structured_list_theme_data.dart';
import 'components/g100_tearsheet_theme_data.dart';
import 'components/g100_toggle_theme_data.dart';
import 'components/g100_tree_view_theme_data.dart';
import 'components/g100_content_switcher_theme_data.dart';
import 'components/g100_notification_theme_data.dart';
import 'components/g100_number_input_theme_data.dart';
import 'components/g100_overflow_menu_theme_data.dart';
import 'components/g100_popover_theme_data.dart';
import 'components/g100_skeleton_theme_data.dart';
import 'components/g100_toggle_tip_theme_data.dart';
import 'components/g100_status_theme_data.dart';
import 'components/g100_syntax_theme_data.dart';
import 'components/g100_ui_shell_theme_data.dart';
import 'components/g100_page_header_theme_data.dart';

/// Gray 100 Theme for Carbon Design System.
class G100Theme {
  const G100Theme._();

  static const CarbonThemeData theme = CarbonThemeData(
    text: G100TextThemeData(),
    layer: G100LayerThemeData(),
    button: G100ButtonThemeData(),
    notification: G100NotificationThemeData(),
    contentSwitcher: G100ContentSwitcherThemeData(),
    status: G100StatusThemeData(),
    skeleton: G100SkeletonThemeData(),
    chat: G100ChatThemeData(),
    ai: G100AIThemeData(),
    syntax: G100SyntaxThemeData(),
    breadcrumb: G100BreadcrumbThemeData(),
    numberInput: G100NumberInputThemeData(),
    codeSnippet: G100CodeSnippetThemeData(),
    comboBox: G100ComboBoxThemeData(),
    structuredList: G100StructuredListThemeData(),
    sidePanel: G100SidePanelThemeData(),
    tearsheet: G100TearsheetThemeData(),
    toggle: G100ToggleThemeData(),
    treeView: G100TreeViewThemeData(),
    fileUploader: G100FileUploaderThemeData(),
    popover: G100PopoverThemeData(),
    toggleTip: G100ToggleTipThemeData(),
    overflowMenu: G100OverflowMenuThemeData(),
    uiShell: G100UIShellThemeData(),
    pageHeader: G100PageHeaderThemeData(),
  );
}
