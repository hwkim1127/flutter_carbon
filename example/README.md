# Carbon Flutter Example App

This example app demonstrates all **48 Carbon components** from the Flutter Carbon package (31 pure Carbon + 17 Material equivalents) with comprehensive, interactive demos across **47+ pages**.

## Overview

The example app provides complete demonstrations of IBM's Carbon Design System implementation in Flutter, featuring:

- **100% Component Coverage**: All 48 production-ready components
- **47+ Interactive Demo Pages**: Dedicated demos for every component
- **4 Theme Variants**: Live switching between White, G10, G90, and G100 themes
- **Real-World Examples**: Practical usage patterns for each component
- **Multiple Variants**: Different sizes, states, and configurations for every component
- **Categorized Navigation**: Components organized by type (Buttons, Forms, Overlays, etc.)

## Features

### Home Page
- **Categorized Navigation**: Components organized into 12 logical categories
- **Component Cards**: Each component with description and direct navigation
- **Foundation Section**: Access to Colors, Typography, Icons, and Layering demos
- **View All**: Quick link to see all components in one scrollable page

### Component Demo Pages
Each of the 48 components has a dedicated demo page featuring:
- **Comprehensive Examples**: Multiple interactive examples per component
- **All Variants**: Different sizes, styles, and types
- **State Demonstrations**: Enabled, disabled, loading, error, and focus states
- **Edge Cases**: Long text, empty data, many items
- **Integration Examples**: Components used together
- **Clear Documentation**: Descriptions and usage notes

### Theme Switcher
- **Global Access**: Floating action button (bottom right) on every page
- **4 Themes**:
  - **White** - Light theme for optimal readability
  - **G10** - Slightly darker than White
  - **G90** - Dark theme for low-light environments
  - **G100** - Darkest theme with maximum contrast
- **Instant Switching**: Changes apply immediately across the app
- **Bottom Sheet UI**: Clean, accessible theme selection interface

## Component Categories

### Foundation (4 pages)
Fundamental design elements that form the basis of the system:
- **Colors** - Complete color palette with theme tokens
- **Typography** - All 24 type styles with specifications
- **Icons** - Carbon icon font showcase
- **Layering** - Background, layers, fields, and borders

### Buttons (4 components)
Action triggers and interactive elements:
- **Button** - Primary, secondary, tertiary, ghost, danger
- **Combo Button** - Split button with dropdown menu
- **Copy Button** - Copy to clipboard with feedback
- **Chat Button** - Chat interface specialized buttons

### Forms (7 components)
Input components for data collection:
- **Text Input** - Text fields with validation
- **Number Input** - Numeric input with steppers
- **Dropdown** - Select dropdown menu
- **Combo Box** - Searchable dropdown
- **Date & Time Picker** - Material pickers with Carbon theming
- **Toggle** - On/off switch control
- **File Uploader** - File upload with drag & drop

### Notifications (2 components)
Feedback and status:
- **Notification** - Toast and inline notifications
- **Status** - Status indicators

### Content (5 components)
Content display and organization:
- **Content Switcher** - Toggle between content views
- **Skeleton** - Loading placeholders
- **Code Snippet** - Code display with copy
- **Structured List** - Organized data lists
- **Tree View** - Hierarchical tree structure

### Navigation (3 components)
Navigation patterns:
- **Breadcrumb** - Navigation trail
- **Pagination** - Page navigation
- **UI Shell** - Application shell layout

### Overlays (5 components)
Modal and floating content:
- **Modal** - Dialog overlays
- **Side Panel** - Slide-in side drawer
- **Tearsheet** - Full-height slide-in panel
- **Popover** - Contextual popup
- **Toggle Tip** - Toggleable tooltip

### Data Display (2 components)
Data presentation:
- **Loading** - Loading indicators
- **Link** - Hyperlinks

### AI & Syntax (2 components)
AI and code features:
- **AI Label** - AI-generated content labels
- **Syntax Highlighting** - Code syntax themes

### Other (2 components)
Additional components:
- **Overflow Menu** - Actions menu
- **Page Header** - Page title and actions

### Material Equivalents (Fully Themed)
All standard Material widgets are automatically themed to match Carbon Design System. This includes **comprehensive coverage** of:
- **Inputs**: `TextField`, `Checkbox`, `Radio`, `Switch`, `Slider`, `InputDecoration`
- **Navigation**: `AppBar`, `BottomNavigationBar`, `NavigationRail`, `NavigationDrawer`, `TabBar`
- **Surfaces**: `Card`, `Dialog`, `BottomSheet`, `ExpansionTile`
- **Feedback**: `SnackBar`, `ProgressIndicator` (Linear/Circular), `Tooltip`, `Banner`
- **Content**: `Chip`, `DataTable`, `ListTile`, `Icon`, `Divider`
- **Interactions**: `FloatingActionButton`, `TextSelection`, `Scrollbar`, `IconButton`
- **Pickers**: `DatePicker`, `TimePicker`, `SearchBar`, `DropdownMenu`

### Carbon Widgets (3 components)
Custom Carbon implementations:
- **Multi-Select** - Multi-selection dropdown
- **Contained List** - specialized list container
- **Floating Menu** - Expandable FAB menu

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
2. **Browse by Category**: Select a category (Buttons, Forms, Overlays, etc.)
3. **Open Component Demo**: Tap a component card to view its demo page
4. **Try Interactions**: Most demos are interactive - tap buttons, select items, etc.
5. **Switch Themes**: Use the theme FAB (bottom right) to see components in different themes

### Testing Theme Variants

1. **Tap the palette icon** (floating button, bottom right)
2. **Select a theme**: WHITE, G10, G90, or G100
3. **Observe changes**: All components update immediately
4. **Compare variants**: Switch between themes to see color differences

### Understanding Demo Pages

Each demo page follows a consistent structure:

```dart
DemoPageTemplate(
  title: 'Component Name',           // Page title
  description: 'Component purpose',  // What it does
  sections: [                        // Multiple demo sections
    DemoSection(
      title: 'Section Name',         // Example type
      description: 'What this shows', // Section purpose
      builder: (context) => Widget(),  // The actual demo
    ),
  ],
)
```

## Adding New Demo Pages

To add a new component demo:

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
  // State variables here

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'My Component',
      description: 'Brief description of what this component does',
      sections: [
        DemoSection(
          title: 'Basic Usage',
          description: 'The simplest way to use this component',
          builder: (context) => MyComponent(),
        ),
        DemoSection(
          title: 'Variants',
          description: 'Different sizes and styles',
          builder: (context) => Column(
            children: [
              MyComponent(size: ComponentSize.small),
              MyComponent(size: ComponentSize.medium),
              MyComponent(size: ComponentSize.large),
            ],
          ),
        ),
        // More sections...
      ],
    );
  }
}
```

### 2. Add Route Definition

In `lib/routes.dart`, add your route constant:

```dart
class AppRoutes {
  // ... existing routes
  static const String myComponent = '/category/my-component';
}
```

### 3. Add to Category

In `lib/routes.dart`, add to the appropriate category:

```dart
static final Map<String, List<ComponentItem>> categories = {
  'Your Category': [
    // ... existing components
    ComponentItem(
      title: 'My Component',
      route: AppRoutes.myComponent,
      description: 'Brief one-line description',
    ),
  ],
};
```

### 4. Register Route Handler

In `lib/main.dart`, add the route case:

```dart
onGenerateRoute: (settings) {
  Widget Function(BuildContext) builder;

  switch (settings.name) {
    // ... existing cases
    case AppRoutes.myComponent:
      builder = (_) => const MyComponentDemoPage();
      break;
  }

  // ... rest of routing code
}
```

### 5. Import the Page

At the top of `lib/main.dart`:

```dart
import 'pages/my_component_demo_page.dart';
```

## Demo Page Best Practices

### Section Organization

1. **Basic Usage** - Simplest possible example
2. **Variants** - Different sizes, styles, types
3. **States** - Enabled, disabled, loading, error, focus
4. **Interactive Example** - User can interact and see state changes
5. **Edge Cases** - Long text, many items, empty state
6. **Integration** - Used with other components
7. **Customization** - Advanced configuration options

### Example Structure

```dart
DemoSection(
  title: 'Interactive States',
  description: 'Component behavior in different states',
  builder: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // State controls
      Row(
        children: [
          Text('Current state: $_currentState'),
          SizedBox(width: 16),
          CarbonDropdown(
            items: ['Normal', 'Disabled', 'Loading'],
            selectedItem: _currentState,
            onChanged: (value) => setState(() => _currentState = value),
          ),
        ],
      ),
      SizedBox(height: 16),
      // Component in current state
      MyComponent(
        disabled: _currentState == 'Disabled',
        loading: _currentState == 'Loading',
      ),
    ],
  ),
)
```

## Navigation Flow

```
Home Page
├─ Foundation
│  ├─ Colors
│  ├─ Typography
│  ├─ Icons
│  └─ Layering
│
├─ Buttons
│  ├─ Button Variants
│  ├─ Combo Button
│  ├─ Copy Button
│  └─ Chat Button
│
├─ Forms
│  ├─ Dropdown
│  ├─ Combo Box
│  ├─ Number Input
│  ├─ Toggle
│  └─ File Uploader
│
├─ Navigation
│  ├─ Breadcrumb
│  ├─ Pagination
│  ├─ UI Shell
│  └─ Page Header
│
├─ Overlays
│  ├─ Modal
│  ├─ Side Panel
│  ├─ Tearsheet
│  ├─ Popover
│  └─ Toggle Tip
│
├─ Content
│  ├─ Content Switcher
│  ├─ Skeleton
│  ├─ Code Snippet
│  ├─ Structured List
│  └─ Tree View
│
├─ Notifications
│  └─ Notification
│
├─ Data Display
│  ├─ Loading
│  └─ Link
│
├─ AI & Syntax
│  └─ AI Label
│
└─ Other
   ├─ Overflow Menu
   └─ Page Header
```

## Key Files

### Main Application
- **main.dart** - App entry, routing, theme management, FAB wrapper
- **routes.dart** - All route definitions and component categories

### Reusable Widgets
- **demo_page_template.dart** - Consistent page template with title, description, sections
- **section_header.dart** - Section headers with consistent styling

### Demo Pages
All demo pages follow naming convention: `{component}_demo_page.dart`

## Theme Management

The example app implements global theme switching:

```dart
class _CarbonExampleAppState extends State<CarbonExampleApp> {
  CarbonThemeMode _currentMode = CarbonThemeMode.white;

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
      theme: carbonTheme(carbon: carbon),
      // ... routes
    );
  }
}
```

### Theme Switcher FAB

Every page is wrapped with a FAB for theme switching:

```dart
class ThemeSwitcherWrapper extends StatelessWidget {
  final CarbonThemeMode currentMode;
  final ValueChanged<CarbonThemeMode> onThemeChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => _showThemePicker(context),
            child: Icon(Icons.palette),
          ),
        ),
      ],
    );
  }
}
```

## Component Status

All 48 component demos are fully implemented.

**Current Status**:
- ✅ 100% Complete
- 48/48 components with demo pages
- 4 foundation pages
- 48 total demo pages

## Development Tips

### Hot Reload
Use hot reload (press `r` in terminal) to see changes instantly without losing state.

### Theme Testing
Test each component in all 4 themes to ensure proper color token usage.

### State Management
Use StatefulWidget for interactive demos where user actions change component state.

### Code Organization
- Keep demo pages focused on the component
- Extract complex examples into separate widgets
- Use clear, descriptive section titles
- Add comments for non-obvious code

### Accessibility
- Test with screen readers
- Ensure proper semantic labels
- Test keyboard navigation
- Verify color contrast

## Troubleshooting

### Component Not Showing
- Verify import path
- Check that component is exported in main package
- Ensure theme data exists for the component

### Theme Not Applying
- Confirm `carbonTheme(carbon: carbon)` is used in MaterialApp
- Check that `context.carbon` is called inside build method
- Verify component uses theme tokens, not hardcoded colors

### Navigation Issues
- Ensure route is defined in AppRoutes
- Verify route case exists in onGenerateRoute
- Check that demo page is imported in main.dart

## Related Documentation

- [Main README](../README.md) - Package overview and quick start

---

**100% Complete** - All 48 Carbon components now have comprehensive demo pages! 🎉
