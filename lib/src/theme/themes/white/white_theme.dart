import '../../carbon_theme_data.dart';
import 'white_layer_theme_data.dart';
import 'white_text_theme_data.dart';
import 'components/white_ai_theme_data.dart';
import 'components/white_breadcrumb_theme_data.dart';
import 'components/white_button_theme_data.dart';
import 'components/white_chat_theme_data.dart';
import 'components/white_code_snippet_theme_data.dart';
import 'components/white_combo_box_theme_data.dart';
import 'components/white_file_uploader_theme_data.dart';
import 'components/white_side_panel_theme_data.dart';
import 'components/white_structured_list_theme_data.dart';
import 'components/white_tearsheet_theme_data.dart';
import 'components/white_toggle_theme_data.dart';
import 'components/white_tree_view_theme_data.dart';
import 'components/white_content_switcher_theme_data.dart';
import 'components/white_notification_theme_data.dart';
import 'components/white_number_input_theme_data.dart';
import 'components/white_overflow_menu_theme_data.dart';
import 'components/white_popover_theme_data.dart';
import 'components/white_skeleton_theme_data.dart';
import 'components/white_toggle_tip_theme_data.dart';
import 'components/white_status_theme_data.dart';
import 'components/white_syntax_theme_data.dart';
import 'components/white_ui_shell_theme_data.dart';
import 'components/white_page_header_theme_data.dart';

/// Carbon White Theme.
///
/// Returns a [CarbonThemeData] configured with the 'White' theme tokens.
class WhiteTheme {
  const WhiteTheme._();

  static const CarbonThemeData theme = CarbonThemeData(
    text: WhiteTextThemeData(),
    layer: WhiteLayerThemeData(),
    button: WhiteButtonThemeData(),
    notification: WhiteNotificationThemeData(),
    contentSwitcher: WhiteContentSwitcherThemeData(),
    status: WhiteStatusThemeData(),
    skeleton: WhiteSkeletonThemeData(),
    chat: WhiteChatThemeData(),
    ai: WhiteAIThemeData(),
    syntax: WhiteSyntaxThemeData(),
    breadcrumb: WhiteBreadcrumbThemeData(),
    numberInput: WhiteNumberInputThemeData(),
    codeSnippet: WhiteCodeSnippetThemeData(),
    comboBox: WhiteComboBoxThemeData(),
    structuredList: WhiteStructuredListThemeData(),
    sidePanel: WhiteSidePanelThemeData(),
    tearsheet: WhiteTearsheetThemeData(),
    toggle: WhiteToggleThemeData(),
    treeView: WhiteTreeViewThemeData(),
    fileUploader: WhiteFileUploaderThemeData(),
    popover: WhitePopoverThemeData(),
    toggleTip: WhiteToggleTipThemeData(),
    overflowMenu: WhiteOverflowMenuThemeData(),
    uiShell: WhiteUIShellThemeData(),
    pageHeader: WhitePageHeaderThemeData(),
  );
}
