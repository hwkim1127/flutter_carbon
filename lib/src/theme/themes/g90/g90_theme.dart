import '../../carbon_theme_data.dart';
import '../../themes/g90/components/g90_ai_theme_data.dart';
import '../../themes/g90/components/g90_breadcrumb_theme_data.dart';
import '../../themes/g90/components/g90_button_theme_data.dart';
import '../../themes/g90/components/g90_chat_theme_data.dart';
import '../../themes/g90/components/g90_code_snippet_theme_data.dart';
import '../../themes/g90/components/g90_combo_box_theme_data.dart';
import '../../themes/g90/components/g90_file_uploader_theme_data.dart';
import '../../themes/g90/components/g90_side_panel_theme_data.dart';
import '../../themes/g90/components/g90_structured_list_theme_data.dart';
import '../../themes/g90/components/g90_tearsheet_theme_data.dart';
import '../../themes/g90/components/g90_toggle_theme_data.dart';
import '../../themes/g90/components/g90_tree_view_theme_data.dart';
import '../../themes/g90/components/g90_content_switcher_theme_data.dart';
import '../../themes/g90/components/g90_notification_theme_data.dart';
import '../../themes/g90/components/g90_number_input_theme_data.dart';
import '../../themes/g90/components/g90_overflow_menu_theme_data.dart';
import '../../themes/g90/components/g90_popover_theme_data.dart';
import '../../themes/g90/components/g90_skeleton_theme_data.dart';
import '../../themes/g90/components/g90_toggle_tip_theme_data.dart';
import '../../themes/g90/components/g90_status_theme_data.dart';
import '../../themes/g90/components/g90_syntax_theme_data.dart';
import '../../themes/g90/components/g90_ui_shell_theme_data.dart';
import '../../themes/g90/components/g90_page_header_theme_data.dart';
import 'g90_layer_theme_data.dart';
import 'g90_text_theme_data.dart';

/// Carbon Gray 90 Theme.
class G90Theme {
  const G90Theme._();

  static const CarbonThemeData theme = CarbonThemeData(
    text: G90TextThemeData(),
    layer: G90LayerThemeData(),
    button: G90ButtonThemeData(),
    notification: G90NotificationThemeData(),
    contentSwitcher: G90ContentSwitcherThemeData(),
    status: G90StatusThemeData(),
    skeleton: G90SkeletonThemeData(),
    chat: G90ChatThemeData(),
    ai: G90AIThemeData(),
    syntax: G90SyntaxThemeData(),
    breadcrumb: G90BreadcrumbThemeData(),
    numberInput: G90NumberInputThemeData(),
    codeSnippet: G90CodeSnippetThemeData(),
    comboBox: G90ComboBoxThemeData(),
    structuredList: G90StructuredListThemeData(),
    sidePanel: G90SidePanelThemeData(),
    tearsheet: G90TearsheetThemeData(),
    toggle: G90ToggleThemeData(),
    treeView: G90TreeViewThemeData(),
    fileUploader: G90FileUploaderThemeData(),
    popover: G90PopoverThemeData(),
    toggleTip: G90ToggleTipThemeData(),
    overflowMenu: G90OverflowMenuThemeData(),
    uiShell: G90UIShellThemeData(),
    pageHeader: G90PageHeaderThemeData(),
  );
}
