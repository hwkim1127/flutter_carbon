## 1.1.0
* Added `CarbonDataTable` widget:
  * Supports expandable rows with custom content (native expansion behavior).
  * Supports horizontal scrolling via `minWidth` property.
  * Flexible column sizing with `flex` and `width` support.
  * Sortable headers support.
* Fixed `CarbonNavItem` interaction handling.
* Deprecated `onSideNavItemTap` (will be removed in v2.0.0). Use individual `onTap` callbacks on `CarbonNavItem` instead.
* Added support for `onTap` on `CarbonNavItem` children and menu headers.
* Updated `CarbonContentSwitcher` to support generic value types (previously restricted to `String`).
* Added `CarbonTabs` widget for explicit Carbon Design System tab styling (Line and Contained).
* Enhanced `CarbonToggle`:
  * Added `hideStateText` parameter for small toggles (hides On/Off text).
  * Added assertions to validate proper configuration (small size requirement, accessibility).
* Added assertion to `CarbonUIShell` to prevent conflicting usage of deprecated `onSideNavItemTap` and `CarbonNavItem.onTap`.
* Added chevron icons to `CarbonUIShell` side nav menu items with children.

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
