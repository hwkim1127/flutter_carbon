# Step 30 — `CarbonScrollbar` primitive

## Goal

An internal, Carbon-styled scrollbar built on `RawScrollbar` (which lives
in flutter/widgets — Material-free): sharp corners, 6px thumb in
`$border-strong-01`, interactive drag, **visible exactly while the content
overflows**.

## SDK facts this design rests on (verified against Flutter 3.44.5)

- `RawScrollbar(thumbVisibility: true)` asserts a non-null, attached
  `ScrollController` post-frame — every adopter needs a real controller.
- On Flutter < 3.32 (pubspec min is 3.27) a NON-overflowing scrollable
  paints a full-track thumb — visibility must be gated by us.
- The scrollbar painter is fed ONLY by scroll notifications bubbling
  through the `RawScrollbar`'s child — a sibling overlay never paints.
  Nested-2D cases ancestor-wrap the clipped viewport with an axis-based
  `notificationPredicate` (inner-axis notifications arrive at depth 1).
- Flutter's base `ScrollBehavior` injects a default grey scrollbar around
  every scrollable on desktop platforms — the primitive suppresses it via
  `ScrollConfiguration(... scrollbars: false)` around its child, or
  desktop gets two bars.
- RTL vertical placement is automatic; `padding` accepts
  `EdgeInsetsDirectional`. `padding` must NEVER be null — `RawScrollbar`'s
  null default falls back to MediaQuery padding (notch insets).

## API

`lib/src/base/carbon_scrollbar.dart` — NOT exported (CarbonPressable
convention).

```dart
typedef CarbonScrollbarBuilder = Widget Function(BuildContext, ScrollController);

class CarbonScrollbar extends StatefulWidget {
  const CarbonScrollbar({
    ScrollController? controller,     // owned internally when null
    required CarbonScrollbarBuilder builder, // receives the effective controller
    Axis axis = Axis.vertical,
    bool Function(ScrollNotification)? notificationPredicate,
                                      // default: depth == 0 && metrics.axis == axis
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    double thickness = 6,
    double crossAxisMargin = 2,
  });
}
```

Builder-based (not a plain child) because several adopters are stateless
(tearsheet, UI shell side nav, dropdown menu content) and cannot own a
controller — the primitive owns one for them.

## Implementation notes

- State holds `_internal` controller (created iff `controller == null`,
  disposed iff owned; standard null↔non-null swap in `didUpdateWidget`).
- `NotificationListener<ScrollMetricsNotification>` flips a single
  `_overflowing` bool when
  `maxScrollExtent - minScrollExtent > 1e-10` changes — setState is safe
  there (the notification is dispatched post-layout via microtask; this
  is the framework's own Scrollbar convention). The handler returns
  false so notifications keep bubbling (an outer CarbonScrollbar of the
  other axis needs them).
- `RawScrollbar(thumbVisibility: _overflowing, interactive: true,
  radius: Radius.zero, thumbColor: carbon.layer.borderStrong01,
  mainAxisMargin: 2, notificationPredicate: _accept, padding: …)`.
- Toggling `thumbVisibility` fades the thumb in/out via RawScrollbar's
  own animation; while true, the fade-out timer never starts — the thumb
  stays put. One-frame latency on first appearance is inherent (the
  framework has the same).

## Tests

`test/base/carbon_scrollbar_test.dart` (imports the src path; pumps in a
pure `CarbonApp`):

- Content fits → no thumb painted.
- Content overflows → thumb painted (after `pumpAndSettle`).
- Content grows from fitting to overflowing → thumb appears; shrinks
  back → hidden (the <3.32 gating regression).
- Thumb drag moves `controller.offset`; taps on content still land.
- Desktop platform override → exactly ONE `RawScrollbar` in the subtree
  (default-scrollbar suppression works).
- RTL → vertical thumb on the left half.
