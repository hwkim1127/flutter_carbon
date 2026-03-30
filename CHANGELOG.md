## 1.1.0

### Deprecations

* **CarbonUIShell**
  * Deprecated `onSideNavItemTap` (will be removed in v2.0.0). Use individual `onTap` callbacks on `CarbonNavItem` instead.


### New Features

* **Foundation & Theme Updates**
  * Updated `CheckboxThemeData` and `RadioThemeData` to use `VisualDensity(vertical: -4.0, horizontal: -4.0)` and `MaterialTapTargetSize.shrinkWrap` for better Carbon compliance.
  * Updated `ChipThemeData` to use `StadiumBorder` (pill shape) and adjusted `labelPadding` (with negative vertical values) to achieve compact Carbon Tag sizing.
  * Added `isDense: true` to global `InputDecorationTheme` to prevent excessive height in text fields.
  * Standardized icon sizes across all components using `CarbonIconSizes` tokens.
  * Added `CarbonIconSizes.iconSize03` (24px) and `CarbonIconSizes.iconSize04` (32px) constants.
  * Set default icon size to 16px (`iconSize01`) for:
    * `IconThemeData` (global default)
    * `IconButtonThemeData`
    * `AppBarTheme` (back and action icons)
    * `NavigationBarTheme`
    * `NavigationRailTheme`
    * `NavigationDrawerTheme`

* **CarbonButton**
  * Added `CarbonButton` widget following Carbon Design System button specifications:
    * **Seven kind variants** via `CarbonButtonKind` enum:
      * `primary` — filled, for primary actions
      * `secondary` — filled, for secondary actions
      * `tertiary` — outlined, for less-prominent actions
      * `ghost` — transparent, for low-emphasis actions
      * `danger` — filled red, for destructive primary actions
      * `dangerTertiary` — outlined red, for destructive secondary actions
      * `dangerGhost` — transparent red, for destructive ghost actions
    * **Five size variants** via `CarbonButtonSize` enum: `sm` (32 px), `md` (40 px), `lg` (48 px, default), `xl` (64 px), `twoXl` (80 px)
    * **Icon support**: optional trailing icon via `icon` parameter; omitting `child` produces a square icon-only button
    * **Disabled state**: passing `onPressed: null` disables the button with correct Carbon disabled colors
    * **Hover and press states** with animated background transitions (`durationFast01`)
    * **Focus ring**: 2 px focus outline extending outside the button bounds, using `borderInteractive` token
    * **Keyboard accessibility**: Space and Enter key activation
    * Typography follows Carbon type scale — `bodyCompact01` (14 px) for sm/md/lg and `bodyCompact02` (16 px) for xl/2xl
 
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

* **CarbonBreadcrumb**
  * Fixed default behavior to omit trailing slash after the last item (`noTrailingSlash` now defaults to `true`).

* **CarbonContentSwitcher**
  * Fixed `G10` theme visibility issue where selected text was white on white background (changed text color to `gray100`).
  * Fixed `G10` theme border visibility issue (changed divider color to `gray30`).
  * Updated to support generic value types (previously restricted to `String`).

* **CarbonTile**
  * Added optional `backgroundColor` parameter to allow custom background color override.

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

* **CarbonTearsheet**
  * Added responsive width logic: Automatically adapts to screen width on smaller devices (e.g., mobile) while respecting the maximum width defined by `CarbonTearsheetWidth` (narrow/wide).
  * Fixed action button layout to match Carbon action-set specification: buttons now fill the full footer width equally with no padding or gaps between them (previously right-aligned with 16px container padding and 8px gaps).
  * Action buttons should be sized by callers: use `CarbonButtonSize.xl` (64px) for narrow tearsheets and `CarbonButtonSize.twoXl` (80px) for wide tearsheets, matching the Carbon web component behavior.

* **CarbonComboBox**
  * `CarbonComboBoxItem` now supports an optional `child` (Widget) parameter as an alternative to `label` (String).
    * Exactly one of `label` or `child` must be provided — enforced by assert.
    * When `child` is provided, it is rendered as the dropdown item instead of `Text(label)`.
    * Filtering falls back to `value.toString()` when `label` is absent.
    * Added `filterText` getter on `CarbonComboBoxItem` for consistent filter logic.

* **CarbonFileUploaderDropZone**
  * Added `dragText` parameter to customize the primary drop zone label (defaults to `'Drag and drop files here or'`).
  * Added `browseText` parameter to customize the secondary browse label (defaults to `'click to upload'`).
  * Both parameters are ignored when a custom `child` widget is provided.


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
