# Carbon Flutter Example App

This example app demonstrates the Flutter Carbon package with **36 custom `Carbon*` widgets** and **Material theming coverage** across **12 categories and 48+ demo pages**.

## Overview

The example app provides interactive demonstrations of IBM's Carbon Design System implementation in Flutter, featuring:

- **36 Custom Carbon Widgets**: Native `Carbon*` implementations following Carbon Design System specifications
- **Material Theming**: Standard Flutter widgets (TabBar, Checkbox, ExpansionTile, etc.) automatically styled to match Carbon
- **48+ Interactive Demo Pages**: Dedicated demos for every component
- **4 Theme Variants**: Live switching between White, G10, G90, and G100 themes
- **Real-World Examples**: Practical usage patterns and all variants per component
- **Categorized Navigation**: Components organized into 12 logical categories

## Features

### Home Page
- **Categorized Navigation**: Components organized into 12 logical categories
- **Component Cards**: Each component with description and direct navigation
- **Foundation Section**: Access to Colors, Typography, Icons, and Layering demos

### Component Demo Pages
Each demo page features:
- **Multiple Examples**: Several interactive sections per component
- **All Variants**: Different sizes, styles, and types
- **State Demonstrations**: Enabled, disabled, error, and focus states
- **Clear Descriptions**: Usage notes per section

### Theme Switcher
- **Global Access**: Floating action button (bottom right) on every page
- **4 Themes**:
  - **White** — Light theme for optimal readability
  - **G10** — Slightly darker than White
  - **G90** — Dark theme for low-light environments
  - **G100** — Darkest theme with maximum contrast
- **Instant Switching**: Changes apply immediately across the entire app

## Component Categories

### Foundation (4 pages)
Core design tokens and styles:
- **Colors** — Complete color palette with theme tokens
- **Typography** — All 24 type styles with specifications
- **Icons** — Carbon icon font showcase
- **Layering** — Background, layers, fields, and borders

### Buttons (4 components)
Custom `Carbon*` button implementations:
- **Button** — `CarbonButton`: primary, secondary, tertiary, ghost, danger — 5 kinds × 5 sizes
- **Combo Button** — `CarbonComboButton`: split button with dropdown menu
- **Copy Button** — `CarbonCopyButton`: copy to clipboard with feedback animation
- **Chat Button** — `CarbonChatButton`: chat interface specialized buttons

### Forms (7 components)
Input and selection components:
- **Text Input** — Material `TextField` with Carbon theming
- **Number Input** — `CarbonNumberInput`: numeric input with steppers
- **Dropdown** — `CarbonDropdown`: custom overlay dropdown with smart positioning
- **Combo Box** — `CarbonComboBox`: searchable dropdown with keyboard navigation
- **Date & Time Picker** — Material pickers with Carbon theming
- **Toggle** — `CarbonToggle`: on/off switch with label
- **File Uploader** — `CarbonFileUploader`: drag & drop file upload

### Notifications (2 components)
Feedback and alerts:
- **Notification** — `CarbonNotification`: toast and inline notifications
- **Status** — Status indicator icons and colors

### Content (5 components)
Content display and organization:
- **Content Switcher** — `CarbonContentSwitcher`: toggle between content views
- **Skeleton** — `CarbonSkeleton`: animated loading placeholders
- **Code Snippet** — `CarbonCodeSnippet`: code display with copy
- **Structured List** — `CarbonStructuredList`: organized data lists
- **Tree View** — `CarbonTreeView`: hierarchical tree structure

### Navigation (3 components)
Navigation patterns:
- **Breadcrumb** — `CarbonBreadcrumb`: navigation trail
- **Pagination** — `CarbonPagination`: page navigation with items-per-page selector
- **UI Shell** — `CarbonUIShell`: application shell with side nav and header

### Overlays (5 components)
Modal and floating content:
- **Modal** — `CarbonModal`: dialog overlays
- **Side Panel** — `CarbonSidePanel`: slide-in side drawer
- **Tearsheet** — `CarbonTearsheet`: full-height slide-in panel (narrow and wide)
- **Popover** — `CarbonPopover`: contextual popup
- **Toggle Tip** — `CarbonToggleTip`: toggleable informational tooltip

### Data Display (2 components)
Inline data presentation:
- **Loading** — `CarbonLoading`: spinner loading indicators
- **Link** — `CarbonLink`: inline hyperlinks

### AI & Syntax (2 components)
AI and code features:
- **AI Label** — `CarbonAiLabel`: AI-generated content labels
- **Syntax Highlighting** — Code syntax themes for `CarbonCodeSnippet`

### Other (2 components)
Additional components:
- **Overflow Menu** — `CarbonOverflowMenu`: actions menu
- **Page Header** — `CarbonPageHeader`: page title with actions

### Carbon Components (7 components)
Custom `Carbon*` implementations with dedicated demo pages:
- **Tag** — `CarbonTag`: 12 color variants, 3 sizes (sm/md/lg), dismissible, disabled
- **Tabs** — `CarbonTabs`: Line and Contained variants; also shows Material `TabBar` with Carbon theming
- **Data Table** — `CarbonDataTable`: sort, multi-select, radio-select, expand, batch actions, toolbar, skeleton, zebra stripes
- **Tile** — `CarbonTile`: clickable and selectable tile variants
- **Multi-Select** — `CarbonMultiSelect`: multi-selection dropdown with `CarbonTag` chips
- **Contained List** — `CarbonContainedList`: list container for small spaces
- **Floating Menu** — `CarbonFloatingMenu`: expandable floating action menu

### Material Theming (5 demos)
Carbon components covered via Material widget theming (no custom `Carbon*` class):
- **Accordion** — `ExpansionTile` with Carbon theme
- **Tooltip** — `Tooltip` with Carbon theme
- **Search** — `SearchBar` with Carbon theme
- **Select** — `DropdownMenu` with Carbon theme
- **Selection Controls** — `Checkbox`, `Radio`, `Switch`, `Slider` with Carbon theme

## Running the Example

### Prerequisites
- Flutter SDK 3.27.0 or higher
- Dart SDK 3.6.0 or higher

### Steps

1. **Navigate to example directory**:
   ```bash
   cd example
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

4. **Select your target device** when prompted (iOS, Android, Web, Desktop)

## Usage Guide

### Exploring Components

1. **Start at Home**: Launch the app to see the categorized component list
2. **Browse by Category**: Select a category (Buttons, Forms, Carbon Components, etc.)
3. **Open Component Demo**: Tap a component card to view its demo page
4. **Try Interactions**: Most demos are interactive — tap buttons, select items, etc.
5. **Switch Themes**: Use the palette FAB (bottom right) to see components in all 4 themes

### Understanding Demo Pages

Each demo page follows a consistent structure:

```dart
DemoPageTemplate(
  title: 'Component Name',
  description: 'Component purpose',
  sections: [
    DemoSection(
      title: 'Section Name',
      description: 'What this shows',
      builder: (context) => Widget(),
    ),
  ],
)
```

## Adding New Demo Pages

### 1. Create the Demo Page

Create `lib/pages/my_component_demo_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

class MyComponentDemoPage extends StatefulWidget {
  const MyComponentDemoPage({super.key});

  @override
  State<MyComponentDemoPage> createState() => _MyComponentDemoPageState();
}

class _MyComponentDemoPageState extends State<MyComponentDemoPage> {
  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'My Component',
      description: 'Brief description of what this component does.',
      sections: [
        DemoSection(
          title: 'Basic Usage',
          description: 'The simplest way to use this component.',
          builder: (context) => const MyComponent(),
        ),
        // More sections...
      ],
    );
  }
}
```

### 2. Add Route Constant

In `lib/routes.dart`:

```dart
class AppRoutes {
  // ... existing routes
  static const String myComponent = '/category/my-component';
}
```

### 3. Add to Category

In `lib/routes.dart`, add to the appropriate `ComponentCategory`:

```dart
ComponentItem(
  title: 'My Component',
  route: AppRoutes.myComponent,
  description: 'Brief one-line description',
),
```

### 4. Register Route Handler

In `lib/main.dart`:

```dart
case AppRoutes.myComponent:
  builder = (_) => const MyComponentDemoPage();
  break;
```

### 5. Import the Page

At the top of `lib/main.dart`:

```dart
import 'pages/my_component_demo_page.dart';
```

## Navigation Structure

```
Home Page
├─ Foundation
│  ├─ Colors
│  ├─ Typography
│  ├─ Icons
│  └─ Layering
│
├─ Buttons
│  ├─ Button (CarbonButton)
│  ├─ Combo Button
│  ├─ Copy Button
│  └─ Chat Button
│
├─ Forms
│  ├─ Text Input
│  ├─ Number Input
│  ├─ Dropdown (CarbonDropdown)
│  ├─ Combo Box (CarbonComboBox)
│  ├─ Date & Time Picker
│  ├─ Toggle
│  └─ File Uploader
│
├─ Notifications
│  ├─ Notification
│  └─ Status
│
├─ Content
│  ├─ Content Switcher
│  ├─ Skeleton
│  ├─ Code Snippet
│  ├─ Structured List
│  └─ Tree View
│
├─ Navigation
│  ├─ Breadcrumb
│  ├─ Pagination
│  └─ UI Shell
│
├─ Overlays
│  ├─ Modal
│  ├─ Side Panel
│  ├─ Tearsheet
│  ├─ Popover
│  └─ Toggle Tip
│
├─ Data Display
│  ├─ Loading
│  └─ Link
│
├─ AI & Syntax
│  ├─ AI Label
│  └─ Syntax Highlighting
│
├─ Other
│  ├─ Overflow Menu
│  └─ Page Header
│
├─ Carbon Components
│  ├─ Tag (CarbonTag)
│  ├─ Tabs (CarbonTabs)
│  ├─ Data Table (CarbonDataTable)
│  ├─ Tile (CarbonTile)
│  ├─ Multi-Select (CarbonMultiSelect)
│  ├─ Contained List (CarbonContainedList)
│  └─ Floating Menu (CarbonFloatingMenu)
│
└─ Material Theming
   ├─ Accordion
   ├─ Tooltip
   ├─ Search
   ├─ Select
   └─ Selection Controls
```

## Key Files

- **main.dart** — App entry, routing, theme management, FAB wrapper
- **routes.dart** — All route constants and component category definitions
- **widgets/demo_page_template.dart** — Consistent page template (`DemoPageTemplate`, `DemoSection`)

## Component Status

| Category | Count | Type |
|---|---|---|
| Custom `Carbon*` widgets | 36 | Native Carbon implementation |
| Material theming demos | 5 | Material widget + Carbon theme |
| Not yet implemented | 16 | Planned for future releases |
| **Carbon Design System total** | **74** | |

See [../README.md](../README.md) for the full component coverage breakdown.

## Troubleshooting

### Theme Not Applying
- Confirm `carbonTheme(carbon: carbon)` is used in `MaterialApp.theme`
- Check that `context.carbon` is called inside `build`
- Verify the component uses Carbon theme tokens, not hardcoded colors

### Navigation Issues
- Ensure the route constant is defined in `AppRoutes`
- Verify the `case` exists in `onGenerateRoute` in `main.dart`
- Check that the demo page is imported at the top of `main.dart`

## Related Documentation

- [Main README](../README.md) — Package overview, component coverage, and quick start
