## 1.1.0

### Deprecations

* **CarbonUIShell**
  * Deprecated `onSideNavItemTap` (will be removed in v2.0.0). Use individual `onTap` callbacks on `CarbonNavItem` instead.


### New Features

* **CarbonDataTable**
  * Added `CarbonDataTable` widget with comprehensive features following Carbon Design System specifications:
    * **Expandable rows**: Supports custom expandable content with chevron indicators
    * **Selectable rows**: Multi-select with checkboxes or single-select with radio buttons
    * **Radio mode**: Single-row selection using radio buttons (`radio: true`)
    * **Batch selection**: Select-all checkbox in header with indeterminate state support
    * **Size variants**: Four density options via `CarbonDataTableSize` enum (tall, medium, short, compact)
    * **Sortable columns**: Full sort state management with ascending/descending/none states
      * Sort indicators with up/down arrows
      * Per-column sortable control
      * Programmatic sort control via `sortKey` and `sortDirection`
      * Click-to-sort with automatic direction cycling
    * **Zebra striping**: Alternating row colors for better visual separation (`zebra: true`)
    * **Toolbar support**: Built-in support for title, description, and custom toolbar widgets
    * **Skeleton loading state**: Animated loading placeholders with configurable row count
    * **Efficient architecture**: Uses `InheritedWidget` for configuration distribution (no row copying or iteration)
    * **Horizontal scrolling**: Via `minWidth` property
    * **Flexible column sizing**: With `flex` and fixed `width` support
    * **Custom alignment**: `mainAxisAlignment` and `crossAxisAlignment` for headers and cells
    * **Required header keys**: Headers now require unique `key` property for sorting and column identification

* **CarbonToolbar**
  * Added comprehensive toolbar component system for data tables:
    * **CarbonToolbar**: Main container with automatic switching between regular and batch actions
    * **CarbonToolbarContent**: Wrapper for search, filters, and action buttons
    * **CarbonToolbarBatchActions**: Batch actions toolbar shown when items are selected
      * Shows selected count
      * Cancel button to clear selection
      * Flexible action buttons for bulk operations
      * Highlighted background to indicate active state
    * **CarbonToolbarSearch**: Styled search field component
      * Search icon prefix
      * Clear button when text entered
      * Expandable or fixed width modes
      * Carbon-styled borders and colors

* **CarbonTabs**
  * Added `CarbonTabs` widget for explicit Carbon Design System tab styling (Line and Contained).
  * Added `extendLine` parameter to extend the bottom border across the full width (Line type only).
  * Added auto-scroll behavior to center the selected tab when it changes.


### Component Updates

* **CarbonNavItem**
  * Fixed interaction handling.
  * Added support for `onTap` on children and menu headers.

* **CarbonStructuredList**
  * Added `size` property to support `normal` (default) and `condensed` sizes.
  * Added custom alignment support (`mainAxisAlignment`, `crossAxisAlignment`) for headers and cells.

* **CarbonContentSwitcher**
  * Updated to support generic value types (previously restricted to `String`).

* **CarbonToggle**
  * Enhanced `CarbonToggle`:
    * Added `hideStateText` parameter for small toggles (hides On/Off text).
    * Added assertions to validate proper configuration (small size requirement, accessibility).

* **CarbonUIShell**
  * Added chevron icons to side nav menu items with children.
  * Added assertion to prevent conflicting usage of deprecated `onSideNavItemTap` and `CarbonNavItem.onTap`.

* **CarbonDropdown**
  * Complete rewrite using custom overlay implementation (replaced Flutter's `DropdownButton`).
  * Added precise Carbon Design System compliance (no forced padding, exact sizing, sharp corners).
  * Added `width` parameter for optional fixed-width dropdowns (uses `Expanded` internally when specified).
  * Added smart positioning logic (menu appears above trigger when near bottom of screen).
  * Added hover effects with proper Carbon colors (`layerHover01`).
  * Added checkmark icon for selected items.
  * Improved menu item styling with proper selection and disabled states.

* **CarbonPagination**
  * Refactored to match Carbon Design System specifications:
    * Created custom `_PageSelector` widget using `CarbonDropdown`.
    * Implemented Left/Right section layout (Items per page | Page selector + Navigation).
    * Added `layer01` background color.
    * Added vertical dividers between sections.
  * Updated visual spacing and alignment for compact appearance.


## 1.0.1+1

* Fixed issue with inverted colors in generated icons (e.g., `4k-filled`, `checkbox-checked-filled`) caused by transparent bounding box elements in SVGs.

## 1.0.1

* Refactored `G100Theme` to use a constant theme definition with a private constructor for consistency.

## 1.0.0+4

* Updated `ButtonsDemoPage` to correctly document `ElevatedButton` as the Carbon secondary button variant.
* Integrated `super_drag_and_drop` package in `FileUploaderDemoPage` for native drag and drop support.

## 1.0.0+3

* Fixed deprecated `RadioListTile.groupValue` usage in example app by migrating to `RadioGroup` widget (Flutter v3.32.0+)
* Fixed Dart formatting issue

## 1.0.0+2

* README.md updated

## 1.0.0+1

* static analysis fix for pub.dev

## 1.0.0

* Initial release with Carbon Design System V11.
