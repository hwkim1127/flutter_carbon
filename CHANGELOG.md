## 1.1.0

### Deprecations

* **CarbonUIShell**
  * Deprecated `onSideNavItemTap` (will be removed in v2.0.0). Use individual `onTap` callbacks on `CarbonNavItem` instead.


### New Features

* **CarbonDataTable**
  * Added `CarbonDataTable` widget with comprehensive features:
    * Supports expandable rows with custom content (native expansion behavior).
    * Supports horizontal scrolling via `minWidth` property.
    * Flexible column sizing with `flex` and `width` support.
    * Sortable headers support.
    * Added custom alignment support (`mainAxisAlignment`, `crossAxisAlignment`) for headers and cells.
    * Added `child` property to `CarbonDataTableHeader` for custom header widgets (e.g., Select All checkbox).
    * Removed unused generic type parameter `<T>` from `CarbonDataTable` class definition.

* **CarbonTabs**
  * Added `CarbonTabs` widget for explicit Carbon Design System tab styling (Line and Contained).


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
