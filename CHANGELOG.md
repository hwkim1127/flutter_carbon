## 1.2.1

### Deprecations

* **CarbonDataTable**
  * `CarbonDataTable.sortable` is now a no-op and marked `@Deprecated`. Sort UI is driven entirely by `header.sortable: true` (per-column opt-in) + a non-null `onSort` callback — the table-level flag became redundant ("yes I really mean it"). Existing call sites that pass `sortable: true` keep compiling (with a deprecation warning) and behave the same as before, since the gate now uses `header.sortable && onSort != null`. To disable all sort UI on a table, pass `onSort: null` (or omit it). The field will be removed in 2.0.0.

### Behavior Changes

* **CarbonDataTable**
  * `CarbonDataTableHeader.sortable` now defaults to **`false`** (was `true`). Sort indicators no longer appear on every column whenever the table is sortable; columns now **opt in** by setting `sortable: true` explicitly. The previous default made non-sortable columns show a misleading grey up/down chevron. Existing call sites that explicitly set `sortable: false` keep working (the value is now redundant but harmless); call sites that relied on the implicit default to be sortable must set `sortable: true` on those headers.

### Bug Fixes

* **CarbonDataTable**
  * Fixed: a sortable header that used `flex` (no fixed `width`) crashed at layout with `Expanded was placed inside a Listener`. The sortable click handler (`MouseRegion` + `GestureDetector`) was wrapping the cell container — which, for `flex`-sized columns, **is** an `Expanded` — and that `Expanded` ended up nested inside a `Listener` instead of being a direct child of the parent `Row`. The click handler now wraps the header's **content** before the cell container is built, so the `Expanded` (or `SizedBox`, for `width`-sized columns) stays a direct child of the parent `Flex`. Sortable columns can now use either `flex` or `width`.

## 1.2.0

### New Features

* **CarbonProgressIndicator** (new)
  * Added `CarbonProgressIndicator` widget — a native Carbon Design System progress indicator component.
  * Accepts a `List<CarbonProgressStep>` to define each step with a required `label`, optional `secondaryLabel`, optional explicit `state`, and `disabled` flag.
  * Step states are automatically derived from `currentIndex` (parent-managed):
    * `complete` — steps before the current index; filled circle with white checkmark.
    * `current` — step at the current index; filled circle with white hollow center (CircleDash).
    * `incomplete` — steps after the current index; circle outline.
    * `invalid` — error state (explicit only); `CarbonIcons.warningFilled` in `carbon.layer.supportError`.
    * `disabled` — grayed-out circle outline; not tappable even when `onStepTap` is set.
    * Individual steps can override automatic state via `CarbonProgressStep.state`.
  * **Orientation**: horizontal (default) and vertical via `vertical` parameter.
    * Horizontal: connector lines run left/right of each icon; each step in `Expanded` by default.
    * Vertical: connector line runs downward from icon; labels sit to the right; minimum step height 58px matching Carbon spec.
  * **`spaceEqually`** (horizontal only, default `true`): wraps each step in `Expanded` to distribute width equally.
  * **`onStepTap`**: when provided, steps become tappable. Current and disabled steps remain non-interactive.
  * **Connector lines** reflect completion: lines connecting to/from complete steps use `buttonPrimary` (Carbon Blue); lines to incomplete steps use `#8D8D8D`.
  * **Custom icon painters** (`CustomPainter`):
    * `_CheckCirclePainter` — filled circle + white checkmark strokes.
    * `_CurrentCirclePainter` — filled circle + white hollow dot center.
    * `_OutlineCirclePainter` — 1.5px stroke circle outline.
  * `MouseRegion` cursor changes to `click` on tappable steps.
  * Icon and label colors follow Carbon theme tokens (`carbon.button.buttonPrimary`, `carbon.text.textPrimary`, `carbon.text.textSecondary`, `carbon.text.textDisabled`).

### Component Updates

* **CarbonComboBox**
  * The trailing chevron icon is now tappable and toggles the dropdown open/closed (previously only the text field area opened the menu).

### Bug Fixes

* **CarbonComboBox**
  * Fixed: the trailing chevron icon did not flip back from up to down immediately after the dropdown closed because `_isOpen` was mutated outside `setState`. Closing the dropdown now triggers a rebuild consistently.

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
  * Fixed chevron icon appearing immediately after text instead of at the trailing edge. The trigger row now uses `LayoutBuilder` to detect bounded constraints: uses `Expanded` for the label when width is constrained (e.g. inside `Expanded` parent), and falls back to natural sizing when unconstrained (e.g. inside `Row(mainAxisSize: MainAxisSize.min)`).

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
  * Added `scrollable` parameter (defaults to `true`). When set to `false`, the content area uses `Expanded` instead of `SingleChildScrollView`, allowing children that manage their own scrolling (e.g. `TabBarView`) to lay out correctly.

* **CarbonComboBox**
  * `CarbonComboBoxItem` now supports an optional `child` (Widget) parameter as an alternative to `label` (String).
    * Exactly one of `label` or `child` must be provided — enforced by assert.
    * When `child` is provided, it is rendered as the dropdown item instead of `Text(label)`.
    * Filtering falls back to `value.toString()` when `label` is absent.
    * Added `filterText` getter on `CarbonComboBoxItem` for consistent filter logic.
  * Added `onSearch` callback for external/database-driven search.
    * When `onSearch` is provided, client-side filtering is disabled — the parent is responsible for updating `items` in response to the query.
    * Useful for large datasets where items should be fetched on demand (e.g. SQLite full-text search).
  * Added keyboard navigation support.
    * **↓ / ↑ Arrow**: moves highlight through dropdown items; opens the dropdown if closed.
    * **Enter / Numpad Enter**: selects the currently highlighted item.
    * **Escape**: closes the dropdown.
    * Holding an arrow key repeats navigation (`KeyRepeatEvent` handled).
    * Dropdown list auto-scrolls to keep the highlighted item visible.
    * Highlighted item is visually indicated using `menuItemHover` color.
  * Removed Material underline border from the internal `TextField` (all border variants set to `InputBorder.none`).

* **CarbonTag** (new)
  * Added `CarbonTag` widget — a native Carbon Design System tag component, replacing Flutter's `Chip` for Carbon-compliant tag rendering.
  * Supports 12 color variants via `CarbonTagType` enum: `red`, `magenta`, `purple`, `blue`, `cyan`, `teal`, `green`, `gray`, `coolGray`, `warmGray`, `highContrast`, `outline`. Colors use fixed IBM Design Language palette values, independent of the active theme.
  * Supports 3 size variants via `CarbonTagSize` enum: `sm` (18px), `md` (24px, default), `lg` (32px).
  * Provide `onDismiss` callback to render a dismissible tag with a close icon button.
  * `disabled` parameter dims text and disables the close button.
  * Hover state with per-type hover color using `MouseRegion`.
  * Fully pill-shaped (`borderRadius: 100`); `outline` type renders with a 1px border and transparent background.

* **CarbonFileUploaderDropZone**
  * Added `dragText` parameter to customize the primary drop zone label (defaults to `'Drag and drop files here or'`).
  * Added `browseText` parameter to customize the secondary browse label (defaults to `'click to upload'`).

### Bug Fixes

* **CarbonDataTableRow**
  * Fixed: clicking the row body on an expandable row toggled the visual expansion state but did not fire `onExpansionChanged`. The callback is now called consistently whether the row is expanded via the chevron or by tapping the row body.
  * Both parameters are ignored when a custom `child` widget is provided.

* **CarbonMultiSelect**
  * Selected item chips now render using `CarbonTag` instead of Flutter's `Chip`, eliminating the `contentSize >= rawLabelSize.height` layout assertion caused by the global `ChipThemeData` negative vertical `labelPadding`.


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
