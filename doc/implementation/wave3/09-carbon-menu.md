# Step 09 — CarbonMenu primitive

New file `lib/src/widgets/carbon_menu.dart`: the native menu model and panel
that replaces Material's `PopupMenuEntry`/`PopupMenuButton` machinery. Purely
additive — nothing changes for existing widgets in this step.

## Model (public)

```dart
enum CarbonMenuItemKind { standard, danger }   // React Menu `kind` parity
enum CarbonMenuSize { xs, sm, md, lg }         // item heights 24/32/40/48

sealed class CarbonMenuEntry<T> { const CarbonMenuEntry(); }

class CarbonMenuItem<T> extends CarbonMenuEntry<T> {
  const CarbonMenuItem({
    required this.label,
    this.value,          // T? — host's onSelected fires only when non-null
    this.icon,           // Widget?, rendered 16px via IconTheme
    this.kind = CarbonMenuItemKind.standard,
    this.disabled = false,
    this.onTap,          // per-item callback; fires before onSelected
    this.shortcut,       // display-only trailing text
  });
}

class CarbonMenuItemDivider<T> extends CarbonMenuEntry<T> { const ...; }
```

Generics rationale: React's Menu is value-free (JS closures); Dart callers
often want typed values with a single selection callback — `value: T?` +
host-level `ValueChanged<T>` supports both styles.

Exported from `lib/flutter_carbon.dart` with a `show` clause limited to the
model + enums. `CarbonMenuPanel` stays internal (building-block convention,
like `CarbonAnchoredOverlay`).

## Panel (`CarbonMenuPanel<T>`, not exported)

`entries`, `onClose` (required — Escape/activation dismissal), `onSelected`,
`size` (default `sm` = 32px items, Carbon default), `minWidth: 160`,
`maxWidth: 288`. When the host anchors with `matchAnchorWidth: true` the
tight width wins automatically.

Spec rendering (Carbon v11.96 `menu/_menu.scss`):

| Role | Value / token |
| --- | --- |
| Container | bg `layer01`, 1px `borderSubtle01` border, shadow (0,2,6) `layer.shadow`@0.3, 4px vertical padding |
| Item | height by size (24/32/40/48), 16px horizontal padding, bodyCompact01 |
| Item rest | `textSecondary` / `iconSecondary` |
| Item highlighted | bg `layerHover01`, `textPrimary` (70ms AnimatedContainer) |
| Danger highlighted | bg `button.buttonDangerPrimary`, `textOnColor` (standard look at rest — per spec) |
| Disabled | `textDisabled`, no hover |
| Divider | `CarbonDivider` (1px `borderSubtle01`), 4px vertical margin |

Item interaction is MouseRegion + GestureDetector (not `CarbonPressable`):
keyboard is centralized on one panel-level `Focus` node.

## Keyboard (single Focus node + `_highlightedIndex`)

- `Escape` → `onClose`
- `ArrowDown`/`ArrowUp` → next/previous enabled item (skips dividers +
  disabled; no wrap-around — noted follow-up)
- `Home`/`End` → first/last enabled item
- `Enter`/`Space` → activate highlighted
- Hover writes the same `_highlightedIndex`, so mouse and keyboard share one
  highlight.

Activation order: `item.onTap?.call()` → `onSelected(value)` if value
non-null → `onClose()` (callbacks first, close last).

## Tests (`test/widgets/carbon_menu_test.dart`)

Items + divider render; tap fires onTap + onSelected + onClose; null-value
item skips onSelected; disabled item inert; Escape closes; ArrowDown skips a
disabled item and Enter activates; danger item smoke.

## Deferred

Submenus (Carbon MenuItem children), `MenuItemSelectable`/`RadioGroup`,
wrap-around arrow traversal, overflow-menu adoption of this model.
