# Step 10 — CarbonComboButton rewrite (BREAKING)

Full rewrite of `lib/src/widgets/carbon_combo_button.dart` onto the wave-3
menu primitive. Removes the last Material type in the public API.

## Breaking API change

```dart
// Before                                          // After
CarbonComboButton(                                 CarbonComboButton<String>(
  label: 'Save',                                     label: 'Save',
  menuItems: [                                       menuItems: [
    PopupMenuItem(value: 'a', child: Text('A')),       CarbonMenuItem(value: 'a', label: 'A'),
    PopupMenuDivider(),                                CarbonMenuItemDivider(),
  ],                                                 ],
  onMenuItemSelected: (dynamic v) {...},             onMenuItemSelected: (String v) {...},
)                                                  )
```

`CarbonComboButtonSize` (small/medium/large = 32/40/48) is unchanged.
`label`, `onPressed`, `disabled`, `tooltipContent` unchanged.

## Structure (spec: combo-button v11.96)

`Row(key: _containerKey)`:
1. Primary action: `ConstrainedBox(maxWidth: 239)` → `CarbonButton(kind:
   primary, size: sm/md/lg mapped, child: Text ellipsis)`. (Spec min-width
   ~111 skipped — Flutter buttons hug content; noted deviation.)
2. Separator: 1px × height, `carbon.button.buttonSeparator`
   (`layer.borderDisabled` when disabled).
3. Trigger: icon-only `CarbonButton` (renders square) with
   `AnimatedRotation(turns: open ? 0.5 : 0, 110ms fast02,
   standardProductive)` around the chevron. Wrapped in `CarbonTooltip` ONLY
   while the menu is closed (unmounting the tooltip removes any visible
   entry via its dispose).

## Menu overlay

`OverlayEntry → CarbonAnchoredOverlay(anchorRect:
anchorRectGetterFor(_containerKey.currentContext!), alignment: bottomEnd,
spacing: 0, matchAnchorWidth: true, onDismiss: _closeMenu) →
CarbonOverlaySurface → CarbonMenuPanel<T>`. Menu width == full container
width (spec). Lifecycle is the overflow-menu pattern verbatim: reentry
guards in `_open`/`_close`, `didUpdateWidget` closes when `disabled` flips
true, `dispose` removes the entry directly (never setState-in-dispose).

Known limitation (documented, shared with overflow menu): the entry captures
`menuItems` at open; widget updates while open don't repaint the menu.

## Tests (rewrite `test/widgets/carbon_combo_button_test.dart`)

Drop `PopupMenuItem`/`Scaffold`/material import. Cases: label renders +
`onPressed`; chevron opens menu; select fires both `item.onTap` AND
`onMenuItemSelected(value)` then closes; divider renders; disabled inert;
tap-outside dismisses; chevron `turns` 0.5 open / 0 closed; menu width ==
container width; unmount-while-open no exception; themes smoke via
`buildTestApp`.

## Example (`example/lib/pages/combo_button_demo_page.dart`)

Rewrite all ~9 demo sites: `PopupMenuItem` → `CarbonMenuItem(value:, label:)`,
`PopupMenuDivider` → `CarbonMenuItemDivider`, the `Colors.red` styled item →
`kind: CarbonMenuItemKind.danger`.
