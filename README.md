<p align="center">
  <img src="logo.png" width="200" alt="Flutter Carbon Logo" />
</p>

# Flutter Carbon

A comprehensive Flutter implementation of [IBM's Carbon Design System](https://carbondesignsystem.com/), providing a complete theming solution with **37 custom Carbon components**, 4 theme variants, and automatic Carbon styling for standard Material widgets.

#### 🔗 [Live Demo](https://hwkim1127.github.io/flutter_carbon/)

**Carbon Design System (v11) ships 85 components** across its `styles` and `web-components` packages. Here is how Flutter Carbon covers them:

- **37 custom `Carbon*` widgets** — full spec implementations
- **11 via Material theming** — standard Material widgets auto-styled by `carbonTheme()`
- **12 architectural / utilities** — layout/structural concepts mapped to Flutter primitives
- **25 not yet implemented** — planned for future releases (11 of these are the `fluid-*` input variants)

## Overview

This package brings the power and consistency of IBM's Carbon Design System V11 to Flutter applications. It includes all the design tokens (colors, typography, spacing, motion), a complete theme extension system, and production-ready widgets that follow Carbon specifications.

## ✨ Features

### 🎨 Complete Design Foundation
- **4 Theme Variants**: White, Gray 10, Gray 90, Gray 100 with seamless runtime switching
- **Carbon Design System V11**: Full compliance with the latest Carbon specifications
- **Complete Color Palette**: All IBM Design Language colors with semantic token mappings
- **Typography System**: 24 type styles following Carbon specifications (heading-01 through heading-07, body styles, code, helper text, labels)
- **Spacing & Layout**: Consistent spacing scale (2px to 160px) and container sizes
- **Motion System**: Duration and easing values for animations
- **Layering System**: Background, layer, field, and border tokens for proper visual hierarchy

### 🧱 Spec-First Internals (1.3+)
- **No Material ink ripple** — interaction feedback is a flat color change, exactly as the Carbon spec defines
- **Carbon icon glyphs throughout** — every internal icon comes from the bundled `CarbonIcons` font, not Material Icons
- **Widgets-layer implementation** — 24 of 37 components have no `material.dart` dependency at all; the rest keep it only for primitives (text fields, checkboxes) that get native replacements in V2 (see `V2_ROADMAP.md`)

### 🧩 37 Carbon Components

**Buttons & Actions**
- `CarbonButton` - Full-spec button with 7 kind variants (primary, secondary, tertiary, ghost, danger, dangerTertiary, dangerGhost) and 5 size variants (sm/md/lg/xl/2xl); supports text, text+icon, and icon-only modes
- `CarbonComboButton` - Split button with primary action and dropdown menu
- `CarbonCopyButton` - Copy to clipboard with visual feedback
- `CarbonChatButton` - Specialized button for chat interfaces with quick actions

**Forms & Input**
- `CarbonDropdown` - Single-select dropdown with search
- `CarbonComboBox` - Autocomplete combo box with filtering
- `CarbonNumberInput` - Numeric input with increment/decrement controls
- `CarbonToggle` - Toggle switch (on/off)
- `CarbonFileUploader` - File upload with button and drag-drop variants
- `CarbonMultiSelect` - Multi-selection dropdown with chips and filtering

**Navigation**
- `CarbonBreadcrumb` - Breadcrumb navigation
- `CarbonPagination` - Page navigation with configurable sizes
- `CarbonUIShell` - Complete application shell (header nav, side nav, content, right panel)
- `CarbonPageHeader` - Page header with breadcrumbs, actions, tabs
- `CarbonTabs` - Tab navigation with Line and Contained styles

**Overlays & Dialogs**
- `CarbonModal` - 5 modal types (passive, transactional, danger, input, custom)
- `CarbonSidePanel` - Slide-in panel from left/right with 5 size variants
- `CarbonTearsheet` - Bottom sheet with full-height content; action buttons fill the footer width equally — use `CarbonButtonSize.xl` for narrow and `CarbonButtonSize.twoXl` for wide tearsheets
- `CarbonPopover` - Floating content panel with positioning
- `CarbonToggleTip` - Interactive tooltip that stays open on click

**Content Display**
- `CarbonCodeSnippet` - Syntax-highlighted code display (single-line, multi-line, inline)
- `CarbonContentSwitcher` - Tab-like content switcher
- `CarbonStructuredList` - Table-like list with selectable rows
- `CarbonDataTable` - Comprehensive data table with:
  - Expandable/selectable rows (radio or checkbox modes)
  - Batch selection with select-all
  - Sortable columns with indicators
  - Size variants (tall/medium/short/compact)
  - Zebra striping
  - Toolbar support
  - Skeleton loading state
- `CarbonToolbar` - Toolbar system for data tables (regular actions and batch actions)
- `CarbonTreeView` - Hierarchical tree with expand/collapse
- `CarbonLink` - Styled hyperlinks with visited state
- `CarbonTile` - Clickable/selectable/expandable tiles
- `CarbonContainedList` - List container for small UI spaces with headers and actions

**Notifications & Feedback**
- `CarbonProgressIndicator` - Multi-step progress indicator (horizontal/vertical) with complete/current/incomplete/invalid/disabled states and optional tap-to-navigate
- `CarbonNotification` - Toast/inline notifications with 4 severity types
- `CarbonLoading` - Loading spinner (small, default, large)
- `CarbonSkeleton` - Skeleton loading states (text, rectangle, circle)

**Tags & Labels**
- `CarbonTag` - Carbon tag component with 12 color variants (red, magenta, purple, blue, cyan, teal, green, gray, coolGray, warmGray, highContrast, outline), 3 size variants (sm/md/lg), and optional dismiss button; uses fixed palette colors independent of the active theme

**Other Components**
- `CarbonOverflowMenu` - Kebab menu with actions
- `CarbonAILabel` - AI-generated content indicator with gradient
- `CarbonFloatingMenu` - Expandable floating action menu with animations

#### Handled via Material Theming (11)

These Carbon components are covered by standard Material widgets that automatically receive Carbon styling through `carbonTheme()` (from `package:flutter_carbon/material.dart`, using the MaterialApp + `CarbonMaterialBridge` setup):

| Carbon Component | Flutter Equivalent |
|---|---|
| `accordion` | `ExpansionTile` |
| `checkbox` | `Checkbox` |
| `inline-loading` | `CircularProgressIndicator` |
| `list` | `ListTile` |
| `progress-bar` | `LinearProgressIndicator` |
| `radio-button` | `Radio` |
| `search` | `SearchBar` |
| `slider` | `Slider` |
| `text-input` | `TextField` |
| `textarea` | `TextField(maxLines: null)` |
| `tooltip` | `Tooltip` |

> For buttons, prefer `CarbonButton` over Material variants (`FilledButton`, `ElevatedButton`, etc.) — it implements the full Carbon spec with 7 kind variants and 5 size variants.
> For tags, prefer `CarbonTag` over `Chip` — it implements the full Carbon tag spec with 12 color types and proper sizing.

#### Architectural / Utilities (12)

These are not renderable widgets — they are structural concepts, token systems, or deprecated entries:

| Carbon Component | Flutter Equivalent |
|---|---|
| `aspect-ratio` | Flutter `AspectRatio` widget |
| `feature-flags` | Runtime configuration, not a UI component |
| `form` | Flutter `Form` widget |
| `form-group` | Flutter layout (`Column`, `Padding`) |
| `grid` | Flutter layout (`Row`, `Column`, `Wrap`, `GridView`) |
| `heading` | `CarbonTypography` text styles |
| `icon` | `CarbonIcons` icon font |
| `layer` | Theme layering tokens (`carbon.layer.*`) |
| `list-box` | Internal primitive — implemented implicitly by `CarbonDropdown` / `CarbonComboBox` / `CarbonMultiSelect` |
| `skip-to-content` | Accessibility helper — no visual widget needed |
| `slug` | Deprecated — use `CarbonAILabel` |
| `stack` | Deprecated utility |

#### Not Yet Implemented (25)

These components do not have a dedicated `Carbon*` widget yet:

| Carbon Component | Notes |
|---|---|
| `ai-skeleton` | Use `CarbonSkeleton` |
| `badge-indicator` | No current equivalent |
| `copy` | Use `CarbonCopyButton` |
| `date-picker` | Use Material `showDatePicker()` (auto-themed) |
| `dialog` | Experimental Carbon primitive (feature-flagged) — use `CarbonModal` |
| `fluid-*` (11 variants) | `combo-box`, `date-picker`, `dropdown`, `list-box`, `multiselect`, `number-input`, `search`, `select`, `text-area`, `text-input`, `time-picker` — fluid/expressive variants, not yet implemented |
| `icon-button` | Use `CarbonButton` with icon-only mode |
| `icon-indicator` | No current equivalent |
| `menu` | Use Material `MenuBar` / `DropdownMenu` (auto-themed) |
| `menu-button` | Use Material `MenuAnchor` (auto-themed) |
| `pagination-nav` | Page-number button navigation — use `CarbonPagination` (select-based) |
| `password-input` | Use `TextField(obscureText: true)` (auto-themed) |
| `select` | Use `CarbonDropdown` |
| `shape-indicator` | No current equivalent |
| `time-picker` | Use Material `showTimePicker()` (auto-themed) |

### 📱 49 Demo Pages

The example app includes comprehensive demos for every component, organized into 12 categories:
- Foundation (4 pages)
- Buttons (4 pages)
- Forms (7 pages)
- Notifications (2 pages)
- Content (5 pages)
- Navigation (3 pages)
- Overlays (5 pages)
- Data Display (2 pages)
- AI & Syntax (2 pages)
- Other (2 pages)
- Carbon Components (8 pages)
- Material Theming (5 pages)

## 🚀 Quick Start

### 1. Setup Theme

**Option A — pure Carbon app** (no MaterialApp needed):

```dart
import 'package:flutter_carbon/flutter_carbon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CarbonApp(
      title: 'My Carbon App',
      // Choose your theme: WhiteTheme, G10Theme, G90Theme, or G100Theme
      theme: WhiteTheme.theme,
      home: const MyHomePage(),
    );
  }
}
```

**Option B — Material app with the Carbon bridge** (needed for the
Material-themed components and the widgets that still use Material internals):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_carbon/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = WhiteTheme.theme;

    return MaterialApp(
      title: 'My Carbon App',
      theme: carbonTheme(carbon: carbon),
      builder: (context, child) => CarbonMaterialBridge(child: child!),
      home: const MyHomePage(),
    );
  }
}
```

### 2. Access Theme Tokens

Use the context extension to access Carbon tokens:

```dart
@override
Widget build(BuildContext context) {
  final carbon = context.carbon;

  return Scaffold(
    backgroundColor: carbon.layer.layer01,
    body: Column(
      children: [
        Text(
          'Hello Carbon',
          style: CarbonTypography.heading03.copyWith(
            color: carbon.text.textPrimary,
          ),
        ),
        SizedBox(height: CarbonSpacing.spacing05), // 16px
        // Your widgets here
      ],
    ),
  );
}
```

### 3. Use Carbon Components

```dart
// Button — all 7 kinds
CarbonButton(
  child: Text('Save'),
  onPressed: _handleSave,
  kind: CarbonButtonKind.primary,
  size: CarbonButtonSize.lg,
)

CarbonButton(
  child: Text('Cancel'),
  onPressed: () => Navigator.pop(context),
  kind: CarbonButtonKind.ghost,
)

CarbonButton(
  child: Text('Delete'),
  icon: Icon(CarbonIcons.trash_can),
  onPressed: _handleDelete,
  kind: CarbonButtonKind.danger,
)

// Icon-only button
CarbonButton(
  icon: Icon(CarbonIcons.add),
  onPressed: _handleAdd,
  kind: CarbonButtonKind.primary,
  size: CarbonButtonSize.sm,
)

// Dropdown
CarbonDropdown<String>(
  label: 'Select an option',
  items: const [
    CarbonDropdownItem(value: 'opt1', child: Text('Option 1')),
    CarbonDropdownItem(value: 'opt2', child: Text('Option 2')),
  ],
  value: _selectedValue,
  onChanged: (value) => setState(() => _selectedValue = value),
)

// Multi-Select
CarbonMultiSelect<String>(
  label: 'Select countries',
  values: _selectedCountries,
  items: const [
    CarbonMultiSelectItem(value: 'kr', child: Text('South Korea')),
    CarbonMultiSelectItem(value: 'us', child: Text('United States')),
  ],
  onChanged: (values) => setState(() => _selectedCountries = values),
  itemToString: (value) => countryNames[value] ?? value,
)

// Tile
CarbonTile.selectable(
  title: 'Selectable Option',
  selected: _isSelected,
  onSelectedChanged: (selected) => setState(() => _isSelected = selected),
  child: const Text('Click to select this option'),
)

// Modal
CarbonModal.show(
  context: context,
  type: CarbonModalType.transactional,
  title: 'Confirm Action',
  body: const Text('Are you sure you want to proceed?'),
  primaryButtonText: 'Confirm',
  onPrimaryPressed: () => Navigator.pop(context),
)

// Notification
CarbonNotification(
  kind: CarbonNotificationKind.success,
  title: 'Success!',
  subtitle: 'Your changes have been saved.',
  onClose: () {},
)

// Tabs
CarbonTabs(
  tabs: [
    CarbonTab(label: 'Tab 1', icon: Icon(Icons.home)),
    CarbonTab(label: 'Tab 2', icon: Icon(Icons.settings)),
    CarbonTab(label: 'Tab 3', disabled: true),
  ],
  type: CarbonTabsType.contained, // or CarbonTabsType.line
  extendLine: true, // optional: extends bottom border to full width (Line type only)
  onTabChanged: (index) {
     print('Selected tab: $index');
  },
)

// Tag
CarbonTag(
  text: 'Design',
  type: CarbonTagType.blue,
  size: CarbonTagSize.md,
)

// Dismissible tag
CarbonTag(
  text: 'Removable',
  type: CarbonTagType.gray,
  onDismiss: () => removeTag(),
)

// Data Table with Toolbar
CarbonDataTable(
  title: 'Users',
  description: 'Manage user accounts',
  hasSelectableRows: true,
  batchSelection: true,
  zebra: true,
  size: CarbonDataTableSize.medium,
  // Sorting: columns opt in via header.sortable + a non-null onSort
  sortKey: _sortKey,
  sortDirection: _sortDirection,
  onSort: (key, direction) => sortUsers(key, direction),
  toolbar: CarbonToolbar(
    selectedCount: selectedIds.length,
    content: CarbonToolbarContent(
      children: [
        CarbonToolbarSearch(
          onChanged: (value) => filterUsers(value),
        ),
        CarbonButton(
          onPressed: () => addUser(),
          icon: Icon(CarbonIcons.add),
          child: Text('Add User'),
        ),
      ],
    ),
    batchActions: CarbonToolbarBatchActions(
      selectedCount: selectedIds.length,
      onCancel: () => clearSelection(),
      actions: [
        CarbonButton(
          kind: CarbonButtonKind.ghost,
          onPressed: () => deleteSelected(),
          icon: Icon(CarbonIcons.trashCan),
          child: Text('Delete'),
        ),
      ],
    ),
  ),
  headers: [
    CarbonDataTableHeader(key: 'name', label: 'Name', sortable: true),
    CarbonDataTableHeader(key: 'status', label: 'Status', sortable: true),
    CarbonDataTableHeader(key: 'role', label: 'Role'), // not sortable (default)
  ],
  rows: users.map((user) => CarbonDataTableRow(
    cells: [
      CarbonDataTableCell(child: Text(user.name)),
      CarbonDataTableCell(child: Text(user.status)),
      CarbonDataTableCell(child: Text(user.role)),
    ],
    selected: selectedIds.contains(user.id),
    onSelectChanged: (selected) => toggleSelection(user.id, selected),
    expandedContent: Text('Additional details for ${user.name}'),
  )).toList(),
)
```

## 🎨 Theme Switching

Switch between the 4 Carbon themes at runtime:

```dart
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CarbonThemeData _carbon = WhiteTheme.theme;

  void _switchTheme(String themeName) {
    setState(() {
      switch (themeName) {
        case 'white':
          _carbon = WhiteTheme.theme;
          break;
        case 'g10':
          _carbon = G10Theme.theme;
          break;
        case 'g90':
          _carbon = G90Theme.theme;
          break;
        case 'g100':
          _carbon = G100Theme.theme;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: carbonTheme(carbon: _carbon),
      builder: (context, child) => CarbonMaterialBridge(child: child!),
      home: MyHomePage(onThemeChanged: _switchTheme),
    );
  }
}
```

In a pure Carbon app, just rebuild `CarbonApp` with a different `theme:` —
switches animate automatically via `AnimatedCarbonTheme`.

## 📚 Design Tokens

### Colors

Access via `context.carbon`:

```dart
// Background & Layers
carbon.background
carbon.layer.layer01, .layer02, .layer03

// Fields & Borders
carbon.field.field01, .field02
carbon.layer.borderSubtle00, .borderStrong01

// Text
carbon.text.textPrimary, .textSecondary, .textOnColor, .textDisabled

// Buttons
carbon.button.buttonPrimary, .buttonSecondary, .buttonDanger

// Support (Status Colors)
carbon.layer.supportError, .supportSuccess, .supportWarning, .supportInfo

// Interactive
carbon.interactive.link, .focus, .hover
```

### Typography

24 predefined styles via `CarbonTypography`:

```dart
// Headings
CarbonTypography.heading01  // 14px, 600, 18px line-height
CarbonTypography.heading02  // 16px, 600, 22px line-height
CarbonTypography.heading03  // 20px, 400, 28px line-height
CarbonTypography.heading04  // 28px, 400, 36px line-height
CarbonTypography.heading05  // 32px, 400, 40px line-height
CarbonTypography.heading06  // 42px, 300, 50px line-height
CarbonTypography.heading07  // 54px, 300, 64px line-height

// Body Text
CarbonTypography.bodyCompact01, .bodyCompact02
CarbonTypography.bodyShort01, .bodyShort02
CarbonTypography.bodyLong01, .bodyLong02

// Other
CarbonTypography.code01, .code02           // Monospace code
CarbonTypography.label01, .label02         // Form labels
CarbonTypography.helperText01, .helperText02  // Helper text
```

### Spacing

13 spacing values via `CarbonSpacing`:

```dart
CarbonSpacing.spacing01  // 2px
CarbonSpacing.spacing02  // 4px
CarbonSpacing.spacing03  // 8px
CarbonSpacing.spacing04  // 12px
CarbonSpacing.spacing05  // 16px
CarbonSpacing.spacing06  // 24px
CarbonSpacing.spacing07  // 32px
CarbonSpacing.spacing08  // 40px
CarbonSpacing.spacing09  // 48px
CarbonSpacing.spacing10  // 64px
CarbonSpacing.spacing11  // 80px
CarbonSpacing.spacing12  // 96px
CarbonSpacing.spacing13  // 160px
```

## 📱 Example App

A comprehensive example app showcasing every component is included in the `example/` directory. It features:

- **49 demo pages** with interactive examples
- **All 4 theme variants** with live switching
- **Multiple examples per component** (variants, states, sizes)
- **Categorized navigation** for easy browsing
- **Real-world usage patterns**
- **"All Components" overview page**

Run the example:
```bash
cd example
flutter run
```

## 🏗️ Project Structure

```
lib/
├── flutter_carbon.dart          # Main export file
├── src/
│   ├── theme/
│   │   ├── carbon_theme.dart          # Theme helper function
│   │   ├── carbon_theme_data.dart     # Main theme data class
│   │   ├── component_themes/          # Theme data for each component
│   │   │   ├── button_theme_data.dart
│   │   │   ├── modal_theme_data.dart
│   │   │   ├── tile_theme_data.dart
│   │   │   ├── contained_list_theme_data.dart
│   │   │   └── ... (23 more theme files)
│   │   └── themes/                    # 4 concrete themes
│   │       ├── white/
│   │       ├── g10/
│   │       ├── g90/
│   │       └── g100/
│   ├── foundation/
│   │   ├── colors.dart                # Color palette
│   │   ├── typography.dart            # Typography system
│   │   ├── layout.dart                # Spacing & container sizes
│   │   └── motion.dart                # Animation durations
│   ├── base/                          # Internal building blocks (not exported)
│   │   ├── carbon_pressable.dart      # Hover/press/focus detector (no ripple)
│   │   ├── carbon_divider.dart        # 1px rule
│   │   └── carbon_overlay_surface.dart # Text style root for overlays
│   ├── widgets/                       # 37 Carbon components
│   │   ├── carbon_button.dart
│   │   ├── carbon_modal.dart
│   │   ├── carbon_dropdown.dart
│   │   ├── carbon_tile.dart
│   │   ├── carbon_tag.dart
│   │   ├── carbon_data_table.dart
│   │   ├── carbon_toolbar.dart
│   │   ├── carbon_multi_select.dart
│   │   ├── carbon_contained_list.dart
│   │   ├── carbon_floating_menu.dart
│   │   └── ... (27 more widgets)
│   └── icons/                         # Carbon icon font
│       └── carbon_icons.dart
└── example/                           # Example app
    ├── lib/
    │   ├── main.dart                  # App entry + routing
    │   ├── routes.dart                # Route definitions
    │   └── pages/                     # 49 demo pages
    └── assets/                        # Example assets
```

## 🎯 Carbon Design System V11 Compliance

This implementation follows the official Carbon Design System V11 specifications:

- ✅ Color tokens match Carbon V11 theme definitions
- ✅ Typography follows Carbon type scale
- ✅ Components match Carbon web component behavior
- ✅ All 4 official themes (White, G10, G90, G100) supported
- ✅ Spacing, motion, and layering follow Carbon guidelines
- ✅ 37 custom `Carbon*` widgets with full spec compliance
- ✅ No Material ink ripple — flat interaction feedback per Carbon spec (1.3+)
- ✅ 11 Carbon components covered via automatic Material theming
- 🚧 25 components not yet implemented (see table above)

**Reference**: https://carbondesignsystem.com/

## 🤝 Contributing

Contributions are welcome! This project implements the Carbon Design System V11 for Flutter.

### Guidelines
1. Follow Carbon Design System V11 specifications
2. Support all 4 theme variants (White, G10, G90, G100)
3. Build widget internals on the widgets layer — use the `lib/src/base/` primitives (`CarbonPressable`, `CarbonDivider`, `CarbonOverlaySurface`) and `CarbonIcons` instead of Material widgets/icons (see `V2_ROADMAP.md`)
4. Add comprehensive examples in the example app with demos
5. Run `flutter analyze` to ensure code quality
6. Test across all 4 themes

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

This is the same license used by IBM's Carbon Design System.

## 🙏 Acknowledgments

- IBM's Carbon Design System team for the design specifications
- The Flutter team for the excellent framework
- Carbon Design System: https://carbondesignsystem.com
- Carbon GitHub: https://github.com/carbon-design-system/carbon

## 💬 Support

For issues, questions, or contributions, please refer to the project repository.

---

**Built with Flutter ❤ Inspired by IBM's Carbon Design System V11**
