import 'package:flutter/material.dart';
import 'package:flutter_carbon/src/theme/component_themes/ai_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/breadcrumb_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/button_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/chat_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/code_snippet_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/combo_box_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/content_switcher_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/layer_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/notification_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/number_input_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/overflow_menu_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/popover_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/skeleton_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/file_uploader_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/side_panel_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/structured_list_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/tearsheet_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/toggle_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/toggle_tip_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/status_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/syntax_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/text_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/tree_view_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/ui_shell_theme_data.dart';
import 'package:flutter_carbon/src/theme/component_themes/page_header_theme_data.dart';

export 'package:flutter_carbon/src/theme/component_themes/ai_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/breadcrumb_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/button_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/chat_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/code_snippet_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/combo_box_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/content_switcher_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/layer_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/notification_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/number_input_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/overflow_menu_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/popover_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/skeleton_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/file_uploader_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/side_panel_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/structured_list_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/tearsheet_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/toggle_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/toggle_tip_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/status_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/syntax_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/text_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/tree_view_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/ui_shell_theme_data.dart';
export 'package:flutter_carbon/src/theme/component_themes/page_header_theme_data.dart';

/// The Carbon Design System Theme.
///
/// This extension aggregates all semantic and component themes.
/// Use [CarbonThemeData.of] to access the current theme data.
@immutable
class CarbonThemeData extends ThemeExtension<CarbonThemeData> {
  final CarbonLayerThemeData layer;
  final CarbonTextThemeData text;
  final CarbonButtonThemeData button;
  final CarbonNotificationThemeData notification;
  final CarbonContentSwitcherThemeData contentSwitcher;
  final CarbonStatusThemeData status;
  final CarbonSkeletonThemeData skeleton;
  final CarbonChatThemeData chat;
  final CarbonAIThemeData ai;
  final CarbonSyntaxThemeData syntax;
  final CarbonBreadcrumbThemeData breadcrumb;
  final CarbonNumberInputThemeData numberInput;
  final CarbonCodeSnippetThemeData codeSnippet;
  final CarbonComboBoxThemeData comboBox;
  final CarbonStructuredListThemeData structuredList;
  final CarbonSidePanelThemeData sidePanel;
  final CarbonTearsheetThemeData tearsheet;
  final CarbonToggleThemeData toggle;
  final CarbonTreeViewThemeData treeView;
  final CarbonFileUploaderThemeData fileUploader;
  final CarbonPopoverThemeData popover;
  final CarbonToggleTipThemeData toggleTip;
  final CarbonOverflowMenuThemeData overflowMenu;
  final CarbonUIShellThemeData uiShell;
  final CarbonPageHeaderThemeData pageHeader;

  const CarbonThemeData({
    required this.layer,
    required this.text,
    required this.button,
    required this.notification,
    required this.contentSwitcher,
    required this.status,
    required this.skeleton,
    required this.chat,
    required this.ai,
    required this.syntax,
    required this.breadcrumb,
    required this.numberInput,
    required this.codeSnippet,
    required this.comboBox,
    required this.structuredList,
    required this.sidePanel,
    required this.tearsheet,
    required this.toggle,
    required this.treeView,
    required this.fileUploader,
    required this.popover,
    required this.toggleTip,
    required this.overflowMenu,
    required this.uiShell,
    required this.pageHeader,
  });

  @override
  CarbonThemeData copyWith({
    CarbonLayerThemeData? layer,
    CarbonTextThemeData? text,
    CarbonButtonThemeData? button,
    CarbonNotificationThemeData? notification,
    CarbonContentSwitcherThemeData? contentSwitcher,
    CarbonStatusThemeData? status,
    CarbonSkeletonThemeData? skeleton,
    CarbonChatThemeData? chat,
    CarbonAIThemeData? ai,
    CarbonSyntaxThemeData? syntax,
    CarbonBreadcrumbThemeData? breadcrumb,
    CarbonNumberInputThemeData? numberInput,
    CarbonCodeSnippetThemeData? codeSnippet,
    CarbonComboBoxThemeData? comboBox,
    CarbonStructuredListThemeData? structuredList,
    CarbonSidePanelThemeData? sidePanel,
    CarbonTearsheetThemeData? tearsheet,
    CarbonToggleThemeData? toggle,
    CarbonTreeViewThemeData? treeView,
    CarbonFileUploaderThemeData? fileUploader,
    CarbonPopoverThemeData? popover,
    CarbonToggleTipThemeData? toggleTip,
    CarbonOverflowMenuThemeData? overflowMenu,
    CarbonUIShellThemeData? uiShell,
    CarbonPageHeaderThemeData? pageHeader,
  }) {
    return CarbonThemeData(
      layer: layer ?? this.layer,
      text: text ?? this.text,
      button: button ?? this.button,
      notification: notification ?? this.notification,
      contentSwitcher: contentSwitcher ?? this.contentSwitcher,
      status: status ?? this.status,
      skeleton: skeleton ?? this.skeleton,
      chat: chat ?? this.chat,
      ai: ai ?? this.ai,
      syntax: syntax ?? this.syntax,
      breadcrumb: breadcrumb ?? this.breadcrumb,
      numberInput: numberInput ?? this.numberInput,
      codeSnippet: codeSnippet ?? this.codeSnippet,
      comboBox: comboBox ?? this.comboBox,
      structuredList: structuredList ?? this.structuredList,
      sidePanel: sidePanel ?? this.sidePanel,
      tearsheet: tearsheet ?? this.tearsheet,
      toggle: toggle ?? this.toggle,
      treeView: treeView ?? this.treeView,
      fileUploader: fileUploader ?? this.fileUploader,
      popover: popover ?? this.popover,
      toggleTip: toggleTip ?? this.toggleTip,
      overflowMenu: overflowMenu ?? this.overflowMenu,
      uiShell: uiShell ?? this.uiShell,
      pageHeader: pageHeader ?? this.pageHeader,
    );
  }

  @override
  CarbonThemeData lerp(ThemeExtension<CarbonThemeData>? other, double t) {
    if (other is! CarbonThemeData) return this;
    return CarbonThemeData(
      layer: layer.lerp(other.layer, t),
      text: text.lerp(other.text, t),
      button: button.lerp(other.button, t),
      notification: notification.lerp(other.notification, t),
      contentSwitcher: contentSwitcher.lerp(other.contentSwitcher, t),
      status: status.lerp(other.status, t),
      skeleton: skeleton.lerp(other.skeleton, t),
      chat: chat.lerp(other.chat, t),
      ai: ai.lerp(other.ai, t),
      syntax: syntax.lerp(other.syntax, t),
      breadcrumb: breadcrumb.lerp(other.breadcrumb, t),
      numberInput: numberInput.lerp(other.numberInput, t),
      codeSnippet: codeSnippet.lerp(other.codeSnippet, t),
      comboBox: comboBox.lerp(other.comboBox, t),
      structuredList: structuredList.lerp(other.structuredList, t),
      sidePanel: sidePanel.lerp(other.sidePanel, t),
      tearsheet: tearsheet.lerp(other.tearsheet, t),
      toggle: toggle.lerp(other.toggle, t),
      treeView: treeView.lerp(other.treeView, t),
      fileUploader: fileUploader.lerp(other.fileUploader, t),
      popover: popover.lerp(other.popover, t),
      toggleTip: toggleTip.lerp(other.toggleTip, t),
      overflowMenu: overflowMenu.lerp(other.overflowMenu, t),
      uiShell: uiShell.lerp(other.uiShell, t),
      pageHeader: pageHeader.lerp(other.pageHeader, t),
    );
  }
}
