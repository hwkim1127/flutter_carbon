# 02 — Import Sweep: theme files material → widgets

## Goal

Remove `package:flutter/material.dart` from every theme-data file and
`foundation/typography.dart`. These files only use `Color`, `TextStyle`,
`FontWeight`, and `@immutable` — all available via `package:flutter/widgets.dart`.

## Files

Pattern: replace line 1 `import 'package:flutter/material.dart';` with
`import 'package:flutter/widgets.dart';` in:

- `lib/src/theme/component_themes/*.dart` (~28 files)
- `lib/src/theme/themes/white/**` , `g10/**`, `g90/**`, `g100/**` (~22 files)
- `lib/src/foundation/typography.dart`

Explicitly **excluded** (handled in later steps):

- `lib/src/theme/carbon_theme.dart` (step 04)
- `lib/src/theme/carbon_theme_data.dart` (step 04)

## Method

Mechanical sed across the two directories + typography.dart, then let the
analyzer catch any file that secretly used a Material-only symbol (fix those
individually — none are expected).

```bash
grep -rl "flutter/material.dart" lib/src/theme/component_themes lib/src/theme/themes lib/src/foundation \
  | xargs sed -i "s|import 'package:flutter/material.dart';|import 'package:flutter/widgets.dart';|"
```

## Executed scope note

The sweep surfaced that all ~28 component theme classes in
`component_themes/` also `extends ThemeExtension<T>`. Since `widgets.dart` has
no `ThemeExtension`, dropping it (originally scheduled with step 04) happened
here instead: each became a plain class, `@override` removed from
`copyWith`/`lerp`, and `lerp` signatures changed from
`lerp(ThemeExtension<T>? other, double t)` to `lerp(T? other, double t)` with a
null check. Also swept: `Colors.transparent` → `CarbonPalette.transparent` in
12 theme files (overflow menu / toggle tip / ui shell / content switcher).

## Verification

- `flutter analyze` — zero issues.
- `grep -rl "flutter/material" lib/src/theme lib/src/foundation` returns only
  `lib/src/theme/carbon_theme.dart` and `lib/src/theme/carbon_theme_data.dart`
  (cleared in step 04).
- `flutter test` — unchanged (no behavior change).
