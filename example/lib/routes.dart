/// Route definitions for the example app.
class AppRoutes {
  static const String home = '/';
  static const String allComponents = '/all';

  // Foundation
  static const String colors = '/foundation/colors';
  static const String typography = '/foundation/typography';
  static const String icons = '/foundation/icons';
  static const String layering = '/foundation/layering';

  // Buttons
  static const String buttons = '/buttons';
  static const String comboButton = '/buttons/combo';
  static const String copyButton = '/buttons/copy';
  static const String chatButton = '/buttons/chat';

  // Forms
  static const String textInput = '/forms/text-input';
  static const String numberInput = '/forms/number-input';
  static const String dropdown = '/forms/dropdown';
  static const String comboBox = '/forms/combo-box';
  static const String dateTimePicker = '/forms/date-time-picker';
  static const String toggle = '/forms/toggle';
  static const String fileUploader = '/forms/file-uploader';

  // Notifications
  static const String notifications = '/notifications';
  static const String status = '/notifications/status';

  // Content
  static const String contentSwitcher = '/content/switcher';
  static const String skeleton = '/content/skeleton';
  static const String codeSnippet = '/content/code-snippet';
  static const String structuredList = '/content/structured-list';
  static const String treeView = '/content/tree-view';

  // Navigation
  static const String breadcrumb = '/navigation/breadcrumb';
  static const String pagination = '/navigation/pagination';
  static const String uiShell = '/navigation/ui-shell';

  // Overlays
  static const String modal = '/overlays/modal';
  static const String sidePanel = '/overlays/side-panel';
  static const String tearsheet = '/overlays/tearsheet';
  static const String popover = '/overlays/popover';
  static const String toggleTip = '/overlays/toggle-tip';

  // Data Display
  static const String loading = '/data/loading';
  static const String link = '/data/link';

  // AI/Syntax
  static const String aiLabel = '/ai/label';
  static const String syntaxHighlighting = '/ai/syntax';

  // Other
  static const String overflowMenu = '/other/overflow-menu';
  static const String pageHeader = '/other/page-header';

  // Material Equivalents
  static const String accordion = '/material/accordion';
  static const String tabs = '/material/tabs';
  static const String tag = '/material/tag';
  static const String tooltip = '/material/tooltip';
  static const String search = '/material/search';
  static const String select = '/material/select';
  static const String dataTable = '/material/data-table';
  static const String tile = '/material/tile';
  static const String selectionControls = '/material/selection-controls';

  // Carbon Widgets (Custom Implementations)
  static const String multiSelect = '/carbon/multi-select';
  static const String containedList = '/carbon/contained-list';
  static const String floatingMenu = '/carbon/floating-menu';
}

/// Component category for organizing navigation.
class ComponentCategory {
  final String title;
  final String? subtitle;
  final List<ComponentItem> items;

  const ComponentCategory({
    required this.title,
    this.subtitle,
    required this.items,
  });
}

/// Individual component item.
class ComponentItem {
  final String title;
  final String route;
  final String? description;

  const ComponentItem({
    required this.title,
    required this.route,
    this.description,
  });
}

/// All component categories.
final List<ComponentCategory> componentCategories = [
  ComponentCategory(
    title: 'Foundation',
    subtitle: 'Core design tokens and styles',
    items: [
      ComponentItem(
        title: 'Colors',
        route: AppRoutes.colors,
        description: 'Color palette and usage',
      ),
      ComponentItem(
        title: 'Typography',
        route: AppRoutes.typography,
        description: 'Type styles and hierarchy',
      ),
      ComponentItem(
        title: 'Icons',
        route: AppRoutes.icons,
        description: 'Carbon icon library',
      ),
      ComponentItem(
        title: 'Layering',
        route: AppRoutes.layering,
        description: 'Layer tokens and elevation',
      ),
    ],
  ),
  ComponentCategory(
    title: 'Buttons',
    subtitle: 'Interactive button components',
    items: [
      ComponentItem(
        title: 'Button',
        route: AppRoutes.buttons,
        description: 'Primary, secondary, tertiary, ghost, danger',
      ),
      ComponentItem(
        title: 'Combo Button',
        route: AppRoutes.comboButton,
        description: 'Split button with dropdown menu',
      ),
      ComponentItem(
        title: 'Copy Button',
        route: AppRoutes.copyButton,
        description: 'Copy to clipboard button',
      ),
      ComponentItem(
        title: 'Chat Button',
        route: AppRoutes.chatButton,
        description: 'Messaging action button',
      ),
    ],
  ),
  ComponentCategory(
    title: 'Forms',
    subtitle: 'Form controls and inputs',
    items: [
      ComponentItem(
        title: 'Text Input',
        route: AppRoutes.textInput,
        description: 'Text field with validation',
      ),
      ComponentItem(
        title: 'Number Input',
        route: AppRoutes.numberInput,
        description: 'Numeric input with steppers',
      ),
      ComponentItem(
        title: 'Dropdown',
        route: AppRoutes.dropdown,
        description: 'Select dropdown menu',
      ),
      ComponentItem(
        title: 'Combo Box',
        route: AppRoutes.comboBox,
        description: 'Searchable dropdown',
      ),
      ComponentItem(
        title: 'Date & Time Picker',
        route: AppRoutes.dateTimePicker,
        description: 'Material pickers with Carbon theming',
      ),
      ComponentItem(
        title: 'Toggle',
        route: AppRoutes.toggle,
        description: 'Toggle switch control',
      ),
      ComponentItem(
        title: 'File Uploader',
        route: AppRoutes.fileUploader,
        description: 'File upload with drag & drop',
      ),
    ],
  ),
  ComponentCategory(
    title: 'Notifications',
    subtitle: 'User feedback and status',
    items: [
      ComponentItem(
        title: 'Notification',
        route: AppRoutes.notifications,
        description: 'Toast and inline notifications',
      ),
      ComponentItem(
        title: 'Status',
        route: AppRoutes.status,
        description: 'Status indicators',
      ),
    ],
  ),
  ComponentCategory(
    title: 'Content',
    subtitle: 'Content display components',
    items: [
      ComponentItem(
        title: 'Content Switcher',
        route: AppRoutes.contentSwitcher,
        description: 'Toggle between content views',
      ),
      ComponentItem(
        title: 'Skeleton',
        route: AppRoutes.skeleton,
        description: 'Loading placeholders',
      ),
      ComponentItem(
        title: 'Code Snippet',
        route: AppRoutes.codeSnippet,
        description: 'Code display with copy',
      ),
      ComponentItem(
        title: 'Structured List',
        route: AppRoutes.structuredList,
        description: 'Organized data lists',
      ),
      ComponentItem(
        title: 'Tree View',
        route: AppRoutes.treeView,
        description: 'Hierarchical tree structure',
      ),
    ],
  ),
  ComponentCategory(
    title: 'Navigation',
    subtitle: 'Navigation patterns',
    items: [
      ComponentItem(
        title: 'Breadcrumb',
        route: AppRoutes.breadcrumb,
        description: 'Navigation trail',
      ),
      ComponentItem(
        title: 'Pagination',
        route: AppRoutes.pagination,
        description: 'Page navigation',
      ),
      ComponentItem(
        title: 'UI Shell',
        route: AppRoutes.uiShell,
        description: 'Application shell layout',
      ),
    ],
  ),
  ComponentCategory(
    title: 'Overlays',
    subtitle: 'Modal and overlay components',
    items: [
      ComponentItem(
        title: 'Modal',
        route: AppRoutes.modal,
        description: 'Dialog overlays',
      ),
      ComponentItem(
        title: 'Side Panel',
        route: AppRoutes.sidePanel,
        description: 'Slide-in side drawer',
      ),
      ComponentItem(
        title: 'Tearsheet',
        route: AppRoutes.tearsheet,
        description: 'Full-height slide-in panel',
      ),
      ComponentItem(
        title: 'Popover',
        route: AppRoutes.popover,
        description: 'Contextual popup',
      ),
      ComponentItem(
        title: 'Toggle Tip',
        route: AppRoutes.toggleTip,
        description: 'Toggleable tooltip',
      ),
    ],
  ),
  ComponentCategory(
    title: 'Data Display',
    subtitle: 'Data presentation',
    items: [
      ComponentItem(
        title: 'Loading',
        route: AppRoutes.loading,
        description: 'Loading indicators',
      ),
      ComponentItem(
        title: 'Link',
        route: AppRoutes.link,
        description: 'Hyperlinks',
      ),
    ],
  ),
  ComponentCategory(
    title: 'AI & Syntax',
    subtitle: 'AI and code features',
    items: [
      ComponentItem(
        title: 'AI Label',
        route: AppRoutes.aiLabel,
        description: 'AI-generated content labels',
      ),
      ComponentItem(
        title: 'Syntax Highlighting',
        route: AppRoutes.syntaxHighlighting,
        description: 'Code syntax themes',
      ),
    ],
  ),
  ComponentCategory(
    title: 'Other',
    subtitle: 'Additional components',
    items: [
      ComponentItem(
        title: 'Overflow Menu',
        route: AppRoutes.overflowMenu,
        description: 'Actions menu',
      ),
      ComponentItem(
        title: 'Page Header',
        route: AppRoutes.pageHeader,
        description: 'Page title and actions',
      ),
    ],
  ),
  ComponentCategory(
    title: 'Material Equivalents',
    subtitle: 'Material widgets with Carbon theming',
    items: [
      ComponentItem(
        title: 'Accordion',
        route: AppRoutes.accordion,
        description: 'ExpansionTile with Carbon theme',
      ),
      ComponentItem(
        title: 'Tabs',
        route: AppRoutes.tabs,
        description: 'TabBar with Carbon theme',
      ),
      ComponentItem(
        title: 'Tag',
        route: AppRoutes.tag,
        description: 'Chip variants with Carbon theme',
      ),
      ComponentItem(
        title: 'Tooltip',
        route: AppRoutes.tooltip,
        description: 'Tooltip with Carbon theme',
      ),
      ComponentItem(
        title: 'Search',
        route: AppRoutes.search,
        description: 'SearchBar with Carbon theme',
      ),
      ComponentItem(
        title: 'Select',
        route: AppRoutes.select,
        description: 'DropdownMenu with Carbon theme',
      ),
      ComponentItem(
        title: 'Data Table',
        route: AppRoutes.dataTable,
        description: 'DataTable with Carbon theme',
      ),
      ComponentItem(
        title: 'Tile',
        route: AppRoutes.tile,
        description: 'Carbon clickable/selectable tiles',
      ),
      ComponentItem(
        title: 'Selection Controls',
        route: AppRoutes.selectionControls,
        description: 'Themed Checkbox, Radio, Switch, Slider',
      ),
    ],
  ),
  ComponentCategory(
    title: 'Carbon Widgets',
    subtitle: 'Custom Carbon implementations',
    items: [
      ComponentItem(
        title: 'Multi-Select',
        route: AppRoutes.multiSelect,
        description: 'Multi-selection dropdown with chips',
      ),
      ComponentItem(
        title: 'Contained List',
        route: AppRoutes.containedList,
        description: 'List container for small spaces',
      ),
      ComponentItem(
        title: 'Floating Menu',
        route: AppRoutes.floatingMenu,
        description: 'Expandable floating action menu',
      ),
    ],
  ),
];
