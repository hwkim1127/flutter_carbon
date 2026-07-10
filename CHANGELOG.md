## 2.0.0 (Unreleased)

The V2 rearchitecture (`doc/V2_ROADMAP.md`): `flutter_carbon` is now a
self-contained implementation of Carbon Design System on the widgets layer —
theming core, app shell, and **every widget** are Material-free (guard-test
enforced). Material interop is an explicit bridge library
(`package:flutter_carbon/material.dart`). See `MIGRATION.md`
("1.x → 2.0.0") — for Material apps the migration is one import change plus
one `builder:` line.

### Breaking Changes

* `CarbonThemeData` (and every component theme data class) no longer extends
  Material's `ThemeExtension`; they are plain immutable classes. `lerp`
  signatures changed from `lerp(ThemeExtension<T>? other, double t)` to
  `lerp(T? other, double t)`.
* `context.carbon` resolves via the new `CarbonTheme` inherited widget instead
  of `Theme.of(context).extension<...>()`. Material apps must install
  `CarbonMaterialBridge` in `MaterialApp.builder`; a missing theme now throws
  a `FlutterError` with setup instructions (was `StateError`).
* `carbonTheme()` and `CarbonInputDecorationHelper` moved from
  `package:flutter_carbon/flutter_carbon.dart` to
  `package:flutter_carbon/material.dart` (which re-exports the core library —
  switching the import is enough).
* `CarbonComboButton` is now generic `CarbonComboButton<T>`: `menuItems` is
  `List<CarbonMenuEntry<T>>` (was Material's `List<PopupMenuEntry<dynamic>>`)
  and `onMenuItemSelected` is `ValueChanged<T>` (was `void Function(dynamic)`).
  Migration: `PopupMenuItem(value: 'x', child: Text('X'))` →
  `CarbonMenuItem(value: 'x', label: 'X')`; `PopupMenuDivider()` →
  `CarbonMenuItemDivider()`.
* `CarbonFloatingMenu.heroTag` removed (it existed only for Material's
  FloatingActionButton Hero animation; the trigger is native now).
* `CarbonDataTable.sortable` removed, as scheduled when it was deprecated in
  1.2.1 (no-op since then — a column sorts iff its header has
  `sortable: true` and the table has a non-null `onSort`).
* `CarbonUIShell.onSideNavItemTap` removed, as scheduled when it was
  deprecated (use `CarbonNavItem.onTap` on each item).
* `CarbonOverflowMenu.items` is now `List<CarbonOverflowMenuEntry>` (was
  `List<dynamic>`); `CarbonOverflowMenuItem` and `CarbonOverflowMenuDivider`
  extend the new sealed `CarbonOverflowMenuEntry` base, so existing item
  lists compile unchanged — only lists explicitly typed `List<dynamic>` (or
  containing other types) need updating.
* `CarbonTreeView` is now generic `CarbonTreeView<T>` with **value-based
  selection**: `selectedNode` is replaced by `selectedValue` (`T?`), compared
  against the new `CarbonTreeNode<T>.value` (which replaces the untyped
  `CarbonTreeNode.data`). Expansion state is also keyed by `value` when
  present, so it survives rebuilding the `nodes` list; value-less nodes fall
  back to instance identity as before.
* `CarbonStructuredListRow.data` removed (an untyped payload the widget never
  read; selection is index-based via `selectedIndex`/`onRowSelected`).
* `CarbonCodeSnippet` API aligned to React's CodeSnippet:
  `showCopyButton` → `hideCopyButton` (inverted), `feedbackMessage` →
  `labels.copied` (via `CarbonCodeSnippetLabels`), `maxCollapsedLines` →
  `maxCollapsedNumberOfRows` (**semantics change**: rows are 16px viewport
  rows clipped by height — the text is never truncated, so selection
  survives collapse and copy always gets the full code; default 10 → 15),
  `useMonospace` removed (the spec `code-01` mono type is always used).
* `CarbonCopyButton` reworked to the spec icon-only square button (sizes
  sm 32 / md 40 / lg 48) with a feedback tooltip: the visible
  `label`/`successLabel` texts are gone (→ `iconDescription` a11y label and
  the `feedback` tooltip text) and `successDuration` is now
  `feedbackTimeout`.
* `CarbonCodeSnippetThemeData`: `border` removed (spec snippets have no
  border); `copyButtonBackgroundActive` added.
* Behavioral: `CarbonUIShell` and `CarbonModal` no longer create
  `Scaffold`/`Material` ancestors — Material widgets passed as content need
  their own `Material`.

### New Features

Theming and app shell:

* **`CarbonApp`** — a pure-Carbon application shell on `WidgetsApp`: no
  `MaterialApp` needed. Provides Navigator/Overlay, localizations, Carbon
  default text style, text-selection colors, and animated theme switching.
* **`CarbonPageRoute`** — page route with Carbon productive motion (fade +
  slight rise, `duration-moderate-02` / entrance-productive easing). Used by
  `CarbonApp` and pushable directly.
* **`CarbonTheme`** / **`AnimatedCarbonTheme`** / **`CarbonThemeDataTween`** —
  the new theming core (CupertinoTheme-style `of`/`maybeOf`, implicit
  animation for runtime theme switches).
* **`CarbonMaterialBridge`** / **`CarbonMaterialThemeExtension`** — the
  Material interop layer in `package:flutter_carbon/material.dart`.

New native widgets (previously themed-Material or missing):

* **`CarbonTextInput`** / **`CarbonTextArea`** — Material-free text fields
  built on `EditableText` with full Carbon spec styling (sizes xs/sm/md/lg,
  invalid/warn states with icons, read-only, hidden label) and a complete
  Carbon-styled selection experience: custom selection handles and a
  Cut/Copy/Paste/Select-all context menu with overridable labels
  (**`CarbonTextSelectionLabels`**). Works under pure `CarbonApp` and the
  Material bridge. Deferred: password visibility toggle, character counter
  UI (`maxLength` still enforces the limit), inline/fluid variants, skeleton.
* **`CarbonCheckbox`**, **`CarbonRadio`**, **`CarbonTooltip`**,
  **`CarbonSpinner`** — spec-accurate native replacements for the Material
  controls previously used internally.
* **`CarbonSearch`** — native search input: sizes xs–lg, magnifier and
  clear button per spec (hidden with layout retained while empty), Carbon
  Escape semantics (clear when text, collapse when empty and expandable),
  and the expandable square-button variant with the 70ms width animation.
* **`CarbonSelect`** — the native-select form control: text-input-like
  field with invalid/warn status icons and text, read-only, hidden label,
  sizes xs–lg; opens a Carbon menu where the selected option is highlighted
  with a checkmark and keyboard arrows continue from the selection.
* **`CarbonSlider`** — native slider including the two-handle range mode
  (`valueUpper`): drag and track-tap with nearest-handle picking (handles
  cannot cross), keyboard per handle (arrows, Shift × `stepMultiplier`,
  Home/End), embedded number input (out-of-range values clamp on commit),
  RTL-aware, per-handle slider semantics, `onChanged`/`onRelease` reporting
  `CarbonSliderChange{value, valueUpper}`.
* **`CarbonAccordion`** — native accordion: sm/md/lg heading heights,
  chevron align start/end, flush rules, disabled items, controlled
  (`open`/`onHeadingClick`) and uncontrolled sections, the Carbon 110ms
  height-and-fade motion, and the spec's responsive content padding.
* **`CarbonDatePicker`** — native date picker in three variants: simple
  (masked `m/d/Y` input), single (input + calendar popup), and range (two
  inputs sharing one calendar with in-range highlighting). Fully
  keyboard-navigable calendar (arrows cross month boundaries,
  PageUp/PageDown ±month, Shift+PageUp/PageDown ±year, Home/End, Enter,
  Escape), spec month/year header with an editable year input and hover
  spinners, today dot, min/max bounds (selection hard-capped to years
  1–9999), typed input with `formatDate`/`parseDate` escape hatches, and
  localizable strings via **`CarbonDatePickerLabels`**. Zero dependencies —
  no `intl`.
* **`CarbonTimePicker`** + **`CarbonTimePickerSelect`** — the Carbon time
  picker: a masked `hh:mm` text input (spec widths, invalid/warn states,
  consumer-driven validation with the `time12h` convenience pattern) plus
  compact label-less companion selects (AM/PM, timezone) composed in a
  row — not a clock dial, per spec.
* **`CarbonMenuItem<T>` / `CarbonMenuItemDivider`** — native menu model per
  the Carbon Menu spec: per-item `onTap` plus typed values, danger kind
  (red on hover/focus only, per spec), disabled items, icons, shortcut
  hints, and keyboard navigation (arrows/Home/End/Enter/Escape).
* **Syntax highlighting for `CarbonCodeSnippet`** — optional
  `highlighter` parameter with a pluggable `CarbonSyntaxHighlighter`
  interface and a `CarbonSyntaxSpan`/`CarbonSyntaxKind` model. Colors come
  from the theme's previously unused `carbon.syntax` tokens, so
  highlighting follows all four themes and animated theme switches.
  Selection/copy are unaffected. **Thirteen built-in languages** on a
  shared zero-dependency tokenizer engine: Dart (Flutter-aware — named
  argument labels color as property names), Bash, JSON/JSONC, Python,
  JavaScript, TypeScript, C, C++, Java, C#, Rust, Go, and PHP — plus
  **`carbonHighlighterFor('tag')`** resolving Markdown fence tags.
  String interpolation islands (`$name`, `${expr}`, `{expr}`, f-strings,
  template literals) render in the `escape` color.
* **`CarbonCodeSnippet` to the Carbon spec** — `code-01` typography (12/16)
  in all variants; the inline chip is a click-to-copy button per spec (4px
  radius, hover/active layers, focus border); single-line is the spec 40px
  field; multi-line uses the spec row model
  (`min`/`maxCollapsedNumberOfRows`, `min`/`maxExpandedNumberOfRows` × 16px
  rows) with an animated viewport, a ghost Show more/less button with
  rotating chevron, and overflow fade indicators that clear on focus. New:
  `wrapText`, `showLineNumbers` (non-selectable gutter, wrap-aware),
  `disabled`, `copyText`, `onCopy`, `feedbackTimeout`, localizable
  **`CarbonCodeSnippetLabels`**, and a **`CarbonCodeSnippetSkeleton`**
  loading placeholder. Copy feedback is a real Carbon tooltip bubble,
  announced as a live region.

Keyboard and focus:

* Overlay keyboard/focus pass across the library: dropdown, overflow menu,
  multi-select, combo-button, and select menus take focus on open
  (arrows/Home/End/Enter drive the menu, Escape closes, previous focus
  restored); popover and toggle tip close on Escape; dismissible modals
  close on Escape.

### Changes

* `CarbonToolbarSearch` is now a thin wrapper over `CarbonSearch`: the focus
  outline is the spec 2px (was 1px), the expanded magnifier uses
  `$icon-secondary`, and clearing no longer collapses the field — collapse
  happens on blur or Escape while empty (React parity).
* Modal adopts the Carbon spec: 64px footer buttons filling the width in
  halves and flush with the container, `secondary`-kind cancel, danger modal
  uses the `danger` button kind (the non-spec red header band is gone),
  240ms entrance motion, `$overlay` barrier token, `heading-03` titles,
  left-aligned passive content.
* Combo box, number input, toolbar search, and multi-select text fields use
  the native Carbon editable core. Modal's input uses
  `CarbonTextInput`/`CarbonTextArea`; with `maxLength` the Material
  character counter UI is no longer shown (the limit still applies).
* Code snippet selection uses the Carbon-native editable core (Carbon
  context menu instead of Material's).
* Combo button halves separate with the `$button-separator` token; the
  chevron rotates 180° while open; the menu matches the container width.
* Dropdown-style menus (dropdown, combo box, multi-select, select) share one
  overlay positioner with real-height flip decisions and keyboard avoidance;
  multi-select's menu now floats and dismisses on outside tap.
* `CarbonButton` labels now ellipsize inside width-constrained buttons
  instead of overflowing.
* Toolbar batch-action buttons are native pressables (keyboard-focusable,
  no ripple); floating menu trigger gains hover/pressed feedback.
* Loading spinner uses the `$interactive` token and Carbon's exact arc
  geometry/rotation; pagination prev/next buttons show Carbon tooltips.
* `CarbonTooltip` gained an `enabled` flag (suppress without unmounting).
* Example app: the Accordion, Search, and Select demos are native and moved
  out of the "Material Theming" category (Slider gets its own demo under
  Forms); "Material Theming" now demos Tooltip and the Checkbox/Radio/Switch
  selection controls only.
* Example app: the Date & Time Picker demo is fully native
  (`CarbonDatePicker`/`CarbonTimePicker`) — `showDatePicker`,
  `showDateRangePicker`, and `showTimePicker` remain available to bridge
  users (their Material themes stay in `carbonTheme()`).
* Example app: side-panel and tearsheet demo content uses Carbon inputs
  and buttons — the Material `TextField`s/`IconButton`s previously passed
  as overlay content threw "No Material widget found" once those overlays
  stopped providing a Material ancestor in 2.0.

### Bug Fixes

* **`CarbonPalette.overlay` corrected to the Carbon spec** `rgba(black, 0.6)`
  (was a custom light gray at 32%): modal, side panel, tearsheet, and
  loading scrims now render per spec across all four themes.
* Menu/panel shadows no longer double-apply alpha (the `$shadow` token
  already encodes it).
* Select and combo-button menus grow beyond a narrow trigger when their
  content needs it (previously the width match was exact, and a compact
  select's selected row — label + checkmark — could squeeze the label out
  entirely, leaving only the checkmark).
* Content switcher: small-size labels no longer clip vertically (a fixed
  vertical padding exceeded the 32px height); labels use `body-compact-01`
  at every size per spec (small previously rendered 12px).
* Side panel: `actions` render as a Carbon action set — stretched to equal
  widths and flush with the panel edges (the modal/tearsheet footer
  convention) instead of a right-aligned padded row. Pass `CarbonButton`s
  with `CarbonButtonSize.xl`.
* `carbonTheme()`: the chip theme no longer makes standard Material `Chip`s
  fail a layout assertion in debug builds (the Carbon-tag-like compact
  sizing used negative vertical label padding; prefer `CarbonTag` for
  spec-accurate tags).
* Number input: the focus border now repaints when focus changes.
* Toolbar search: the clear button appears while typing (was only updating on
  incidental rebuilds).
* Toggle: focusing no longer crashes in debug builds (negative-margin focus
  ring), with a regression test.
* Dropdown: menu hover highlight renders again.

Token audit vs Carbon v11.96 (`@carbon/themes` sources); corrected drift:

* **Content switcher (white theme)**: adopted the 2025 redesign — container
  `gray-20`, selected `white`, hover `gray-20-hover` (was inverted).
* **`$toggle-off`** (all themes): white/g10 gray-30 → gray-50; g90 gray-70 →
  gray-50; g100 gray-70 → gray-60. Toggle disabled text now uses spec
  `$text-disabled` (25% text-primary) instead of solid approximations.
* **Status (g90)**: red/purple/blue/gray corrected to the 50-level palette
  values (previously copied g100's 40-level values).
* **Notification backgrounds (g90)**: colored dark backgrounds → neutral
  `gray-80` for all four kinds, matching Carbon's dark-theme component tokens.

## 1.3.0

### Visual Changes

* **No more ink ripple.** Every internal `InkWell` was replaced with a plain
  hover/press/focus detector. Carbon's spec has no ripple — interaction
  feedback is a flat color change — so this is a fidelity fix, but interactive
  surfaces (tree view rows, structured list rows, copy buttons, menu items,
  file uploader drop zone, …) no longer splash on tap.
* **Carbon icon glyphs everywhere.** All internal Material `Icons.*` were
  replaced with the corresponding `CarbonIcons` glyphs (close, chevrons,
  checkmarks, warning/error/information, search, menu, overflow, subtract,
  undo, copy). Notification/status/loading icons now use Carbon's filled
  variants (`errorFilled`, `checkmarkFilled`, `warningFilled`,
  `informationFilled`).

### Internal De-Materialization

* 24 of 37 widgets no longer import `package:flutter/material.dart` at all —
  including button, tabs, tag, tile, breadcrumb, link, skeleton, page header,
  progress indicator, dropdown, notification, overflow menu, popover,
  toggle tip, structured list, tree view, content switcher, copy button,
  contained list, chat button, AI label, toggle, side panel, and tearsheet.
* New internal building blocks (not exported): `CarbonPressable`
  (hover/press/focus + keyboard activation, extracted from `CarbonButton`),
  `CarbonDivider` (1px rule, horizontal/vertical), and `CarbonOverlaySurface`
  (installs Carbon's text style in overlay entries, replacing
  `Material(color: transparent)` wrappers).
* Material `elevation` on the dropdown menu, combo box menu, side panel, and
  tearsheet was replaced with explicit Carbon box shadows.
* `CarbonTearsheet` no longer builds on `Scaffold`.
* Internal `Theme.of(context).extension<CarbonThemeData>()` lookups were
  replaced with `context.carbon` across all widgets.
* All internal `Colors.*` uses were replaced with `CarbonPalette` constants;
  added `CarbonPalette.transparent`.
* The 13 widgets still importing Material do so for components that get
  native Carbon replacements in V2: `TextField` (combo box, multi-select,
  number input, modal, toolbar search), `Checkbox`/`Radio` (data table,
  multi-select), Material `Tooltip` (pagination, combo button),
  `CircularProgressIndicator` (loading, file uploader),
  `FloatingActionButton` (floating menu), `Scaffold` (modal, UI shell), and
  `SelectableText` (code snippet).

### New Features

* **`context.carbonOrNull`** — nullable variant of `context.carbon` that
  returns null instead of throwing when no Carbon theme is installed.

### Bug Fixes

* **CarbonPagination**
  * The default English page-range label rendered the literal placeholder
    text `{current} of N pages`. It now renders `of N pages` (the current
    page is displayed by the adjacent page dropdown), matching the documented
    behavior.

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
