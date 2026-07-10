# Step 11 — Modal restructure

`lib/src/widgets/carbon_modal.dart` drops `Scaffold`, `FilledButton`,
`OutlinedButton`, `IconButton` and adopts the Carbon v11.96 modal spec.
Public API (`CarbonModal.passive/transactional/danger/input/custom`)
unchanged. The routes were already widgets-layer `PageRouteBuilder`.

## Changes

1. **`_show<T>` helper** dedupes the five push sites and adds the spec
   entrance: `transitionDuration: CarbonMotion.moderate02` (240ms), fade +
   translateY(−24→0) with `entranceExpressive`/`exitExpressive`;
   `barrierColor: carbon.layer.overlay` (was hardcoded black@0.5).
2. **`_ModalScaffold` without Scaffold**: `CarbonOverlaySurface` (restores
   the DefaultTextStyle that Material provided) → `SafeArea` →
   `Padding(bottom: MediaQuery.viewInsetsOf(context).bottom)` (keyboard
   avoidance for the input modal) → `Stack[ Positioned.fill barrier
   GestureDetector(opaque), centered Container(maxWidth, margin 16) ]`.
3. **Shared `_ModalContainer`** for all five bodies — the footer sits
   OUTSIDE all padding, flush with the container:
   - Container: bg `layer01`, 1px `borderSubtle01` border (spec; was
     `layer02`, no border).
   - Header: `Padding(top:16, left:16, right:48)`, title `heading03`
     (20px regular — was 20px w600) in `textPrimary`.
   - Body: `Padding(top:8, sides:16, bottom:48)`, `body01` DefaultTextStyle.
     `padBody: false` for the custom modal.
   - Close button (passive/custom): 48×48 `CarbonPressable` overlaid
     top-right via Stack, 20px close icon `iconPrimary`, hover
     `layerHover01`, `Semantics(label: 'Close')`.
4. **Spec footer**: `Row[ Expanded(CarbonButton(kind: secondary, size: xl
   /*64px*/)), Expanded(CarbonButton(kind: primary-or-danger, size: xl)) ]` —
   buttons touch (no gap), fill halves, flush bottom.
5. **Danger modal**: the red `supportError` header band is removed (not
   Carbon) — spec danger = standard modal + `danger`-kind primary button.
6. Passive modal content: left-aligned (drop `textAlign: center`).

## Known gaps (flagged, out of scope)

- Carbon top-aligns labels in ≥64px modal buttons; `CarbonButton` centers —
  a CarbonButton fidelity item, not hacked around here.
- Spec breakpoint size presets (xs/sm/md/lg container widths) not adopted;
  current `maxWidth: 480` + margin kept.

## Tests (`test/widgets/carbon_modal_test.dart`)

- Danger test: `find.byIcon(warningFilled)` → assert
  `CarbonButton.kind == CarbonButtonKind.danger` on the primary.
- New: footer buttons are 64px tall, equal widths, flush with the container
  bottom; close button pops.
- Behavioral note (CHANGELOG): modal content no longer has a Material
  ancestor; Material widgets passed as `content` need their own `Material`.
