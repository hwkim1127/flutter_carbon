# Step 16 — CarbonSlider (incl. two-handle range)

## Goal

Native Carbon Slider (v11.96 `packages/styles/scss/components/slider`),
fully controlled, including the two-handle range mode (maintainer decision)
and the embedded number input.

## Spec digest

- Container: row with 16px gaps — min label / slider body / max label /
  number input. Body max-width 640, min-width 200, padding-block 16.
- Track 2px `$border-subtle`; filled segment 2px `$layer-selected-inverse`
  → `$border-interactive` while a thumb has focus; 110ms.
- Thumb 14px circle `$layer-selected-inverse`; hover/focus/active scale to
  20px; focus adds `$interactive` fill + inset rings; disabled
  `$border-disabled`, no scale.
- Range labels `body-compact-01`. Number input 40h × 64w (96w when
  invalid/warn, status icon at inset-end 16).
- Keyboard: arrows ±step, Shift+arrows ±step×stepMultiplier (defaults 1/4);
  values snap to the nearest step.
- Range mode (`unstable_valueUpper` in React): two handles, filled track
  between them, handles cannot cross; `onChange` reports
  `{value, valueUpper}`.

## API

```dart
class CarbonSliderChange {
  final double value;
  final double? valueUpper;   // non-null only in range mode
}

CarbonSlider({
  String? labelText, bool hideLabel = false,
  required double min, required double max, required double value,
  double? valueUpper,          // non-null ⇒ range mode
  double step = 1, double stepMultiplier = 4,
  String? minLabel, String? maxLabel,
  String Function(double value, String? label)? formatLabel,
  bool hideTextInput = false,
  bool disabled = false, bool readOnly = false,
  bool invalid = false, String? invalidText,
  bool warn = false, String? warnText,
  ValueChanged<CarbonSliderChange>? onChanged,   // during drag / per key
  ValueChanged<CarbonSliderChange>? onRelease,   // pointer-up / commit
})
```

Asserts: `min < max`, `step > 0`, `value` in range,
`valueUpper == null || valueUpper >= value`.

## Implementation notes

- Value math (`ratio → min + round((raw-min)/step)*step`, clamped; RTL
  mirrors the ratio) lives in pure static helpers, unit-tested directly.
- One opaque `GestureDetector` over the body: tap-down/drag-start picks the
  handle (range: nearest by dx; tie → the upper when past the lower),
  focuses it, emits; drag-update snaps + clamps with the **no-crossing**
  rule (lower ≤ upper); `onChanged` only when the snapped value changes;
  drag-end/tap-up → `onRelease`.
- Thumbs: 28×28 hit boxes, each its own `Focus(onKeyEvent)`; arrows ±step
  (RTL swaps Left/Right), Shift ×stepMultiplier, Home/End to that handle's
  bounds; `onChanged` on keydown, `onRelease` on arrow keyup. readOnly:
  focusable, keys ignored.
- Filled track color animates (fast02) with immediate geometry (Positioned)
  so drags never lag.
- Number input: private `_SliderInput` on `CarbonEditableCore` (40×64 chrome
  per spec); local controller synced from `widget.value` only while
  unfocused; commit on submit/blur — unparsable restores, out-of-range
  **clamps on commit** (deliberate simplification of React's transient
  invalid flag). Range mode shows two inputs.
- Semantics: per thumb `Semantics(slider:, value:, onIncrease/onDecrease)`.

## Accepted deviations (follow-ups)

- Focused thumb = solid `$interactive` fill (spec: double inset ring).
- Range handles are circles (spec: 24×16 directional icon handles).
- Clamp-on-commit for the number input (spec/React: transient invalid).

## Tests

`test/widgets/carbon_slider_test.dart` with a fixed-width harness: track
tap → snapped onChanged; drag +25% width → +25; drag end → onRelease;
step-10 snapping; ArrowRight +1 / Shift+ArrowRight +4 / Home/End; range
nearest-thumb + no-crossing + valueUpper populated; input '150' + Enter →
clamped; garbage restores; disabled/readOnly inert; RTL; slider semantics.
Plus unit tests on the static math helpers.

## Example

New `slider_demo_page.dart` (basic, hideTextInput, steps, disabled/readOnly,
invalid/warn, range) + `AppRoutes.slider` + `main.dart` case; the Slider
section leaves `material_selection_demo_page.dart`.
